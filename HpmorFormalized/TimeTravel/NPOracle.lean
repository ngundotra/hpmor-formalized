import Mathlib
import HpmorFormalized.TimeTravel.Novikov

/-!
# Time-Turner as NP Oracle: The Multiple Fixed-Point Problem

**HPMOR Chapter**: 17

**Claim Formalized**:
Harry considers whether the Time-Turner could solve NP-complete problems:
send a potential solution back in time, check it, and only send it if it's
correct. The self-consistency constraint (Novikov principle) means the loop
only stabilizes if a valid solution exists. This would make NP problems
solvable in polynomial time using a time machine.

## The Argument (Informal)

1. You have an NP decision problem with a polynomial-time verifier.
2. You receive a message from the future (via Time-Turner): `Option Solution`.
3. If you receive `some s`, you verify it. If valid, send `some s` back. If
   invalid, send `none` back.
4. If you receive `none`, you also send `none` back.
5. Self-consistency: the state must be a fixed point of this transition.
6. **Harry's hope**: If a valid solution exists, the self-consistent loop
   must contain it, because the `none` loop would be "unstable."

## The Flaw: Multiple Fixed Points

The key insight revealed by formalization:

- `none` is **always** a fixed point of the transition function, regardless
  of whether a solution exists. (Receive nothing → send nothing → consistent.)
- If a valid solution `s` exists, then `some s` is **also** a fixed point.
  (Receive `s` → verify `s` → valid → send `s` → consistent.)
- The Novikov principle guarantees that **a** consistent loop exists, but
  does not specify **which** fixed point the universe selects.
- Therefore, even when a valid solution exists, the universe can always
  choose the trivial `none` fixed point. Self-consistency alone provides
  no computational power.

## Tier 3 Finding

**The multiple-fixed-point problem**: Self-consistency is necessary but not
sufficient for computational usefulness. The Novikov principle guarantees
existence of consistent loops, but the "trivial" loop (nothing sent, nothing
received) is always available as an alternative. To use a time machine as
an NP oracle, you would need an additional physical principle that selects
the "interesting" fixed point over the trivial one — and no such principle
is known or motivated by physics.

This is precisely the gap between "consistent loops exist" (Novikov) and
"consistent loops solve problems" (the NP oracle claim).
-/

open Function

-- ============================================================================
-- § 1. NP Problem and Time-Loop Oracle Model
-- ============================================================================

/-- An `NPProblem` models an NP decision problem with:
    - `Solution`: the type of candidate solutions (witnesses)
    - `verify`: a function that checks whether a candidate is a valid solution
    The key property of NP is that `verify` runs in polynomial time,
    but we abstract over computational complexity here and focus on the
    logical structure. -/
structure NPProblem where
  /-- The type of candidate solutions / witnesses. -/
  Solution : Type
  /-- The verifier: returns `true` iff the candidate is a valid solution. -/
  verify : Solution → Bool

/-- The state of the time loop: either a candidate solution was sent back
    in time, or nothing was sent. -/
abbrev LoopState (P : NPProblem) := Option P.Solution

/-- The time-loop transition function for the NP oracle scheme.
    - If a candidate `s` is received and it verifies, send it back (`some s`).
    - If a candidate `s` is received but fails verification, send `none`.
    - If `none` is received, send `none`.

    This models Harry's proposed protocol: only propagate valid solutions. -/
def npOracleTransition (P : NPProblem) : LoopState P → LoopState P
  | none => none
  | some s => if P.verify s then some s else none

-- ============================================================================
-- § 2. The Trivial Fixed Point: `none` is Always Self-Consistent
-- ============================================================================

/-- **The trivial fixed point.**
    `none` (no solution sent) is always a fixed point of the NP oracle
    transition, regardless of whether a valid solution exists.
    This is the crux of the problem: the "do nothing" loop is always
    self-consistent. -/
theorem none_is_fixpoint (P : NPProblem) :
    npOracleTransition P none = none := by
  rfl

/-- `none` is self-consistent in the TimeLoop sense. -/
theorem none_is_selfConsistent (P : NPProblem) :
    (TimeLoop.mk (npOracleTransition P)).selfConsistent none := by
  exact none_is_fixpoint P

-- ============================================================================
-- § 3. Valid Solutions are Also Fixed Points
-- ============================================================================

/-- **The solution fixed point.**
    If `s` is a valid solution (passes verification), then `some s` is
    also a fixed point of the transition. -/
theorem valid_solution_is_fixpoint (P : NPProblem) (s : P.Solution)
    (hs : P.verify s = true) :
    npOracleTransition P (some s) = some s := by
  simp [npOracleTransition, hs]

/-- A valid solution is self-consistent in the TimeLoop sense. -/
theorem valid_solution_is_selfConsistent (P : NPProblem) (s : P.Solution)
    (hs : P.verify s = true) :
    (TimeLoop.mk (npOracleTransition P)).selfConsistent (some s) := by
  exact valid_solution_is_fixpoint P s hs

-- ============================================================================
-- § 4. Invalid Solutions are NOT Fixed Points
-- ============================================================================

/-- **Invalid solutions are expelled.**
    If `s` fails verification, `some s` is NOT a fixed point: the loop
    transitions to `none`. This is what makes the scheme "almost work" —
    invalid solutions cannot persist in a self-consistent loop. -/
theorem invalid_solution_not_fixpoint (P : NPProblem) (s : P.Solution)
    (hs : P.verify s = false) :
    npOracleTransition P (some s) = none := by
  simp [npOracleTransition, hs]

theorem invalid_solution_not_selfConsistent (P : NPProblem) (s : P.Solution)
    (hs : P.verify s = false) :
    ¬ (TimeLoop.mk (npOracleTransition P)).selfConsistent (some s) := by
  simp [TimeLoop.selfConsistent, npOracleTransition, hs]

-- ============================================================================
-- § 5. Complete Characterization of Fixed Points
-- ============================================================================

/-- **Full characterization of fixed points.**
    A state is a fixed point of the NP oracle transition if and only if:
    - It is `none`, OR
    - It is `some s` where `s` is a valid solution.

    This is the key structural result: we know exactly what the fixed
    points look like. -/
theorem fixpoint_characterization (P : NPProblem) (state : LoopState P) :
    npOracleTransition P state = state ↔
    state = none ∨ ∃ s, state = some s ∧ P.verify s = true := by
  constructor
  · intro h
    cases state with
    | none => left; rfl
    | some s =>
      right; use s; refine ⟨rfl, ?_⟩
      by_contra h_neg
      push_neg at h_neg
      have : P.verify s = false := Bool.eq_false_iff.mpr h_neg
      have := invalid_solution_not_fixpoint P s this
      rw [this] at h
      simp at h
  · intro h
    cases h with
    | inl h => subst h; rfl
    | inr h =>
      obtain ⟨s, hs_eq, hs_ver⟩ := h
      subst hs_eq
      exact valid_solution_is_fixpoint P s hs_ver

-- ============================================================================
-- § 6. The Multiple Fixed-Point Problem (Main Result)
-- ============================================================================

/-- **Multiple fixed points when a solution exists.**
    If the NP problem has a valid solution, then the transition function
    has at least TWO distinct fixed points: `none` and `some s`.
    This is the formal statement of the "multiple fixed-point problem"
    that undermines the NP oracle argument. -/
theorem multiple_fixpoints_when_solvable (P : NPProblem) (s : P.Solution)
    (hs : P.verify s = true) :
    ∃ fp₁ fp₂ : LoopState P,
      fp₁ ≠ fp₂ ∧
      npOracleTransition P fp₁ = fp₁ ∧
      npOracleTransition P fp₂ = fp₂ := by
  refine ⟨none, some s, ?_, none_is_fixpoint P, valid_solution_is_fixpoint P s hs⟩
  intro h; simp at h

/-- **The trivial fixed point persists even with solutions.**
    Even when a valid solution exists, `none` remains a fixed point.
    The universe can always "choose" the trivial loop. -/
theorem trivial_fixpoint_always_available (P : NPProblem) :
    ∀ (_evidence : ∃ s, P.verify s = true),
    npOracleTransition P none = none := by
  intro _
  rfl

-- ============================================================================
-- § 7. Self-Consistency Alone Cannot Select the Useful Fixed Point
-- ============================================================================

/-- A `FixedPointSelector` is any rule that picks a fixed point from
    the set of all fixed points. This models the "additional physics"
    that would be needed to make the NP oracle work. -/
structure FixedPointSelector (P : NPProblem) where
  /-- The selected state. -/
  selected : LoopState P
  /-- It must be a fixed point. -/
  is_fixpoint : npOracleTransition P selected = selected

/-- There always exists a selector that picks the trivial (useless) fixed point.
    This shows that self-consistency alone cannot guarantee computational
    usefulness: there is always a self-consistent selection that provides
    no information about the NP problem. -/
theorem trivial_selector_exists (P : NPProblem) :
    ∃ sel : FixedPointSelector P, sel.selected = none :=
  ⟨⟨none, rfl⟩, rfl⟩

/-- When a solution exists, there also exists a selector that picks it.
    But nothing in the self-consistency framework distinguishes this
    selector from the trivial one. -/
theorem solution_selector_exists (P : NPProblem) (s : P.Solution)
    (hs : P.verify s = true) :
    ∃ sel : FixedPointSelector P, sel.selected = some s :=
  ⟨⟨some s, valid_solution_is_fixpoint P s hs⟩, rfl⟩

/-- **The indistinguishability theorem.**
    Both the trivial selector and the solution selector satisfy the
    self-consistency constraint. No property expressible purely in terms
    of `npOracleTransition` can distinguish them — they are both valid
    fixed-point selections.

    More precisely: for any predicate on `FixedPointSelector` that is
    determined solely by the fixed-point property (i.e., holds for all
    selectors or none), we cannot use it to prefer the solution selector
    over the trivial one. -/
theorem selectors_both_valid (P : NPProblem) (s : P.Solution)
    (hs : P.verify s = true)
    (pred : FixedPointSelector P → Prop)
    (h_uniform : ∀ sel₁ sel₂ : FixedPointSelector P, pred sel₁ → pred sel₂) :
    pred ⟨none, rfl⟩ ↔ pred ⟨some s, valid_solution_is_fixpoint P s hs⟩ := by
  constructor
  · exact h_uniform _ _
  · exact h_uniform _ _

-- ============================================================================
-- § 8. When the Problem is Unsolvable, Only the Trivial Fixed Point Exists
-- ============================================================================

/-- **Unsolvable problems have a unique fixed point.**
    If no valid solution exists, `none` is the ONLY fixed point.
    In this case, the NP oracle scheme gives the correct answer
    (no solution) — but vacuously, since it always returns `none`. -/
theorem unique_fixpoint_when_unsolvable (P : NPProblem)
    (h_unsolvable : ∀ s, P.verify s = false) :
    ∀ state : LoopState P,
      npOracleTransition P state = state → state = none := by
  intro state hfix
  cases state with
  | none => rfl
  | some s =>
    exfalso
    simp [npOracleTransition, h_unsolvable s] at hfix

/-- The contrapositive: if a non-trivial fixed point exists, a solution exists. -/
theorem nontrivial_fixpoint_implies_solvable (P : NPProblem)
    (state : LoopState P) (h_nontrivial : state ≠ none)
    (hfix : npOracleTransition P state = state) :
    ∃ s, P.verify s = true := by
  cases state with
  | none => exact absurd rfl h_nontrivial
  | some s =>
    refine ⟨s, ?_⟩
    by_contra h_neg
    push_neg at h_neg
    have hf : P.verify s = false := Bool.eq_false_iff.mpr h_neg
    have := invalid_solution_not_fixpoint P s hf
    rw [this] at hfix
    simp at hfix

-- ============================================================================
-- § 9. Connection to Novikov: The Time Loop Always Has a Consistent State
-- ============================================================================

/-- The NP oracle transition always has `none` as a fixed point, so
    Novikov consistency is trivially satisfied — but in a useless way. -/
theorem np_oracle_novikov_trivial (P : NPProblem) :
    (TimeLoop.mk (npOracleTransition P)).selfConsistent none := by
  exact none_is_fixpoint P

-- ============================================================================
-- § 10. The Core Asymmetry: Information-Theoretic Analysis
-- ============================================================================

/-- **The oracle is asymmetric.**
    The NP oracle can confirm solutions (if received from the future)
    but cannot generate them. When `none` is received, nothing is learned
    and `none` is sent back — a perfectly self-consistent but informationally
    vacuous loop.

    We formalize this as: for any problem, there exists a fixed point
    that carries zero bits of information about the solution. -/
theorem zero_information_fixpoint_exists (P : NPProblem) :
    ∃ state : LoopState P,
      npOracleTransition P state = state ∧ state = none :=
  ⟨none, rfl, rfl⟩

/-- **Summary theorem: The NP oracle scheme fails.**
    For any NP problem:
    1. `none` is always a fixed point (the trivial loop).
    2. Valid solutions are also fixed points (the useful loop).
    3. Self-consistency cannot distinguish between them.
    Therefore, the Time-Turner cannot solve NP problems via
    self-consistency alone. -/
theorem np_oracle_scheme_fails (P : NPProblem) :
    -- The trivial fixed point always exists
    (npOracleTransition P none = none) ∧
    -- Valid solutions are also fixed points
    (∀ s, P.verify s = true → npOracleTransition P (some s) = some s) ∧
    -- If unsolvable, only trivial fixed point exists
    ((∀ s, P.verify s = false) →
      ∀ state, npOracleTransition P state = state → state = none) := by
  exact ⟨rfl,
    fun s hs => valid_solution_is_fixpoint P s hs,
    fun h_unsolv state hfix => unique_fixpoint_when_unsolvable P h_unsolv state hfix⟩
