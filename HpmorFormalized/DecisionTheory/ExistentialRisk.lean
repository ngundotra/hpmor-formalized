import Mathlib

/-!
# Expected Utility Under Existential Risk

**HPMOR Chapters**: 43-47 (The Dementor/Patronus scenario)

**Claims Formalized**:
In HPMOR Ch. 43-47, Harry faces Dementors — creatures that represent death itself.
Harry argues that when facing existential risk (an outcome with effectively unbounded
negative utility), you should take extreme measures to prevent it, because any finite
probability times negative infinity dominates all other finite considerations.

This module formalizes this reasoning using extended real-valued utility (EReal) and
reveals a fundamental problem: **standard expected utility theory breaks down with
infinite disutility**.

## Key Results

1. `eu_bot_of_nonzero_prob`: If an outcome has utility ⊥ (negative infinity) and
   nonzero probability, the expected utility of the entire action is ⊥.

2. `eu_indiscriminate`: If ALL available actions have nonzero probability of the
   catastrophic outcome, standard EU assigns them all utility ⊥, making it impossible
   to discriminate between actions — even ones that are obviously better.

3. `lexicographic_discriminates`: A lexicographic preference ordering (first minimize
   catastrophe probability, then maximize expected utility conditional on survival)
   CAN discriminate between actions that standard EU cannot.

## Tier 3 Finding

Harry's informal argument ("any probability of infinite disutility dominates everything")
is **mathematically correct within standard EU** — but this is actually a *bug*, not a
feature. It means standard EU with unbounded negative utility is too coarse to guide
action when existential risk is unavoidable. Harry's actual decision-making implicitly
uses something more like **lexicographic preferences** or **bounded utility**.

This is a genuine breakdown: the formalization reveals that Harry's reasoning requires
a non-standard decision framework to be action-guiding.
-/

-- ============================================================================
-- § 1. Decision Problem Setup
-- ============================================================================

/-- An outcome in our decision problem, parameterized by a finite type. -/
structure DecisionProblem (Outcome : Type*) [Fintype Outcome] where
  /-- Utility function mapping outcomes to extended reals. -/
  utility : Outcome → EReal
  /-- An outcome is catastrophic if it has utility ⊥ (negative infinity). -/
  catastrophic : Outcome → Prop
  /-- Catastrophic outcomes have utility ⊥. -/
  catastrophic_iff : ∀ o, catastrophic o ↔ utility o = ⊥

/-- An action specifies a probability distribution over outcomes.
    We model probabilities as nonneg reals that sum to 1. -/
structure Action (Outcome : Type*) [Fintype Outcome] where
  /-- Probability of each outcome. -/
  prob : Outcome → ℝ
  /-- Probabilities are nonneg. -/
  prob_nonneg : ∀ o, 0 ≤ prob o
  /-- Probabilities sum to 1. -/
  prob_sum : ∑ o, prob o = 1

-- ============================================================================
-- § 2. The Core Theorem: Nonzero Probability of ⊥ Yields EU = ⊥
-- ============================================================================

/-- A simplified model: expected utility with just two outcomes (catastrophe and
    survival), demonstrating the core issue. This avoids complications with
    EReal summation over Fintype while capturing the essential mathematical content. -/

/-- Expected utility of a binary gamble: with probability p get utility u_good,
    with probability (1-p) get utility u_bad. -/
noncomputable def binary_eu (p : ℝ) (u_good u_bad : EReal) : EReal :=
  (p : EReal) * u_good + ((1 - p) : ℝ) * u_bad

/-- **Core theorem**: If the bad outcome has utility ⊥ and occurs with positive
    probability, the expected utility is ⊥.

    This is the formal version of Harry's argument: any nonzero chance of
    existential catastrophe (utility -∞) makes the expected utility -∞. -/
theorem eu_bot_of_pos_prob {p : ℝ} (hp : 0 < p) (hp1 : p < 1)
    (u_good : EReal) :
    binary_eu p u_good ⊥ = ⊥ := by
  unfold binary_eu
  have h1p : (0 : ℝ) < 1 - p := sub_pos.mpr hp1
  have h1p_ereal : (0 : EReal) < ((1 - p : ℝ) : EReal) := by
    exact_mod_cast h1p
  -- (1-p) > 0 and ⊥ means (1-p) * ⊥ = ⊥
  have : ((1 - p : ℝ) : EReal) * ⊥ = ⊥ := EReal.coe_mul_bot_of_pos h1p
  rw [this]
  simp [EReal.add_bot]

/-- **Indiscrimination theorem**: Two actions with different survival probabilities
    and different good-outcome utilities both get EU = ⊥, so standard EU cannot
    tell them apart.

    This shows the breakdown: an action with 99% survival and great outcomes is
    rated identically to an action with 1% survival and terrible outcomes. -/
theorem eu_indiscriminate
    {p₁ p₂ : ℝ} (hp₁ : 0 < p₁) (hp₁' : p₁ < 1) (hp₂ : 0 < p₂) (hp₂' : p₂ < 1)
    (u₁ u₂ : EReal) :
    binary_eu p₁ u₁ ⊥ = binary_eu p₂ u₂ ⊥ := by
  rw [eu_bot_of_pos_prob hp₁ hp₁', eu_bot_of_pos_prob hp₂ hp₂']

-- ============================================================================
-- § 3. Lexicographic Preferences: A Framework That Works
-- ============================================================================

/-- Lexicographic preference over actions facing existential risk.
    First criterion: minimize probability of catastrophe.
    Second criterion (tiebreaker): maximize expected utility conditional on survival.

    This captures what Harry *actually* does: he primarily tries to minimize
    the chance of catastrophe, and only secondarily considers other outcomes. -/
structure LexAction where
  /-- Probability of survival (1 - P(catastrophe)). -/
  survivalProb : ℝ
  /-- Expected utility conditional on survival. -/
  conditionalEU : ℝ
  /-- Survival probability is in [0, 1]. -/
  survival_nonneg : 0 ≤ survivalProb
  survival_le_one : survivalProb ≤ 1

/-- Lexicographic ordering: first compare survival probability, then conditional EU. -/
def LexAction.lexLe (a b : LexAction) : Prop :=
  a.survivalProb < b.survivalProb ∨
  (a.survivalProb = b.survivalProb ∧ a.conditionalEU ≤ b.conditionalEU)

/-- **Lexicographic preferences can discriminate**: An action with higher survival
    probability is strictly preferred, even though standard EU rates both as ⊥.

    This is the key positive result: Harry's reasoning is *not* that all actions
    are equivalent when facing existential risk. Rather, he uses a decision
    framework where minimizing catastrophe probability comes first. -/
theorem lexicographic_discriminates
    (a b : LexAction) (h : a.survivalProb < b.survivalProb) :
    a.lexLe b ∧ ¬ b.lexLe a := by
  constructor
  · left; exact h
  · intro hba
    cases hba with
    | inl hlt => linarith
    | inr heq => linarith [heq.1]

-- ============================================================================
-- § 4. Bounded Utility: The Other Fix
-- ============================================================================

/-- An alternative resolution: bound utility from below. If utility is bounded
    in [-M, ∞) for some finite M, expected utility is always finite and
    can discriminate between actions. -/

/-- With bounded utility, higher survival probability yields higher expected utility. -/
theorem bounded_eu_discriminates
    {p₁ p₂ : ℝ} {u_good u_bad : ℝ}
    (hp₁ : 0 < p₁) (hp₁' : p₁ ≤ 1) (hp₂ : 0 < p₂) (hp₂' : p₂ ≤ 1)
    (h_surv : p₁ < p₂)
    (h_util : u_bad < u_good) :
    p₁ * u_good + (1 - p₁) * u_bad < p₂ * u_good + (1 - p₂) * u_bad := by
  have : (p₂ - p₁) * (u_good - u_bad) > 0 := by
    apply mul_pos
    · linarith
    · linarith
  nlinarith

-- ============================================================================
-- § 5. Summary of Findings
-- ============================================================================

/-!
## Summary: What the Formalization Reveals

### Harry's Argument (HPMOR Ch. 43-47)
Harry faces Dementors and argues that preventing existential catastrophe should
dominate all other considerations because `P(catastrophe) × (-∞) = -∞`.

### What We Proved

1. **Harry is mathematically correct** (`eu_bot_of_pos_prob`): In standard EU
   with EReal-valued utility, any nonzero probability of a ⊥-utility outcome
   makes the expected utility ⊥.

2. **But this breaks decision-making** (`eu_indiscriminate`): If every available
   action has *some* nonzero probability of catastrophe (realistic in practice),
   standard EU rates them all as ⊥ and cannot guide action.

3. **Harry actually uses lexicographic preferences** (`lexicographic_discriminates`):
   His real decision procedure is: first minimize catastrophe probability, then
   optimize other outcomes. This is a non-standard but well-studied decision
   framework.

4. **Bounding utility also works** (`bounded_eu_discriminates`): If we replace -∞
   with a very large but finite negative utility, standard EU can again discriminate
   between actions. This is the approach taken by most practical decision theories.

### Tier 3 Classification
This is a genuine **hidden assumption** in Harry's reasoning. He presents his argument
as standard expected utility theory, but it actually requires either:
- Lexicographic preferences (minimize catastrophe first), or
- Bounded utility (catastrophe is very bad but finite)

Standard EU with unbounded negative utility is too coarse to be action-guiding when
existential risk cannot be fully eliminated.
-/
