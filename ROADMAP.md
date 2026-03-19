# Formalization Roadmap

**Status: 10 modules, ~40+ theorems, 0 sorries, 7 Tier 3 findings**

> "The first thing a scientist does when they notice a confusing observation is
> not to make up a story — it is to ask, what do I already know?"
> — HPMOR Ch. 2

## Tier 3 Findings

These are the results that justify the project's existence. Each one is a case
where formal verification revealed something that HPMOR's informal reasoning
missed, assumed without stating, or got subtly wrong.

| # | Module | Finding | What HPMOR glossed over |
|---|--------|---------|------------------------|
| 1 | Bayes | Monotonicity requires non-negative likelihood ratios | The posterior formula has a singularity at negative L. The domain restriction is never mentioned in the text. |
| 2 | DecisionTheory | Precommitment value theorem requires unique Nash equilibrium | The "incredible commitment" result only works against the *best* NE. Games with multiple equilibria need a different analysis. |
| 3 | ExistentialRisk | Standard EU self-defeats with -infinity utility | Harry's Dementor reasoning is correct within EReal, but useless: if *every* action has nonzero catastrophe probability, all actions evaluate to -infinity. Harry implicitly uses lexicographic preferences or bounded utility. |
| 4 | FinalExam | Harry's exploit is optimal at a 55% success threshold | The threshold `(comply - fail) / (success - fail)` is surprisingly low. Harry didn't need near-certainty — just a better-than-even chance. |
| 5 | IteratedPD | Cooperation threshold is independent of the sucker payoff | The folk theorem threshold `(T-R)/(T-P)` doesn't involve S at all. Harry's hand-wave about "iteration helps" now has an exact formula. |
| 6 | CausalDAG | Consistent histories require forest structure | State propagation along DAG edges needs at most one parent per node. Multi-parent merges require a separate rule HPMOR never discusses. |
| 7 | Aumann | Common priors are required — Harry and Draco don't share them | The theorem needs a *single shared* prior. Harry (Muggle science) and Draco (pureblood ideology) have different priors, so Aumann doesn't apply to their negotiations. |

## Module status

All modules build clean with zero sorries.

### TimeTravel — Tier 2-3

**Novikov** (Tier 2): The core theorem — every deterministic evolution on a
finite state space admits a periodic orbit — is general, falsifiable, and
faithful. The fixed-point variants for idempotent and eventually-constant
transitions are solid.

**CausalDAG** (Tier 2-3): Rebuilt with general relation-based acyclicity
(transitive closure, not Fin n indexing). Topological ordering proved via
ancestor-counting. Consistent histories proved for forest DAGs. Finding #6
(forest structure requirement) surfaced here.

**Paradox** (Tier 2): Rewritten with general fixed-point theorems over
arbitrary finite types. No more hardcoded enums. Concrete HPMOR example
preserved as illustration at the bottom.

**Path forward:** Prove tight period bounds for Novikov (does minimal
period divide |S|!?). Extend CausalDAG consistent histories beyond forests.

### Bayes — Tier 2-3, 100% complete

All 8 theorems proven. The key HPMOR claim — posterior tends to 1 as
evidence strength grows — is fully verified. Finding #1 (monotonicity
domain restriction) surfaced here.

**Path forward:** Convergence rate analysis. Can we bound how much
evidence Harry needs to reach a given posterior threshold?

### DecisionTheory — Tier 2-3

Stackelberg leader advantage, precommitment value theorem, and incredible
commitment theorem all proven. ExistentialRisk module formalizes EU with
-infinity utility using EReal. Findings #2 and #3 surfaced here.

**Path forward:** Subgame-perfect equilibrium. Credible threats.

### GameTheory — Tier 3

Aumann's agreement theorem fully proved with counterexample. Iterated PD
folk theorem with exact discount factor threshold. Final exam game-theoretic
analysis of Harry vs Voldemort. Findings #4, #5, and #7 surfaced here.

**Path forward:** Mixed-strategy NE existence (needs Brouwer). Shapley
values for the Harry/Draco/Hermione coalition. Ultimatum game SPE.

## Quality tiers (see [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md))

| Module | Tier | Sorries | Key finding |
|--------|------|---------|-------------|
| TimeTravel / Novikov | 2 | 0 | — |
| TimeTravel / CausalDAG | 2-3 | 0 | Forest structure required (#6) |
| TimeTravel / Paradox | 2 | 0 | — |
| Bayes | 2-3 | 0 | Non-negative domain (#1) |
| DecisionTheory / Basic | 2-3 | 0 | Unique Nash required (#2) |
| DecisionTheory / ExistentialRisk | 3 | 0 | EU self-defeats with -∞ (#3) |
| GameTheory / Aumann | 3 | 0 | Common priors required (#7) |
| GameTheory / IteratedPD | 3 | 0 | Threshold independent of S (#5) |
| GameTheory / FinalExam | 3 | 0 | 55% threshold (#4) |
| GameTheory / Basic | 1-2 | 0 | Definitions + basic NE |

## Unformalized claims (backlog)

A comprehensive extraction of all formalizable HPMOR claims is in progress
(see HPMOR_CLAIMS.md when available). The claims below are the highest-value
targets remaining.

### High priority

| Claim | Chapters | Why it might surprise us |
|-------|----------|------------------------|
| Conservation of magic | 4-6, 28-30 | What symmetry group does conservation imply? Noether's theorem in reverse. |
| Interdict of Merlin | 77-78 | What channel capacity does the Interdict impose? |
| Subgame-perfect equilibrium | 54-56, 113-122 | Does "credible threat" reasoning require SPE or is NE sufficient? |
| Multiple hypothesis testing | 8-9 | Occam's razor as minimum description length |

### Medium priority

| Claim | Chapters | Notes |
|-------|----------|-------|
| Mixed-strategy NE existence | 33 | Hard (Brouwer in Mathlib) |
| Shapley values / coalition | 33 | Harry/Draco/Hermione power dynamics |
| Partial transfiguration | 28-29 | Research-level, speculative |
| Fermi paradox / Great Filter | 21 | Bayesian estimation |

## Autoformalization tools

| Tool | Claims attempted | Result |
|------|-----------------|--------|
| Aristotle (Harmonic) | Infinitely many primes, Bayes proofs, Aumann, IteratedPD, FinalExam, ExistentialRisk | Success on simple proofs; queue delays on complex ones; manual writing often faster |
| Manual + LLM assist | All modules | Primary method for most proofs |

See [README.md](README.md) for Aristotle setup instructions.

## How to use this file

1. Check the Tier 3 findings table — that's the project's main output
2. Pick a backlog claim or find a path-forward item above
3. Formalize with the goal of reaching Tier 3 (see [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md))
4. Update this file when you find something
5. Run `lake build` before submitting
