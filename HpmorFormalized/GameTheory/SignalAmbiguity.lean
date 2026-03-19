import Mathlib

/-!
# Signal Ambiguity Enabling Coalition Formation (HPMOR Ch. 60)

**HPMOR Chapter**: 60 (Dumbledore's ambiguous communications)

## Prediction

"I expect this to confirm with interesting structure. In standard signaling games,
clarity (separating equilibria) is usually preferred because it resolves uncertainty.
But when the sender faces multiple audiences with conflicting interests, ambiguity
(pooling or semi-separating equilibria) can dominate. The hidden assumption in HPMOR
is that Dumbledore's audience is heterogeneous — if everyone had aligned interests,
clarity would be better. The formalization should identify the exact
audience-heterogeneity condition under which ambiguity dominates."

## Claims Formalized

In HPMOR Ch. 60, Dumbledore and other characters use ambiguous communication
strategically — saying things that can be interpreted multiple ways by different
audiences. This allows flexible coalition formation: allies interpret the signal
one way, opponents another.

We model this as a signaling game with:
- A sender with a private type (Strong or Weak)
- Two receivers: an Ally and an Opponent
- Two signaling strategies: Clear (type-revealing) vs Ambiguous (pooling)
- The sender's payoff depends on BOTH receivers' responses

Key results:
1. With a single homogeneous audience, clarity weakly dominates ambiguity.
2. With heterogeneous audiences, ambiguity can strictly dominate clarity.
3. The boundary condition: ambiguity helps iff the opponent's penalty for
   detecting the sender's type exceeds the ally's benefit from knowing it.

## Key Findings (Tier 3)

1. **Homogeneous audience**: When both receivers have aligned interests with
   the sender, clarity weakly dominates. The ally benefits from knowing the
   sender's type, and the opponent (who is really also an ally) benefits too.
   Ambiguity throws away information that helps everyone.

2. **Heterogeneous audience**: When the opponent will exploit knowledge of
   the sender's type, ambiguity dominates. The sender sacrifices the ally's
   information benefit to deny the opponent exploitable information.

3. **Boundary condition**: Let B_A be the ally's benefit from receiving a
   clear signal and P_O be the penalty the sender suffers when the opponent
   correctly identifies the sender's type. Ambiguity dominates iff P_O > B_A.
   This is the "audience heterogeneity condition."

4. **HPMOR implication**: Dumbledore operates in an environment where opponents
   (Death Eaters, Ministry adversaries) can do significant damage with clear
   information (P_O is large), while allies can partially compensate through
   other channels (B_A is moderate). The formalization confirms that strategic
   ambiguity is optimal in exactly this regime.

## Structure

1. `SenderType` — Strong or Weak
2. `SignalStrategy` — Clear (separating) or Ambiguous (pooling)
3. `SignalingParams` — Payoff parameters for ally benefit and opponent penalty
4. Payoff functions for each strategy
5. Homogeneous audience theorem (clarity dominates)
6. Heterogeneous audience theorem (ambiguity can dominate)
7. Boundary characterization
-/

-- ============================================================================
-- § 1. Types and Strategies
-- ============================================================================

/-- The sender's private type. -/
inductive SenderType where
  | Strong : SenderType
  | Weak : SenderType
  deriving DecidableEq

/-- The sender's signaling strategy.
    - `Clear`: send a distinct signal for each type (separating)
    - `Ambiguous`: send the same signal regardless of type (pooling) -/
inductive SignalStrategy where
  | Clear : SignalStrategy
  | Ambiguous : SignalStrategy
  deriving DecidableEq

open SenderType SignalStrategy

-- ============================================================================
-- § 2. Signaling Game Parameters
-- ============================================================================

/-- Parameters for a signaling game with one sender and two receivers
    (an ally and an opponent).

    - `basePayoff`: the sender's payoff absent any signaling effects
    - `allyBenefit`: additional payoff the sender gets when the ally correctly
      identifies the sender's type (ally can help more effectively)
    - `opponentPenalty`: payoff LOSS the sender suffers when the opponent
      correctly identifies the sender's type (opponent can exploit)

    Under a clear signal, BOTH receivers learn the type.
    Under an ambiguous signal, NEITHER receiver learns the type. -/
structure SignalingParams where
  /-- Base payoff to the sender -/
  basePayoff : ℝ
  /-- Benefit from ally knowing sender's type (nonneg) -/
  allyBenefit : ℝ
  /-- Penalty from opponent knowing sender's type (nonneg) -/
  opponentPenalty : ℝ
  /-- Ally benefit is nonneg -/
  hB_nonneg : 0 ≤ allyBenefit
  /-- Opponent penalty is nonneg -/
  hP_nonneg : 0 ≤ opponentPenalty

namespace SignalingParams

-- ============================================================================
-- § 3. Payoff Functions
-- ============================================================================

/-- The sender's payoff under each signaling strategy.
    - Clear: base + allyBenefit - opponentPenalty
      (ally learns type and helps, opponent learns type and exploits)
    - Ambiguous: base + 0 - 0
      (neither receiver learns type) -/
noncomputable def senderPayoff (p : SignalingParams) (s : SignalStrategy) : ℝ :=
  match s with
  | Clear => p.basePayoff + p.allyBenefit - p.opponentPenalty
  | Ambiguous => p.basePayoff

/-- The net value of clarity over ambiguity. -/
noncomputable def clarityAdvantage (p : SignalingParams) : ℝ :=
  p.senderPayoff Clear - p.senderPayoff Ambiguous

/-- The clarity advantage equals allyBenefit - opponentPenalty. -/
theorem clarity_advantage_eq (p : SignalingParams) :
    p.clarityAdvantage = p.allyBenefit - p.opponentPenalty := by
  unfold clarityAdvantage senderPayoff
  ring

-- ============================================================================
-- § 4. Single Homogeneous Audience: Clarity Dominates
-- ============================================================================

/-! ### Homogeneous Audience

When the sender faces a single audience (or equivalently, when the opponent
has aligned interests — i.e., the penalty is zero), clarity weakly dominates.
This models the standard signaling game result: with aligned interests,
more information is always (weakly) better. -/

/-- With a homogeneous audience (no opponent penalty), clarity weakly dominates
    ambiguity. The ally's benefit from knowing the type is never negative. -/
theorem clarity_dominates_homogeneous (p : SignalingParams)
    (h_homogeneous : p.opponentPenalty = 0) :
    p.senderPayoff Clear ≥ p.senderPayoff Ambiguous := by
  unfold senderPayoff
  linarith [p.hB_nonneg]

/-- With a homogeneous audience and positive ally benefit, clarity STRICTLY
    dominates ambiguity. -/
theorem clarity_strictly_dominates_homogeneous (p : SignalingParams)
    (h_homogeneous : p.opponentPenalty = 0)
    (h_benefit : 0 < p.allyBenefit) :
    p.senderPayoff Clear > p.senderPayoff Ambiguous := by
  unfold senderPayoff
  linarith

-- ============================================================================
-- § 5. Heterogeneous Audience: Ambiguity Can Dominate
-- ============================================================================

/-! ### Heterogeneous Audience

When the sender faces receivers with conflicting interests, the opponent's
penalty can exceed the ally's benefit, making ambiguity strictly better.
This is the core mechanism in HPMOR Ch. 60: Dumbledore's opponents would
do more damage with clear information than his allies would gain. -/

/-- When the opponent penalty exceeds the ally benefit, ambiguity strictly
    dominates clarity. This is the key heterogeneous-audience result. -/
theorem ambiguity_dominates_heterogeneous (p : SignalingParams)
    (h_hetero : p.opponentPenalty > p.allyBenefit) :
    p.senderPayoff Ambiguous > p.senderPayoff Clear := by
  unfold senderPayoff
  linarith

/-- The boundary condition: ambiguity weakly dominates clarity iff
    opponentPenalty >= allyBenefit. -/
theorem ambiguity_weakly_dominates_iff (p : SignalingParams) :
    p.senderPayoff Ambiguous ≥ p.senderPayoff Clear ↔
    p.opponentPenalty ≥ p.allyBenefit := by
  unfold senderPayoff
  constructor
  · intro h; linarith
  · intro h; linarith

/-- The boundary condition: ambiguity strictly dominates clarity iff
    opponentPenalty > allyBenefit. -/
theorem ambiguity_strictly_dominates_iff (p : SignalingParams) :
    p.senderPayoff Ambiguous > p.senderPayoff Clear ↔
    p.opponentPenalty > p.allyBenefit := by
  unfold senderPayoff
  constructor
  · intro h; linarith
  · intro h; linarith

-- ============================================================================
-- § 6. Existence: Payoff Structures Where Ambiguity Dominates
-- ============================================================================

/-- There exist valid signaling parameters where ambiguity strictly dominates
    clarity. This is the existence claim: heterogeneous audiences can make
    ambiguity optimal. -/
theorem exists_ambiguity_dominates :
    ∃ p : SignalingParams, p.senderPayoff Ambiguous > p.senderPayoff Clear := by
  exact ⟨⟨0, 1, 3, by linarith, by linarith⟩, by unfold senderPayoff; norm_num⟩

-- ============================================================================
-- § 7. Quantifying Audience Heterogeneity
-- ============================================================================

/-! ### The Heterogeneity Ratio

We define audience heterogeneity as the ratio of opponent penalty to ally
benefit. This ratio determines the optimal signaling strategy:
- ratio < 1: clarity dominates (allies matter more)
- ratio = 1: indifference (boundary)
- ratio > 1: ambiguity dominates (opponents are more dangerous) -/

/-- The heterogeneity ratio P_O / B_A, defined when B_A > 0. -/
noncomputable def heterogeneityRatio (p : SignalingParams) : ℝ :=
  p.opponentPenalty / p.allyBenefit

/-- When heterogeneity ratio < 1, clarity strictly dominates. -/
theorem clarity_when_low_heterogeneity (p : SignalingParams)
    (hB_pos : 0 < p.allyBenefit)
    (h_ratio : p.heterogeneityRatio < 1) :
    p.senderPayoff Clear > p.senderPayoff Ambiguous := by
  unfold heterogeneityRatio at h_ratio
  rw [div_lt_one hB_pos] at h_ratio
  unfold senderPayoff
  linarith

/-- When heterogeneity ratio > 1, ambiguity strictly dominates. -/
theorem ambiguity_when_high_heterogeneity (p : SignalingParams)
    (hB_pos : 0 < p.allyBenefit)
    (h_ratio : p.heterogeneityRatio > 1) :
    p.senderPayoff Ambiguous > p.senderPayoff Clear := by
  unfold heterogeneityRatio at h_ratio
  have h : p.allyBenefit < p.opponentPenalty := by
    rwa [gt_iff_lt, one_lt_div hB_pos] at h_ratio
  unfold senderPayoff
  linarith

/-- When heterogeneity ratio = 1, the sender is indifferent. -/
theorem indifference_at_boundary (p : SignalingParams)
    (hB_pos : 0 < p.allyBenefit)
    (h_ratio : p.heterogeneityRatio = 1) :
    p.senderPayoff Clear = p.senderPayoff Ambiguous := by
  unfold heterogeneityRatio at h_ratio
  have h_eq : p.opponentPenalty = p.allyBenefit := by
    rw [div_eq_one_iff_eq (ne_of_gt hB_pos)] at h_ratio
    exact h_ratio
  unfold senderPayoff
  linarith

-- ============================================================================
-- § 8. Extended Model: Partial Ambiguity
-- ============================================================================

/-! ### Partial Ambiguity

In practice, signals can be partially ambiguous — revealing the type to the
ally with probability α and to the opponent with probability β, where
α, β ∈ [0, 1]. Clear signals have α = β = 1; fully ambiguous signals have
α = β = 0. Dumbledore's skill lies in crafting signals with high α and low β. -/

/-- Parameters for a partial-ambiguity signaling game. -/
structure PartialSignalingParams where
  /-- Base payoff -/
  basePayoff : ℝ
  /-- Benefit when ally learns type -/
  allyBenefit : ℝ
  /-- Penalty when opponent learns type -/
  opponentPenalty : ℝ
  hB_nonneg : 0 ≤ allyBenefit
  hP_nonneg : 0 ≤ opponentPenalty

namespace PartialSignalingParams

/-- The sender's payoff as a function of ally-revelation probability α
    and opponent-revelation probability β. -/
noncomputable def partialPayoff (p : PartialSignalingParams) (α β : ℝ) : ℝ :=
  p.basePayoff + α * p.allyBenefit - β * p.opponentPenalty

/-- Clear signal corresponds to α = 1, β = 1. -/
theorem clear_is_full_revelation (p : PartialSignalingParams) :
    p.partialPayoff 1 1 = p.basePayoff + p.allyBenefit - p.opponentPenalty := by
  unfold partialPayoff
  ring

/-- Ambiguous signal corresponds to α = 0, β = 0. -/
theorem ambiguous_is_no_revelation (p : PartialSignalingParams) :
    p.partialPayoff 0 0 = p.basePayoff := by
  unfold partialPayoff
  ring

/-- **Optimal Targeting Theorem**: The optimal signal maximizes payoff by
    maximizing α (ally revelation) and minimizing β (opponent revelation).
    The ideal signal has α = 1, β = 0 — perfectly targeted communication.
    This is what Dumbledore strives for: messages that allies understand
    but opponents cannot decode. -/
theorem optimal_targeting (p : PartialSignalingParams)
    (α β : ℝ) (_hα : 0 ≤ α) (hα1 : α ≤ 1) (hβ : 0 ≤ β) (_hβ1 : β ≤ 1) :
    p.partialPayoff α β ≤ p.partialPayoff 1 0 := by
  unfold partialPayoff
  have h1 : α * p.allyBenefit ≤ 1 * p.allyBenefit := by
    exact mul_le_mul_of_nonneg_right hα1 p.hB_nonneg
  have h2 : 0 ≤ β * p.opponentPenalty := mul_nonneg hβ p.hP_nonneg
  linarith

/-- The ideal targeted signal (α = 1, β = 0) is at least as good as
    both clear and ambiguous signals. -/
theorem targeted_beats_clear (p : PartialSignalingParams) :
    p.partialPayoff 1 0 ≥ p.partialPayoff 1 1 := by
  unfold partialPayoff
  linarith [p.hP_nonneg]

theorem targeted_beats_ambiguous (p : PartialSignalingParams) :
    p.partialPayoff 1 0 ≥ p.partialPayoff 0 0 := by
  unfold partialPayoff
  linarith [p.hB_nonneg]

-- ============================================================================
-- § 9. The Ambiguity Premium
-- ============================================================================

/-- The "ambiguity premium" — how much the sender would pay to be able
    to send ambiguous rather than clear signals — equals P_O - B_A
    when this is positive, and 0 otherwise. -/
noncomputable def ambiguityPremium (p : PartialSignalingParams) : ℝ :=
  max 0 (p.opponentPenalty - p.allyBenefit)

/-- The ambiguity premium is nonneg. -/
theorem ambiguity_premium_nonneg (p : PartialSignalingParams) :
    0 ≤ p.ambiguityPremium := le_max_left 0 _

/-- When P_O > B_A, the premium is positive and equals P_O - B_A. -/
theorem ambiguity_premium_positive (p : PartialSignalingParams)
    (h : p.opponentPenalty > p.allyBenefit) :
    p.ambiguityPremium = p.opponentPenalty - p.allyBenefit := by
  unfold ambiguityPremium
  exact max_eq_right_iff.mpr (by linarith)

/-- When B_A >= P_O, the premium is zero — ambiguity has no value. -/
theorem ambiguity_premium_zero (p : PartialSignalingParams)
    (h : p.allyBenefit ≥ p.opponentPenalty) :
    p.ambiguityPremium = 0 := by
  unfold ambiguityPremium
  exact max_eq_left_iff.mpr (by linarith)

end PartialSignalingParams

-- ============================================================================
-- § 10. HPMOR Analysis: Dumbledore's Strategic Communication
-- ============================================================================

/-! ### Connecting to HPMOR Ch. 60

Dumbledore operates in a setting with:
- **Allies** (Order of the Phoenix members): benefit from knowing Dumbledore's
  true assessment of threats and plans. B_A is moderate.
- **Opponents** (Death Eaters, Ministry adversaries, Voldemort): would
  exploit clear information to counter Dumbledore's moves. P_O is very large.

Since P_O >> B_A, Dumbledore rationally prefers ambiguous communication.
Moreover, his skill as a communicator can be modeled as achieving high α
(allies decode his messages) with low β (opponents cannot), approaching
the optimal targeted signal.

The key insight: it's not that Dumbledore is being "mysterious for the sake
of being mysterious" — ambiguity is the *strategically optimal* response to
audience heterogeneity.
-/

/-- A concrete HPMOR scenario: B_A = 2 (moderate ally benefit),
    P_O = 8 (large opponent penalty). Ambiguity strictly dominates clarity. -/
theorem dumbledore_prefers_ambiguity :
    let p : SignalingParams := ⟨10, 2, 8, by linarith, by linarith⟩
    p.senderPayoff Ambiguous > p.senderPayoff Clear := by
  unfold SignalingParams.senderPayoff
  norm_num

/-- The heterogeneity ratio in Dumbledore's setting is 4 >> 1. -/
theorem dumbledore_high_heterogeneity :
    let B_A := (2 : ℝ)
    let P_O := (8 : ℝ)
    P_O / B_A = 4 := by
  norm_num

/-- If Dumbledore could target perfectly (α = 1, β = 0), that would be
    even better than ambiguity. His speeches try to approach this ideal. -/
theorem dumbledore_targeting_gain :
    let p : PartialSignalingParams := ⟨10, 2, 8, by linarith, by linarith⟩
    p.partialPayoff 1 0 > p.partialPayoff 0 0 ∧
    p.partialPayoff 1 0 > p.partialPayoff 1 1 := by
  unfold PartialSignalingParams.partialPayoff
  norm_num

/-- **Complete Phase Diagram**: The sender's optimal strategy depends on
    the heterogeneity ratio r = P_O / B_A:
    - r < 1: use clear signals (allies' benefit outweighs opponent's exploitation)
    - r = 1: indifferent
    - r > 1: use ambiguous signals (opponent's exploitation outweighs ally benefit)
    - If targeted signals possible: always use targeted (α = 1, β = 0) -/
theorem complete_characterization (p : SignalingParams) :
    (p.opponentPenalty < p.allyBenefit →
      p.senderPayoff Clear > p.senderPayoff Ambiguous) ∧
    (p.opponentPenalty = p.allyBenefit →
      p.senderPayoff Clear = p.senderPayoff Ambiguous) ∧
    (p.opponentPenalty > p.allyBenefit →
      p.senderPayoff Ambiguous > p.senderPayoff Clear) := by
  unfold senderPayoff
  constructor
  · intro h; linarith
  constructor
  · intro h; linarith
  · intro h; linarith

end SignalingParams
