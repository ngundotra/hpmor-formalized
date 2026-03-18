import Mathlib

/-!
# Deterministic Time Travel: Fixed-Point Resolution of Paradoxes

We formalize a simple model of deterministic time travel with discrete time and state,
and prove that closed causal loops require a fixed-point resolution to maintain consistency.

## Overview

- **State**: A discrete type with three values: `ActionA`, `ActionB`, and `UniverseOverride`.
- **Time**: Discrete time, modeled as `ℕ`.
- **Forward transition** `F : State → State`: represents normal causal evolution.
- **Backward causal function** `B : State → State`: represents information sent back in time.
- **Axiom of Consistency**: A closed causal loop is valid only if there exists a state `s`
  with `s = B(F(s))`, i.e., `s` is a fixed point of `B ∘ F`.

## Main Results

1. **Paradox**: When `F` swaps `ActionA ↔ ActionB` and `B = id`, neither `ActionA` nor
   `ActionB` satisfies the consistency axiom — no fixed point exists among those two states.
2. **Resolution**: Introducing `UniverseOverride` with `F(UniverseOverride) = UniverseOverride`
   provides a fixed point of `B ∘ F`, resolving the paradox.
-/

-- ============================================================================
-- § 1. Basic Definitions
-- ============================================================================

/-- Discrete time, modeled as natural numbers. -/
abbrev Time := ℕ

/-- The state space with three distinct values. -/
inductive State where
  | ActionA
  | ActionB
  | UniverseOverride
  deriving DecidableEq, Repr

open State

/-- The paradoxical forward transition function:
  - `ActionA ↦ ActionB` (doing A causes B)
  - `ActionB ↦ ActionA` (doing B causes A)
  - `UniverseOverride ↦ UniverseOverride` (override is a fixed point) -/
def F : State → State
  | ActionA          => ActionB
  | ActionB          => ActionA
  | UniverseOverride => UniverseOverride

/-- The backward causal function: perfect copy (`B = id`).
  Information sent back in time arrives unchanged. -/
def B : State → State := id

/-- The **Axiom of Consistency** for a closed causal loop:
  a state `s` is *consistent* if `s = B(F(s))`, i.e., `s` is a fixed point of `B ∘ F`. -/
def Consistent (F B : State → State) (s : State) : Prop :=
  s = B (F s)

/-- A timeline (with given `F` and `B`) admits a valid loop if there exists a consistent state. -/
def HasValidLoop (F B : State → State) : Prop :=
  ∃ s, Consistent F B s

-- ============================================================================
-- § 2. The Paradox: No consistent state among ActionA and ActionB
-- ============================================================================

/-- `ActionA` is not a fixed point of `B ∘ F` under the paradox transitions. -/
theorem actionA_inconsistent : ¬ Consistent F B ActionA := by
  simp [F, B, Consistent]

/-- `ActionB` is not a fixed point of `B ∘ F` under the paradox transitions. -/
theorem actionB_inconsistent : ¬ Consistent F B ActionB := by
  simp [F, B, Consistent]

/-- Neither `ActionA` nor `ActionB` can serve as a consistent state in the causal loop.
  This is the formal statement of the **grandfather paradox**: if the universe is
  restricted to only `ActionA` and `ActionB`, no valid timeline exists. -/
theorem no_consistent_state_AB :
    ¬ ∃ s, (s = ActionA ∨ s = ActionB) ∧ Consistent F B s := by
  simp +decide [Consistent]

-- ============================================================================
-- § 3. The Resolution: UniverseOverride is a fixed point
-- ============================================================================

/-- `UniverseOverride` is a fixed point of `B ∘ F`. -/
theorem universeOverride_consistent : Consistent F B UniverseOverride := by
  rfl

/-- With all three states available, a valid causal loop exists. -/
theorem paradox_resolved : HasValidLoop F B :=
  ⟨_, universeOverride_consistent⟩

-- ============================================================================
-- § 4. UniverseOverride is the *unique* consistent state
-- ============================================================================

/-- In fact, `UniverseOverride` is the *only* consistent state under these transitions. -/
theorem unique_consistent_state :
    ∀ s, Consistent F B s → s = UniverseOverride := by
  intro s hs; cases s <;> tauto

