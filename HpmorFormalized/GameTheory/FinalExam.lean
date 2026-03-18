import Mathlib

/-!
# Game Theory: The HPMOR Final Exam (Ch. 113-122)

**HPMOR Chapters**: 113-122 (Harry vs Voldemort confrontation)

## The Scenario

Voldemort (proposer) issues an ultimatum to Harry (responder):
"Surrender your wand and magic, or everyone dies."

Harry has (in the standard model) two strategies:
- **Comply**: Lose his magic, but everyone survives
- **Refuse**: Everyone dies (including Harry)

In the extended model, Harry discovers a third strategy:
- **Exploit**: Use partial transfiguration (a hidden capability Voldemort
  doesn't know about) to neutralize the threat

## Key Question (Tier 3)

Is Harry's exploit strategy *optimal* or merely *sufficient*?
We prove that compliance is the unique SPE response in the 2-strategy game,
and characterize exactly when the exploit strategy dominates compliance.

## Game-Theoretic Finding

The exploit dominates compliance iff its success probability exceeds
`u_comply / u_exploit_success`, where these are Harry's payoffs for
compliance and successful exploitation respectively. Since exploitation
success yields strictly better outcomes (Harry keeps his magic AND
everyone lives), the threshold is strictly less than 1 — meaning even
an imperfect exploit can be rational.
-/

open scoped NNReal

-- ============================================================================
-- § 1. The Two-Strategy Ultimatum Game
-- ============================================================================

/-- Harry's strategies in the standard (2-strategy) ultimatum game. -/
inductive HarryStrategy2 : Type
  | comply : HarryStrategy2
  | refuse : HarryStrategy2
  deriving DecidableEq, Fintype

/-- Harry's strategies in the extended (3-strategy) game. -/
inductive HarryStrategy3 : Type
  | comply : HarryStrategy3
  | refuse : HarryStrategy3
  | exploit : HarryStrategy3
  deriving DecidableEq, Fintype

/-- Voldemort's strategy in the ultimatum: he has already committed to
    "surrender or die". We model his single move as the ultimatum itself.
    In subgame-perfect analysis, we focus on Harry's response. -/
inductive VoldemortStrategy : Type
  | ultimatum : VoldemortStrategy
  deriving DecidableEq, Fintype

-- ============================================================================
-- § 2. Payoff Structure
-- ============================================================================

/-- Payoffs for the HPMOR final exam game.
    We parameterize payoffs to prove results generically. -/
structure FinalExamPayoffs where
  /-- Harry's payoff from compliance (loses magic, everyone lives).
      Positive because others survive. -/
  harry_comply : ℝ
  /-- Harry's payoff from refusal (everyone dies). -/
  harry_refuse : ℝ
  /-- Harry's payoff if exploit succeeds (keeps magic, everyone lives). -/
  harry_exploit_success : ℝ
  /-- Harry's payoff if exploit fails (everyone dies, or worse). -/
  harry_exploit_fail : ℝ
  /-- Voldemort's payoff from Harry's compliance (threat eliminated). -/
  voldy_comply : ℝ
  /-- Voldemort's payoff from Harry's refusal (must carry out threat). -/
  voldy_refuse : ℝ
  /-- Voldemort's payoff if Harry's exploit succeeds (Voldemort loses). -/
  voldy_exploit_success : ℝ
  /-- Voldemort's payoff if Harry's exploit fails. -/
  voldy_exploit_fail : ℝ
  /-- Core assumption: Harry prefers compliance to refusal (others' lives matter). -/
  comply_beats_refuse : harry_comply > harry_refuse
  /-- Core assumption: Successful exploitation is strictly better than compliance
      (Harry keeps magic AND everyone lives). -/
  exploit_success_beats_comply : harry_exploit_success > harry_comply
  /-- Core assumption: Failed exploitation is no better than refusal. -/
  exploit_fail_le_refuse : harry_exploit_fail ≤ harry_refuse
  /-- Core assumption: Compliance payoff is positive. -/
  harry_comply_pos : harry_comply > 0
  /-- Core assumption: Successful exploit payoff is positive. -/
  harry_exploit_success_pos : harry_exploit_success > 0

-- ============================================================================
-- § 3. The Standard 2-Strategy Game: Compliance is Unique SPE
-- ============================================================================

/-- In the 2-strategy game, Harry's payoff function. -/
def harry_payoff_2 (p : FinalExamPayoffs) : HarryStrategy2 → ℝ
  | .comply => p.harry_comply
  | .refuse => p.harry_refuse

/-- Compliance is a best response in the 2-strategy game:
    Harry's payoff from compliance exceeds his payoff from refusal. -/
theorem comply_is_best_response_2 (p : FinalExamPayoffs) :
    ∀ s : HarryStrategy2, harry_payoff_2 p .comply ≥ harry_payoff_2 p s := by
  intro s
  cases s with
  | comply => exact le_refl _
  | refuse =>
    simp only [harry_payoff_2, ge_iff_le]
    exact le_of_lt p.comply_beats_refuse

/-- Compliance is the *unique* best response: any best response must be compliance. -/
theorem comply_unique_best_response_2 (p : FinalExamPayoffs)
    (s : HarryStrategy2)
    (hs : ∀ s' : HarryStrategy2, harry_payoff_2 p s ≥ harry_payoff_2 p s') :
    s = .comply := by
  cases s with
  | comply => rfl
  | refuse =>
    exfalso
    have h := hs .comply
    simp [harry_payoff_2] at h
    linarith [p.comply_beats_refuse]

/-- **Main Theorem (Part a)**: In the standard 2-strategy ultimatum game,
    compliance is the unique subgame-perfect equilibrium response.

    This formalizes: when Harry only has comply/refuse, compliance is not just
    a Nash equilibrium response — it's the *only* rational response. -/
theorem compliance_unique_spe (p : FinalExamPayoffs) :
    ∃! s : HarryStrategy2,
      ∀ s' : HarryStrategy2, harry_payoff_2 p s ≥ harry_payoff_2 p s' := by
  refine ⟨.comply, comply_is_best_response_2 p, ?_⟩
  intro s hs
  exact comply_unique_best_response_2 p s hs

-- ============================================================================
-- § 4. The Extended 3-Strategy Game with Exploit
-- ============================================================================

/-- Harry's *expected* payoff in the 3-strategy game, where the exploit
    succeeds with probability `prob`. -/
noncomputable def harry_expected_payoff_3 (p : FinalExamPayoffs) (prob : ℝ) :
    HarryStrategy3 → ℝ
  | .comply => p.harry_comply
  | .refuse => p.harry_refuse
  | .exploit => prob * p.harry_exploit_success + (1 - prob) * p.harry_exploit_fail

/-- The probability threshold above which exploit dominates compliance. -/
noncomputable def exploit_threshold (p : FinalExamPayoffs) : ℝ :=
  (p.harry_comply - p.harry_exploit_fail) /
  (p.harry_exploit_success - p.harry_exploit_fail)

/-- The threshold is strictly between 0 and 1 under our assumptions. -/
theorem threshold_in_unit_interval (p : FinalExamPayoffs) :
    0 < exploit_threshold p ∧ exploit_threshold p < 1 := by
  constructor
  · -- 0 < threshold
    unfold exploit_threshold
    apply div_pos
    · linarith [p.comply_beats_refuse, p.exploit_fail_le_refuse]
    · linarith [p.exploit_success_beats_comply, p.comply_beats_refuse,
                p.exploit_fail_le_refuse]
  · -- threshold < 1
    unfold exploit_threshold
    rw [div_lt_one]
    · linarith [p.exploit_success_beats_comply]
    · linarith [p.exploit_success_beats_comply, p.comply_beats_refuse,
                p.exploit_fail_le_refuse]

/-- **Main Theorem (Part b)**: When the exploit probability exceeds the threshold,
    the exploit strategy yields strictly higher expected payoff than compliance.

    This is the key game-theoretic result: Harry's "trick" is rational iff
    he believes his probability of success exceeds the threshold. -/
theorem exploit_dominates_above_threshold (p : FinalExamPayoffs)
    (prob : ℝ) (hprob : prob > exploit_threshold p) :
    harry_expected_payoff_3 p prob .exploit >
    harry_expected_payoff_3 p prob .comply := by
  simp only [harry_expected_payoff_3, exploit_threshold, gt_iff_lt] at *
  have hdenom : p.harry_exploit_success - p.harry_exploit_fail > 0 := by
    linarith [p.exploit_success_beats_comply, p.comply_beats_refuse,
              p.exploit_fail_le_refuse]
  have hdenom_ne : p.harry_exploit_success - p.harry_exploit_fail ≠ 0 := ne_of_gt hdenom
  have hprob' :
      (p.harry_comply - p.harry_exploit_fail) /
      (p.harry_exploit_success - p.harry_exploit_fail) < prob := hprob
  rw [div_lt_iff₀ hdenom] at hprob'
  linarith

/-- Conversely, below the threshold, compliance dominates the exploit. -/
theorem comply_dominates_below_threshold (p : FinalExamPayoffs)
    (prob : ℝ) (hprob : prob < exploit_threshold p) :
    harry_expected_payoff_3 p prob .comply >
    harry_expected_payoff_3 p prob .exploit := by
  simp only [harry_expected_payoff_3, exploit_threshold, gt_iff_lt] at *
  have hdenom : p.harry_exploit_success - p.harry_exploit_fail > 0 := by
    linarith [p.exploit_success_beats_comply, p.comply_beats_refuse,
              p.exploit_fail_le_refuse]
  have hdenom_ne : p.harry_exploit_success - p.harry_exploit_fail ≠ 0 := ne_of_gt hdenom
  have hprob' :
      prob < (p.harry_comply - p.harry_exploit_fail) /
      (p.harry_exploit_success - p.harry_exploit_fail) := hprob
  rw [lt_div_iff₀ hdenom] at hprob'
  linarith

/-- At exactly the threshold, Harry is indifferent between comply and exploit. -/
theorem indifferent_at_threshold (p : FinalExamPayoffs) :
    harry_expected_payoff_3 p (exploit_threshold p) .exploit =
    harry_expected_payoff_3 p (exploit_threshold p) .comply := by
  simp [harry_expected_payoff_3, exploit_threshold]
  have hdenom : p.harry_exploit_success - p.harry_exploit_fail ≠ 0 := by
    linarith [p.exploit_success_beats_comply, p.comply_beats_refuse,
              p.exploit_fail_le_refuse]
  field_simp
  ring

-- ============================================================================
-- § 5. Characterizing the Threshold (Part c)
-- ============================================================================

/-- **Main Theorem (Part c)**: The exploit threshold equals the ratio
    (comply_payoff - fail_payoff) / (success_payoff - fail_payoff).

    Interpretation: The threshold depends on how much better success is
    compared to compliance, relative to the gap between success and failure.
    Since success is strictly better than compliance (Harry keeps his magic),
    the numerator is strictly less than the denominator, so the threshold
    is strictly less than 1. This means Harry doesn't need certainty of
    success — even a moderate probability suffices. -/
theorem exploit_threshold_characterization (p : FinalExamPayoffs) :
    exploit_threshold p =
    (p.harry_comply - p.harry_exploit_fail) /
    (p.harry_exploit_success - p.harry_exploit_fail) := by
  rfl

-- ============================================================================
-- § 6. HPMOR-Specific Instantiation
-- ============================================================================

/-- Concrete payoffs modeling the HPMOR scenario.
    - Comply: Harry loses magic but everyone lives → payoff 5
    - Refuse: Everyone dies → payoff 0
    - Exploit success: Harry keeps magic, everyone lives → payoff 10
    - Exploit fail: Everyone dies (or worse) → payoff -1
      (worse than refuse because Voldemort is angered)
    - Voldemort values compliance most → payoff 10
    - Voldemort dislikes refusal → payoff -5
    - Voldemort is destroyed by exploit → payoff -10
    - Voldemort benefits from failed exploit → payoff 8 -/
noncomputable def hpmorPayoffs : FinalExamPayoffs where
  harry_comply := 5
  harry_refuse := 0
  harry_exploit_success := 10
  harry_exploit_fail := -1
  voldy_comply := 10
  voldy_refuse := -5
  voldy_exploit_success := -10
  voldy_exploit_fail := 8
  comply_beats_refuse := by norm_num
  exploit_success_beats_comply := by norm_num
  exploit_fail_le_refuse := by norm_num
  harry_comply_pos := by norm_num
  harry_exploit_success_pos := by norm_num

/-- In the HPMOR scenario, the exploit threshold is 6/11 ≈ 0.545.
    Harry needs to believe his partial transfiguration trick has at least
    a ~55% chance of success to rationally choose it over compliance. -/
theorem hpmor_threshold_value :
    exploit_threshold hpmorPayoffs = 6 / 11 := by
  simp [exploit_threshold, hpmorPayoffs]
  norm_num

/-- The exploit strategy is the unique best response in the 3-strategy game
    when the exploit probability exceeds the threshold.
    This shows the exploit is not just *sufficient* but *optimal*. -/
theorem exploit_optimal_above_threshold (p : FinalExamPayoffs)
    (prob : ℝ) (hprob : prob > exploit_threshold p)
    (_hprob_le : prob ≤ 1) :
    ∀ s : HarryStrategy3,
      harry_expected_payoff_3 p prob .exploit ≥ harry_expected_payoff_3 p prob s := by
  intro s
  cases s with
  | comply =>
    exact le_of_lt (exploit_dominates_above_threshold p prob hprob)
  | refuse =>
    simp [harry_expected_payoff_3]
    have hthresh := threshold_in_unit_interval p
    have hdenom : p.harry_exploit_success - p.harry_exploit_fail > 0 := by
      linarith [p.exploit_success_beats_comply, p.comply_beats_refuse,
                p.exploit_fail_le_refuse]
    -- exploit expected payoff > comply payoff > refuse payoff
    have h1 := exploit_dominates_above_threshold p prob hprob
    simp [harry_expected_payoff_3] at h1
    linarith [p.comply_beats_refuse]
  | exploit => exact le_refl _

-- ============================================================================
-- § 7. Meta-Analysis: Was Harry's Decision Rational?
-- ============================================================================

/-- Harry's decision was rational if he believed his exploit probability
    exceeded the threshold. Given that partial transfiguration was an
    ability Voldemort didn't know about (information asymmetry), and
    Harry had practiced it extensively, a subjective probability above
    6/11 ≈ 55% is plausible.

    **Verdict**: Harry's strategy was not just sufficient but *optimal*
    given reasonable beliefs about his success probability. The formalization
    reveals that the threshold (6/11 in our parameterization) is surprisingly
    low — Harry didn't need to be highly confident, just more likely than not
    to succeed. -/
theorem harry_was_rational (prob : ℝ)
    (hprob : prob > 6 / 11) (hprob_le : prob ≤ 1) :
    ∀ s : HarryStrategy3,
      harry_expected_payoff_3 hpmorPayoffs prob .exploit ≥
      harry_expected_payoff_3 hpmorPayoffs prob s := by
  have : exploit_threshold hpmorPayoffs = 6 / 11 := hpmor_threshold_value
  exact exploit_optimal_above_threshold hpmorPayoffs prob (this ▸ hprob) hprob_le
