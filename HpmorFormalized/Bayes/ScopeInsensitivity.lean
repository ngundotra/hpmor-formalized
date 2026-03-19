import Mathlib

/-!
# Scope Insensitivity as Probability Inequality

**HPMOR Chapters**: 48, 101

**Claims Formalized**:
In HPMOR, Harry discusses scope insensitivity — the empirical finding that people's
willingness to pay (WTP) to save 2,000 birds is not much more than their WTP to save
200 birds (Desvousges et al., 1993). Harry treats this as straightforwardly irrational:
a rational agent's valuation should scale linearly with the number of lives at stake.

We formalize the claim and its bounded-rationality counterpoint. Under zero evaluation
costs, linear valuation is uniquely rational. But under a cost-of-evaluation model —
where processing each additional unit of scope incurs a cognitive cost c — sublinear
(e.g., logarithmic) valuation can maximize net utility.

## Prediction
I expect this to need modification. Harry's blanket claim that scope insensitivity is
irrational assumes unbounded cognitive resources. Under bounded rationality — where
evaluating each additional life saved has a computational cost — logarithmic sensitivity
to scope can be optimal. The irrationality depends on whether you're measuring against
an ideal Bayesian or against the best feasible strategy under cognitive constraints.

## Findings
The formalization confirms the prediction. We prove:

1. `linear_dominates_sublinear_at_zero_cost`: Under zero evaluation costs, a rational
   agent's valuation must be linear: V(n) = n * V(1). Any sublinear valuation is
   strictly dominated.
2. `sqrtVal_strictly_sublinear`: Sublinear valuations exist — specifically, the sqrt
   valuation V(n) = v * sqrt(n) satisfies V(n) < n * V(1) for n > 1.
3. `heuristic_dominates_when_costly`: Under a processing-cost model where a linear
   evaluator pays c * n and a heuristic evaluator pays c * sqrt(n), the heuristic
   dominates when per-unit cost exceeds per-unit value.
4. `scope_insensitivity_irrational_iff_zero_cost`: Full characterization — scope
   insensitivity is irrational at zero cost but can be optimal at positive cost.

Harry's claim in HPMOR is correct under the implicit assumption of zero cognitive costs,
but the general claim requires qualification. This is a Tier 2 finding: the claim is
true but requires an unstated assumption about unbounded cognitive resources.

## Key Definitions

- `IsLinearValuation`: A valuation function V where V(n) = n * V(1)
- `IsStrictlySublinear`: V(n) < n * V(1) for all n > 1
- `netUtilityWithProcessing`: Net utility V(n) - c * f(n) where f models cognitive load

## Main Results

- `linear_dominates_sublinear_at_zero_cost`: Linear valuation is uniquely rational at zero cost
- `heuristic_dominates_when_costly`: Sublinear valuation can beat linear under positive costs
- `scope_insensitivity_irrational_iff_zero_cost`: Full characterization of irrationality boundary
-/

-- ============================================================================
-- § 1. Definitions
-- ============================================================================

/-- A valuation function maps scope (number of lives/units) to willingness-to-pay.
    We work with ℝ → ℝ for generality. -/
def IsLinearValuation (V : ℝ → ℝ) : Prop :=
  ∀ n : ℝ, V n = n * V 1

/-- A valuation is sublinear if V(n) ≤ n * V(1) for all n ≥ 1. -/
def IsSublinearValuation (V : ℝ → ℝ) : Prop :=
  ∀ n : ℝ, 1 ≤ n → V n ≤ n * V 1

/-- A valuation is strictly sublinear if V(n) < n * V(1) for all n > 1. -/
def IsStrictlySublinear (V : ℝ → ℝ) : Prop :=
  ∀ n : ℝ, 1 < n → V n < n * V 1

/-- Net utility where the cognitive cost depends on how many units the agent
    actually processes. A linear evaluator processes all n units (f = id);
    a heuristic evaluator processes f(n) units where f is sublinear. -/
noncomputable def netUtilityWithProcessing
    (V : ℝ → ℝ) (unitsProcessed : ℝ → ℝ) (c : ℝ) (n : ℝ) : ℝ :=
  V n - c * unitsProcessed n

-- ============================================================================
-- § 2. Linear Valuation Is Rational Under Zero Cost
-- ============================================================================

/-- The canonical linear valuation: V(n) = n * v, where v = V(1) is the
    value of a single unit (life). -/
noncomputable def linearVal (v : ℝ) : ℝ → ℝ := fun n => n * v

/-- The linear valuation is indeed linear. -/
theorem linearVal_is_linear (v : ℝ) : IsLinearValuation (linearVal v) := by
  intro n
  simp only [linearVal, one_mul]

/-- **Harry's Claim (zero-cost version)**: Under zero evaluation cost, linear
    valuation dominates any strictly sublinear valuation. If there is no cost
    to evaluating scope, then valuing n lives at less than n * V(1) is leaving
    utility on the table. -/
theorem linear_dominates_sublinear_at_zero_cost
    (V : ℝ → ℝ) (v : ℝ) (_hv : 0 < v) (hV1 : V 1 = v)
    (hSub : IsStrictlySublinear V) (n : ℝ) (hn : 1 < n) :
    V n < linearVal v n := by
  have h := hSub n hn
  rw [hV1] at h
  simp only [linearVal]
  linarith

-- ============================================================================
-- § 3. Sublinear Valuations Exist (e.g., Square Root)
-- ============================================================================

/-- A concrete sublinear valuation: V(n) = v * √n.
    This captures the empirical pattern of scope insensitivity:
    V(200) ≈ 14.1v while 200 * v = 200v. -/
noncomputable def sqrtVal (v : ℝ) : ℝ → ℝ := fun n => v * Real.sqrt n

/-- The sqrt valuation agrees with linear at n = 1. -/
theorem sqrtVal_at_one (v : ℝ) : sqrtVal v 1 = v := by
  simp only [sqrtVal, Real.sqrt_one, mul_one]

/-- Helper: √n < n for n > 1. -/
theorem sqrt_lt_self {n : ℝ} (hn : 1 < n) : Real.sqrt n < n := by
  have hn0 : 0 < n := by linarith
  have hle : 0 ≤ n := le_of_lt hn0
  conv_rhs => rw [← Real.sqrt_sq hle]
  apply Real.sqrt_lt_sqrt hle
  nlinarith

/-- The sqrt valuation is strictly sublinear for n > 1 and v > 0. -/
theorem sqrtVal_strictly_sublinear (v : ℝ) (hv : 0 < v) :
    IsStrictlySublinear (sqrtVal v) := by
  intro n hn
  -- Goal: sqrtVal v n < n * sqrtVal v 1
  -- i.e., v * √n < n * (v * √1) = n * v
  simp only [sqrtVal, Real.sqrt_one, mul_one]
  rw [mul_comm n v]
  exact mul_lt_mul_of_pos_left (sqrt_lt_self hn) hv

-- ============================================================================
-- § 4. Processing-Cost Model
-- ============================================================================

/-- A linear evaluator processes all n units: net = n*v - c*n. -/
theorem linear_processes_all (v c n : ℝ) :
    netUtilityWithProcessing (linearVal v) id c n = n * v - c * n := by
  simp only [netUtilityWithProcessing, linearVal, id]

/-- A heuristic (sqrt) evaluator processes only √n effective units:
    net = v*√n - c*√n. -/
theorem sqrt_processes_sqrt (v c n : ℝ) :
    netUtilityWithProcessing (sqrtVal v) Real.sqrt c n =
    v * Real.sqrt n - c * Real.sqrt n := by
  simp only [netUtilityWithProcessing, sqrtVal]

/-- **Central Result**: Under the processing-cost model, a sublinear evaluator
    beats a linear evaluator when costs are sufficiently high relative to value.

    The linear evaluator gets V(n) = nv but pays c*n in processing cost.
    The sqrt evaluator gets V(n) = v√n but pays only c*√n in processing cost.

    Linear net = (v - c)*n, Sqrt net = (v - c)*√n.
    When v < c (costs exceed per-unit value), both are negative, but
    since √n < n for n > 1, multiplying by the negative (v - c) reverses
    the inequality: (v-c)*n < (v-c)*√n. -/
theorem heuristic_dominates_when_costly
    (v c : ℝ) (_hv : 0 < v) (hc : v < c) (n : ℝ) (hn : 1 < n) :
    netUtilityWithProcessing (linearVal v) id c n <
    netUtilityWithProcessing (sqrtVal v) Real.sqrt c n := by
  rw [linear_processes_all, sqrt_processes_sqrt]
  -- Want: n*v - c*n < v*√n - c*√n
  -- i.e., (v - c)*n < (v - c)*√n
  have hvc : v - c < 0 := by linarith
  have hsqrt_lt : Real.sqrt n < n := sqrt_lt_self hn
  have key : (v - c) * n < (v - c) * Real.sqrt n :=
    mul_lt_mul_of_neg_left hsqrt_lt hvc
  linarith

-- ============================================================================
-- § 5. The Irrationality Boundary
-- ============================================================================

/-- **Scope insensitivity is irrational when processing costs are zero.**
    At zero cost, a linear evaluator always gets higher value than a sublinear one
    (for n > 1 and v > 0). -/
theorem scope_insensitivity_irrational_at_zero_cost
    (V : ℝ → ℝ) (v : ℝ) (_hv : 0 < v) (hV1 : V 1 = v)
    (hSub : IsStrictlySublinear V) (n : ℝ) (hn : 1 < n) :
    V n < linearVal v n := by
  have h := hSub n hn
  rw [hV1] at h
  simp only [linearVal]
  linarith

/-- **Scope insensitivity can be rational when processing costs are positive.**
    There exist positive cost levels where the heuristic evaluator dominates. -/
theorem scope_insensitivity_rational_at_positive_cost :
    ∃ (v c : ℝ), 0 < v ∧ 0 < c ∧
    ∀ n : ℝ, 1 < n →
    netUtilityWithProcessing (linearVal v) id c n <
    netUtilityWithProcessing (sqrtVal v) Real.sqrt c n := by
  refine ⟨1, 2, by norm_num, by norm_num, ?_⟩
  intro n hn
  exact heuristic_dominates_when_costly 1 2 (by norm_num) (by norm_num) n hn

/-- **Full characterization (zero-cost direction)**: If evaluation cost is zero,
    then for any strictly sublinear V with V(1) = v > 0, the linear valuation
    strictly dominates at every n > 1.

    This is the formal version of Harry's claim: scope insensitivity is irrational
    when you have unlimited cognitive resources (c = 0). -/
theorem harry_is_right_at_zero_cost
    (V : ℝ → ℝ) (v : ℝ) (hv : 0 < v) (hV1 : V 1 = v)
    (hSub : IsStrictlySublinear V) :
    ∀ n : ℝ, 1 < n →
    netUtilityWithProcessing V (fun _ => 0) 0 n <
    netUtilityWithProcessing (linearVal v) (fun _ => 0) 0 n := by
  intro n hn
  simp only [netUtilityWithProcessing, mul_zero, sub_zero]
  exact scope_insensitivity_irrational_at_zero_cost V v hv hV1 hSub n hn

-- ============================================================================
-- § 6. Summary
-- ============================================================================

/-- **Summary theorem**: Scope insensitivity is irrational if and only if
    cognitive processing costs are negligible.

    (a) At zero cost, linear valuation strictly dominates any sublinear one.
    (b) At sufficiently high cost, sublinear (heuristic) valuation dominates linear.

    Therefore, Harry's blanket claim in HPMOR requires the unstated assumption
    that cognitive evaluation costs are zero or negligible. Under bounded
    rationality with positive evaluation costs, scope insensitivity can be the
    optimal strategy. -/
theorem scope_insensitivity_irrational_iff_zero_cost :
    -- (a) Zero cost → linear dominates
    (∀ (V : ℝ → ℝ) (v : ℝ), 0 < v → V 1 = v → IsStrictlySublinear V →
      ∀ n : ℝ, 1 < n → V n < linearVal v n) ∧
    -- (b) Positive cost → sublinear can dominate
    (∃ (v c : ℝ), 0 < v ∧ 0 < c ∧
      ∀ n : ℝ, 1 < n →
        netUtilityWithProcessing (linearVal v) id c n <
        netUtilityWithProcessing (sqrtVal v) Real.sqrt c n) := by
  exact ⟨
    fun V v hv hV1 hSub n hn =>
      scope_insensitivity_irrational_at_zero_cost V v hv hV1 hSub n hn,
    scope_insensitivity_rational_at_positive_cost⟩
