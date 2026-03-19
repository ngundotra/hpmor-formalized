theorem eu_indiscriminate
    {p₁ p₂ : ℝ} (hp₁ : 0 < p₁) (hp₁' : p₁ < 1) (hp₂ : 0 < p₂) (hp₂' : p₂ < 1)
    (u₁ u₂ : EReal) :
    binary_eu p₁ u₁ ⊥ = binary_eu p₂ u₂ ⊥ := by
  rw [eu_bot_of_pos_prob hp₁ hp₁', eu_bot_of_pos_prob hp₂ hp₂']

theorem lexicographic_discriminates
    (a b : LexAction) (h : a.survivalProb < b.survivalProb) :
    a.lexLe b ∧ ¬ b.lexLe a := by
  constructor
  · left; exact h
  · intro hba
    cases hba with
    | inl hlt => linarith
    | inr heq => linarith [heq.1]
