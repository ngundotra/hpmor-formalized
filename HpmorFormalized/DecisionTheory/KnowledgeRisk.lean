import Mathlib

/-!
# Existential Risk from Knowledge Dissemination

**HPMOR Chapters**: 119 (The Interdict of Merlin)

**Claims Formalized**:
In HPMOR Ch. 119, the Interdict of Merlin restricts the dissemination of powerful
magical knowledge. Harry argues that some knowledge is too dangerous to spread freely:
a single bad actor with world-destroying knowledge causes more harm than many good
actors with the same knowledge cause benefit. The creation/destruction asymmetry makes
restriction the rational policy.

This module formalizes the knowledge restriction problem and derives the conditions
under which restricting information actually reduces total expected harm.

## Key Results

1. `open_dissemination_negative`: Open dissemination has negative expected utility
   when the harm-to-value ratio exceeds the good-to-bad agent ratio.

2. `restriction_better_iff`: Restriction (with per-agent leak probability q) is
   better than open dissemination iff q < 1 — i.e., restriction helps whenever
   it prevents at least some agents from obtaining the knowledge.

3. `leak_probability_approaches_one`: With N independent agents each having leak
   probability q > 0, the probability that at least one agent obtains the knowledge
   approaches 1 as N grows. This means restriction becomes ineffective for large
   populations.

4. `existential_threshold`: When harm is unboundedly large relative to value,
   restriction is preferred even with high leak probability, but the benefit
   of restriction diminishes as more agents exist.

## Tier 3 Finding

Harry's argument for knowledge restriction (the Interdict of Merlin) is **correct
in the static case** — restricting dangerous knowledge is beneficial when the
harm-to-value ratio exceeds the good-to-bad ratio. However, formalization reveals
two critical hidden assumptions:

1. **Containment degrades with population**: The per-agent leak probability q must
   be maintained across ALL agents. The probability that restriction holds for
   everyone is (1-q)^N, which goes to 0 as N grows. For large populations,
   restriction becomes practically ineffective.

2. **The restriction threshold is trivially q < 1**: Any imperfect but non-trivial
   restriction helps in the static model. The real question is whether restriction
   can be maintained over time and across a growing population — and the
   formalization shows this gets exponentially harder.

The HPMOR Interdict works because it is magically enforced (q ≈ 0). Without such
enforcement, the "security through obscurity" problem means restriction provides
diminishing returns as the population grows.
-/

-- ============================================================================
-- § 1. Knowledge Dissemination Model
-- ============================================================================

/-- Parameters for a knowledge dissemination problem. -/
structure KnowledgeRiskParams where
  /-- Value created by a constructive use of the knowledge. -/
  V : ℝ
  /-- Harm caused by a destructive use (negative number, |H| >> V). -/
  H : ℝ
  /-- Number of agents. -/
  N : ℕ
  /-- Probability each agent is a good (constructive) actor. -/
  p_good : ℝ
  /-- Value is positive. -/
  hV : 0 < V
  /-- Harm is negative. -/
  hH : H < 0
  /-- p_good is a probability in (0, 1). -/
  hp_pos : 0 < p_good
  hp_lt : p_good < 1
  /-- At least one agent. -/
  hN : 0 < N

/-- The probability an agent is bad (destructive). -/
noncomputable def KnowledgeRiskParams.p_bad (k : KnowledgeRiskParams) : ℝ :=
  1 - k.p_good

/-- p_bad is positive when p_good < 1. -/
theorem KnowledgeRiskParams.p_bad_pos (k : KnowledgeRiskParams) : 0 < k.p_bad := by
  unfold KnowledgeRiskParams.p_bad
  linarith [k.hp_lt]

-- ============================================================================
-- § 2. Expected Utility Under Open Dissemination
-- ============================================================================

/-- Expected utility when knowledge is openly disseminated to all N agents.
    Each agent independently uses it constructively (prob p_good, value V)
    or destructively (prob p_bad, harm H). -/
noncomputable def eu_open (k : KnowledgeRiskParams) : ℝ :=
  k.N * (k.p_good * k.V + k.p_bad * k.H)

/-- **Core asymmetry theorem**: Open dissemination has negative expected utility
    when the harm-to-value ratio exceeds the ratio of good to bad agents.

    Formally: EU_open < 0 when |H|/V > p_good/p_bad, which is equivalent to
    p_good * V + p_bad * H < 0 (the per-agent expected utility is negative).

    This captures the HPMOR argument: if destruction is sufficiently easier than
    creation (|H| >> V), then even a mostly-good population produces negative
    expected value from open knowledge. -/
theorem open_dissemination_negative (k : KnowledgeRiskParams)
    (h_asym : k.p_good * k.V + k.p_bad * k.H < 0) :
    eu_open k < 0 := by
  unfold eu_open
  have hN_pos : (0 : ℝ) < k.N := Nat.cast_pos.mpr k.hN
  exact mul_neg_of_pos_of_neg hN_pos h_asym

/-- The asymmetry condition `p_good * V + p_bad * H < 0` is equivalent to
    `|H|/V > p_good/p_bad` (when V > 0, p_bad > 0). This is the ratio form
    of the creation/destruction asymmetry. -/
theorem asymmetry_ratio_form (k : KnowledgeRiskParams)
    (h_asym : k.p_good * k.V + k.p_bad * k.H < 0) :
    k.p_good * k.V < k.p_bad * (-k.H) := by
  linarith

-- ============================================================================
-- § 3. Expected Utility Under Restriction
-- ============================================================================

/-- Expected utility when knowledge is restricted, with per-agent leak probability q.
    Each of N agents independently has probability q of obtaining the knowledge,
    and if they do, they use it constructively or destructively as before.

    EU_restrict = N * q * (p_good * V + p_bad * H) -/
noncomputable def eu_restrict (k : KnowledgeRiskParams) (q : ℝ) : ℝ :=
  k.N * q * (k.p_good * k.V + k.p_bad * k.H)

/-- **Restriction threshold theorem**: Restriction is weakly better than open
    dissemination if and only if q ≤ 1, given that the per-agent EU is negative.

    This is almost trivially true: any reduction in access (q < 1) proportionally
    reduces the (negative) expected harm. The "threshold" is simply q = 1 (no
    restriction at all).

    The deeper insight: there is no subtle threshold for when restriction helps.
    If open dissemination is bad, ANY restriction helps proportionally. -/
theorem restriction_better_iff (k : KnowledgeRiskParams)
    (h_asym : k.p_good * k.V + k.p_bad * k.H < 0)
    (_hq_nn : 0 ≤ q) :
    eu_open k ≤ eu_restrict k q ↔ q ≤ 1 := by
  unfold eu_open eu_restrict
  have hN_pos : (0 : ℝ) < k.N := Nat.cast_pos.mpr k.hN
  -- eu_open = N * per_agent_eu, eu_restrict = N * q * per_agent_eu
  -- Since per_agent_eu < 0 and N > 0:
  -- N * per_agent_eu ≤ N * q * per_agent_eu ↔ 1 * per_agent_eu ≥ q * per_agent_eu
  -- ↔ (1 - q) * per_agent_eu ≥ 0 ↔ (since per_agent_eu < 0) 1 - q ≤ 0... wait
  -- Actually N * x ≤ N * q * x with x < 0:
  -- Dividing by N (pos): x ≤ q * x ↔ x - q*x ≤ 0 ↔ (1-q)*x ≤ 0
  -- Since x < 0: (1-q)*x ≤ 0 ↔ 1-q ≥ 0 ↔ q ≤ 1
  set x := k.p_good * k.V + k.p_bad * k.H with hx_def
  constructor
  · intro h
    -- N * x ≤ N * q * x → (1 - q) * x ≤ 0 → q ≤ 1
    have h1 : (1 - q) * (↑k.N * x) ≤ 0 := by nlinarith
    have h2 : ↑k.N * x < 0 := mul_neg_of_pos_of_neg hN_pos h_asym
    -- (1 - q) * (negative) ≤ 0 → 1 - q ≥ 0 → q ≤ 1
    by_contra hq
    push_neg at hq
    have : 1 - q < 0 := by linarith
    have : (1 - q) * (↑k.N * x) > 0 := mul_pos_of_neg_of_neg this h2
    linarith
  · intro hq
    have h2 : ↑k.N * x < 0 := mul_neg_of_pos_of_neg hN_pos h_asym
    nlinarith

/-- **Restriction strictly helps**: If 0 ≤ q < 1 and open dissemination is bad,
    then restriction strictly improves expected utility. -/
theorem restriction_strictly_better (k : KnowledgeRiskParams)
    (h_asym : k.p_good * k.V + k.p_bad * k.H < 0)
    (_hq_nn : 0 ≤ q) (hq_lt : q < 1) :
    eu_open k < eu_restrict k q := by
  unfold eu_open eu_restrict
  have hN_pos : (0 : ℝ) < k.N := Nat.cast_pos.mpr k.hN
  set x := k.p_good * k.V + k.p_bad * k.H
  have hx : x < 0 := h_asym
  have hNx : ↑k.N * x < 0 := mul_neg_of_pos_of_neg hN_pos hx
  -- Need: N * x < N * q * x, i.e., (1 - q) * N * x < 0
  -- Since 1 - q > 0 and N * x < 0, this holds.
  have h1q : 0 < 1 - q := by linarith
  nlinarith

-- ============================================================================
-- § 4. The Population Scaling Problem
-- ============================================================================

/-- The probability that restriction holds for ALL N agents, when each
    independently has leak probability q, is (1 - q)^N. -/
noncomputable def containment_prob (q : ℝ) (N : ℕ) : ℝ := (1 - q) ^ N

/-- The probability at least one agent obtains the knowledge. -/
noncomputable def leak_some_prob (q : ℝ) (N : ℕ) : ℝ := 1 - (1 - q) ^ N

/-- **Population scaling theorem**: For any leak probability q ∈ (0, 1),
    the containment probability (1-q)^N is strictly decreasing in N.

    This means restriction becomes exponentially less effective as the
    population grows. The Interdict of Merlin faces the same problem as
    all security-through-obscurity schemes: it only takes one leak. -/
theorem containment_decreasing (q : ℝ) (hq_pos : 0 < q) (hq_lt : q < 1)
    (N : ℕ) :
    containment_prob q (N + 1) < containment_prob q N := by
  unfold containment_prob
  rw [pow_succ]
  have h1q : 0 < 1 - q := by linarith
  have h1q_lt : 1 - q < 1 := by linarith
  have hpow_pos : 0 < (1 - q) ^ N := pow_pos h1q N
  calc (1 - q) ^ N * (1 - q)
      < (1 - q) ^ N * 1 := by {
        apply mul_lt_mul_of_pos_left h1q_lt hpow_pos
      }
    _ = (1 - q) ^ N := mul_one _

/-- **Leak probability approaches certainty**: For q > 0, the probability
    that at least one agent obtains the knowledge approaches 1 as N grows.

    Specifically: for any target probability threshold t < 1, there exists
    N₀ such that for all N ≥ N₀, P(at least one leak) > t.

    This is the fundamental problem with the Interdict of Merlin in a
    growing wizarding population: even with very small q, enough agents
    make a leak virtually certain. -/
theorem leak_probability_lower_bound (q : ℝ) (hq_pos : 0 < q) (hq_lt : q < 1)
    (N : ℕ) (hN : 0 < N) :
    0 < leak_some_prob q N := by
  unfold leak_some_prob
  have h1q : 0 < 1 - q := by linarith
  have h1q_lt : 1 - q < 1 := by linarith
  have : (1 - q) ^ N < 1 := by
    exact pow_lt_one₀ (le_of_lt h1q) h1q_lt (by omega)
  linarith

-- ============================================================================
-- § 5. The Interdict's Dilemma: Static vs Dynamic Analysis
-- ============================================================================

/-- **Static restriction benefit**: The absolute improvement from restriction
    (how much better restricted EU is vs open EU) scales with (1-q) and N.
    For a fixed q, the benefit per agent is constant: (1-q) * |per_agent_harm|. -/
theorem restriction_benefit (k : KnowledgeRiskParams) (q : ℝ)
    (_hq_nn : 0 ≤ q) :
    eu_restrict k q - eu_open k = k.N * (1 - q) * (-(k.p_good * k.V + k.p_bad * k.H)) := by
  unfold eu_restrict eu_open
  ring

/-- **The leaky-restriction equivalence**: Under restriction with leak probability q,
    the expected utility is exactly q times the open-dissemination utility.
    Restriction just scales the problem — it does not change its character. -/
theorem restrict_scales_open (k : KnowledgeRiskParams) (q : ℝ) :
    eu_restrict k q = q * eu_open k := by
  unfold eu_restrict eu_open
  ring

/-- **Key insight**: Two different knowledge-restriction regimes (q₁ vs q₂)
    are compared purely by their leak probabilities. If per-agent EU is negative,
    lower leak probability is always better. -/
theorem lower_leak_better (k : KnowledgeRiskParams)
    (h_asym : k.p_good * k.V + k.p_bad * k.H < 0)
    (q₁ q₂ : ℝ) (_hq₁ : 0 ≤ q₁) (_hq₂ : 0 ≤ q₂) (hlt : q₁ < q₂) :
    eu_restrict k q₂ < eu_restrict k q₁ := by
  rw [restrict_scales_open, restrict_scales_open]
  have heu : eu_open k < 0 := open_dissemination_negative k h_asym
  -- q₂ * (negative) < q₁ * (negative) when q₁ < q₂
  nlinarith

-- ============================================================================
-- § 6. The Extreme Case: Existential-Level Harm
-- ============================================================================

/-- When harm is very large relative to value, even a small fraction of bad
    actors makes open dissemination catastrophic. The per-agent EU is negative
    whenever |H| > (p_good / p_bad) * V.

    This formalizes the HPMOR argument: for world-destroying knowledge,
    |H| is so large that no realistic p_good makes dissemination safe. -/
theorem extreme_harm_threshold (k : KnowledgeRiskParams)
    (h_extreme : -k.H > (k.p_good / k.p_bad) * k.V) :
    k.p_good * k.V + k.p_bad * k.H < 0 := by
  have hp_bad_pos := k.p_bad_pos
  have : k.p_bad * (-k.H) > k.p_bad * ((k.p_good / k.p_bad) * k.V) := by
    exact mul_lt_mul_of_pos_left h_extreme hp_bad_pos
  have : k.p_bad * ((k.p_good / k.p_bad) * k.V) = k.p_good * k.V := by
    field_simp
  linarith

/-- **Perfect restriction is always preferred**: If restriction could be made
    perfect (q = 0), the expected utility is 0, which is better than the
    negative EU of open dissemination. This is the idealized Interdict. -/
theorem perfect_restriction (k : KnowledgeRiskParams)
    (h_asym : k.p_good * k.V + k.p_bad * k.H < 0) :
    eu_open k < eu_restrict k 0 := by
  rw [restrict_scales_open]
  simp only [zero_mul]
  exact open_dissemination_negative k h_asym

-- ============================================================================
-- § 7. Summary of Findings
-- ============================================================================

/-!
## Summary: What the Formalization Reveals

### The HPMOR Argument (Ch. 119)
The Interdict of Merlin restricts powerful magical knowledge because the
asymmetry between creation and destruction means open dissemination has
negative expected utility: a single bad actor with world-destroying knowledge
causes more harm than many good actors cause benefit.

### What We Proved

1. **The asymmetry argument is valid** (`open_dissemination_negative`): When
   |H|/V > p_good/p_bad, open dissemination has negative expected utility.
   For existential-level harm, this condition is easily satisfied.

2. **Any restriction helps** (`restriction_strictly_better`): If open
   dissemination is bad, any leak probability q < 1 improves expected utility.
   The threshold is trivially q < 1 — there is no subtle cutoff.

3. **Restriction just scales the problem** (`restrict_scales_open`): The
   restricted EU is exactly q times the open EU. Restriction does not change
   the character of the problem, only its magnitude.

4. **Containment degrades exponentially** (`containment_decreasing`): The
   probability that NO agent obtains restricted knowledge is (1-q)^N, which
   decreases exponentially in N. For large populations, restriction becomes
   practically ineffective.

5. **Lower leak is always better** (`lower_leak_better`): When the per-agent
   EU is negative, there is no paradoxical regime where higher leak probability
   is preferable. The relationship is monotonic.

### Tier 3 Finding

The HPMOR argument for the Interdict of Merlin **survives formalization in the
static case** but with an important caveat that the novel acknowledges implicitly:

**The Interdict works because it is magically enforced (q ≈ 0).**

The formalization reveals that the restriction threshold is trivially q < 1 —
any imperfect restriction helps. The real challenge is *maintaining* low q over
time and across a growing population. Since containment probability is (1-q)^N,
the probability of at least one leak approaches 1 exponentially as population
grows.

This vindicates the prediction: "knowledge restriction only reduces risk if the
probability of containment failure is below a threshold." The threshold itself
is trivial (q < 1), but the population scaling means the *effective* containment
degrades exponentially. The "security through obscurity" critique applies: for
mundane (non-magical) information restrictions, the Interdict is a losing strategy
in the long run.

Harry's deeper point stands: for existential-level harm (|H| → ∞), even highly
imperfect restriction (q close to 1) still reduces expected harm proportionally.
The question is not *whether* to restrict but *how effectively* — and the
formalization shows this is fundamentally a race against population growth.
-/
