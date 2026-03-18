# Contributing to hpmor-formalized

We welcome contributions from anyone interested in formal verification, rationality, or HPMOR. No prior Lean experience required for some contribution types.

> **Before you start:** Read [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md).
> Every formalization in this project must be **falsifiable** (Tier 1),
> should be **faithful** to the original HPMOR claim (Tier 2), and should
> actively try to be **surprising** (Tier 3). We are stress-testing the
> methods of rationality, not collecting tautologies.

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

| HPMOR Concept | Chapters | Possible Lean formalization | Tier 3 potential |
|--------------|----------|-----------------------------|------------------|
| Aumann's agreement theorem | 22-24 | Common knowledge + Bayesian agents must agree | High: does it require common priors? HPMOR doesn't say |
| Patronus 2.0 / Dementor model | 43-47 | Utility functions, expected value under existential risk | High: standard EU may not handle -infinity utility |
| Conservation laws of magic | 4-6, 28-30 | Conservation laws as invariants of a dynamical system | Medium: what symmetry group does magic conservation imply? |
| Iterated PD / folk theorem | 33 | Cooperation thresholds under iteration | High: find exact discount factor bounds Harry glosses over |
| Interdict of Merlin | 77-78 | Information-theoretic bounds on knowledge transmission | Medium: what channel capacity does the Interdict imply? |
| Final exam (Ch. 113-122) | 113-122 | Multi-agent game under incomplete information | High: is Harry's strategy actually optimal? |

**Aim for Tier 3.** The best contributions don't just confirm what HPMOR
says -- they reveal what HPMOR *didn't* say. Choose the most general setting,
use the weakest hypotheses, and report what the proof actually required.

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
7. Write a `## Findings` section in the module docstring (see
   [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md) for the template)
8. Self-score against the acceptance scorecard before submitting

### 3. Improve existing proofs

Look for opportunities to **raise the tier** of existing formalizations:

- Generalize a theorem that only works on a specific type to work on a class
  (e.g., replace a `Bool` proof with a `Finite S` proof)
- Weaken hypotheses and see if the theorem still holds -- if so, you've
  found a sharper result
- Add a `## Findings` section to a module that doesn't have one
- Fix any remaining Mathlib linter warnings (run `lake build` and check)

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

### Acceptance criteria

Every theorem must pass the scorecard in [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md):

- **Required:** Falsifiable (Tier 1) -- dropping a hypothesis must break it
- **Required:** Non-trivial -- proof is not just `rfl` / `simp` / `decide`
- **Required:** Faithful (Tier 2) -- a mathematician would recognize the original claim
- **Preferred:** General -- about a class of objects, not a specific example
- **Actively sought:** Surprising (Tier 3) -- formalization revealed something
  the informal argument hid

Include a `## Findings` section in your module docstring documenting what
formalization taught you. Even "no hidden assumptions found" is worth stating.

## Using autoformalization tools

If you have access to Harmonic's Aristotle, Axiom's AXLE, or similar tools, you can:

1. Feed them the natural-language claim from HPMOR
2. Review and clean up the generated Lean code
3. Verify it compiles against our Mathlib version (v4.28.0)
4. Submit the result as a PR

We're interested in documenting which tools work well for which kinds of formalizations.

## Questions?

Open an issue. We're happy to help newcomers get started with Lean or find good first issues.
