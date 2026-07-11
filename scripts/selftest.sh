#!/usr/bin/env bash
# ============================================================================
# OFFLINE AI — LIVE SELF-TEST
# Actually runs each model and confirms it responds correctly.
#
# Usage: bash scripts/selftest.sh
# ============================================================================

set -uo pipefail

BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'

OLLAMA_API="http://localhost:11434"
PASS=0
FAIL=0
SKIP=0
TMPDIR_SELF=$(mktemp -d)
trap "rm -rf $TMPDIR_SELF" EXIT

# ============================================================================
# HELPERS
# ============================================================================

print_header() {
    echo ""
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${CYAN}${BOLD}  $1${RESET}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

pass() {
    echo -e "  ${GREEN}✓${RESET} $1"
    PASS=$((PASS + 1))
}

fail() {
    echo -e "  ${RED}✗${RESET} $1"
    FAIL=$((FAIL + 1))
}

skip() {
    echo -e "  ${YELLOW}–${RESET} $1 (skipped)"
    SKIP=$((SKIP + 1))
}

# Build a JSON payload file for Ollama API
# Usage: build_payload <model> <prompt> <max_tokens> <output_file>
build_payload() {
    python3 -c "
import json, sys
payload = {
    'model': sys.argv[1],
    'prompt': sys.argv[2],
    'stream': False,
    'options': {
        'temperature': 0.1,
        'num_predict': int(sys.argv[3])
    }
}
with open(sys.argv[4], 'w') as f:
    json.dump(payload, f)
" "$1" "$2" "$3" "$4"
}

# Extract response text from Ollama JSON
# Handles DeepSeek's <think>...</think> tags by stripping them
# Usage: extract_response <json_file>
extract_response() {
    python3 -c "
import sys, json, re
with open(sys.argv[1]) as f:
    data = json.load(f)
text = data.get('response', '')
# DeepSeek R1 wraps reasoning in <think> tags — strip them for display
text = re.sub(r'<think>.*?</think>', '', text, flags=re.DOTALL).strip()
print(text)
" "$1"
}

# ============================================================================
# PRE-FLIGHT: Is Ollama alive?
# ============================================================================

print_header "Offline AI — Live Self-Test"

echo -e "${BOLD}Pre-flight checks:${RESET}"

if ! command -v ollama &>/dev/null; then
    fail "Ollama not installed"
    echo ""
    echo "  Install with: brew install ollama"
    echo "  Or re-run: bash install.sh"
    exit 1
fi
pass "Ollama installed"

if ! curl -sf "${OLLAMA_API}/api/tags" -o "${TMPDIR_SELF}/tags.json" 2>/dev/null; then
    fail "Ollama not running"
    echo ""
    echo "  Start it with: ollama serve"
    echo "  Then re-run this test."
    exit 1
fi
pass "Ollama API responding at ${OLLAMA_API}"

AVAILABLE_MODELS=$(python3 -c "
import json
with open('${TMPDIR_SELF}/tags.json') as f:
    data = json.load(f)
for m in data.get('models', []):
    print(m['name'])
" 2>/dev/null || echo "")

if [ -z "$AVAILABLE_MODELS" ]; then
    fail "No models found — run 'ollama pull qwen2.5-coder:32b' first"
    exit 1
fi
pass "Models found in Ollama"

echo ""
echo -e "${DIM}  Available: $(echo "$AVAILABLE_MODELS" | tr '\n' ', ' | sed 's/,$//')${RESET}"

# ============================================================================
# LIVE MODEL TESTS
# ============================================================================

print_header "Running Live Model Tests"

TEST_NUM=0

test_model() {
    local model_tag="$1"
    local model_label="$2"
    local prompt="$3"
    local expect_pattern="$4"
    local timeout_sec="${5:-120}"

    TEST_NUM=$((TEST_NUM + 1))
    local payload_file="${TMPDIR_SELF}/payload_${TEST_NUM}.json"
    local response_file="${TMPDIR_SELF}/response_${TEST_NUM}.json"

    echo ""
    echo -e "${BOLD}  Testing: ${model_label}${RESET}"
    echo -e "${DIM}  Model:  ${model_tag}${RESET}"
    echo -e "${DIM}  Prompt: ${prompt}${RESET}"

    # Check if model is downloaded
    if ! echo "$AVAILABLE_MODELS" | grep -q "^${model_tag}"; then
        skip "${model_label} — model not downloaded (run: ollama pull ${model_tag})"
        return
    fi

    # Build JSON payload
    build_payload "$model_tag" "$prompt" "128" "$payload_file"

    # Send request
    local start_time=$SECONDS
    if ! curl -sf --max-time "$timeout_sec" \
        "${OLLAMA_API}/api/generate" \
        -X POST \
        -H "Content-Type: application/json" \
        -d "@${payload_file}" \
        -o "$response_file" 2>/dev/null; then

        local elapsed=$(( SECONDS - start_time ))
        fail "${model_label} — no response after ${elapsed}s"
        return
    fi

    local elapsed=$(( SECONDS - start_time ))

    # Extract response
    local reply
    reply=$(extract_response "$response_file" 2>/dev/null || echo "")

    if [ -z "$reply" ]; then
        fail "${model_label} — empty response"
        return
    fi

    # Show result
    pass "${model_label} — responded in ${elapsed}s"
    local preview
    preview=$(echo "$reply" | head -c 300 | tr '\n' ' ')
    echo -e "  ${DIM}  Response: ${preview}${RESET}"
}

# ── Test 1: Qwen Coder 32B — Main chat model ──
test_model \
    "qwen2.5-coder:32b" \
    "Qwen Coder 32B (Main Chat)" \
    "You are running as a local offline AI model via Ollama. Respond with a single short sentence confirming you are working. Start your reply with: I am working." \
    "working" \
    120

# ── Test 2: Qwen Coder 7B — Autocomplete model ──
test_model \
    "qwen2.5-coder:7b" \
    "Qwen Coder 7B (Autocomplete)" \
    "Complete this Python function. Reply with ONLY the code, nothing else: def add(a, b): return" \
    "return" \
    60

# ── Test 3: DeepSeek R1 14B — Reasoning model ──
test_model \
    "deepseek-r1:14b" \
    "DeepSeek R1 14B (Reasoning)" \
    "What is 7 * 8? Reply with just the number." \
    "56" \
    120

# ============================================================================
# BONUS: Code generation round-trip test
# ============================================================================

print_header "Code Generation Round-Trip Test"

echo -e "${BOLD}  Testing: Qwen generates code → Python executes it${RESET}"

# Find the best available Qwen model
CODE_MODEL=""
if echo "$AVAILABLE_MODELS" | grep -q "^qwen2.5-coder:32b"; then
    CODE_MODEL="qwen2.5-coder:32b"
elif echo "$AVAILABLE_MODELS" | grep -q "^qwen2.5-coder:7b"; then
    CODE_MODEL="qwen2.5-coder:7b"
fi

if [ -z "$CODE_MODEL" ]; then
    skip "Code round-trip — no Qwen model available"
else
    PAYLOAD_FILE="${TMPDIR_SELF}/payload_roundtrip.json"
    RESPONSE_FILE="${TMPDIR_SELF}/response_roundtrip.json"

    build_payload "$CODE_MODEL" \
        "Write a Python one-liner that prints the sum of numbers 1 to 10. Output ONLY the Python code, nothing else. No markdown, no explanation." \
        "64" \
        "$PAYLOAD_FILE"

    if curl -sf --max-time 120 \
        "${OLLAMA_API}/api/generate" \
        -X POST \
        -H "Content-Type: application/json" \
        -d "@${PAYLOAD_FILE}" \
        -o "$RESPONSE_FILE" 2>/dev/null; then

        GENERATED_CODE=$(python3 -c "
import json
with open('${RESPONSE_FILE}') as f:
    data = json.load(f)
code = data.get('response', '').strip()
# Strip markdown fences if present
lines = code.split('\n')
clean = []
for line in lines:
    stripped = line.strip()
    if stripped.startswith('\`\`\`'):
        continue
    clean.append(line)
print('\n'.join(clean).strip())
" 2>/dev/null || echo "")

        echo -e "${DIM}  Generated: ${GENERATED_CODE}${RESET}"

        if [ -n "$GENERATED_CODE" ]; then
            # macOS doesn't have 'timeout' — use perl as fallback
            if command -v timeout &>/dev/null; then
                EXEC_RESULT=$(timeout 5 python3 -c "$GENERATED_CODE" 2>&1 || echo "EXEC_ERROR")
            elif command -v gtimeout &>/dev/null; then
                EXEC_RESULT=$(gtimeout 5 python3 -c "$GENERATED_CODE" 2>&1 || echo "EXEC_ERROR")
            else
                EXEC_RESULT=$(python3 -c "$GENERATED_CODE" 2>&1 || echo "EXEC_ERROR")
            fi

            if echo "$EXEC_RESULT" | grep -q "55"; then
                pass "Code round-trip — model wrote code, Python ran it, got 55"
                echo -e "  ${DIM}  Output: ${EXEC_RESULT}${RESET}"
            elif echo "$EXEC_RESULT" | grep -q "EXEC_ERROR"; then
                fail "Code round-trip — generated code failed to execute"
                echo -e "  ${DIM}  Error: ${EXEC_RESULT}${RESET}"
            else
                pass "Code round-trip — code executed (output: ${EXEC_RESULT})"
            fi
        else
            fail "Code round-trip — model returned empty code"
        fi
    else
        fail "Code round-trip — API request failed"
    fi
fi

# ============================================================================
# RESULTS
# ============================================================================

print_header "Results"

echo -e "  ${GREEN}Passed:  ${PASS}${RESET}"
if [ $FAIL -gt 0 ]; then
    echo -e "  ${RED}Failed:  ${FAIL}${RESET}"
else
    echo -e "  Failed:  ${FAIL}"
fi
if [ $SKIP -gt 0 ]; then
    echo -e "  ${YELLOW}Skipped: ${SKIP}${RESET}"
fi
echo ""

if [ $FAIL -eq 0 ] && [ $SKIP -eq 0 ]; then
    echo -e "  ${GREEN}${BOLD}All systems go. Your offline AI is fully operational.${RESET}"
    echo ""
    echo "  Start coding:"
    echo "  • VS Code:  Cmd+L to chat with Qwen"
    echo "  • Terminal:  aider-offline"
    echo "  • Browser:   webui-start → localhost:8080"
elif [ $FAIL -eq 0 ]; then
    echo -e "  ${YELLOW}${BOLD}Working, but some models are not downloaded.${RESET}"
    echo ""
    echo "  Download missing models with: ollama pull <model-name>"
else
    echo -e "  ${RED}${BOLD}Some tests failed. Check output above for details.${RESET}"
    echo ""
    echo "  Common fixes:"
    echo "  • Restart Ollama:  ollama serve"
    echo "  • Re-pull model:   ollama pull qwen2.5-coder:32b"
    echo "  • Full reinstall:  bash install.sh"
fi

echo ""
exit $FAIL
