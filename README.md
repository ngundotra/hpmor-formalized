# hpmor-formalized

Formalizing the mathematical and logical claims of [Harry Potter and the Methods of Rationality](https://hpmor.com) in Lean 4 with Mathlib.

## What is this?

HPMOR by Eliezer Yudkowsky is dense with real mathematical reasoning: Bayesian epistemology, game theory, decision theory, and the physics of time travel. This project takes those claims and turns them into machine-verified proofs.

We're using **autoformalization agents** to accelerate the work:
- [Harmonic's Aristotle](https://www.harmonic.fun/) -- autoformalization from natural language to Lean
- [Axiom's AXLE](https://axiom.dev/) -- automated proof search and formalization
- Potentially [Math Inc's Gauss](https://www.mathinc.ai/) -- LLM-guided theorem proving

## Modules

| Module | HPMOR Chapters | What it formalizes | Status |
|--------|---------------|--------------------|--------|
| [`TimeTravel.Novikov`](HpmorFormalized/TimeTravel/Novikov.lean) | 11-17, 61-63 | Novikov self-consistency principle: any finite time-loop has a paradox-free fixed point | Fully proven |
| [`TimeTravel.Paradox`](HpmorFormalized/TimeTravel/Paradox.lean) | 11-17, 61-63 | Grandfather paradox modeled as fixed-point problem; universe override as resolution | Fully proven |
| [`Bayes.Basic`](HpmorFormalized/Bayes/Basic.lean) | 2-3 | Bayesian posterior update; posterior -> 1 as evidence strength -> infinity | Definitions + key properties proven; limit `sorry`'d |
| [`DecisionTheory.Basic`](HpmorFormalized/DecisionTheory/Basic.lean) | 33, 54-56, 75-77 | Prisoner's dilemma, dominant strategy defection, precommitment | Stubbed |
| [`GameTheory.Basic`](HpmorFormalized/GameTheory/Basic.lean) | 22-24, 33, 47, 113-122 | Nash equilibrium, bargaining, Pareto improvements | Stubbed |

### Flagship: Novikov Self-Consistency

The Time-Turner in HPMOR obeys strict rules -- you can't create paradoxes. We prove this must be the case: any deterministic state machine over a finite state space iterated through a closed timelike curve **must** have a periodic orbit (pigeonhole principle). We also model causal structure as DAGs and prove paradox-freedom properties.

**This may be the first-ever Lean 4 formalization of Novikov's self-consistency principle.**

### Bayesian Reasoning (Ch. 2-3)

Harry sees McGonagall turn into a cat. Despite a prior of P(magic) ~ 0, the likelihood ratio is astronomical. We formalize the Bayesian update `P(H|E) = L*e / (L*e + (1-e))` and state the theorem that as L -> infinity, the posterior -> 1. The key insight: no prior is too small to overcome with strong enough evidence.

## Building

Requires [elan](https://github.com/leanprover/elan) (installs Lean 4 automatically).

```bash
git clone https://github.com/ngundotra/hpmor-formalized.git
cd hpmor-formalized
lake exe cache get    # download prebuilt Mathlib (~5 min)
lake build            # build all modules
```

## Project structure

```
hpmor-formalized/
  lakefile.toml                          # Lake build config (Mathlib dependency)
  lean-toolchain                         # Lean 4 v4.28.0
  HpmorFormalized.lean                   # Root import (all modules)
  HpmorFormalized/
    TimeTravel/
      Novikov.lean                       # Novikov self-consistency (fully proven)
      Paradox.lean                       # Grandfather paradox (fully proven)
    Bayes/
      Basic.lean                         # Bayesian updates (partial)
    DecisionTheory/
      Basic.lean                         # Prisoner's dilemma (stub)
    GameTheory/
      Basic.lean                         # Negotiation equilibria (stub)
  .github/workflows/ci.yml              # lake build on every push
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add new formalizations, fill in `sorry`'d proofs, or propose new HPMOR claims to formalize.

## References

- [HPMOR full text](https://hpmor.com)
- [Mathlib4 docs](https://leanprover-community.github.io/mathlib4_docs/)
- [Novikov self-consistency principle](https://en.wikipedia.org/wiki/Novikov_self-consistency_principle)
- [Lean 4 documentation](https://lean-lang.org/lean4/doc/)
