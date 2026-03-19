theorem lex_rational : lexPref.isRational :=
  ⟨lex_complete, lex_transitive⟩

theorem lex_no_money_pump : ¬ hasMoneyPumpCycle lexPref :=
  rational_no_money_pump lexPref lex_rational

theorem finite_tradeoff_exists [Fintype α] [DecidableEq α]
    (r : PreferenceRelation α)
    (hdec : ∀ x y, Decidable (r.pref x y))
    (hr : r.isRational)
    (x y : α) (hxy : r.strictPref x y) :
    ∃ u : α → ℝ, u x > u y := by
  let filt : α → Finset α := fun a => @Finset.filter _ (fun z => r.pref a z) (hdec a) Finset.univ
  let u : α → ℝ := fun a => (filt a).card
  use u
