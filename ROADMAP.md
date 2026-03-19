# Formalization Roadmap

**Status: 10 modules, ~40+ theorems, 0 sorries, 7 Tier 3 findings**

> "The first thing a scientist does when they notice a confusing observation is
> not to make up a story — it is to ask, what do I already know?"
> — HPMOR Ch. 2

## Tier 3 Findings

These are the results that justify the project's existence. Each one is a case
where formal verification revealed something that HPMOR's informal reasoning
missed, assumed without stating, or got subtly wrong.

| # | Module | Finding | What HPMOR glossed over | Ch. | How the story could address it | What a sharper formalization would change |
|---|--------|---------|------------------------|-----|-------------------------------|------------------------------------------|
| 1 | Bayes | Monotonicity requires non-negative likelihood ratios | The posterior formula has a singularity at negative L. The domain restriction is never mentioned in the text. | 2-3 | Harry could note aloud that likelihood ratios are ratios of probabilities and therefore non-negative by construction. A single sentence of inner monologue would close the gap and reinforce that Bayes is about *probabilities*, not arbitrary real numbers. | Prove a quantitative convergence rate: how many bits of evidence does Harry need to go from prior ε to posterior > 0.99? This would let us check whether McGonagall's cat transformation is actually enough. |
| 2 | DecisionTheory | Precommitment value theorem requires unique Nash equilibrium | The "incredible commitment" result only works against the *best* NE. Games with multiple equilibria need a different analysis. | 75-77 | When Harry discusses the value of binding promises, he could acknowledge that precommitment only helps when there is a single "trap" equilibrium to escape. If the game has multiple equilibria, the analysis is more subtle — you might precommit your way into a worse one. | Formalize the full Stackelberg game with multiple equilibria. Characterize exactly which equilibrium structures make precommitment valuable versus harmful. |
| 3 | ExistentialRisk | Standard EU self-defeats with -infinity utility | Harry's Dementor reasoning is correct within EReal, but useless: if *every* action has nonzero catastrophe probability, all actions evaluate to -infinity. Harry implicitly uses lexicographic preferences or bounded utility. | 43-47 | Harry could explicitly say he is using *lexicographic* preferences: first minimize probability of total annihilation, then maximize expected quality of survival. This is what his reasoning actually does. Calling it "expected utility" is technically wrong. Four sentences of self-correction would make the argument airtight and more interesting. | Formalize lexicographic EU properly. Prove it agrees with standard EU when utilities are bounded, and diverges precisely when unbounded outcomes appear. Characterize the class of decision problems where the two frameworks disagree. |
| 4 | FinalExam | Harry's exploit is optimal at a 55% success threshold | The threshold `(comply - fail) / (success - fail)` is surprisingly low. Harry didn't need near-certainty — just a better-than-even chance. | 113-122 | Harry's internal monologue could include a quick expected-value calculation: "If I think partial transfiguration works more than half the time, this is strictly better than surrendering." The low threshold makes his decision *more* defensible, not less — worth a sentence of acknowledgment. | Extend to incomplete information: Voldemort doesn't know Harry has partial transfiguration. Model as a signaling game and check whether Harry's choice to conceal the capability is also optimal. |
| 5 | IteratedPD | Cooperation threshold is independent of the sucker payoff | The folk theorem threshold `(T-R)/(T-P)` doesn't involve S at all. Harry's hand-wave about "iteration helps" now has an exact formula. | 33 | Harry could say: "The threshold for sustainable cooperation depends on how much you gain by cheating and how bad mutual punishment is, but — and this is the surprising part — not on how bad it is to be suckered." This is a genuinely non-obvious fact that would strengthen the scene. | Extend to stochastic games where payoffs vary per round, or to games with imperfect monitoring (can you sustain cooperation if you can't always tell whether the other player defected?). |
| 6 | CausalDAG | Consistent histories require forest structure | State propagation along DAG edges needs at most one parent per node. Multi-parent merges require a separate rule HPMOR never discusses. | 11-17 | The Time-Turner rules could note that causal consistency is simple when each event has one cause, but gets genuinely hard when multiple causal chains converge. This is why "don't mess with time" is practical advice: multi-parent causal structures require a merge rule that physics may not provide. | Formalize consistent histories for general DAGs (not just forests) by introducing an explicit merge function. Prove necessary and sufficient conditions on the merge function for consistency to be guaranteed. |
| 7 | Aumann | Common priors are required — Harry and Draco don't share them | The theorem needs a *single shared* prior. Harry (Muggle science) and Draco (pureblood ideology) have different priors, so Aumann doesn't apply to their negotiations. | 22-24 | Harry could realize mid-argument that he and Draco are not just disagreeing about evidence — they are starting from different priors. "We can share all our observations and still disagree, because we do not share the same background model of the world." This would make the negotiation scenes more honest and more interesting. | Formalize the *extent* of disagreement under different priors. Given two priors and common knowledge of posteriors, what is the maximum possible divergence? Can we bound how "far apart" Harry and Draco can rationally remain? |

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
