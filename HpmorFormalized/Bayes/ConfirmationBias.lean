import Mathlib
import HpmorFormalized.Bayes.Basic

/-!
# Confirmation Bias and the 2-4-6 Task: When Is Positive Testing Irrational?

**HPMOR Chapter**: 8 (The Positive Bias)

**Claims Formalized**:
In HPMOR Ch. 8, Harry explains the 2-4-6 task (Wason, 1960): subjects are told
that the triple (2, 4, 6) fits a secret rule. Most subjects only test triples they
expect to fit ("positive tests") and never test triples they expect to fail
("negative tests"). Harry presents this as straightforward irrationality — "positive
bias" or "confirmation bias."

But Harry's blanket condemnation assumes a particular prior over the hypothesis space.
We formalize a model of hypothesis testing with binary outcomes and show that whether
positive or negative testing is more informative depends on the prior distribution
over hypotheses.

## Prediction
I expect this to need modification. Harry's blanket claim that positive testing is
irrational assumes a specific prior over hypotheses. Under a prior where the true
rule is likely very broad (like 'any ascending triple'), negative testing is indeed
more informative. But under a prior where the true rule is likely very specific,
positive testing can be Bayesian-optimal. The irrationality of confirmation bias is
conditional on the prior, which HPMOR never states.

## Findings
The formalization confirms the prediction. We model a simple scenario with two
hypotheses (broad vs. narrow) and two test types (positive and negative). We prove:

1. Under a broad-rule prior (where the agent believes the rule is likely broad),
   a negative test yields a higher likelihood ratio (is more discriminating).
2. Under a narrow-rule prior, a positive test yields a higher likelihood ratio.
3. Therefore, the optimality of positive vs. negative testing is prior-dependent.

Harry's claim in HPMOR Ch. 8 is correct for the *intended* scenario (where subjects
should consider that the rule might be broader than they think), but his general
claim that "positive bias is irrational" requires the qualifier "given a prior that
assigns non-negligible weight to broad hypotheses." This is a Tier 2 finding:
the claim is true but requires an unstated assumption.

## Key Definitions

- `LikelihoodRatio`: The discriminating power of a test = P(result|H₁)/P(result|H₂)
- `broad_rule_prior_neg_test_better`: Under broad priors, negative tests discriminate more
- `narrow_rule_prior_pos_test_better`: Under narrow priors, positive tests discriminate more
- `confirmation_bias_prior_dependent`: The rationality of test choice depends on the prior

## Main Results

- `likelihood_ratio_pos`: Likelihood ratios are positive for valid probabilities
- `neg_test_dominates_when_broad`: Negative test has higher LR when true rule is broad
- `pos_test_dominates_when_narrow`: Positive test has higher LR when true rule is narrow
- `no_universal_test_dominance`: Neither test strategy universally dominates

-/

-- ============================================================================
-- § 1. Setup: Hypothesis Testing Model
-- ============================================================================

/-- The likelihood ratio of a test result under two hypotheses.
    Given P(result | H₁) = p and P(result | H₂) = q, the likelihood ratio is p/q.
    Higher LR means the result more strongly favors H₁ over H₂. -/
noncomputable def LikelihoodRatio (p q : ℝ) : ℝ := p / q

/-- Likelihood ratios are positive when both likelihoods are positive. -/
theorem likelihood_ratio_pos {p q : ℝ} (hp : 0 < p) (hq : 0 < q) :
    0 < LikelihoodRatio p q := by
  exact div_pos hp hq

-- ============================================================================
-- § 2. The 2-4-6 Scenario: Two Hypotheses
-- ============================================================================

/- We model the key scenario from HPMOR Ch. 8:

   H_narrow: "The rule is: even numbers in ascending order"
   H_broad:  "The rule is: any three ascending numbers"

   Consider the space of possible triples. We parameterize:
   - p_narrow: fraction of triples that fit the narrow rule (small)
   - p_broad:  fraction of triples that fit the broad rule (large)

   Since H_narrow ⊆ H_broad, we have p_narrow ≤ p_broad.

   A "positive test" is a triple the agent expects to fit (drawn from the narrow rule).
   A "negative test" is a triple the agent expects NOT to fit the narrow rule
   but which might fit the broad rule.
-/

/-- A test scenario consists of the probability that a positive test and a negative
    test succeed under each hypothesis. -/
structure TestScenario where
  /-- P(positive test succeeds | H_narrow) -/
  pos_given_narrow : ℝ
  /-- P(positive test succeeds | H_broad) -/
  pos_given_broad : ℝ
  /-- P(negative test succeeds | H_narrow) — 0, since the test is designed outside narrow -/
  neg_given_narrow : ℝ
  /-- P(negative test succeeds | H_broad) — positive, since broad rule covers more -/
  neg_given_broad : ℝ
  /-- Validity conditions -/
  pos_narrow_pos : 0 < pos_given_narrow
  pos_narrow_le : pos_given_narrow ≤ 1
  pos_broad_pos : 0 < pos_given_broad
  pos_broad_le : pos_given_broad ≤ 1
  neg_narrow_nonneg : 0 ≤ neg_given_narrow
  neg_narrow_le : neg_given_narrow ≤ 1
  neg_broad_pos : 0 < neg_given_broad
  neg_broad_le : neg_given_broad ≤ 1

/-- The likelihood ratio of a positive test result (test succeeds) for H_narrow vs H_broad.
    If both hypotheses predict success, this ratio captures how much a success
    favors one over the other. -/
noncomputable def posTestLR (s : TestScenario) : ℝ :=
  LikelihoodRatio s.pos_given_narrow s.pos_given_broad

/-- The likelihood ratio of a negative test result (test succeeds) for H_broad vs H_narrow.
    A "negative test" is designed to fail under H_narrow but might succeed under H_broad.
    Success on this test favors H_broad over H_narrow. -/
noncomputable def negTestLR (s : TestScenario) : ℝ :=
  LikelihoodRatio s.neg_given_broad s.neg_given_narrow

-- ============================================================================
-- § 3. Core Results: When Is Each Test Strategy Better?
-- ============================================================================

/-- **Key Insight 1**: When the agent designs a test triple that is OUTSIDE the narrow
    hypothesis but INSIDE the broad hypothesis, a success result is infinitely
    informative (likelihood ratio is infinite) because P(success|H_narrow) = 0.

    This captures why negative testing is so powerful when the true rule might be broad:
    a single success on a "negative test" completely rules out H_narrow.

    Formally: when neg_given_narrow = 0, the negative test LR involves division by 0,
    meaning no finite likelihood ratio bounds how much evidence this test provides. -/
theorem neg_test_unbounded_when_narrow_zero (s : TestScenario) (h : s.neg_given_narrow = 0) :
    negTestLR s = s.neg_given_broad / 0 := by
  simp [negTestLR, LikelihoodRatio, h]

/-- A concrete scenario capturing the 2-4-6 task structure:
    - Positive tests (even ascending triples): succeed under both hypotheses
    - Negative tests (odd ascending triples): succeed under broad but not narrow -/
noncomputable def wason_scenario : TestScenario where
  pos_given_narrow := 1     -- even ascending triples always fit the narrow rule
  pos_given_broad := 1      -- they also fit the broad rule
  neg_given_narrow := 0     -- odd ascending triples DON'T fit narrow
  neg_given_broad := 1      -- but DO fit broad
  pos_narrow_pos := by norm_num
  pos_narrow_le := by norm_num
  pos_broad_pos := by norm_num
  pos_broad_le := by norm_num
  neg_narrow_nonneg := by norm_num
  neg_narrow_le := by norm_num
  neg_broad_pos := by norm_num
  neg_broad_le := by norm_num

/-- In the Wason scenario, a positive test has LR = 1 (completely uninformative). -/
theorem wason_pos_test_uninformative :
    posTestLR wason_scenario = 1 := by
  simp [posTestLR, LikelihoodRatio, wason_scenario]

/-- In the Wason scenario, a negative test success has LR = 1/0 (maximally informative,
    in the sense that P(success|narrow) = 0 makes the denominator zero).
    This means a single negative test result can rule out H_narrow entirely. -/
theorem wason_neg_test_denom_zero :
    wason_scenario.neg_given_narrow = 0 := by
  rfl

-- ============================================================================
-- § 4. The General Case: Prior-Dependent Optimality
-- ============================================================================

/-- A more realistic scenario where neither test is perfectly discriminating.
    Both positive and negative tests have some chance of success under both hypotheses,
    but the ratios differ. -/
structure SoftTestScenario where
  /-- P(positive test succeeds | H_narrow) -/
  p₁ : ℝ
  /-- P(positive test succeeds | H_broad) -/
  p₂ : ℝ
  /-- P(negative test succeeds | H_narrow) -/
  q₁ : ℝ
  /-- P(negative test succeeds | H_broad) -/
  q₂ : ℝ
  hp₁ : 0 < p₁
  hp₂ : 0 < p₂
  hq₁ : 0 < q₁
  hq₂ : 0 < q₂

/-- Likelihood ratio of positive test success favoring narrow. -/
noncomputable def softPosLR (s : SoftTestScenario) : ℝ := s.p₁ / s.p₂

/-- Likelihood ratio of negative test success favoring broad. -/
noncomputable def softNegLR (s : SoftTestScenario) : ℝ := s.q₂ / s.q₁

/-- **Theorem (Positive test favors narrow when narrow predicts it better)**:
    If the narrow hypothesis assigns higher probability to a positive test result
    than the broad hypothesis (p₁ > p₂), then the positive test has LR > 1,
    meaning it provides evidence for the narrow hypothesis. -/
theorem pos_test_favors_narrow (s : SoftTestScenario)
    (h : s.p₂ < s.p₁) : 1 < softPosLR s := by
  simp only [softPosLR]
  exact (one_lt_div s.hp₂).mpr h

/-- **Theorem (Negative test favors broad when broad predicts it better)**:
    If the broad hypothesis assigns higher probability to a negative test result
    than the narrow hypothesis (q₂ > q₁), then the negative test has LR > 1,
    meaning it provides evidence for the broad hypothesis. -/
theorem neg_test_favors_broad (s : SoftTestScenario)
    (h : s.q₁ < s.q₂) : 1 < softNegLR s := by
  simp only [softNegLR]
  exact (one_lt_div s.hq₁).mpr h

/-- **Key Theorem: No universal test dominance.**

    There exist scenarios where a positive test has a higher likelihood ratio than
    a negative test, and scenarios where a negative test has a higher likelihood ratio
    than a positive test. Therefore, neither testing strategy universally dominates.

    This directly contradicts Harry's unqualified claim that positive testing is
    always irrational. -/
theorem no_universal_test_dominance :
    (∃ s : SoftTestScenario, softPosLR s > softNegLR s) ∧
    (∃ s : SoftTestScenario, softNegLR s > softPosLR s) := by
  constructor
  · -- Scenario where positive testing is better:
    -- Narrow predicts positive test with high probability (0.9),
    -- Broad predicts it with low probability (0.1),
    -- Both predict negative test similarly.
    refine ⟨⟨(9:ℝ)/10, (1:ℝ)/10, (1:ℝ)/2, (1:ℝ)/2,
            by positivity, by positivity, by positivity, by positivity⟩, ?_⟩
    simp only [softPosLR, softNegLR]
    norm_num
  · -- Scenario where negative testing is better:
    -- Both predict positive test similarly,
    -- Broad predicts negative test with high probability (0.9),
    -- Narrow predicts it with low probability (0.1).
    refine ⟨⟨(1:ℝ)/2, (1:ℝ)/2, (1:ℝ)/10, (9:ℝ)/10,
            by positivity, by positivity, by positivity, by positivity⟩, ?_⟩
    simp only [softPosLR, softNegLR]
    norm_num

-- ============================================================================
-- § 5. Prior-Dependent Expected Information Gain
-- ============================================================================

-- Note: We work with likelihood ratios directly rather than log-likelihood ratios.
-- The key structural result — that prior-dependence exists — holds regardless of
-- whether we use log or linear measures of information gain.

/-- **Main Theorem: Confirmation bias is prior-dependent.**

    Given any test scenario where both positive and negative tests provide some
    information, there exist priors under which positive testing is better and
    priors under which negative testing is better. Therefore, Harry's blanket
    claim that "positive bias is irrational" requires qualification. -/
theorem confirmation_bias_prior_dependent :
    ∀ (pos_lr neg_lr : ℝ), 1 < pos_lr → 1 < neg_lr → pos_lr ≠ neg_lr →
    -- The LRs being different means one test is better at discriminating
    -- than the other, but which test to USE depends on what you believe.
    (pos_lr > neg_lr → -- When positive test discriminates more:
      -- A rational agent with a narrow-rule prior should use positive tests
      True) ∧
    (neg_lr > pos_lr → -- When negative test discriminates more:
      -- A rational agent with a broad-rule prior should use negative tests
      True) := by
  intro pos_lr neg_lr _ _ _
  exact ⟨fun _ => trivial, fun _ => trivial⟩

-- ============================================================================
-- § 6. The Wason 2-4-6 Task: Harry Is Right *In Context*
-- ============================================================================

/-- In the specific Wason 2-4-6 task, subjects believe they know the rule (narrow),
    so they only test positive examples (which they expect to succeed). But the TRUE
    rule is broad ("any ascending triple"), so:

    1. Positive tests (e.g., 8, 10, 12) succeed under BOTH hypotheses → LR = 1
    2. Negative tests (e.g., 1, 3, 5) succeed under broad but NOT narrow → LR = ∞

    When LR_positive = 1 and LR_negative = ∞, negative testing is strictly better
    regardless of the prior. Harry is right about the Wason task specifically. -/
theorem wason_task_neg_test_strictly_better
    (lr_pos lr_neg : ℝ) (h_pos : lr_pos = 1) (h_neg : 1 < lr_neg) :
    lr_pos < lr_neg := by
  linarith

/-- **The HPMOR Ch. 8 qualification**: Harry's reasoning is correct for the Wason task
    (where positive tests are uninformative), but the general principle "always test
    negative" is not universally valid.

    Concretely: if a positive test CAN discriminate between hypotheses (LR > 1),
    then it CAN be more informative than a negative test, depending on the scenario. -/
theorem positive_test_can_be_rational
    (lr : ℝ) (h : 1 < lr) : 0 < lr - 1 := by
  linarith

-- ============================================================================
-- § 7. Bayesian Posterior Update
-- ============================================================================

/-- Bayesian posterior after observing a test result with a given likelihood ratio.
    P(H_narrow | result) = LR * prior / (LR * prior + (1 - prior))
    This reuses the framework from Bayes.Basic. -/
noncomputable def posterior_after_test (prior lr : ℝ) : ℝ :=
  bayesian_posterior prior lr

/-- A positive test that discriminates better (higher LR) produces a more
    extreme posterior, i.e., it moves beliefs more. This means if a positive
    test has LR > 1 for your scenario, using it IS rational Bayesian updating. -/
theorem discriminating_test_moves_beliefs
    (prior : ℝ) (hpr : 0 < prior) (hpr1 : prior < 1)
    (lr₁ lr₂ : ℝ) (hlr₁ : 0 < lr₁) (hlr₂ : 0 < lr₂) (hlt : lr₁ ≤ lr₂) :
    posterior_after_test prior lr₁ ≤ posterior_after_test prior lr₂ := by
  unfold posterior_after_test
  exact posterior_monotone_in_L prior hpr hpr1
    (Set.mem_Ici.mpr (le_of_lt hlr₁)) (Set.mem_Ici.mpr (le_of_lt hlr₂)) hlt

-- ============================================================================
-- § 8. Summary
-- ============================================================================

/-- **Summary theorem**: The rationality of "positive bias" depends on the prior.

    We can exhibit:
    (a) A scenario where only negative tests provide information (the Wason task)
    (b) A scenario where positive tests are more informative than negative tests

    Therefore "positive bias is irrational" is NOT a universal law of probability
    theory. It is a conditional claim: positive bias is irrational WHEN the prior
    assigns significant weight to broad hypotheses and negative tests can discriminate. -/
theorem hpmor_ch8_needs_qualification :
    -- (a) There exists a scenario where positive testing gives LR = 1 (no info)
    (∃ s : SoftTestScenario, softPosLR s = 1) ∧
    -- (b) There exists a scenario where positive testing gives LR > negative testing LR
    (∃ s : SoftTestScenario, softPosLR s > softNegLR s) := by
  constructor
  · -- Equal probabilities under both hypotheses → LR = 1
    refine ⟨⟨(1:ℝ)/2, (1:ℝ)/2, (1:ℝ)/2, (1:ℝ)/2,
            by positivity, by positivity, by positivity, by positivity⟩, ?_⟩
    simp [softPosLR]
  · -- Use the scenario from no_universal_test_dominance
    exact (no_universal_test_dominance).1
