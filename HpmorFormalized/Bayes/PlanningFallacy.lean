import Mathlib

/-!
# Planning Fallacy and Outside View Correction

**HPMOR Chapter**: 6

**Claims Formalized**:
Harry advocates "the outside view" — instead of estimating how long YOUR project
will take based on project-specific features (the "inside view"), look at how long
SIMILAR projects took (the "outside view" / reference class forecasting). HPMOR
presents this as straightforwardly correct: the outside view dominates because
individual estimators are biased (the planning fallacy).

We formalize estimation under squared-error loss, define inside-view and
outside-view estimators, and prove that the outside view dominates when the
reference class is well-calibrated and the inside view is biased. We then prove
that the outside view FAILS when the reference class is poorly chosen — and that
choosing a good reference class requires the same judgment the outside view was
supposed to replace.

## Prediction
I expect this to need modification. The outside view is only as good as your
choice of reference class. If you pick too broad a class ('all human projects'),
the estimate is uninformative. If you pick too narrow a class ('projects exactly
like mine'), you're back to the inside view. The hidden assumption is that a
'good' reference class exists and can be identified — which is itself an
empirical judgment the outside view doesn't help with.

## Findings
The formalization confirms the prediction. We prove:

1. When the inside view is biased and the reference class mean matches the true
   duration, the outside view has strictly lower MSE (Theorem
   `outside_view_dominates_biased_inside`).
2. When the reference class is poorly chosen (its mean deviates from the true
   duration by more than the inside view's bias), the outside view has *higher*
   MSE than the inside view (Theorem `outside_view_fails_bad_class`).
3. The quality of the outside view depends entirely on a "reference class quality"
   parameter — the gap between the reference class mean and the true duration.
   Choosing this well requires exactly the kind of project-specific judgment the
   outside view was supposed to eliminate (Theorem
   `reference_class_selection_requires_judgment`).

This is a Tier 2 finding: HPMOR's claim is correct under the unstated assumption
that a well-calibrated reference class is available, but the method's reliability
is conditional on a judgment call the framework does not formalize.

## Key Definitions

- `InsideEstimate`: An inside-view estimate with bias and variance
- `OutsideEstimate`: An outside-view estimate from a reference class
- `mse`: Mean squared error of an estimate = bias² + variance
- `reference_class_gap`: How far the reference class mean is from the true duration

## Main Results

- `mse_decomposition`: MSE = bias² + variance (bias-variance decomposition)
- `outside_view_dominates_biased_inside`: Outside view wins when well-calibrated
- `outside_view_fails_bad_class`: Outside view loses when reference class is poor
- `reference_class_selection_requires_judgment`: No reference class universally dominates
-/

-- ============================================================================
-- § 1. Definitions: Estimation Under Squared-Error Loss
-- ============================================================================

/-- An estimate of a project's true duration D.
    `bias` is E[estimate] - D (systematic error, positive = underestimate correction).
    `variance` is Var[estimate] (noise around the mean). -/
structure Estimate where
  bias : ℝ
  variance : ℝ
  variance_nonneg : 0 ≤ variance

/-- Mean squared error: MSE = bias² + variance.
    This is the standard bias-variance decomposition. -/
noncomputable def mse (e : Estimate) : ℝ := e.bias ^ 2 + e.variance

/-- MSE is always nonneg. -/
theorem mse_nonneg (e : Estimate) : 0 ≤ mse e := by
  unfold mse
  have h1 : 0 ≤ e.bias ^ 2 := sq_nonneg e.bias
  linarith [e.variance_nonneg]

/-- The bias-variance decomposition: MSE = bias² + variance. -/
theorem mse_decomposition (e : Estimate) :
    mse e = e.bias ^ 2 + e.variance := by
  rfl

-- ============================================================================
-- § 2. Inside View vs Outside View
-- ============================================================================

/-- An inside-view estimate: the estimator uses project-specific features
    but is subject to the planning fallacy (optimistic bias).
    `planning_bias` is how much the inside view underestimates (positive = underestimate). -/
def insideEstimate (planning_bias inside_variance : ℝ)
    (hv : 0 ≤ inside_variance) : Estimate :=
  { bias := planning_bias
    variance := inside_variance
    variance_nonneg := hv }

/-- An outside-view estimate: the estimator uses the mean of a reference class.
    `reference_class_gap` is (reference class mean - true duration).
    `ref_variance` is the variance within the reference class. -/
def outsideEstimate (reference_class_gap ref_variance : ℝ)
    (hv : 0 ≤ ref_variance) : Estimate :=
  { bias := reference_class_gap
    variance := ref_variance
    variance_nonneg := hv }

-- ============================================================================
-- § 3. The HPMOR Claim: Outside View Dominates Biased Inside View
-- ============================================================================

/-- **Harry's Claim (HPMOR Ch. 6): The outside view dominates a biased inside view.**

    When the inside view has nonzero bias (planning fallacy) and the reference
    class is perfectly calibrated (gap = 0) with lower or equal variance,
    the outside view has strictly lower MSE.

    This is the formalization of "use the outside view, not the inside view." -/
theorem outside_view_dominates_biased_inside
    (planning_bias inside_var ref_var : ℝ)
    (hbias : planning_bias ≠ 0)
    (hiv : 0 ≤ inside_var)
    (hrv : 0 ≤ ref_var)
    (hvar : ref_var ≤ inside_var) :
    mse (outsideEstimate 0 ref_var hrv) <
    mse (insideEstimate planning_bias inside_var hiv) := by
  simp only [mse, outsideEstimate, insideEstimate]
  have h1 : (0 : ℝ) ^ 2 = 0 := by ring
  rw [h1]
  have h2 : 0 < planning_bias ^ 2 := by positivity
  linarith

/-- A well-calibrated reference class (gap = 0) produces an unbiased estimate. -/
theorem well_calibrated_unbiased (ref_var : ℝ) (hv : 0 ≤ ref_var) :
    (outsideEstimate 0 ref_var hv).bias = 0 := by
  rfl

-- ============================================================================
-- § 4. When the Outside View Fails: Bad Reference Class
-- ============================================================================

/-- **The outside view fails when the reference class is poorly chosen.**

    If the reference class gap (|ref mean - true duration|) exceeds the inside
    view's bias in absolute value, and variances are equal, then the outside
    view has HIGHER MSE than the inside view.

    Example: Using "all software projects" as a reference class for a routine
    bug fix would produce a worse estimate than the (biased) inside view. -/
theorem outside_view_fails_bad_class
    (planning_bias ref_gap common_var : ℝ)
    (hv : 0 ≤ common_var)
    (h_gap_worse : planning_bias ^ 2 < ref_gap ^ 2) :
    mse (insideEstimate planning_bias common_var hv) <
    mse (outsideEstimate ref_gap common_var hv) := by
  simp only [mse, insideEstimate, outsideEstimate]
  linarith

-- ============================================================================
-- § 5. Reference Class Selection Requires Judgment
-- ============================================================================

/-- **No reference class universally dominates.**

    For any reference class with a nonzero gap, there exists an inside-view
    estimator that beats it; and for any biased inside view, there exists a
    reference class that beats it. Therefore, choosing between inside and
    outside views requires knowing the magnitudes of the biases — which is
    exactly the judgment the outside view was supposed to replace. -/
theorem reference_class_selection_requires_judgment :
    -- (a) For any poorly-calibrated reference class, a less-biased inside view beats it
    (∀ ref_gap : ℝ, ref_gap ≠ 0 →
      ∃ planning_bias : ℝ, planning_bias ^ 2 < ref_gap ^ 2) ∧
    -- (b) For any biased inside view, a well-calibrated outside view beats it
    (∀ planning_bias : ℝ, planning_bias ≠ 0 →
      ∃ ref_gap : ℝ, ref_gap ^ 2 < planning_bias ^ 2) := by
  constructor
  · intro ref_gap h_ne
    refine ⟨0, ?_⟩
    simp only [zero_pow, Ne, OfNat.ofNat_ne_zero, not_false_eq_true]
    exact sq_pos_of_ne_zero h_ne
  · intro planning_bias h_ne
    refine ⟨0, ?_⟩
    simp only [zero_pow, Ne, OfNat.ofNat_ne_zero, not_false_eq_true]
    exact sq_pos_of_ne_zero h_ne

/-- **The reference class spectrum.**

    As the reference class gap grows from 0, the outside view's MSE increases
    monotonically. There is a critical threshold where outside view MSE equals
    inside view MSE. Beyond this threshold, the inside view is preferable.

    This shows the outside view's quality degrades continuously with reference
    class mismatch. -/
theorem outside_view_mse_increases_with_gap
    (ref_var : ℝ) (hv : 0 ≤ ref_var)
    (gap₁ gap₂ : ℝ) (h : gap₁ ^ 2 ≤ gap₂ ^ 2) :
    mse (outsideEstimate gap₁ ref_var hv) ≤
    mse (outsideEstimate gap₂ ref_var hv) := by
  simp only [mse, outsideEstimate]
  linarith

-- ============================================================================
-- § 6. The Crossover Point
-- ============================================================================

/-- **Crossover theorem**: The outside view beats the inside view if and only if
    the reference class gap is smaller in magnitude than the planning bias
    (assuming equal variance). This makes explicit the hidden condition in
    Harry's argument. -/
theorem outside_beats_inside_iff
    (planning_bias ref_gap common_var : ℝ)
    (hv : 0 ≤ common_var) :
    mse (outsideEstimate ref_gap common_var hv) ≤
    mse (insideEstimate planning_bias common_var hv) ↔
    ref_gap ^ 2 ≤ planning_bias ^ 2 := by
  simp only [mse, outsideEstimate, insideEstimate]
  constructor
  · intro h; linarith
  · intro h; linarith

-- ============================================================================
-- § 7. Concrete Numerical Examples
-- ============================================================================

/-- **Example 1**: A project with true duration 10. Inside view estimates 7
    (bias = -3). A good reference class has mean 10 (gap = 0).
    Outside view MSE = 0 + var, Inside view MSE = 9 + var.
    Outside view wins by exactly the squared bias. -/
theorem example_good_reference_class :
    let inside := insideEstimate (-3) 1 (by norm_num)
    let outside := outsideEstimate 0 1 (by norm_num)
    mse outside < mse inside := by
  simp only [mse, insideEstimate, outsideEstimate]
  norm_num

/-- **Example 2**: Same project, but reference class is "all government projects"
    with mean duration 50 (gap = 40). Inside view bias = -3.
    Outside view MSE = 1600 + var, Inside view MSE = 9 + var.
    Inside view wins despite the planning fallacy. -/
theorem example_bad_reference_class :
    let inside := insideEstimate (-3) 1 (by norm_num)
    let outside := outsideEstimate 40 1 (by norm_num)
    mse inside < mse outside := by
  simp only [mse, insideEstimate, outsideEstimate]
  norm_num

-- ============================================================================
-- § 8. The Fundamental Limitation
-- ============================================================================

/-- **The outside view does not solve the meta-problem.**

    Given two candidate reference classes with different squared gaps, choosing the
    better one requires knowing which gap is smaller — i.e., knowing something
    about the true duration. But knowing the true duration is exactly what we
    were trying to estimate. The outside view pushes the epistemic problem
    back one level without eliminating it.

    Formally: for any two reference classes with different MSEs (different
    squared gaps), the one with the smaller gap is better. But determining
    which gap is smaller requires knowledge of the true duration. -/
theorem no_universal_reference_class
    (gap₁ gap₂ : ℝ) (h_sq : gap₁ ^ 2 ≠ gap₂ ^ 2)
    (var : ℝ) (hv : 0 ≤ var) :
    -- One class beats the other, but WHICH depends on the gaps
    (mse (outsideEstimate gap₁ var hv) <
     mse (outsideEstimate gap₂ var hv)) ∨
    (mse (outsideEstimate gap₂ var hv) <
     mse (outsideEstimate gap₁ var hv)) := by
  simp only [mse, outsideEstimate]
  rcases lt_or_gt_of_ne h_sq with h | h
  · left; linarith
  · right; linarith

/-- **Alternative formulation avoiding the symmetry issue:**
    Two reference classes with genuinely different squared gaps always admit
    a winner and a loser, showing that reference class selection matters. -/
theorem reference_class_selection_matters
    (gap₁ gap₂ : ℝ) (h : gap₁ ^ 2 < gap₂ ^ 2)
    (var : ℝ) (hv : 0 ≤ var) :
    mse (outsideEstimate gap₁ var hv) <
    mse (outsideEstimate gap₂ var hv) := by
  simp only [mse, outsideEstimate]
  linarith
