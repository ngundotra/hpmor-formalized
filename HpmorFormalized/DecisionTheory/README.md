# DecisionTheory

HPMOR Chapters: 33, 43-47, 54-56, 75-77

## Goal

Formalize HPMOR's decision-theoretic claims: that precommitment has
strategic value, that defection dominates in one-shot games but not always
in repeated ones, and that expected utility reasoning works even (especially?)
when the stakes are existential. Determine where these arguments hold as
stated and where they silently rely on unstated assumptions.

## What's here

| File | What it does | Tier |
|------|-------------|------|
| Basic.lean | General 2-player game framework. Stackelberg leader advantage, precommitment value, incredible commitment theorem. Prisoner's Dilemma as special case. | 2-3 |
| ExistentialRisk.lean | Expected utility with -infinity outcomes using EReal. Proves standard EU is self-defeating when catastrophe has nonzero probability. Formalizes lexicographic and bounded alternatives. | 3 |

## Findings so far

- **Precommitment requires unique Nash**: The incredible commitment theorem only works against the *best* Nash equilibrium payoff. Games with multiple equilibria need a different analysis. HPMOR implicitly assumes uniqueness.
- **Standard EU self-defeats with -infinity**: Harry's Dementor reasoning is mathematically correct within EReal — any positive probability times -infinity gives -infinity. But this makes the framework *useless*: if every action has some catastrophe probability, all evaluate to -infinity. Harry's actual reasoning uses lexicographic preferences (minimize catastrophe probability first), which is not standard EU.

## What's next

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Subgame-perfect equilibrium (Ch. 54-56) | Probably straightforward to define; the interesting question is whether HPMOR's "credible threat" examples actually require SPE or just NE | Medium |
| Timeless Decision Theory (Ch. 33) | Genuinely uncertain whether TDT can be formalized in a way that's both precise and distinguishable from standard game theory | Very high — best target |
| Sunk cost fallacy formalization (Ch. 76) | Almost certainly confirms — this is a well-understood concept | Low — skip |
| Constrained optimization with binding constraints (Ch. 56) | Probably confirms; Lagrange multiplier theory is well-developed in Mathlib | Low |
