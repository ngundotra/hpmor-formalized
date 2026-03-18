# Formalization Roadmap

**Progress: 15/19 theorems proven (79%)**

> "The first thing a scientist does when they notice a confusing observation is
> not to make up a story — it is to ask, what do I already know?"
> — HPMOR Ch. 2

## Status by module

### TimeTravel (100% complete)

| # | Theorem | File | Proven |
|---|---------|------|--------|
| 1 | `novikov_periodic_consistency` | Novikov.lean | Yes |
| 2 | `exists_iterate_eq_of_finite` | Novikov.lean | Yes |
| 3 | `periodic_point_of_iterate_eq` | Novikov.lean | Yes |
| 4 | `novikov_fixed_point_of_idempotent` | Novikov.lean | Yes |
| 5 | `novikov_fixed_point_of_constant_composition` | Novikov.lean | Yes |
| 6 | `dag_no_self_loop` | Novikov.lean | Yes |
| 7 | `dag_irreflexive` | Novikov.lean | Yes |
| 8 | `dag_asymmetric` | Novikov.lean | Yes |
| 9 | `consistent_assignment_exists` | Novikov.lean | Yes |
| 10 | `time_turner_consistency` | Novikov.lean | Yes |
| 11 | `actionA_inconsistent` | Paradox.lean | Yes |
| 12 | `actionB_inconsistent` | Paradox.lean | Yes |
| 13 | `no_consistent_state_AB` | Paradox.lean | Yes |
| 14 | `universeOverride_consistent` | Paradox.lean | Yes |
| 15 | `paradox_resolved` | Paradox.lean | Yes |
| 16 | `unique_consistent_state` | Paradox.lean | Yes |

### Bayes (62% complete)

| # | Theorem | File | Proven | Difficulty | Notes |
|---|---------|------|--------|------------|-------|
| 1 | `posterior_formula` | Basic.lean | Yes | — | |
| 2 | `posterior_zero_prior` | Basic.lean | Yes | — | |
| 3 | `posterior_no_update` | Basic.lean | Yes | — | |
| 4 | `posterior_denom_pos` | Basic.lean | Yes | — | |
| 5 | `posterior_pos` | Basic.lean | Yes | — | |
| 6 | `posterior_tendsto_one` | Basic.lean | **sorry** | Medium | Needs `Filter.Tendsto`, real analysis. The key HPMOR Ch. 2-3 claim. |
| 7 | `posterior_monotone_in_L` | Basic.lean | **sorry** | Easy-Medium | Monotonicity of L*e/(L*e + (1-e)) in L |
| 8 | `posterior_le_one` | Basic.lean | **sorry** | Easy | Algebraic: numerator <= denominator |

### DecisionTheory (100% of stated theorems, but module is a stub)

| # | Theorem | File | Proven |
|---|---------|------|--------|
| 1 | `dominant_strategy_defect` | Basic.lean | Yes |
| 2 | `precommitment_cooperation_dominates` | Basic.lean | Yes |

### GameTheory (100% of stated theorems, but module is a stub)

| # | Theorem | File | Proven |
|---|---------|------|--------|
| 1 | `nash_bargaining_zero_at_disagreement` | Basic.lean | Yes |

## Unformalized HPMOR claims (backlog)

Claims extracted from the text, not yet modeled. Ordered by estimated impact and feasibility.

### High priority (core HPMOR rationality concepts)

| Claim | Chapters | Mathematical content | Estimated difficulty |
|-------|----------|---------------------|---------------------|
| Aumann's agreement theorem | 22-24 | Common-knowledge Bayesian agents with the same prior cannot agree to disagree | Hard (requires probability spaces, common knowledge operator) |
| Conservation of magic | 4-6, 28-30 | If magic obeys conservation laws, model as invariant of a discrete dynamical system | Medium |
| Expected utility under existential risk | 43-47 | Dementor/Patronus: maximizing EU when one outcome is annihilation (utility = -inf) | Medium |
| Multiple hypothesis testing | 8-9 | Comparing magic hypotheses: "Occam's razor" as minimum description length | Medium |

### Medium priority (game theory extensions)

| Claim | Chapters | Mathematical content | Estimated difficulty |
|-------|----------|---------------------|---------------------|
| Subgame-perfect equilibrium | 54-56, 113-122 | Credible threats require SPE, not just NE | Medium |
| Iterated PD / Tit-for-Tat | 33 | Harry's argument that iteration changes the equilibrium | Easy-Medium |
| Mixed-strategy NE existence | 33 | Nash's theorem via Brouwer/Kakutani fixed point | Hard (Brouwer in Mathlib) |
| Ultimatum game SPE | 113-122 | Voldemort confrontation as ultimatum with credible threats | Medium |
| Three-player coalition (Shapley) | 33 | Harry/Draco/Hermione coalition formation | Hard |
| Precommitment changes the game | 75-77 | Restricting your strategy set can increase your equilibrium payoff | Medium |

### Lower priority (interesting but speculative)

| Claim | Chapters | Mathematical content | Estimated difficulty |
|-------|----------|---------------------|---------------------|
| Partial transfiguration | 28-29 | Continuous maps on discrete structures (timeless physics interpretation) | Research-level |
| Interdict of Merlin | 77-78 | Information-theoretic limits: maximum entropy transfer under channel constraints | Hard |
| Simulation argument | 46 | Probability in simulated universes (anthropic reasoning) | Research-level |
| Fermi paradox / Great Filter | 21 | Bayesian estimation of existential risk from observational silence | Medium |

## Proof cleanup backlog

The TimeTravel module triggers Mathlib linter warnings. These are style issues, not correctness issues, but cleaning them up improves maintainability.

| Issue | Location | Fix |
|-------|----------|-----|
| `cases'` deprecated | Novikov.lean:102-103 | Replace with `obtain` or `rcases` |
| `refine'` deprecated | Novikov.lean:104 | Replace with `refine` |
| `simp` should be `simp only` | Novikov.lean:143 | Run `simp?` to get explicit lemma list |
| Lines over 100 chars | Novikov.lean:101,113 | Break into multiple lines |
| Unused `[Fintype S]` hypotheses | Multiple theorems | Replace with `[Finite S]` + `Fintype.ofFinite` |
| Unused `[DecidableEq S]` hypotheses | Multiple theorems | Remove and use `classical` |
| Unused variable `hn` | Novikov.lean:140,200 | Remove or use |
| Multi-goal tactic | Novikov.lean:206 | Focus with `·` |

## Autoformalization tool log

Track which tools were tried on which claims and whether they succeeded. Update this as we experiment.

| Claim | Tool | Result | Notes |
|-------|------|--------|-------|
| Novikov self-consistency | Manual + LLM assist | Success | Proofs generated with LLM guidance, verified in Lean |
| Grandfather paradox | Manual + LLM assist | Success | Straightforward fixed-point model |
| Bayesian posterior (definitions) | Manual | Success | Definitions are simple |
| Bayesian posterior (limit) | — | Not yet attempted | Good candidate for Aristotle or AXLE |
| Prisoner's dilemma | Manual | Success (trivial) | Definitions only, real work is SPE |

## How to use this file

1. Pick a row from any table above
2. If it says **sorry**: fill in the proof
3. If it's in the backlog: create the module, state the theorems, prove what you can
4. Update this file when you finish something
5. Run `lake build` before submitting
