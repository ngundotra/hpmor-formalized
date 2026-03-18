# Contributing to hpmor-formalized

We welcome contributions from anyone interested in formal verification, rationality, or HPMOR. No prior Lean experience required for some contribution types.

## Ways to contribute

### 1. Fill in a `sorry`

The fastest way to contribute. Search the codebase for `sorry` -- each one is a theorem statement that compiles but lacks a proof. Current open `sorry`s:

| Theorem | File | Difficulty |
|---------|------|-----------|
| `posterior_tendsto_one` | `Bayes/Basic.lean` | Medium -- requires Mathlib's `Filter.Tendsto` and real analysis |
| `posterior_monotone_in_L` | `Bayes/Basic.lean` | Easy-Medium -- monotonicity of a rational function |
| `posterior_le_one` | `Bayes/Basic.lean` | Easy -- algebraic bound |

To find all `sorry`s:
```bash
grep -rn "sorry" HpmorFormalized/
```

### 2. Formalize a new HPMOR claim

HPMOR is full of formalizable claims. Some ideas for new modules:

| HPMOR Concept | Chapters | Possible Lean formalization |
|--------------|----------|-----------------------------|
| Conservation laws of magic | 4-6, 28-30 | Conservation laws as invariants of a dynamical system |
| Aumann's agreement theorem | 22-24 | Common knowledge + Bayesian agents must agree |
| Patronus 2.0 / Dementor model | 43-47 | Utility functions, expected value under existential risk |
| Partial transfiguration | 28-29 | Continuous transformations on discrete structures |
| Interdict of Merlin | 77-78 | Information-theoretic bounds on knowledge transmission |
| Final exam (Ch. 113-122) | 113-122 | Multi-agent game under incomplete information |

To add a new module:

1. Create the file under `HpmorFormalized/YourTopic/YourFile.lean`
2. Add `import HpmorFormalized.YourTopic.YourFile` to `HpmorFormalized.lean`
3. Start with a module docstring (`/-! ... -/`) that explains:
   - Which HPMOR chapters it formalizes
   - What claims are being formalized
   - What the mathematical model is
4. Define your structures and state your theorems
5. Prove what you can, use `sorry` for the rest
6. Run `lake build` to make sure everything compiles

### 3. Improve existing proofs

The TimeTravel proofs work but trigger Mathlib linter warnings (style issues, unused hypotheses). Cleaning these up is a great way to learn Lean and contribute without needing to write new math.

Common improvements:
- Replace `cases'` with `obtain` or `rcases`
- Replace `refine'` with `refine`
- Replace `simp [...]` with `simp only [...]`
- Remove unused hypotheses like `[DecidableEq S]` when `classical` suffices
- Fix lines over 100 characters

### 4. Propose claims to formalize

Open an issue describing:
- The HPMOR chapter and passage
- The mathematical claim being made
- A sketch of how you'd model it

You don't need to know Lean to do this.

## Development setup

### Prerequisites

Install [elan](https://github.com/leanprover/elan) (the Lean version manager):

```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

### First build

```bash
git clone https://github.com/ngundotra/hpmor-formalized.git
cd hpmor-formalized
lake exe cache get    # downloads prebuilt Mathlib oleans (~5 min)
lake build            # builds the project
```

### Editor setup

VS Code with the [lean4 extension](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4) is the recommended setup. It gives you:
- Real-time type checking and error highlighting
- Goal state display (see what you need to prove)
- Go-to-definition for Mathlib lemmas

### Workflow

1. Create a branch: `git checkout -b your-feature`
2. Make changes
3. Run `lake build` -- must pass with no errors (warnings from `sorry` are OK)
4. Open a PR

CI runs `lake build` on every push, so you'll know immediately if something breaks.

## Code style

### Module docstrings

Every `.lean` file should start with a `/-! ... -/` block explaining:
- Which HPMOR chapters it relates to
- What mathematical claims are being formalized
- A brief description of the approach

### Naming conventions

Follow Mathlib conventions:
- Theorem names: `snake_case`, descriptive (e.g., `novikov_periodic_consistency`)
- Structure names: `CamelCase` (e.g., `TimeLoop`, `CausalDAG`)
- Use `_of_` for implications (e.g., `fixed_point_of_idempotent`)

### Proof style

- Prefer tactic proofs for readability
- Use `sorry` freely for work-in-progress -- it compiles and communicates intent
- Comment non-obvious proof steps
- Keep proofs under ~20 lines where possible

## Using autoformalization tools

If you have access to Harmonic's Aristotle, Axiom's AXLE, or similar tools, you can:

1. Feed them the natural-language claim from HPMOR
2. Review and clean up the generated Lean code
3. Verify it compiles against our Mathlib version (v4.28.0)
4. Submit the result as a PR

We're interested in documenting which tools work well for which kinds of formalizations.

## Questions?

Open an issue. We're happy to help newcomers get started with Lean or find good first issues.
