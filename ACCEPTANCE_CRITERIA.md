# Acceptance Criteria for Formalized Proofs

> "If you can't say what evidence would convince you, you don't have a belief —
> you have a password."
> — HPMOR Ch. 8

This document defines what makes a formalization **good enough to merge**. The
bar is deliberately high: we are not collecting tautologies dressed up in Lean
syntax. We are building machine-checked arguments that a mathematician would
find *informative*.

---

## Choosing What to Formalize

Before writing any Lean, ask: **would I learn something by trying?**

The project's best results came from claims where the outcome was genuinely
uncertain. The worst use of time is formalizing something where you already
know what will happen. This applies in both directions — a claim you're
sure will verify is bookkeeping, and a claim you're sure can't be modeled
is stalling.

### The four outcome categories

Every formalization attempt lands in one of these:

| Category | What happens | Information value |
|----------|-------------|-------------------|
| **Confirms as stated** | The theorem goes through with exactly the hypotheses HPMOR implies. | Low. You verified a correct argument. |
| **Confirms but reveals hidden structure** | The claim is true, but formalization forces an assumption to be explicit that changes your understanding. | High. The claim isn't wrong, it's incomplete. |
| **Fails as stated, fixable** | The claim is false in the form HPMOR presents it, but a nearby claim is true. The gap is the finding. | High. The conclusion may be right but the reasoning is wrong. |
| **Fails as stated, not obviously fixable** | The claim doesn't formalize and it's unclear what the right version would be. | Very high — but also the hardest to produce. |

### How to choose

**Rank claims by your uncertainty about which category they'll land in.**

If you can confidently predict the outcome, the expected information gain
is low. The claims that make you uncomfortable — where you genuinely
cannot tell whether you'll confirm, refine, refute, or get stuck — are
the ones worth your time.

| Your prediction confidence | Action |
|---------------------------|--------|
| "I'm sure this goes through as stated" | Skip unless it's a dependency for something uncertain |
| "I'm sure this can't be modeled" | Skip unless you have a specific reason to believe a model exists |
| "I think it works but I'm not sure what hypotheses I'll need" | Good target — hidden structure likely |
| "I genuinely don't know if this is true, fixable, or meaningless" | Best target — maximum expected information |

See [HPMOR_CLAIMS.md](HPMOR_CLAIMS.md) for 160+ extracted claims from all
122 chapters, ranked by Tier 3 potential. Each folder's `README.md` also
lists forward-looking predictions for the next claims to tackle.

### State your prediction before you start

Before opening a `.lean` file, write 2-3 sentences in the module docstring
under a `## Prediction` heading:

```
## Prediction

I expect this to [confirm as stated / need modification / fail / be hard to model].
The hypothesis I'm most uncertain about is [X].
If this confirms cleanly, I'll be surprised because [Y].
```

This is not a test you can fail. It is a calibration tool. The point is to
create a record so you can honestly compare prediction to outcome.

### Report the outcome against your prediction

The `## Findings` section (described below) should include a line:

```
- **Prediction vs. reality**: I predicted [X]. What actually happened was [Y].
```

If you predicted confirmation and found a hidden assumption, that's
interesting. If you predicted a hidden assumption and found one, that's
still useful but less surprising. If you predicted nothing interesting
and were right, the claim was probably too easy.

---

## The Three Tiers

Every formalized claim must reach **Tier 1** to merge. We strongly prefer
**Tier 2**, and we actively seek **Tier 3**. If a PR only reaches Tier 1,
it needs a compelling reason to exist.

---

### Tier 1: Falsifiable ("The theorem could have been false")

**Minimum bar for any theorem in this project.**

A theorem is falsifiable if weakening or removing a hypothesis makes it
*provably false*. This is the formalization analogue of Popper's criterion:
if no possible state of the world could contradict your claim, your claim
says nothing.

**How to check:**

- For each hypothesis, ask: "What breaks if I drop this?"
- If removing a hypothesis still lets the proof go through, that hypothesis
  is dead weight. Remove it.
- If the *entire theorem* is true with no hypotheses (i.e., it follows from
  definitions alone), it is a tautology, not a theorem. It belongs in a
  docstring, not in the theorem list.

**Examples from this project:**

| Theorem | Key hypothesis | What breaks without it |
|---------|---------------|----------------------|
| `novikov_periodic_consistency` | `[Finite S]` | False: `n + 1` on `Nat` has no periodic point |
| `posterior_tendsto_one` | `0 < epsilon` | False: zero prior is stuck at zero forever |
| `posterior_le_one` | `0 < L` | Without positive evidence, the formula is degenerate |

**Red flags (Tier 1 failures):**

- Proof is `rfl`, `simp`, or `decide` alone
- Theorem restates a definition with no additional content
- All hypotheses are unused
- The "theorem" is true for *every* function / structure, not just the
  ones satisfying your conditions

---

### Tier 2: Faithful ("A mathematician would recognize the original claim")

**The standard we hold ourselves to.**

A formalization is faithful if someone who knows the math but hasn't read
your Lean code would read the theorem statement and say: "Yes, that is
Bayes' theorem" or "Yes, that is the Novikov self-consistency principle."

**How to check:**

- State the theorem in plain English in the docstring. Does it match the
  HPMOR passage it claims to formalize?
- Are the structures general enough? A theorem about `Bool` is a calculation.
  A theorem about all finite types is mathematics.
- Could a skeptic argue that your formalization "technically proves something
  but not *that* thing"? If so, fix it.

**Tier 2 scorecard:**

| Question | 0 points | 1 point |
|----------|----------|---------|
| Is it about a class of objects or one specific example? | Specific enum/value | Universally quantified over a type |
| Would the proof work if you changed the definitions? | Proof is entangled with arbitrary modeling choices | Proof uses only the mathematically essential structure |
| Does the docstring claim match the theorem statement? | Vague or missing connection to HPMOR | Explicit chapter reference, clear correspondence |

**Examples:**

- `novikov_periodic_consistency` — **Tier 2.** General (all finite types),
  faithful (recognizably the pigeonhole argument for periodic orbits),
  clearly connected to HPMOR Ch. 11-17.

- `actionA_inconsistent` in Paradox.lean — **Tier 1 only.** It checks one
  specific value of a specific enum. It's a unit test for the model, not a
  theorem about time travel. Useful as illustration, but not substantive.

---

### Tier 3: Surprising ("Formalization revealed something the informal argument hid")

**This is what we are really after.**

The entire point of formal verification is that it is *harder to fool
yourself*. A Tier 3 formalization doesn't just confirm what we already
believed — it exposes a hidden assumption, sharpens a vague intuition into
a precise boundary condition, or reveals that an informal argument was
*wrong* (or at least incomplete).

> "The first thing a scientist does when they notice a confusing observation
> is not to make up a story — it is to ask, what do I already know?"
> — HPMOR Ch. 2

**What Tier 3 looks like:**

1. **Hidden assumption exposed.** The informal argument works, but formalization
   forces you to make an assumption explicit that the text glossed over.
   - Example: Formalizing Aumann's agreement theorem and discovering it
     requires *common priors*, not just common knowledge of rationality.
     HPMOR doesn't mention this. That's a finding.

2. **Precise boundary identified.** The informal claim is "X works" but
   formalization shows "X works if and only if Y > threshold."
   - Example: The folk theorem for iterated PD requires a specific discount
     factor bound. "Iteration helps" is vague. "Cooperation is sustainable
     iff delta > (T-R)/(T-P)" is mathematics.

3. **Informal argument was wrong.** Formalization shows the HPMOR claim is
   false as stated, or requires a different model than the text implies.
   - Example: Standard expected utility theory doesn't handle `-infinity`
     utility cleanly (the Dementor/existential risk case). You can't just
     multiply by probability. You need a modified framework. If formalizing
     Harry's argument about Dementors forces a non-standard utility theory,
     that's a genuine discovery.

4. **Non-obvious equivalence.** Two HPMOR claims that seem unrelated turn out
   to be equivalent (or one implies the other) when formalized.
   - Example: Novikov self-consistency and the Brouwer fixed-point theorem
     are related. Does the finite-state-space version reduce to a known
     combinatorial lemma? What's the exact relationship?

**How to check:**

- After completing the proof, write a "Findings" section in the module
  docstring. If you can't think of anything to write, it's probably not
  Tier 3.
- Ask: "Did I learn something I didn't know before I started formalizing?"
- Ask: "Would the HPMOR characters benefit from knowing this?"
- The *proof* itself often contains the surprise — an unexpected lemma you
  needed, or an unexpected lemma you *didn't* need.

**Tier 3 is not optional — it is the mission.**

We are not building a trophy case of checked proofs. We are stress-testing
the methods of rationality. Every module should be *trying* to reach Tier 3.
If you formalize a claim and find no surprises, that's a valid outcome —
report it. But design your formalizations to maximize the chance of surprise:
choose the most general setting, use the weakest hypotheses, and see what
the proof actually requires.

---

## Scorecard

Use this when reviewing PRs or evaluating your own work.

| Criterion | 0 | 1 | Weight |
|-----------|---|---|--------|
| **Falsifiable**: Removing a hypothesis breaks it | Proof is definitional / vacuously true | At least one hypothesis is load-bearing | Required |
| **Non-trivial**: Proof requires real work | `rfl` / `simp` / `decide` | Multi-step reasoning, lemma applications | Required |
| **Faithful**: Recognizable as the original claim | Model is artificial, connection is hand-wavy | Clear HPMOR reference, mathematician would agree | Required |
| **General**: Proves something about a class, not one example | Specific values, hardcoded types | Universally quantified, polymorphic | Preferred |
| **Surprising**: Revealed something the informal argument hid | Confirmed what we expected, no new insight | Exposed hidden assumption, sharpened boundary, or found error | **Actively sought** |

**Merge thresholds:**

- **Score 0-1:** Do not merge. This is a definition or tautology.
- **Score 2:** Merge only if it's a necessary stepping stone to a higher-tier result.
- **Score 3:** Good. Standard for merge.
- **Score 4-5:** Excellent. This is what the project exists for.

---

## Applying the Scorecard: Current Project Assessment

| Module | Current Score | Path to Tier 3 |
|--------|-------------|----------------|
| TimeTravel/Novikov | 3-4 | Investigate: does the finite-case Novikov reduce to a known fixed-point theorem? What's the minimal algebraic structure needed? |
| TimeTravel/Paradox | 1-2 | Generalize: prove that *any* non-injective transition has a fixed point, not just your specific 3-element enum. |
| Bayes/Basic (completed) | 1-2 | These are definitions + trivial consequences. They support the real theorems. |
| Bayes/Basic (sorry proofs) | 3-4 (once filled) | Investigate: what's the *rate* of convergence? Does the proof reveal whether Harry's update was too fast or too slow? |
| DecisionTheory | 1-2 | Needs SPE, folk theorem. The real surprise would be finding exact cooperation thresholds. |
| GameTheory | 1-2 | Needs Nash existence, Shapley values. Aumann's theorem is the big Tier 3 target. |

---

## Plain-Language Summary (Required)

Every formalization must include a companion markdown file with the same name
as the Lean file (e.g., `Novikov.md` next to `Novikov.lean`). This summary
must be written in **simple English** — imagine explaining it to a curious
teenager who has read HPMOR but has never seen a proof assistant.

The summary is 4-6 sentences and covers three things:

1. **The HPMOR idea.** What does the book claim, in plain words?
2. **How we modeled it.** What mathematical objects stand in for the story elements?
3. **What this says about HPMOR.** Did formalization confirm the claim, reveal
   a hidden assumption, or expose a flaw? If nothing surprising was found,
   say so honestly.

Example (for Novikov self-consistency):

> In HPMOR, Time-Turners let you send information back in time, but only if
> the result is self-consistent — no paradoxes allowed. We modeled this as a
> function that maps universe-states to universe-states, and proved that on
> any finite set of states, such a function must eventually loop back to
> where it started. This confirms the HPMOR claim: self-consistent time
> loops are not just possible, they are mathematically guaranteed, as long
> as the number of possible states is finite.

**Merge requirement:** No formalization will be merged without its companion
summary. If you can't explain what the proof means in simple English, the
formalization may not be capturing anything meaningful.

---

## Writing a "Findings" Section

Every module that reaches Tier 2 or above should include a `## Findings`
section in its module docstring. This is where you report what formalization
taught you. Even negative results ("the informal argument was correct as
stated, no hidden assumptions found") are worth recording.

Template:

```
## Findings

- **Hidden assumptions**: [What did you have to assume that HPMOR didn't mention?]
- **Boundary conditions**: [Where exactly does the result break down?]
- **Unexpected lemmas**: [What supporting result surprised you?]
- **Connection to known math**: [Did this reduce to a known theorem? Which one?]
- **Assessment**: Tier [1/2/3] — [one-line justification]
```
