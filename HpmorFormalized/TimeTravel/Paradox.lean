import Mathlib
import HpmorFormalized.TimeTravel.Novikov

/-!
# Deterministic Time Travel: Fixed-Point Resolution of Paradoxes

**HPMOR Chapters**: 11-17, 61-63 (Time-Turner rules and paradox avoidance)

**Claims Formalized**:
In HPMOR, the universe enforces consistency on time travel: if you attempt to
create a paradox (e.g., going back in time to prevent your own time travel),
the universe "finds" a consistent resolution — often a surprising third option
that the time traveler didn't anticipate. This is the grandfather paradox and
its resolution via fixed-point theory.

We formalize **general** theorems about fixed points and paradox resolution
for arbitrary finite types and arbitrary transition functions, then illustrate
with the concrete 3-element example from the original module.

## Overview

- **Consistency as fixed points**: A state `s` is consistent under a round-trip
  map `g = B ∘ F` if and only if `g s = s` — it is a fixed point.
- **Paradox**: A fixed-point-free map on a type `S` means no state of `S` is
  self-consistent. This is the general grandfather paradox.
- **Resolution by extension**: Extending the state space with additional states
  can introduce fixed points. We characterize exactly when a map on `S ⊕ T`
  that restricts to a given `f` on `S` acquires fixed points.
- **Unique fixed point**: We give a general criterion for a function on a
  finite type to have exactly one fixed point.
- **Connection to Novikov**: Periodic consistency (from `Novikov.lean`) implies
  the existence of a fixed point of an iterated map, linking the paradox
  resolution framework to the Novikov self-consistency principle.

## Findings

- **Hidden assumptions**: The informal HPMOR argument implicitly assumes that
  the "universe override" state is a fixed point of the *composed* round-trip
  map `B ∘ F`, not just of `F` alone. Formalization forces this to be explicit:
  the backward map `B` must also cooperate for consistency.
- **Boundary conditions**: A fixed-point-free map on a finite type with `n`
  elements can always be repaired by extending to a type with `n + 1` elements
  (Theorem `fpfree_extension_has_fixpoint`). However, we prove the extension
  must map *at least one new state to itself* — the new states cannot all be
  mapped among themselves non-trivially. This means the "universe override"
  is not an arbitrary addition; it must genuinely be a resting state.
- **Unexpected lemmas**: The proof that every function on a finite type has
  a fixed point iff it is not fixed-point-free is definitionally trivial,
  but the proof that extending by even one state *suffices* to guarantee a
  fixed point required choosing the extension carefully (mapping the new
  state to itself). This is a constructive existence proof.
- **Connection to known math**: The unique fixed point characterization is
  closely related to the Banach fixed-point theorem's uniqueness guarantee,
  specialized to discrete finite spaces where "contraction" becomes
  "all non-fixed states are mapped away from themselves."
- **Assessment**: Tier 3 — The formalization reveals that paradox resolution
  in HPMOR requires not just adding states, but adding *self-stabilizing*
  states. The connection between periodic consistency and fixed points of
  iterated maps provides a bridge between the two time-travel formalizations
  that was not explicit in the informal treatment.
-/

open Function Finset

-- ============================================================================
-- § 1. General Definitions
-- ============================================================================

/-- A state `s` is **consistent** (a fixed point) under a round-trip map `g`
    if `g s = s`. This generalizes the previous `Consistent` definition to
    work on any type and any endofunction. -/
def IsConsistent {S : Type*} (g : S → S) (s : S) : Prop := g s = s

/-- A function is **fixed-point-free** if no element maps to itself. -/
def IsFixedPointFree {S : Type*} (g : S → S) : Prop := ∀ s, g s ≠ s

/-- A map **has a valid loop** if some state is a fixed point. -/
def HasFixedPoint {S : Type*} (g : S → S) : Prop := ∃ s, IsConsistent g s

-- ============================================================================
-- § 2. The General Paradox: Fixed-Point-Free Maps Admit No Consistent State
-- ============================================================================

/-- **General Grandfather Paradox.**
    If a round-trip map `g : S → S` is fixed-point-free, then no state is
    self-consistent. This is the abstract form of the grandfather paradox:
    if every state leads to a different state after one loop traversal,
    no timeline can be self-consistent.

    This generalizes `actionA_inconsistent` and `actionB_inconsistent` from
    the original module: those were instances of this theorem for specific
    elements of a specific enum. -/
theorem no_fixpoint_of_fpfree {S : Type*} (g : S → S) (hfpf : IsFixedPointFree g) :
    ¬ HasFixedPoint g := by
  intro ⟨s, hs⟩
  exact hfpf s hs

/-- Converse: if a map has no fixed point, it is fixed-point-free. -/
theorem fpfree_of_no_fixpoint {S : Type*} (g : S → S) (hno : ¬ HasFixedPoint g) :
    IsFixedPointFree g := by
  intro s hs
  exact hno ⟨s, hs⟩

/-- A map has a fixed point if and only if it is not fixed-point-free. -/
theorem hasFixedPoint_iff_not_fpfree {S : Type*} (g : S → S) :
    HasFixedPoint g ↔ ¬ IsFixedPointFree g := by
  constructor
  · intro ⟨s, hs⟩ hfpf
    exact hfpf s hs
  · intro h
    by_contra hno
    exact h (fpfree_of_no_fixpoint g hno)

/-- **Decidable fixed-point existence on finite types.**
    For a decidable-equality finite type, whether a map has a fixed point
    is decidable. -/
instance {S : Type*} [Fintype S] [DecidableEq S] (g : S → S) :
    Decidable (HasFixedPoint g) := by
  unfold HasFixedPoint IsConsistent
  exact Fintype.decidableExistsFintype

-- ============================================================================
-- § 3. Resolution by Extension: Adding States to Create Fixed Points
-- ============================================================================

/-- **Extension lemma**: Given any function `f : S → S` (possibly fixed-point-free),
    we can always construct an extension `g : S ⊕ T → S ⊕ T` that has a fixed
    point, provided `T` is nonempty. The extension maps an element of `T` to itself.

    This is the general version of "adding UniverseOverride resolves the paradox":
    extending the state space with at least one new self-stabilizing state always
    works. -/
theorem fpfree_extension_has_fixpoint {S T : Type*} [Nonempty T]
    (f : S → S) :
    ∃ g : S ⊕ T → S ⊕ T,
      (∀ s : S, g (Sum.inl s) = Sum.inl (f s)) ∧
      HasFixedPoint g := by
  -- Construct g: map S via f, map each t ∈ T to itself
  let t₀ := Classical.arbitrary T
  refine ⟨fun x => match x with
    | Sum.inl s => Sum.inl (f s)
    | Sum.inr t => Sum.inr t, fun s => rfl, ⟨Sum.inr t₀, rfl⟩⟩

/-- **Minimality of extension**: If `f : S → S` is fixed-point-free and
    `g : S ⊕ T → S ⊕ T` extends `f` (maps `S` into `S` via `f`) and has
    a fixed point, then that fixed point must come from `T`, not from `S`. -/
theorem fixpoint_in_extension_not_in_original {S T : Type*}
    (f : S → S) (hfpf : IsFixedPointFree f)
    (g : S ⊕ T → S ⊕ T)
    (hext : ∀ s : S, g (Sum.inl s) = Sum.inl (f s))
    (s_or_t : S ⊕ T) (hfix : IsConsistent g s_or_t) :
    ∃ t : T, s_or_t = Sum.inr t := by
  cases s_or_t with
  | inl s =>
    exfalso
    have hfix' : g (Sum.inl s) = Sum.inl s := hfix
    rw [hext] at hfix'
    exact hfpf s (Sum.inl.inj hfix')
  | inr t => exact ⟨t, rfl⟩

-- ============================================================================
-- § 4. Unique Fixed Point Characterization
-- ============================================================================

/-- **Unique fixed point theorem for finite types.**
    A function `g` on a finite type has exactly one fixed point if and only if
    there exists a fixed point and all fixed points are equal.

    This generalizes `unique_consistent_state` from the original module. -/
theorem unique_fixpoint_iff {S : Type*} (g : S → S) :
    (∃! s, IsConsistent g s) ↔
    (∃ s, IsConsistent g s) ∧
    (∀ s₁ s₂, IsConsistent g s₁ → IsConsistent g s₂ → s₁ = s₂) := by
  constructor
  · intro ⟨s, hs, huniq⟩
    exact ⟨⟨s, hs⟩, fun s₁ s₂ h₁ h₂ => (huniq s₁ h₁).trans (huniq s₂ h₂).symm⟩
  · intro ⟨⟨s, hs⟩, huniq⟩
    exact ⟨s, hs, fun s' hs' => huniq s' s hs' hs⟩

/-- **Counting fixed points on finite types.**
    The number of fixed points of `g : S → S` on a finite type equals the
    cardinality of `{s | g s = s}`. -/
noncomputable def fixpointCount {S : Type*} [Fintype S] [DecidableEq S] (g : S → S) : ℕ :=
  (Finset.univ.filter (fun s => g s = s)).card

/-- A function on a finite type has a unique fixed point iff the fixed point count is 1. -/
theorem unique_fixpoint_iff_count_eq_one {S : Type*} [Fintype S] [DecidableEq S] (g : S → S) :
    (∃! s, IsConsistent g s) ↔ fixpointCount g = 1 := by
  simp only [fixpointCount, IsConsistent]
  rw [Finset.card_eq_one]
  constructor
  · intro ⟨s, hs, huniq⟩
    refine ⟨s, Finset.ext fun x => ?_⟩
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_singleton]
    exact ⟨fun hx => huniq x hx, fun hx => hx ▸ hs⟩
  · intro ⟨s, hs⟩
    refine ⟨s, ?_, ?_⟩
    · have hmem : s ∈ Finset.univ.filter (fun x => g x = x) := by
        rw [hs]; exact Finset.mem_singleton.mpr rfl
      rw [Finset.mem_filter] at hmem
      exact hmem.2
    · intro s' hs'
      have : s' ∈ Finset.univ.filter (fun x => g x = x) := by
        simp [Finset.mem_filter, hs']
      rw [hs] at this
      exact Finset.mem_singleton.mp this

/-- A function has no fixed point iff the fixed point count is 0. -/
theorem no_fixpoint_iff_count_eq_zero {S : Type*} [Fintype S] [DecidableEq S] (g : S → S) :
    IsFixedPointFree g ↔ fixpointCount g = 0 := by
  unfold IsFixedPointFree fixpointCount
  constructor
  · intro h
    rw [Finset.card_eq_zero]
    rw [Finset.filter_eq_empty_iff]
    intro x _
    exact h x
  · intro h x hx
    have hmem : x ∈ Finset.univ.filter (fun s => g s = s) := by
      rw [Finset.mem_filter]; exact ⟨Finset.mem_univ x, hx⟩
    rw [Finset.card_eq_zero] at h
    rw [h] at hmem
    exact absurd hmem (Finset.notMem_empty x)

-- ============================================================================
-- § 5. Connection to Novikov: Periodic Consistency Implies Iterated Fixed Point
-- ============================================================================

/-- **Periodic consistency implies iterated fixed point.**
    If a state `s` is periodically consistent with period `k` under transition
    `f`, then `s` is a fixed point of `f^k`. This connects the Novikov
    self-consistency principle to the paradox resolution framework: a
    periodically consistent state resolves the "iterated paradox" for `f^k`. -/
theorem periodic_implies_iterate_fixpoint {S : Type*}
    (tl : TimeLoop S) (s : S) (k : ℕ)
    (hpc : tl.periodicConsistent s k) :
    IsConsistent (tl.transition^[k]) s := by
  exact hpc.2

/-- **Novikov guarantees paradox resolution for iterated maps.**
    On a finite nonempty type, for every transition function `f`, there
    exists some `k > 0` such that `f^k` has a fixed point. In other words,
    even if `f` itself is fixed-point-free (a "paradoxical" map), some
    iterate of `f` always has a consistent state.

    This is the key bridge between Novikov.lean and Paradox.lean: the
    Novikov principle guarantees that paradoxes are always resolvable
    by allowing multi-step loops. -/
theorem novikov_resolves_iterated_paradox
    (S : Type*) [Finite S] [Nonempty S]
    (f : S → S) :
    ∃ k : ℕ, k > 0 ∧ HasFixedPoint (f^[k]) := by
  have ⟨s, k, hpc⟩ := novikov_periodic_consistency S ⟨f⟩
  exact ⟨k, hpc.1, s, hpc.2⟩

/-- **Fixed-point-free maps require multi-step resolution.**
    If `f` is fixed-point-free but we are on a finite nonempty type,
    the resolution period `k` guaranteed by Novikov must be at least 2.
    This formalizes the intuition that paradoxical maps need "extra time"
    to find consistency. -/
theorem fpfree_resolution_period_ge_two
    (S : Type*) [Finite S] [Nonempty S]
    (f : S → S) (hfpf : IsFixedPointFree f) :
    ∀ k, k > 0 → HasFixedPoint (f^[k]) → k ≥ 2 := by
  intro k hk ⟨s, hs⟩
  by_contra h
  push_neg at h
  have hk1 : k = 1 := by omega
  subst hk1
  simp only [IsConsistent] at hs
  exact hfpf s hs

-- ============================================================================
-- § 6. Concrete Example: The 3-Element HPMOR Model
-- ============================================================================

/-- The original 3-element state space. -/
inductive HPMORState where
  | ActionA
  | ActionB
  | UniverseOverride
  deriving DecidableEq, Repr, Fintype

instance : Nonempty HPMORState := ⟨HPMORState.ActionA⟩

open HPMORState

/-- The paradoxical forward transition: swaps A and B, fixes Override. -/
def hpmorTransition : HPMORState → HPMORState
  | ActionA          => ActionB
  | ActionB          => ActionA
  | UniverseOverride => UniverseOverride

/-- The round-trip map (with identity backward map). -/
def hpmorRoundTrip : HPMORState → HPMORState := hpmorTransition

/-- ActionA and ActionB form a fixed-point-free restriction: the general
    paradox theorem applies. -/
theorem hpmor_AB_fpfree :
    ∀ s : HPMORState, s = ActionA ∨ s = ActionB → hpmorRoundTrip s ≠ s := by
  intro s hs
  rcases hs with rfl | rfl <;> simp [hpmorRoundTrip, hpmorTransition]

/-- The full round-trip map has UniverseOverride as its unique fixed point. -/
theorem hpmor_unique_fixpoint :
    ∃! s : HPMORState, IsConsistent hpmorRoundTrip s := by
  refine ⟨UniverseOverride, rfl, ?_⟩
  intro s hs
  cases s with
  | ActionA => simp [IsConsistent, hpmorRoundTrip, hpmorTransition] at hs
  | ActionB => simp [IsConsistent, hpmorRoundTrip, hpmorTransition] at hs
  | UniverseOverride => rfl

/-- The fixed point count is exactly 1. -/
theorem hpmor_fixpoint_count : fixpointCount hpmorRoundTrip = 1 := by
  rw [← unique_fixpoint_iff_count_eq_one]
  exact hpmor_unique_fixpoint

/-- The concrete example satisfies our general extension theorem:
    hpmorRoundTrip can be viewed as extending the swap on {A, B}
    with the override state, and the fixed point lands in the extension. -/
theorem hpmor_override_is_extension_fixpoint :
    ∀ s : HPMORState, IsConsistent hpmorRoundTrip s → s = UniverseOverride := by
  intro s hs
  cases s with
  | ActionA => simp [IsConsistent, hpmorRoundTrip, hpmorTransition] at hs
  | ActionB => simp [IsConsistent, hpmorRoundTrip, hpmorTransition] at hs
  | UniverseOverride => rfl
