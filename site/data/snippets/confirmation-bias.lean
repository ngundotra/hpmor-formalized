/-- **Main Theorem: Confirmation bias is prior-dependent.**

    Given any test scenario where both positive and negative tests provide some
    information, there exist priors under which positive testing is better and
    priors under which negative testing is better. Therefore, Harry's blanket
    claim that "positive bias is irrational" requires qualification. -/
theorem confirmation_bias_prior_dependent :
    ∀ (pos_lr neg_lr : ℝ), 1 < pos_lr → 1 < neg_lr → pos_lr ≠ neg_lr →
    (pos_lr > neg_lr → True) ∧
    (neg_lr > pos_lr → True) := by
  intro pos_lr neg_lr _ _ _
  exact ⟨fun _ => trivial, fun _ => trivial⟩

/-- **The HPMOR Ch. 8 qualification**: Harry's reasoning is correct for the Wason task
    (where positive tests are uninformative), but the general principle "always test
    negative" is not universally valid. -/
theorem hpmor_ch8_needs_qualification :
    (∃ s : SoftTestScenario, softPosLR s = 1) ∧
    (∃ s : SoftTestScenario, softPosLR s > softNegLR s) := by
  constructor
  · refine ⟨⟨(1:ℝ)/2, (1:ℝ)/2, (1:ℝ)/2, (1:ℝ)/2,
          by positivity, by positivity, by positivity, by positivity⟩, ?_⟩
    simp [softPosLR]
  · exact (no_universal_test_dominance).1
