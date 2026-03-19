# Contributing to hpmor-formalized

Welcome. If you are here, you have presumably looked at a fictional work full of ambitious claims and decided that the appropriate response was not applause, but formal verification.

Correct.

This repository is for turning HPMOR arguments into definitions, lemmas, theorems, counterexamples, and occasionally the discovery that a dramatic speech was quietly leaning on an assumption nobody bothered to say out loud.

So far, this approach has produced 21 Tier 3 findings — cases where formalization revealed something the informal reasoning missed. These include a machine-checked characterization of TDT, a proof that partial transfiguration doesn't require quantum field theory, and the discovery that Harry's existential risk reasoning secretly uses a different decision theory than the one he names. The findings are tracked in [ROADMAP.md](ROADMAP.md). There are 160+ claims remaining in [HPMOR_CLAIMS.md](HPMOR_CLAIMS.md).

Before you begin, read [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md).

The short version:

- Tier 1: the claim must be falsifiable
- Tier 2: the formalization must actually resemble the HPMOR claim
- Tier 3: the formalization should teach us something the story did not make explicit

We are not collecting tautologies. We are interrogating arguments. The project's track record suggests this is productive — roughly half the claims we formalized turned out to need qualification, and several were wrong in ways more interesting than being right.

## Ways to contribute

### 1. Raise the tier of an existing module

This is usually the highest-leverage contribution.

Many modules already compile cleanly. That does not mean they are finished. A proof can be valid and still be too narrow, too toy, or too polite to reality.

Useful upgrades include:

- generalizing a theorem from a specific example to a class of structures
- weakening hypotheses and checking whether the result still survives
- replacing a hardcoded construction with a more faithful model
- proving the hidden assumption a previous version silently relied on
- adding a `## Findings` section that explains what formalization revealed

Examples:

- turn a one-off paradox example into a theorem about arbitrary finite transition systems
- replace a simplified causal model with one that captures the actual obstruction
- strengthen a Bayesian result from "approaches 1" to quantitative bounds on how much evidence is needed

### 2. Formalize a new HPMOR claim

HPMOR is full of claims that sound persuasive in prose and become much more interesting when forced into mathematics.

Good candidates:

| HPMOR concept | Chapters | Possible formalization | Why it is interesting |
|--------------|----------|------------------------|-----------------------|
| Patronus 2.0 / Dementor reasoning | 43-47 | Expected utility under existential risk | Standard EU may fail if one outcome has effectively negative infinity utility |
| Conservation laws of magic | 4-6, 28-30 | Invariants of a dynamical system | What symmetry assumptions would actually imply "conservation of magic"? |
| Iterated prisoner's dilemma | 33 | Cooperation thresholds under repeated play | "Iteration helps" is not a theorem until the discount factor shows up |
| Interdict of Merlin | 77-78 | Information-theoretic transmission bounds | What channel capacity would the Interdict impose? |
| Final exam strategy | 113-122 | Extensive-form or incomplete-information game | Was Harry optimal, or merely theatrically competent? |

When choosing a claim, **rank by your uncertainty about the outcome**, not by difficulty or importance. If you already know it will verify cleanly, it's bookkeeping. If you genuinely can't predict whether it will confirm, need modification, or turn out to be unmodelable, that's where the findings come from. See the "Choosing What to Formalize" section in [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md) for the full framework.

A comprehensive extraction of 160+ formalizable claims from all 122 chapters is available in [HPMOR_CLAIMS.md](HPMOR_CLAIMS.md), ranked by Tier 3 potential. Start there if you're looking for a target.

Write a `## Prediction` in your module docstring before you start proving anything. This keeps you honest.

### 3. Improve the exposition

This project is half proof artifact, half research diary.

Helpful non-proof contributions include:

- improving module docstrings
- writing or refining the companion `.md` explanations
- documenting what a theorem does and does not establish
- clarifying where a result is general versus merely illustrative
- making the argument easier to follow without making it less precise

If a future reader cannot tell what was actually proved, the repo is failing one of its jobs.

### 4. Propose a claim or counterexample

Open an issue if you have:

- an HPMOR passage that seems formalizable
- a suspicion that an existing theorem is too weak or too strong
- a counterexample that shows a current formalization is missing an assumption
- a better model for an already-formalized idea

You do not need to know Lean to do this. You need only the rare and valuable willingness to ask, "Wait, does that actually follow?"

## How to add a new module

1. Create a file under `HpmorFormalized/YourTopic/YourFile.lean`.
2. Add `import HpmorFormalized.YourTopic.YourFile` to [HpmorFormalized.lean](/home/ngundotra/Documents/hpmor-formalized/HpmorFormalized.lean).
3. Start with a module docstring explaining:
   - which HPMOR chapters it formalizes
   - what claim is being tested
   - what mathematical model you chose
   - what would count as success or failure
4. State the main definitions and theorems.
5. Add a `## Findings` section to the module docstring describing what formalization taught you.
6. If helpful, add a companion markdown note beside the module.
7. Run `lake build`.
8. Update [ROADMAP.md](ROADMAP.md) if the project state or priorities changed.

## Development setup

### Prerequisites

Install [elan](https://github.com/leanprover/elan), the Lean toolchain manager:

```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

### First build

```bash
git clone https://github.com/ngundotra/hpmor-formalized.git
cd hpmor-formalized
lake exe cache get
lake build
```

### Editor setup

VS Code with the [lean4 extension](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4) is the recommended setup. It gives you:

- real-time type checking
- goal state display
- jump-to-definition for Mathlib lemmas
- immediate evidence that Lean has found the exact place where your argument became hand-wavy

## Workflow

1. Create a branch.
2. Make the model sharper, the proof stronger, or the exposition clearer.
3. Run `lake build`.
4. Open a PR.

CI checks the project on every push. If reality objects, it will do so in public and with line numbers.

## Code style

### Module docstrings

Every `.lean` file should begin with a `/-! ... -/` block that explains:

- the HPMOR chapters or scene
- the claim being formalized
- the mathematical setup
- the main result
- the findings, especially any hidden assumption, limitation, or surprise

### Naming

Follow Mathlib conventions:

- theorem names in `snake_case`
- structure names in `CamelCase`
- implication-style names using `_of_` where appropriate

### Proof style

Prefer readable proofs over clever ones.

- use tactics when they improve legibility
- comment non-obvious steps sparingly
- keep proofs local and modular
- generalize only when it buys real explanatory power

There is no prize for writing something nobody can maintain except the person who just consumed three cups of tea and a page of category theory.

### Acceptance criteria

Every serious contribution should satisfy the scorecard in [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md):

- Required: falsifiable
- Required: non-trivial
- Required: faithful to the source claim
- Preferred: general rather than one-off
- Actively sought: surprising in a useful way

Write down what formalization changed. Even "the original claim was fine, but only with this extra assumption" is a valuable result.

## Autoformalization tools

If you use Aristotle, AXLE, or another proof-generating tool:

1. start from the actual HPMOR claim, not a watered-down substitute
2. review the generated Lean carefully
3. verify it compiles against this project's Mathlib version
4. keep the mathematics, not the vibes

Generated code is welcome. Unexamined code is not.

## Questions

Open an issue.

The ideal contribution is not "I proved something." It is "I found out exactly what this argument needs in order to be true."
