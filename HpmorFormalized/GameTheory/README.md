# GameTheory

HPMOR Chapters: 7, 19, 22-24, 33, 60, 109, 113-122

## Goal

Formalize the game-theoretic reasoning that drives HPMOR's negotiations,
confrontations, and strategic arguments. Determine whether the informal
arguments hold as stated or require hidden assumptions.

## What's here

| File | What it does | Tier | Finding |
|------|-------------|------|---------|
| Aumann.lean | Aumann's agreement theorem with counterexample. Common priors are necessary. | 2 | #7 |
| IteratedPD.lean | Folk theorem with exact discount factor threshold. Threshold independent of sucker payoff. | 3 | #5 |
| FinalExam.lean | Harry vs Voldemort as ultimatum game. Exploit optimal above 55% threshold. | 2 | #4 |
| HawkDove.lean | Hawk-Dove with reputation. Reputation makes system twice as fragile. Phase transition at R=(C-V)/2. | 3 | #16 |
| SignalAmbiguity.lean | Strategic ambiguity with heterogeneous audiences. Targeted signaling beats both clarity and ambiguity. | 3 | #18 |
| MirrorOfErised.lean | Mirror as preference revelation mechanism. Tests alignment, not character. Gameable by misaligned agents. | 3 | #20 |
| Basic.lean | Nash equilibrium definitions, bargaining. | 1-2 | — |

## Findings so far

- **#4 Final exam** (Weak): The 55% threshold is a modeling artifact — depends on arbitrary payoffs.
- **#5 Iterated PD** (Novel): Cooperation threshold `(T-R)/(T-P)` is independent of sucker payoff S.
- **#7 Aumann** (Weak): Common priors requirement is a textbook result, not a discovery.
- **#16 Hawk-Dove** (Novel): Reputation makes the mixed ESS twice as fragile (threshold at (C-V)/2 not (C-V)).
- **#18 Signal ambiguity** (Novel): Targeted signaling (allies learn everything, opponents nothing) dominates both clarity and full ambiguity.
- **#20 Mirror of Erised** (Novel): The Mirror tests preference alignment (meta-prefs = object-prefs), not character.

## What's next

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Quidditch Snitch as dominant strategy collapse (Ch. 7) | Probably confirms — the dominance boundary is non-obvious | Medium-high |
| Escalation dynamics in sequential games (Ch. 19, 74) | Probably confirms standard results | Medium |
| Unbreakable Vow as commitment device (Ch. 113, 122) | Probably confirms but interaction with finding #2 could be novel | Medium |
| Dynamic signaling — do opponents learn to decode ambiguity? (extends #18) | Genuinely uncertain | High |
