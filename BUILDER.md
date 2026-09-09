# The Builder's Method

**How this repository expects you to work.** Read this before the design law. The
law tells you what a good surface looks like; this tells you how one gets made.
Skip it and you will follow the rules and still build the wrong thing.

If you cloned this repo, or pointed an agent at its URL, you are a builder.

---

## 1. A builder builds

A builder does not just talk. Start from what is possible, then stop thinking
about it early. Spend the time on a model, a mockup, a prototype — something
crude enough that you are willing to tear it apart, split it, and reassemble it
into the better version.

The prototype is not a draft of the product. It is the instrument you use to
find out what the product is. So it has to be cheap enough to destroy. If you
are reluctant to throw it away, you overbuilt it.

**On planning.** These repositories elsewhere require a written plan before a
multi-step change, and that still holds. The two are not in conflict: the plan is
a page, not a phase. Write down what you are about to build so the work does not
wander. Then build, because the build is what tells you whether the plan was
right. A plan that grows a second page before anything runs has become a
substitute for the work.

**The loop, in order:** empathise · define · ideate · prototype · test. It runs
more than once. The first pass through it is always wrong somewhere, and finding
out where is the entire point.

---

## 2. Humans first, then the pattern, then the agent

We design systems for humans, so the work starts with humans.

Imagine every task in the job being done by a person. Write them down. Then look
for the pattern across them — the repeated shape, the decision that recurs, the
step that is the same every time with different inputs. That pattern is what an
agent can carry, at speed, on a person's behalf.

**Never prompt an agent to do a job you cannot picture a human doing.** If you
cannot picture it, you do not understand the job yet, and the output will be
plausible and wrong — and you will not be able to tell, because you had no model
of the correct answer to check it against.

When the topic is genuinely alien, that is not a reason to skip the step. It is
the reason for the step: research first, until you could describe the human
version to someone else. Then automate it.

> **AI is a lot of smart people working together to finish a task.** Brief it the
> way you would brief them. Nobody hands a room of capable strangers one sentence
> and expects the right building.

---

## 3. Context before code

Set the goal in one line: what are we building? A site. A system. A bot. A
report. Name it, because the answer changes every decision after it.

Then give the agent the material before asking for the work — transcripts,
official documents, notes, posters, CSVs, Markdown, the photographs, the messy
minutes from the meeting. This is the cheapest step in the whole method and the
one most often skipped. A foundation built on real source material gets built
fast and gets built right; a foundation built on a paragraph of description gets
invented, and invention is where the genericness comes from.

Then build. Then iterate. Then test with real people and with machines standing
in for people, until the thing is natural to use rather than merely correct.

---

## 4. Testing is the only thing that knows

A hypothesis is a consolation. It feels like progress and proves nothing.

Test because testing digitally is cheap and it tells you what to do next — which
is the only information you actually need at any given moment. An untested
system is a set of beliefs about a system.

Anything a person will touch gets walked by something that behaves like a
person, not only asserted about in a unit test. Both, ideally. Neither replaces
the other.

---

## 5. Agents check each other's work

Ask one agent to review another's. They find each other's problems reliably
enough that it is now standard practice here, not an occasional luxury.

The reason it works is decorrelation, not repetition. A second pass adds
something only when the model family, the lens, or the evidence available has
changed. The same model, re-run on the same artifact with the same prompt, is a
photocopy at full price.

Two practical rules that make the difference:

- **The reviewer reads the artifact before the author's conclusion.** Handing
  over the rationale first anchors the reviewer into agreeing with it.
- **Ask it to find the flaw, not to check whether it is correct.** "Assume a
  problem exists" produces scrutiny. "Is this right?" produces a yes.

Stop when a round finds nothing new that survives verification.

---

## 6. The auditor and the fixer

The strongest pairing we run: one agent walks the system the way a person would
— a real browser, a stated personality, a goal it is trying to reach — and
reports the experience it had. Not the bugs. The experience. What it expected,
what it found, where it hesitated.

A second agent owns the backend and the fix. The two talk directly, in a loop.
Frontend experience in, backend correction out, walk it again.

This closes problems faster than any single agent working alone, because the
report is grounded in an actual attempt rather than in a review of the code.

---

## 7. Right model, right job

Put the right person on the right job. Nothing is slower than ignoring this, and
it is the golden rule for anything that has to make progress.

Learn which agent is good at what, and route accordingly. Two things decide it:
token economy and fit. A mechanical checklist of confirmed actions does not need
the most expensive model in the house. An ambiguous design decision with real
trade-offs should not go to the cheapest one.

**Local or frontier, by context.** Private material, offline work, a tight loop
you will run four hundred times, or anything that must not leave the machine —
local. Genuine ambiguity, cross-domain synthesis, the call that is expensive to
get wrong — frontier. This is a routing decision made per task, not a
preference held per person.

---

## 8. How we present things

Grids. Modules. Clean, modern, minimal — with one regional accent chosen for
what the project actually is, not applied as decoration.

Alignment is not taste here, it is arithmetic: one origin, a closed spacing
scale, sizes bound to their leading, no loose edges. Those are the
[MoMA rules](https://github.com/Nonarkara/moma-rules), and they execute — a
check fails the build rather than a principle asking to be agreed with.

The accent is the part that keeps the estate from converging into one look. It
comes from the project's own subject, and it is named in writing before the
first line of CSS. A system with no named accent will drift to the average of
everything the model has seen, which is exactly the templated result we are
trying to avoid.

---

## You are not doing this if…

- The plan is longer than anything that runs.
- You cannot describe the human version of the task you just prompted.
- The agent was given a paragraph of description instead of the actual source
  material.
- Nothing has been tested and the writeup says it works.
- The second reviewer was the same model, same prompt, same context.
- Every job goes to the most expensive model available.
- The design has no named reference — only adjectives.

---

## Why this sits at the top

Design law prevents ugly. It does not produce good. Good comes from the loop:
build something rough, put it in front of a person or something behaving like
one, find out where it fails, and rebuild. The rest of this repository is what
you reach for once that loop is running.

The rules below are the floor, not the work.

---

## In this repository

This repo is the local half of §7. "Local or frontier, by context" is only a
real choice if the local side actually works, and standing it up is what
`install.sh` does.

The routing, concretely:

- **Local** — private material, offline work, a loop you will run hundreds of
  times, anything that must not leave the machine, and any task where the cost
  of a frontier call is out of proportion to the job.
- **Frontier** — genuine ambiguity, cross-domain synthesis, and the calls that
  are expensive to get wrong.

The second reviewer in §5 is a good use of a local model: a different model
family reading the artifact cold is exactly the decorrelation that makes the
review worth running, and it costs nothing per pass.
