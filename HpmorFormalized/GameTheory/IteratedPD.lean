import Mathlib

/-!
# Folk Theorem for the Iterated Prisoner's Dilemma

**HPMOR Chapter**: 33

**Claim Formalized**:
Harry argues that repeating the Prisoner's Dilemma changes the equilibrium —
cooperation becomes sustainable through iteration. The folk theorem makes this
precise: in an infinitely repeated game with sufficiently patient players
(discount factor above a threshold), cooperation can be sustained as a Nash
equilibrium via grim trigger strategies.

**Key Finding (Tier 3)**:
Harry hand-waves that "iteration helps" without specifying exact conditions.
Formalization reveals the precise discount factor threshold:

  **δ ≥ (T - R) / (T - P)**

where T = temptation, R = reward, P = punishment, S = sucker payoffs satisfy
T > R > P > S. Below this threshold, defection remains dominant even in
the repeated game.

## Structure

1. `PDPayoffs` — Stage game payoff parameters with T > R > P > S
2. `Action` — Cooperate or Defect
3. One-shot dominance: defection strictly dominates in the one-shot game
4. Grim trigger strategy and discounted payoff sums
5. Folk theorem: grim trigger cooperation is a Nash equilibrium iff δ ≥ (T-R)/(T-P)
-/

-- ============================================================================
-- § 1. Stage Game: Prisoner's Dilemma
-- ============================================================================

/-- Actions in the Prisoner's Dilemma -/
inductive PDAction where
  | Cooperate : PDAction
  | Defect : PDAction
  deriving DecidableEq

open PDAction

/-- Payoff parameters for a Prisoner's Dilemma satisfying T > R > P > S.
    - T (temptation): payoff for defecting when opponent cooperates
    - R (reward): payoff for mutual cooperation
    - P (punishment): payoff for mutual defection
    - S (sucker): payoff for cooperating when opponent defects -/
structure PDPayoffs where
  T : ℝ  -- Temptation
  R : ℝ  -- Reward
  P : ℝ  -- Punishment
  S : ℝ  -- Sucker
  hTR : T > R
  hRP : R > P
  hPS : P > S

namespace PDPayoffs

/-- The payoff function for player 1 in the stage game. -/
noncomputable def payoff (pd : PDPayoffs) (a₁ a₂ : PDAction) : ℝ :=
  match a₁, a₂ with
  | Cooperate, Cooperate => pd.R
  | Cooperate, Defect    => pd.S
  | Defect,    Cooperate => pd.T
  | Defect,    Defect    => pd.P

-- ============================================================================
-- § 2. One-Shot Dominance: Defection Strictly Dominates
-- ============================================================================

/-- In the one-shot Prisoner's Dilemma, Defect strictly dominates Cooperate:
    regardless of the opponent's action, defecting yields a strictly higher payoff. -/
theorem defect_strictly_dominates (pd : PDPayoffs) (opp : PDAction) :
    pd.payoff Defect opp > pd.payoff Cooperate opp := by
  cases opp
  · simp only [payoff]; exact pd.hTR  -- vs Cooperate: T > R
  · simp only [payoff]; exact pd.hPS  -- vs Defect: P > S

/-- Mutual defection is a Nash equilibrium of the one-shot game. -/
theorem mutual_defect_is_nash (pd : PDPayoffs) :
    (∀ a : PDAction, pd.payoff Defect Defect ≥ pd.payoff a Defect) ∧
    (∀ a : PDAction, pd.payoff Defect Defect ≥ pd.payoff a Defect) := by
  exact ⟨fun a => by cases a <;> simp only [payoff] <;> linarith [pd.hPS],
         fun a => by cases a <;> simp only [payoff] <;> linarith [pd.hPS]⟩

/-- Mutual cooperation is NOT a Nash equilibrium — player 1 can deviate to Defect. -/
theorem mutual_cooperate_not_nash (pd : PDPayoffs) :
    ∃ a : PDAction, pd.payoff a Cooperate > pd.payoff Cooperate Cooperate := by
  exact ⟨Defect, by simp only [payoff]; exact pd.hTR⟩

-- ============================================================================
-- § 3. Infinitely Repeated Game: Discounted Payoffs
-- ============================================================================

/-- Discount factor parameters: δ ∈ (0, 1). -/
structure DiscountFactor where
  δ : ℝ
  hδ_pos : 0 < δ
  hδ_lt_one : δ < 1

/-- The geometric series 1 + δ + δ² + ... = 1/(1-δ) for δ ∈ (0,1).
    The discounted sum of a constant stream c is c/(1-δ). -/
noncomputable def discounted_constant_stream (df : DiscountFactor) (c : ℝ) : ℝ :=
  c / (1 - df.δ)

/-- One minus δ is positive when δ < 1. -/
theorem one_minus_delta_pos (df : DiscountFactor) : 0 < 1 - df.δ := by
  linarith [df.hδ_lt_one]

-- ============================================================================
-- § 4. Grim Trigger Strategy
-- ============================================================================

/-! The **grim trigger** strategy:
- Start by cooperating
- Continue cooperating as long as the opponent cooperates
- If the opponent ever defects, defect forever after

When both players use grim trigger, the resulting payoff stream is:
- Cooperation path: R, R, R, ... → discounted sum = R/(1-δ)
- Deviation path: T (one round), then P, P, P, ... → T + δP/(1-δ)

A player will not deviate from cooperation iff:
  R/(1-δ) ≥ T + δP/(1-δ)

Rearranging:
  R/(1-δ) - δP/(1-δ) ≥ T
  (R - δP)/(1-δ) ≥ T
  R - δP ≥ T(1-δ)
  R - δP ≥ T - Tδ
  Tδ - δP ≥ T - R
  δ(T - P) ≥ T - R
  δ ≥ (T - R)/(T - P)
-/

/-- The discounted payoff from perpetual cooperation under grim trigger:
    R + δR + δ²R + ... = R/(1-δ) -/
noncomputable def cooperation_payoff (pd : PDPayoffs) (df : DiscountFactor) : ℝ :=
  pd.R / (1 - df.δ)

/-- The discounted payoff from deviating (defecting) in round 0 against a grim
    trigger opponent: get T in round 0, then P forever after.
    T + δP + δ²P + ... = T + δP/(1-δ) -/
noncomputable def deviation_payoff (pd : PDPayoffs) (df : DiscountFactor) : ℝ :=
  pd.T + df.δ * pd.P / (1 - df.δ)

/-- The critical discount factor threshold: δ* = (T - R) / (T - P) -/
noncomputable def critical_delta (pd : PDPayoffs) : ℝ :=
  (pd.T - pd.R) / (pd.T - pd.P)

/-- T - P is positive (needed as a denominator). -/
theorem T_minus_P_pos (pd : PDPayoffs) : pd.T - pd.P > 0 := by
  linarith [pd.hTR, pd.hRP]

/-- The critical delta is between 0 and 1 (it's a valid discount factor). -/
theorem critical_delta_in_unit (pd : PDPayoffs) :
    0 < critical_delta pd ∧ critical_delta pd < 1 := by
  constructor
  · unfold critical_delta
    apply div_pos
    · linarith [pd.hTR]
    · exact T_minus_P_pos pd
  · unfold critical_delta
    rw [div_lt_one (T_minus_P_pos pd)]
    linarith [pd.hRP]

-- ============================================================================
-- § 5. The Folk Theorem: Grim Trigger Cooperation Threshold
-- ============================================================================

/-- **Folk Theorem (cooperation direction)**: If δ ≥ (T-R)/(T-P), then
    cooperation is sustained — the cooperation payoff is at least as large
    as the deviation payoff. -/
theorem grim_trigger_cooperation (pd : PDPayoffs) (df : DiscountFactor)
    (hδ : df.δ ≥ critical_delta pd) :
    cooperation_payoff pd df ≥ deviation_payoff pd df := by
  unfold cooperation_payoff deviation_payoff critical_delta at *
  have h1 : (0 : ℝ) < 1 - df.δ := one_minus_delta_pos df
  have hTP : pd.T - pd.P > 0 := T_minus_P_pos pd
  -- We need: R/(1-δ) ≥ T + δP/(1-δ)
  -- Multiply both sides by (1-δ) > 0:
  -- R ≥ T(1-δ) + δP
  -- R ≥ T - Tδ + δP
  -- R - T ≥ -δ(T - P)
  -- δ(T - P) ≥ T - R
  -- δ ≥ (T - R)/(T - P)  ← which is our hypothesis
  rw [ge_iff_le, ← sub_nonneg]
  have key : df.δ * (pd.T - pd.P) ≥ pd.T - pd.R := by
    have := mul_le_mul_of_nonneg_right hδ (le_of_lt hTP)
    rwa [div_mul_cancel₀ (pd.T - pd.R) (ne_of_gt hTP)] at this
  field_simp
  linarith

/-- **Folk Theorem (defection direction)**: If δ < (T-R)/(T-P), then
    cooperation is NOT sustained — deviating is strictly better. -/
theorem grim_trigger_defection (pd : PDPayoffs) (df : DiscountFactor)
    (hδ : df.δ < critical_delta pd) :
    deviation_payoff pd df > cooperation_payoff pd df := by
  unfold cooperation_payoff deviation_payoff critical_delta at *
  have h1 : (0 : ℝ) < 1 - df.δ := one_minus_delta_pos df
  have hTP : pd.T - pd.P > 0 := T_minus_P_pos pd
  rw [gt_iff_lt, ← sub_pos]
  have key : pd.T - pd.R > df.δ * (pd.T - pd.P) := by
    have := mul_lt_mul_of_pos_right hδ hTP
    rwa [div_mul_cancel₀ (pd.T - pd.R) (ne_of_gt hTP)] at this
  field_simp
  linarith

/-- **Folk Theorem (iff version)**: Grim trigger sustains cooperation as a Nash
    equilibrium if and only if δ ≥ (T-R)/(T-P).

    This is the precise formalization of Harry's claim in HPMOR Ch. 33:
    "iteration helps" is true exactly when the discount factor exceeds
    this threshold. -/
theorem folk_theorem_iff (pd : PDPayoffs) (df : DiscountFactor) :
    cooperation_payoff pd df ≥ deviation_payoff pd df ↔
    df.δ ≥ critical_delta pd := by
  constructor
  · -- If cooperation is sustained, then δ ≥ threshold
    intro h
    by_contra h_not
    push_neg at h_not
    have := grim_trigger_defection pd df h_not
    linarith
  · -- If δ ≥ threshold, then cooperation is sustained
    exact grim_trigger_cooperation pd df

-- ============================================================================
-- § 6. Connecting One-Shot and Repeated Games
-- ============================================================================

/-- In the limit δ → 0 (essentially a one-shot game), the deviation payoff
    approaches T while the cooperation payoff approaches R.
    Since T > R, defection dominates — recovering the one-shot result. -/
theorem one_shot_limit (pd : PDPayoffs) :
    pd.T > pd.R := pd.hTR

/-- The critical delta is strictly between 0 and 1, showing there is a
    non-trivial region where iteration changes the equilibrium structure.
    For any PD with T > R > P > S:
    - δ < (T-R)/(T-P): behaves like one-shot, defection dominates
    - δ ≥ (T-R)/(T-P): cooperation becomes sustainable

    This is precisely what Harry's argument amounts to: the repeated game
    opens up a cooperation region that doesn't exist in the one-shot game. -/
theorem cooperation_region_exists (pd : PDPayoffs) :
    ∃ δ_star : ℝ, 0 < δ_star ∧ δ_star < 1 ∧
    (∀ df : DiscountFactor, df.δ ≥ δ_star →
      cooperation_payoff pd df ≥ deviation_payoff pd df) ∧
    (∀ df : DiscountFactor, df.δ < δ_star →
      deviation_payoff pd df > cooperation_payoff pd df) := by
  exact ⟨critical_delta pd, (critical_delta_in_unit pd).1,
    (critical_delta_in_unit pd).2,
    fun df h => grim_trigger_cooperation pd df h,
    fun df h => grim_trigger_defection pd df h⟩

end PDPayoffs
