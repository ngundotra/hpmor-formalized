# TimeTravel

HPMOR Chapters: 11-17, 61-63

## Goal

Formalize the rules governing time travel in HPMOR and determine whether
the story's constraints are mathematically coherent. The Time-Turner obeys
strict self-consistency: information sent backward must be compatible with
the history that produced it. We want to know exactly when and why this works.

## What's here

| File | What it does | Tier |
|------|-------------|------|
| Novikov.lean | Proves every finite state machine admits periodic orbits (self-consistent loops are guaranteed) | 2 |
| CausalDAG.lean | Models causal structure as a general DAG with transitive-closure acyclicity; proves topological ordering exists and consistent histories propagate on forests | 2-3 |
| Paradox.lean | General fixed-point theorems for paradox resolution; extending a fixed-point-free map with new states always produces a fixed point, and that fixed point must come from the new states | 2 |

## Findings so far

- **CausalDAG**: Consistent state propagation requires forest structure (at most one parent per node). Multi-parent causal merges need a separate rule HPMOR never discusses.
- **Novikov**: The finite state space assumption does real work. On infinite state spaces, self-consistent loops are not guaranteed (counterexample: successor on naturals).

## What's next

These modules were formalized before the prediction framework existed, so
no pre-registered predictions are available. For future work in this folder:

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Tight period bounds (does minimal period divide \|S\|!?) | Probably confirms — this is a known combinatorial fact | Low — skip unless it connects to something deeper |
| Time-Turner as NP oracle (Ch. 17) | Genuinely uncertain — self-consistency may or may not block NP-completeness | High — best target in this folder |
| Extending CausalDAG consistency beyond forests | Probably needs a merge function with specific algebraic properties | Medium — likely to reveal structure |
