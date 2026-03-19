# TimeTravel

HPMOR Chapters: 11-17, 61-63

## Goal

Formalize the rules governing time travel in HPMOR and determine whether
the story's constraints are mathematically coherent. The Time-Turner obeys
strict self-consistency: information sent backward must be compatible with
the history that produced it. We want to know exactly when and why this works.

## What's here

| File | What it does | Tier | Finding |
|------|-------------|------|---------|
| Novikov.lean | Every finite state machine admits periodic orbits (self-consistent loops guaranteed) | 2 | — |
| CausalDAG.lean | General DAG with transitive-closure acyclicity; topological ordering; consistent histories on forests | 2-3 | #6 |
| Paradox.lean | General fixed-point theorems for paradox resolution; extension fixed points must come from new states | 2 | — |
| NPOracle.lean | Time-Turner as NP oracle. "Do nothing" is always a valid fixed point. Multiple-fixed-point problem. | 3 | #12 |

## Findings so far

- **#6 CausalDAG** (Borderline): Consistent state propagation requires forest structure (at most one parent). Specific to the modeling approach.
- **#12 NP Oracle** (Novel): The Time-Turner can't solve NP problems because "do nothing" is always self-consistent. The universe can pick the trivial fixed point.

## What's next

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Tight period bounds (does minimal period divide \|S\|!?) | Probably confirms — known combinatorics | Low |
| Extending CausalDAG beyond forests | Probably needs a merge function with specific algebraic properties | Medium |
| Selection principles for fixed points | Genuinely uncertain — under what axioms does the universe prefer non-trivial loops? | Very high |
