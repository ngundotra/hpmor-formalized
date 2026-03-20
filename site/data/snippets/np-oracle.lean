/-- **The trivial fixed point persists even with solutions.**
    Even when a valid solution exists, `none` remains a fixed point.
    The universe can always "choose" the trivial loop. -/
theorem trivial_fixpoint_always_available (P : NPProblem) :
    ∀ (_evidence : ∃ s, P.verify s = true),
    npOracleTransition P none = none := by
  intro _; rfl

/-- **Summary theorem: The NP oracle scheme fails.**
    For any NP problem:
    1. `none` is always a fixed point (the trivial loop).
    2. Valid solutions are also fixed points (the useful loop).
    3. Self-consistency cannot distinguish between them.
    Therefore, the Time-Turner cannot solve NP problems via
    self-consistency alone. -/
theorem np_oracle_scheme_fails (P : NPProblem) :
    (npOracleTransition P none = none) ∧
    (∀ s, P.verify s = true → npOracleTransition P (some s) = some s) ∧
    ((∀ s, P.verify s = false) →
      ∀ state, npOracleTransition P state = state → state = none) := by
  exact ⟨rfl,
    fun s hs => valid_solution_is_fixpoint P s hs,
    fun h_unsolv state hfix => unique_fixpoint_when_unsolvable P h_unsolv state hfix⟩
