# Formalization Roadmap

> "The first thing a scientist does when they notice a confusing observation is
> not to make up a story — it is to ask, what do I already know?"
> — HPMOR Ch. 2

## Where things stand

### TimeTravel — proven, mostly Tier 2

The Novikov self-consistency results are the strongest work in the project.
The core theorem — every deterministic evolution on a finite state space
admits a periodic orbit — is general, falsifiable, and faithful to the
HPMOR claim. The fixed-point variants for idempotent and eventually-constant
transitions are solid supporting results.

**What's weak:** The DAG causal-structure model bakes acyclicity into the
definition (indexing by `Fin n`), which makes all the DAG theorems trivial
consequences of `<` being irreflexive and asymmetric. The "consistent
histories" result only handles linear chains, not arbitrary DAGs. These
are Tier 1 at best.

The grandfather paradox module is entirely Tier 1 — every theorem operates
on a hardcoded 3-element enum with proofs by `rfl`, `simp`, or `decide`.
It illustrates the idea but proves nothing general.

**Path to Tier 3:**
- Prove tight bounds on the minimal period (does it divide `|S|!`?)
- Identify the exact algebraic structure needed — does this reduce to a
  known fixed-point theorem?
- Redefine the DAG model using transitive-closure acyclicity and prove
  topological ordering exists (non-trivial, faithful)
- Replace the paradox module with general fixed-point characterization:
  "for any non-injective transition on a finite type, characterize when
  fixed points exist and when they're unique"

### Bayes — the key claim is nearly complete

The definitions and basic properties are in place (Tier 1 — definitional
consequences). The three substantive theorems — posterior tends to 1 as
evidence grows, monotonicity in likelihood ratio, and the upper bound —
are the actual HPMOR claim from Ch. 2-3. Two of three are now proven.

**Path to Tier 3:**
- What is the *rate* of convergence? Does the proof reveal whether Harry's
  update was too fast or too slow for the evidence he observed?
- Can we bound how much evidence is needed to reach a given posterior
  threshold, as a function of the prior?

### DecisionTheory — stub, Tier 1

Two theorems about the Prisoner's Dilemma: defection dominates, and mutual
precommitment to cooperation beats mutual defection. Both are trivial
consequences of the payoff definitions.

**Path to substance:**
- Iterated PD with discount factors — find the exact cooperation threshold
- Subgame-perfect equilibrium — credible threats require SPE, not just NE
- Precommitment analysis — prove that restricting your strategy set can
  increase your equilibrium payoff

### GameTheory — stub, Tier 1

One theorem about Nash bargaining at the disagreement point. Definitions
only, no real content yet.

**Path to substance:**
- Nash equilibrium existence (requires Brouwer in Mathlib)
- Aumann's agreement theorem — the big Tier 3 target
- Shapley values for the Harry/Draco/Hermione coalition

## Quality tiers (see [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md))

| Module | Current tier | What it would take to reach Tier 3 |
|--------|-------------|-----------------------------------|
| TimeTravel / Novikov | Tier 2 | Tight period bounds, connection to known fixed-point theory |
| TimeTravel / DAG model | Tier 1 | Rebuild with transitive-closure acyclicity |
| TimeTravel / Paradox | Tier 1 | Generalize to arbitrary transitions on finite types |
| Bayes | Tier 1-2 | Convergence rate analysis, evidence-requirement bounds |
| DecisionTheory | Tier 1 | Iterated PD folk theorem with exact discount thresholds |
| GameTheory | Tier 1 | Aumann's agreement theorem (hidden assumption: common priors?) |

## Unformalized claims (backlog)

Ordered by Tier 3 potential — how likely is formalization to reveal
something the informal argument hid?

### High Tier 3 potential

| Claim | Chapters | Why it might surprise us |
|-------|----------|------------------------|
| Aumann's agreement theorem | 22-24 | Requires common priors, not just common knowledge of rationality. HPMOR doesn't mention this. |
| Expected utility under existential risk | 43-47 | Standard EU may not handle -infinity utility. Harry's Dementor reasoning may require a non-standard framework. |
| Iterated PD / folk theorem | 33 | Harry says "iteration helps" — but cooperation is sustainable iff the discount factor exceeds a specific threshold. What is it? |
| Final exam game theory | 113-122 | Is Harry's strategy actually optimal? Or just good enough? |

### Medium Tier 3 potential

| Claim | Chapters | Why it might surprise us |
|-------|----------|------------------------|
| Conservation of magic | 4-6, 28-30 | What symmetry group does conservation imply? Noether's theorem in reverse. |
| Interdict of Merlin | 77-78 | What channel capacity does the Interdict impose? Information-theoretic bound. |
| Precommitment changes the game | 75-77 | Exact conditions under which restricting your strategy set helps. |
| Subgame-perfect equilibrium | 54-56, 113-122 | Does HPMOR's "credible threat" reasoning actually require SPE, or is NE sufficient? |

### Lower Tier 3 potential

| Claim | Chapters | Notes |
|-------|----------|-------|
| Multiple hypothesis testing | 8-9 | Occam's razor as MDL — well-understood territory |
| Mixed-strategy NE existence | 33 | Hard to formalize (Brouwer) but unlikely to surprise |
| Partial transfiguration | 28-29 | Research-level, speculative |
| Simulation argument | 46 | Research-level, speculative |
| Fermi paradox / Great Filter | 21 | Bayesian estimation — straightforward |

## Cleanup done

~~The TimeTravel module had Mathlib linter warnings (deprecated tactics,
unused hypotheses, long lines).~~ Fixed. All linter warnings resolved.

## Autoformalization tools

| Tool | Claims attempted | Result |
|------|-----------------|--------|
| Aristotle (Harmonic) | Infinitely many primes (test), Bayesian posterior proofs | Success — generated valid Lean 4 with correct Mathlib usage |
| Manual + LLM assist | Novikov, grandfather paradox, basic definitions | Success |

See [README.md](README.md) for Aristotle setup instructions.

## How to use this file

1. Pick a module or backlog claim
2. Check its current tier and path to Tier 3
3. Formalize with the goal of reaching Tier 3 (see [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md))
4. Update this file when you finish something
5. Run `lake build` before submitting
