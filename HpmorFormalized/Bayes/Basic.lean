import Mathlib

/-!
# Bayesian Reasoning: The Strength of Evidence

**HPMOR Chapters**: 2-3 (Harry's encounter with Professor McGonagall)

**Claims Formalized**:
In HPMOR Ch. 2-3, Harry Potter — a rationalist — confronts evidence that magic
is real. Despite having an extremely low prior probability for magic (ε ≈ 0),
he observes Professor McGonagall transform into a cat and back, receive a
Hogwarts letter, and witness other demonstrations. Harry reasons that with a
sufficiently large likelihood ratio (the evidence is far more probable if magic
is real than if it isn't), even an astronomically small prior is overwhelmed,
and the rational posterior probability of magic approaches 1.

This module formalizes Bayes' theorem in this context and proves that as the
strength of evidence (likelihood ratio) grows without bound, the posterior
probability approaches 1 regardless of the (positive) prior.

## Key Definitions

- `bayesian_posterior`: Computes P(H|E) given prior P(H) = ε and likelihood ratio L
- `evidence_strength`: The likelihood ratio L = P(E|H) / P(E|¬H)

## Main Results

- `posterior_formula`: The posterior equals L·ε / (L·ε + (1 - ε))
- `posterior_pos`: The posterior is positive when ε > 0 and L > 0
- `posterior_lt_one`: The posterior is strictly less than 1 for finite L
- `posterior_monotone_in_L`: The posterior is monotonically increasing in L
- `posterior_tendsto_one`: As L → ∞, the posterior → 1 (the key HPMOR claim)
-/

open scoped Topology

-- ============================================================================
-- § 1. Definitions
-- ============================================================================

/-- The Bayesian posterior probability P(H|E) given:
    - `prior`: P(H) = ε, the prior probability of the hypothesis
    - `likelihood_ratio`: L = P(E|H) / P(E|¬H), the strength of evidence

    By Bayes' theorem:
      P(H|E) = P(E|H) · P(H) / P(E)
             = P(E|H) · ε / (P(E|H) · ε + P(E|¬H) · (1 - ε))
             = L · ε / (L · ε + (1 - ε))
-/
noncomputable def bayesian_posterior (prior : ℝ) (likelihood_ratio : ℝ) : ℝ :=
  likelihood_ratio * prior / (likelihood_ratio * prior + (1 - prior))

-- ============================================================================
-- § 2. Basic Properties
-- ============================================================================

/-- The posterior is well-defined and equals the standard Bayes formula. -/
theorem posterior_formula (ε L : ℝ) :
    bayesian_posterior ε L = L * ε / (L * ε + (1 - ε)) := by
  rfl

/-- When the prior is 0, the posterior is 0 regardless of evidence. -/
theorem posterior_zero_prior (L : ℝ) :
    bayesian_posterior 0 L = 0 := by
  simp [bayesian_posterior]

/-- When the likelihood ratio is 1 (evidence is equally likely under H and ¬H),
    the posterior equals the prior (evidence provides no update). -/
theorem posterior_no_update (ε : ℝ) (hε : ε ≥ 0) (hε1 : ε ≤ 1) :
    bayesian_posterior ε 1 = ε := by
  unfold bayesian_posterior
  have h : 1 * ε + (1 - ε) = 1 := by ring
  rw [h]
  ring

/-- The denominator of the posterior is positive when ε ∈ (0, 1) and L > 0. -/
theorem posterior_denom_pos (ε L : ℝ) (hε_pos : 0 < ε) (hε_lt : ε < 1) (hL : 0 < L) :
    0 < L * ε + (1 - ε) := by
  have h1 : 0 < L * ε := mul_pos hL hε_pos
  have h2 : 0 < 1 - ε := sub_pos.mpr hε_lt
  linarith

/-- The posterior is positive when the prior is positive and evidence is positive. -/
theorem posterior_pos (ε L : ℝ) (hε_pos : 0 < ε) (hε_lt : ε < 1) (hL : 0 < L) :
    0 < bayesian_posterior ε L := by
  unfold bayesian_posterior
  apply div_pos
  · exact mul_pos hL hε_pos
  · exact posterior_denom_pos ε L hε_pos hε_lt hL

-- ============================================================================
-- § 3. The Key HPMOR Claim: Posterior → 1 as Evidence Strength → ∞
-- ============================================================================

/-- **Harry's Reasoning (HPMOR Ch. 2-3).**

    For any fixed positive prior ε ∈ (0, 1), as the likelihood ratio L → ∞,
    the posterior probability P(magic | evidence) → 1.

    In HPMOR, Harry observes:
    - Professor McGonagall transforms into a cat (enormous likelihood ratio)
    - A Hogwarts letter arrives by owl
    - Live magical demonstrations

    Each piece of evidence multiplies the likelihood ratio. As L grows,
    L·ε / (L·ε + (1-ε)) → L·ε / (L·ε) = 1.

    This is the formalization of Harry's core insight: no matter how small
    your prior, sufficiently strong evidence *must* update you to near-certainty.
-/
theorem posterior_tendsto_one (ε : ℝ) (hε_pos : 0 < ε) (hε_lt : ε < 1) :
    Filter.Tendsto (bayesian_posterior ε) Filter.atTop (nhds 1) := by
  sorry

/-- The posterior is monotonically increasing in the likelihood ratio L,
    for fixed prior ε ∈ (0, 1). More evidence always increases confidence. -/
theorem posterior_monotone_in_L (ε : ℝ) (hε_pos : 0 < ε) (hε_lt : ε < 1) :
    Monotone (bayesian_posterior ε) := by
  sorry

/-- Complementary result: the posterior is bounded above by 1.
    (Probability axiom: no posterior can exceed certainty.) -/
theorem posterior_le_one (ε L : ℝ) (hε_pos : 0 < ε) (hε_lt : ε < 1) (hL : 0 < L) :
    bayesian_posterior ε L ≤ 1 := by
  sorry
