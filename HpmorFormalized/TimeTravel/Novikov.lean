import Mathlib

/-!
# Novikov's Self-Consistency Principle

**HPMOR Chapters**: 11-17, 61-63 (Time-Turner usage and rules)

**Claims Formalized**:
In HPMOR, time travel via Time-Turners obeys strict self-consistency rules:
information sent back in time must be consistent with the causal history that
produced it. This is a fictional application of Novikov's self-consistency
principle from theoretical physics.

We formalize a mathematical model of Novikov's self-consistency principle.
The principle, proposed by Igor Novikov, states that if time travel to the past
is possible, any events in the past that are influenced by a time traveler must
already be part of the self-consistent history that led to the time travel in
the first place. In other words: paradoxes are impossible because only
self-consistent loops can occur.

## Mathematical Model

We provide two complementary formalizations:

### 1. Time-Loop State Machine
- A finite set of **states** `S` represents possible configurations of the universe.
- A **transition function** `f : S → S` represents the evolution of the universe
  through one complete traversal of a time loop (e.g., one use of a "time turner").
- **Self-consistency** requires a state `s` such that iterating the loop returns
  to `s` — a **periodic orbit** representing a paradox-free, stable history.

### 2. Directed Acyclic Graph (DAG) Causal Structure
See `HpmorFormalized.TimeTravel.CausalDAG` for the DAG-based model, which
uses a general relation with an explicit acyclicity condition.

## Main Results

1. `novikov_periodic_consistency`: Every function on a finite nonempty type
   admits a periodic point — every time loop has a self-consistent history.

2. `novikov_fixed_point_of_idempotent`: Idempotent transitions (modeling
   "stabilizing" time loops) always have fixed points.

3. `novikov_fixed_point_of_constant_composition`: If iterating the loop
   enough times collapses all states to one, that state is a fixed point.

4. See `CausalDAG.lean` for DAG-based results (no self-loops, topological
   ordering, consistent histories for general DAGs).

**Note**: This may be the first-ever Lean 4 formalization of Novikov's
self-consistency principle.
-/

open Function Finset

-- ============================================================================
-- PART 1: Time-Loop State Machine Model
-- ============================================================================

/-- A `TimeLoop` models a time-travel scenario as a deterministic state machine.
    The `transition` function represents the evolution of the universe through
    one complete traversal of a closed timelike curve (time loop). -/
structure TimeLoop (S : Type*) where
  /-- The state transition function for one full loop traversal. -/
  transition : S → S

/-- A state `s` is **self-consistent** (a fixed point) if traversing the
    time loop returns the universe to exactly the same state. This is the
    strongest form of Novikov consistency. -/
def TimeLoop.selfConsistent {S : Type*} (tl : TimeLoop S) (s : S) : Prop :=
  tl.transition s = s

/-- A state `s` is **periodically consistent** with period `k` if traversing
    the time loop `k` times returns to `s`. This models a self-consistent
    history that may cycle through multiple states before repeating. -/
def TimeLoop.periodicConsistent {S : Type*} (tl : TimeLoop S) (s : S) (k : ℕ) : Prop :=
  k > 0 ∧ tl.transition^[k] s = s

/-- **Novikov's Periodic Consistency Theorem.**
    In a finite nonempty state space, every time loop admits a periodically
    consistent state. This is the mathematical core of Novikov's principle:
    deterministic evolution over a finite state space *must* produce a
    self-consistent loop.

    *Proof sketch*: By the pigeonhole principle, the orbit
    `s, f(s), f²(s), …` of any state `s` under `f = tl.transition` must
    revisit some state within `|S|` steps. The first revisited state lies
    on a periodic orbit. -/
theorem novikov_periodic_consistency
    (S : Type*) [Finite S] [Nonempty S]
    (tl : TimeLoop S) :
    ∃ s : S, ∃ k : ℕ, tl.periodicConsistent s k := by
  classical
  have := Fintype.ofFinite S
  have h_pigeonhole : ∀ (s : S), ∃ i j : ℕ, i < j ∧ tl.transition^[i] s = tl.transition^[j] s := by
    intros s
    by_contra h_no_repeat;
    exact absurd ( Set.infinite_range_of_injective ( fun i j hij => le_antisymm
      ( not_lt.1 fun hi => h_no_repeat ⟨ j, i, hi, hij.symm ⟩ )
      ( not_lt.1 fun hj => h_no_repeat ⟨ i, j, hj, hij ⟩ ) ) )
      ( Set.not_infinite.mpr <| Set.toFinite _ );
  obtain ⟨ i, j, hj ⟩ := h_pigeonhole ( Classical.arbitrary S )
  exact ⟨ tl.transition^[i] ( Classical.arbitrary S ), j - i, Nat.sub_pos_of_lt hj.1,
    by rw [ ← Function.iterate_add_apply, Nat.sub_add_cancel hj.1.le, hj.2 ] ⟩

/-- Helper: In a finite type, iterating any function produces a repeated value. -/
lemma exists_iterate_eq_of_finite
    (S : Type*) [Fintype S]
    (f : S → S) (s : S) :
    ∃ i j : ℕ, i < j ∧ j ≤ Fintype.card S ∧ f^[i] s = f^[j] s := by
  classical
  by_contra! h_contra;
  exact absurd ( Finset.card_le_univ ( Finset.image ( fun i => f^[i] s )
    ( Finset.Iic ( Fintype.card S ) ) ) ) ( by
    rw [ Finset.card_image_of_injOn fun i hi j hj hij => le_antisymm
      ( not_lt.1 fun hi' => h_contra _ _ hi' ( by aesop ) hij.symm )
      ( not_lt.1 fun hj' => h_contra _ _ hj' ( by aesop ) hij ) ]
    simp +decide )

/-- Helper: From a repeated iterate, extract a periodic point. -/
lemma periodic_point_of_iterate_eq
    (S : Type*)
    (f : S → S) (s : S) (i j : ℕ) (hij : i < j) (heq : f^[i] s = f^[j] s) :
    f^[j - i] (f^[i] s) = f^[i] s := by
  rw [ ← Function.iterate_add_apply, Nat.sub_add_cancel hij.le, heq ]

/-- **Novikov's Fixed Point Theorem for Idempotent Transitions.**
    If the transition function is idempotent (`f ∘ f = f`), meaning that
    traversing the loop twice has the same effect as traversing it once,
    then a true fixed point exists. This models "stable" time loops where
    the universe settles into a steady state. -/
theorem novikov_fixed_point_of_idempotent
    (S : Type*) [Nonempty S]
    (tl : TimeLoop S)
    (h : tl.transition ∘ tl.transition = tl.transition) :
    ∃ s : S, tl.selfConsistent s := by
  exact ⟨ tl.transition ( Classical.arbitrary S ), congr_fun h _ ⟩

/-- **Novikov's Fixed Point for Eventually Constant Loops.**
    If iterating the transition function `n` times produces a constant
    function (all states collapse to one), then that final state is a
    fixed point — the unique self-consistent history. -/
theorem novikov_fixed_point_of_constant_composition
    (S : Type*) [Nonempty S]
    (tl : TimeLoop S) (n : ℕ) (_hn : n > 0)
    (c : S) (hc : ∀ s : S, tl.transition^[n] s = c) :
    tl.selfConsistent c := by
  simp only [TimeLoop.selfConsistent]
  convert hc ( tl.transition c ) using 1
  erw [ Function.iterate_succ_apply' ]
  rw [ hc ]

-- The DAG-based causal structure model has been moved to CausalDAG.lean
-- for a more faithful formalization using general relations with explicit
-- acyclicity conditions. See HpmorFormalized.TimeTravel.CausalDAG.

-- ============================================================================
-- PART 3: Connecting the Models — Time-Turner Sequences
-- ============================================================================

/-- A `TimeTurnerSequence` models a finite sequence of `k` time-turner actions,
    each described by a transition function. The composition of all transitions
    represents one full traversal of the induced time loop. -/
structure TimeTurnerSequence (S : Type*) (k : ℕ) where
  /-- The transition function for each step. -/
  step : Fin k → (S → S)

/-- The composition of all steps in a time-turner sequence, representing
    one full loop traversal. Steps are composed in order: step 0, then step 1, etc. -/
noncomputable def TimeTurnerSequence.fullLoop {S : Type*} {k : ℕ}
    (seq : TimeTurnerSequence S k) : S → S :=
  if _h : k = 0 then id
  else
    let steps := (List.ofFn seq.step).reverse
    steps.foldl (· ∘ ·) id

/-- The induced `TimeLoop` from a `TimeTurnerSequence`. -/
noncomputable def TimeTurnerSequence.toTimeLoop {S : Type*} {k : ℕ}
    (seq : TimeTurnerSequence S k) : TimeLoop S :=
  ⟨seq.fullLoop⟩

/-- **Main Synthesis Theorem.**
    Any finite sequence of time-turner actions over a finite nonempty state
    space resolves into a mathematically stable, paradox-free loop: there
    exists a state that periodically returns to itself under the composed
    transition. -/
theorem time_turner_consistency
    (S : Type*) [Finite S] [Nonempty S]
    {k : ℕ} (seq : TimeTurnerSequence S k) :
    ∃ s : S, ∃ p : ℕ, p > 0 ∧ seq.fullLoop^[p] s = s := by
  convert novikov_periodic_consistency S _

-- ============================================================================
-- PART 4: Concrete Example — Binary Universe with a Time Turner
-- ============================================================================

/-- A concrete example: a universe with two states (0 and 1), where the
    time-turner action flips the state. The self-consistent loop has period 2:
    the universe alternates between the two states. -/
example : ∃ s : Bool, ∃ k : ℕ, k > 0 ∧ (fun b : Bool => !b)^[k] s = s := by
  exists Bool.true, 2
