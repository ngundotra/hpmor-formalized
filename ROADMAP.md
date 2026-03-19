# Formalization Roadmap

**Status: 10 modules, ~40+ theorems, 0 sorries, 7 Tier 3 findings**

> "The first thing a scientist does when they notice a confusing observation is
> not to make up a story — it is to ask, what do I already know?"
> — HPMOR Ch. 2

## Tier 3 Findings

These are the results that justify the project's existence. Each one is a case
where formal verification revealed something that HPMOR's informal reasoning
missed, assumed without stating, or got subtly wrong.

| # | Module | Finding | In simple English | Ch. | How the story could address it | What a sharper formalization would change |
|---|--------|---------|-------------------|-----|-------------------------------|------------------------------------------|
| 1 | Bayes | Monotonicity requires non-negative likelihood ratios | The Bayes formula only works correctly when the "strength of evidence" number is zero or positive. Negative values break the formula in a way that nobody mentions because in practice evidence strength is always positive — but the math doesn't know that unless you tell it. | 2-3 | Harry could note aloud that likelihood ratios are ratios of probabilities and therefore non-negative by construction. A single sentence of inner monologue would close the gap. | Prove a quantitative convergence rate: how many bits of evidence does Harry need to go from prior ε to posterior > 0.99? |
| 2 | DecisionTheory | Precommitment value theorem requires unique Nash equilibrium | Making a binding promise only helps you if there's exactly one "trap" you're trying to escape. If a game has several stable outcomes, locking yourself in might accidentally trap you in a worse one. Harry never considers this. | 75-77 | Harry could acknowledge that precommitment only helps when there is a single trap equilibrium. If the game has multiple equilibria, you might precommit your way into a worse one. | Formalize the full Stackelberg game with multiple equilibria. Characterize which structures make precommitment valuable versus harmful. |
| 3 | ExistentialRisk | Standard EU self-defeats with -infinity utility | Harry says "any chance of total destruction times negative infinity equals negative infinity, so preventing it trumps everything." Mathematically true — but useless. If *every* option has some tiny chance of catastrophe, then *every* option scores negative infinity and the framework can't tell them apart. Harry's actual reasoning secretly uses a different system: first minimize catastrophe probability, then optimize everything else. | 43-47 | Harry could explicitly say he is using *lexicographic* preferences: first minimize annihilation probability, then maximize quality of survival. Calling it "expected utility" is technically wrong. | Formalize lexicographic EU. Prove it agrees with standard EU when utilities are bounded, and diverges when unbounded outcomes appear. |
| 4 | FinalExam | Harry's exploit is optimal at a 55% success threshold | Harry only needed to believe his trick would work slightly more than half the time for it to be the best choice. He didn't need near-certainty — the math says 55% is enough. This makes his decision more defensible than it might seem. | 113-122 | Harry's internal monologue could include: "If I think partial transfiguration works more than half the time, this is strictly better than surrendering." | Extend to incomplete information: model as a signaling game where Voldemort doesn't know Harry has partial transfiguration. |
| 5 | IteratedPD | Cooperation threshold is independent of the sucker payoff | The exact point where cooperation becomes sustainable depends on how tempting it is to cheat and how bad mutual punishment is — but surprisingly, it does *not* depend on how bad it is to be the sucker. Harry could have said this and it would have been a genuinely non-obvious insight. | 33 | Harry could say: "The threshold depends on temptation and punishment, but — surprisingly — not on how bad it is to be suckered." | Extend to games with imperfect monitoring: can you sustain cooperation if you can't always tell whether the other player defected? |
| 6 | CausalDAG | Consistent histories require forest structure | You can propagate a consistent story through time as long as each event has only one cause. The moment two causal chains merge into one event, you need an extra rule to decide what happens — and physics might not provide one. HPMOR's time travel never deals with this. | 11-17 | The Time-Turner rules could note that causal consistency is simple when each event has one cause, but gets hard when multiple chains converge. | Formalize consistent histories for general DAGs by introducing an explicit merge function. Prove necessary and sufficient conditions on it. |
| 7 | Aumann | Common priors are required — Harry and Draco don't share them | "Rational people must eventually agree" is only true if they started with the same background assumptions. Harry grew up with science; Draco grew up with pureblood ideology. They have different starting points, so the agreement theorem literally does not apply to them. | 22-24 | Harry could realize mid-argument that he and Draco are starting from different priors. "We can share all our observations and still disagree, because we do not share the same background model of the world." | Formalize the *extent* of disagreement under different priors. Bound how "far apart" Harry and Draco can rationally remain. |
| 8 | TabooTradeoffs | Sacred values are irrational on finite choices but not in general | Harry says refusing to trade off sacred values is irrational because it lets people trick you. He's right if you only have finitely many options. But "dictionary ordering" — where life always comes first, no matter how much money — is perfectly logical, can't be exploited, and is exactly the kind of sacred-value thinking Harry calls irrational. He's right at the grocery store but wrong in the philosophy seminar. | 82 | Harry could add: "This argument works because we're choosing among a finite number of real options. If you could somehow face a continuum of choices, sacred values would be perfectly consistent — just not representable by a single number." | Prove `lex_no_real_utility` fully (currently axiomatized). Characterize exactly which preference structures on infinite sets admit utility representations. |
| 9 | HypothesisLocation | "Locating cost" of a hypothesis depends on description language, not on the hypothesis itself | Harry says some ideas are harder to even *think of* than others, and treats this as an objective fact about the idea. But the "cost" of locating a hypothesis is just how many bits you need to describe it — and that depends on which encoding you use. Two different description systems assign different costs to the same hypothesis. There's no language-free "true complexity." HPMOR treats a relative quantity as if it were absolute. | 17 | Harry could say: "The cost of locating a hypothesis is relative to your language of thought. A hypothesis that's complex in English might be simple in Chinese. The invariance theorem bounds the difference, but doesn't eliminate it." | Formalize the invariance theorem fully (currently axiomatized). Prove that the additive constant between any two description languages is computable. |
| 10 | Occlumency | Perfect mind-shielding is either impossible or requires computational hardness assumptions | HPMOR treats Occlumency as "clearing your mind." But to fool *any* Legilimens (information-theoretic security), the fake mental state must have the *identical* distribution to the real one — you must perfectly simulate a genuine mind to fake one. This is a paradox: you need to know what genuine looks like to produce a fake. The weaker version (fool only *bounded* Legilimens) is more plausible but requires that mind-reading is computationally limited — an assumption HPMOR never makes. | 27 | Snape's Occlumency lessons could acknowledge the paradox: "To perfectly shield your mind, you must know precisely what an unshielded mind looks like. This is why Occlumency is difficult — you are constructing a simulation, not merely hiding." | Formalize the connection to zero-knowledge proofs. Can an Occlumens prove they believe X without revealing their actual beliefs? |
| 11 | Conservation | Magic breaking energy conservation doesn't mean magic breaks ALL conservation laws | Harry says Transfiguration violates conservation of energy, which follows from Noether's theorem and time-translation symmetry. He's right. But he never considers that magic might preserve a *different* conserved quantity under a *different* symmetry. We proved this is possible: a system where "magic" breaks one conservation law while preserving another. "Magic violates physics" is less precise than "magic violates one specific symmetry." | 2 | Harry could say: "Transfiguration breaks conservation of energy, which means it breaks time-translation symmetry. But maybe magic has its *own* conservation law — some magical quantity that's always preserved. I wonder what symmetry that would correspond to." | Formalize the connection to Noether's theorem properly. What is the minimal symmetry group needed to recover conservation given that standard energy conservation is broken? |
| 12 | NPOracle | The Time-Turner can't solve NP problems because "do nothing" is always a valid self-consistent loop | Harry considers using the Time-Turner to solve hard problems: send back a solution, verify it, send it if correct. Self-consistency guarantees a stable loop exists. But the "do nothing" loop — send nothing, receive nothing, send nothing — is *also* self-consistent. The universe can always pick the lazy option. To use time travel as a computer, you'd need physics to prefer the interesting fixed point over the trivial one, and no such preference is known. HPMOR conflates "a useful loop is possible" with "the useful loop is what happens." | 17 | Harry could realize: "Wait. The Time-Turner doesn't *have* to show me the answer. It could just as consistently show me nothing. Self-consistency guarantees *a* loop, not *the* loop I want. I need an additional assumption about which fixed point the universe selects." | Investigate selection principles: under what additional axioms (e.g., maximum entropy, minimum action) does the universe select the non-trivial fixed point? Connect to the physics of closed timelike curves. |

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
