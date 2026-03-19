theorem logical_counterfactual_underdetermined
    {Action State : Type}
    (actual : Action) (other : Action) (_h : actual ≠ other)
    (trueProb : State → ℝ)
    (lcf₁ lcf₂ : LogicalCounterfactual Action State)
    (h₁ : lcf₁ actual actual = trueProb)
    (h₂ : lcf₂ actual actual = trueProb)
    (hdiff : lcf₁ actual other ≠ lcf₂ actual other) :
    lcf₁ actual actual = lcf₂ actual actual ∧
    lcf₁ actual other ≠ lcf₂ actual other := by
  exact ⟨by rw [h₁, h₂], hdiff⟩

theorem tdt_neq_edt_smoking_lesion :
    tdtExpectedUtility (smokingLesionProblem 10 100) (smokingTDTProb 0.5)
      smoke healthStates ≠
    edtExpectedUtility (smokingLesionProblem 10 100) (smokingEDTProb 0.9 0.1)
      smoke healthStates := by
  simp only [tdtExpectedUtility, edtExpectedUtility, smokingLesionProblem,
    smokingTDTProb, smokingEDTProb, healthStates,
    List.map, List.sum_cons, List.sum_nil]
  norm_num
