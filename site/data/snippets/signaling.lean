-- The optimal signal maximizes ally revelation (α)
-- and minimizes opponent revelation (β).
-- Neither full clarity nor full ambiguity is optimal —
-- targeted signaling (α = 1, β = 0) beats both.
theorem optimal_targeting (p : PartialSignalingParams)
    (α β : ℝ) (_hα : 0 ≤ α) (hα1 : α ≤ 1)
    (hβ : 0 ≤ β) (_hβ1 : β ≤ 1) :
    p.partialPayoff α β ≤ p.partialPayoff 1 0 := by
  unfold partialPayoff
  have h1 : α * p.allyBenefit ≤ 1 * p.allyBenefit := by
    exact mul_le_mul_of_nonneg_right hα1 p.hB_nonneg
  have h2 : 0 ≤ β * p.opponentPenalty :=
    mul_nonneg hβ p.hP_nonneg
  linarith

-- Targeted beats clarity (which leaks to opponents)
theorem targeted_beats_clear (p : PartialSignalingParams) :
    p.partialPayoff 1 0 ≥ p.partialPayoff 1 1 := by
  unfold partialPayoff; linarith [p.hP_nonneg]

-- Targeted beats ambiguity (which hides from allies)
theorem targeted_beats_ambiguous (p : PartialSignalingParams) :
    p.partialPayoff 1 0 ≥ p.partialPayoff 0 0 := by
  unfold partialPayoff; linarith [p.hB_nonneg]
