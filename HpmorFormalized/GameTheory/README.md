# GameTheory

HPMOR Chapters: 22-24, 33, 113-122

## Goal

Formalize the game-theoretic reasoning that drives HPMOR's negotiations,
confrontations, and strategic arguments. The key questions: Can rational
agents always converge? When does iteration change the equilibrium? Was
Harry's final strategy actually optimal?

## What's here

| File | What it does | Tier |
|------|-------------|------|
| Aumann.lean | Aumann's agreement theorem with counterexample. Proves common priors are necessary — and Harry and Draco don't share them. | 3 |
| IteratedPD.lean | Folk theorem with exact discount factor threshold. Proves the threshold is independent of the sucker payoff. | 3 |
| FinalExam.lean | Harry vs Voldemort as ultimatum game. Proves Harry's exploit is optimal above a 55% success threshold. | 3 |
| Basic.lean | Nash equilibrium definitions, bargaining problem structure. | 1-2 |

## Findings so far

- **Aumann requires common priors**: HPMOR implies rational Bayesians must converge, but never mentions common priors. Harry (Muggle science) and Draco (pureblood ideology) have different priors, so Aumann literally does not apply to their negotiations.
- **Cooperation threshold ignores sucker payoff**: The folk theorem threshold `(T-R)/(T-P)` doesn't involve S. This is genuinely non-obvious and Harry could have said it.
- **Harry's exploit was optimal, not just sufficient**: The success probability threshold of ~55% is surprisingly low. Harry didn't need near-certainty.

## What's next

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Mixed-strategy NE existence via Brouwer (Ch. 33) | Probably confirms — well-established math, question is whether Brouwer is in Mathlib | Low |
| Shapley values for Harry/Draco/Hermione coalition (Ch. 33) | Uncertain — the interesting question is whether the coalition is stable or whether one player has a profitable deviation | Medium-high |
| Final exam as signaling game with incomplete information | Genuinely uncertain — does Harry's concealment of partial transfiguration change the equilibrium analysis? | High — good target |
| Recursive strategic reasoning depth bound (Ch. 24) | Uncertain — is there a formal limit to "I know that you know that I know"? | High |
| Unbreakable Vow as binding commitment device (Ch. 113, 122) | Probably confirms — mechanism design is well-understood — but the "unbreakable" part may interact with the precommitment findings in interesting ways | Medium |
