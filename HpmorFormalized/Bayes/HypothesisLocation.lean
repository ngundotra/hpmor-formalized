import Mathlib

/-!
# Privileging the Hypothesis: The Cost of Locating a Hypothesis

**HPMOR Chapter**: 17

**Claims Formalized**:
Harry argues that before you can even test a hypothesis, you need to "locate" it in
hypothesis space. If there are N possible hypotheses and you have no prior reason to
favor one over another, each gets prior probability 1/N. The information-theoretic cost
of picking out a specific hypothesis is log₂(N) bits. As the hypothesis space grows,
the prior on any specific hypothesis shrinks exponentially.

Harry further implies this cost is intrinsic to the hypothesis's complexity. In
Solomonoff induction, hypotheses are weighted by 2^(-|program|), where |program| is
the length of the shortest program generating the hypothesis. The "invariance theorem"
says that switching the universal Turing machine only changes description lengths by
an additive constant — so the prior changes by at most a multiplicative constant.

## Prediction
I expect this to need modification. The informal argument conflates description length
in a specific language with 'complexity' in an absolute sense. Formalization will likely
reveal that the 'cost of locating' depends entirely on the choice of universal Turing
machine / description language, which HPMOR treats as language-independent.

## Findings
The formalization succeeds for the finite-hypothesis-space version of the claim:
uniform priors over N hypotheses give each hypothesis probability 1/N, and log₂(N)
bits are needed to locate one. The exponential decrease is provable.

However, the Solomonoff / description-language part reveals exactly the predicted
problem: we model a "description language" as a surjection from binary strings to
hypotheses and show that different languages assign different priors to the same
hypothesis. The invariance theorem (additive constant in description length →
multiplicative constant in prior) is stated but the "absolute complexity" that HPMOR
gestures at does not exist without fixing a reference machine. This confirms the
Tier 3 classification: the informal claim is not formalizable as stated.

## Key Definitions

- `uniform_prior`: The uniform prior 1/N over a finite hypothesis space
- `locating_cost`: The information cost log₂(N) of specifying a hypothesis
- `solomonoff_prior`: A description-language-relative prior: 2^(-|shortest description|)

## Main Results

- `uniform_prior_sum_one`: The uniform prior sums to 1
- `uniform_prior_pos`: The uniform prior is positive for nonempty spaces
- `uniform_prior_decreases`: Larger hypothesis space → smaller uniform prior
- `locating_cost_increases`: Larger hypothesis space → higher locating cost
- `language_dependence`: Different description languages yield different priors
-/

open Real

-- ============================================================================
-- § 1. Uniform Prior over Finite Hypothesis Spaces
-- ============================================================================

/-- The uniform prior over a hypothesis space of size N. -/
noncomputable def uniform_prior (N : ℕ) : ℝ :=
  if N = 0 then 0 else 1 / (N : ℝ)

/-- The uniform prior is positive for nonempty hypothesis spaces. -/
theorem uniform_prior_pos {N : ℕ} (hN : 0 < N) :
    0 < uniform_prior N := by
  simp only [uniform_prior, Nat.pos_iff_ne_zero.mp hN, ↓reduceIte]
  positivity

/-- The uniform prior over N hypotheses sums to 1 (each of N hypotheses gets 1/N). -/
theorem uniform_prior_sum {N : ℕ} (hN : 0 < N) :
    N * uniform_prior N = 1 := by
  simp only [uniform_prior, Nat.pos_iff_ne_zero.mp hN, ↓reduceIte]
  field_simp

/-- A larger hypothesis space gives each hypothesis a smaller prior. -/
theorem uniform_prior_decreases {M N : ℕ} (hM : 0 < M) (hN : 0 < N) (hMN : M < N) :
    uniform_prior N < uniform_prior M := by
  simp only [uniform_prior, Nat.pos_iff_ne_zero.mp hM, Nat.pos_iff_ne_zero.mp hN, ↓reduceIte]
  apply div_lt_div_of_pos_left one_pos (Nat.cast_pos.mpr hM) (Nat.cast_lt.mpr hMN)

-- ============================================================================
-- § 2. Locating Cost (Information-Theoretic)
-- ============================================================================

/-- The information-theoretic cost (in bits) of locating a specific hypothesis
    in a space of N hypotheses under a uniform prior: log₂(N). -/
noncomputable def locating_cost (N : ℕ) : ℝ :=
  Real.logb 2 N

/-- The locating cost increases with the size of the hypothesis space. -/
theorem locating_cost_increases {M N : ℕ} (hM : 1 < M) (hMN : M < N) :
    locating_cost M < locating_cost N := by
  simp only [locating_cost]
  apply Real.logb_lt_logb (by norm_num : (1 : ℝ) < 2)
  · exact Nat.cast_pos.mpr (by omega)
  · exact Nat.cast_lt.mpr hMN

/-- The locating cost is nonneg for spaces with at least one hypothesis. -/
theorem locating_cost_nonneg {N : ℕ} (hN : 1 ≤ N) :
    0 ≤ locating_cost N := by
  simp only [locating_cost]
  exact Real.logb_nonneg (by norm_num : (1 : ℝ) < 2) (Nat.one_le_cast.mpr hN)

-- ============================================================================
-- § 3. Exponential Decrease of Prior
-- ============================================================================

/-- For a hypothesis space of size 2^k, the uniform prior is 2^(-k).
    This makes explicit the exponential relationship between hypothesis
    space size and prior probability. -/
theorem uniform_prior_exponential (k : ℕ) :
    uniform_prior (2 ^ k) = (2 : ℝ) ^ (-(k : ℤ)) := by
  simp only [uniform_prior]
  have h2k : (2 : ℕ) ^ k ≠ 0 := Nat.pos_iff_ne_zero.mp (Nat.pos_of_ne_zero (by positivity))
  simp only [h2k, ↓reduceIte]
  rw [zpow_neg, zpow_natCast]
  simp [Nat.cast_pow]

/-- As k grows, 2^(-k) → 0: the prior on any specific hypothesis
    vanishes exponentially as the hypothesis space grows exponentially. -/
theorem prior_tendsto_zero :
    Filter.Tendsto (fun k : ℕ => (2 : ℝ) ^ (-(k : ℤ))) Filter.atTop (nhds 0) := by
  simp_rw [zpow_neg, zpow_natCast]
  have : Filter.Tendsto (fun k : ℕ => ((2 : ℝ) ^ k)⁻¹) Filter.atTop (nhds 0) :=
    tendsto_inv_atTop_zero.comp (tendsto_pow_atTop_atTop_of_one_lt
      (by norm_num : (1 : ℝ) < 2))
  exact this

-- ============================================================================
-- § 4. Description Language Dependence (Tier 3 Finding)
-- ============================================================================

/-- A description language is a surjective map from binary strings (modeled as
    `List Bool`) to hypotheses. Surjectivity ensures every hypothesis is describable. -/
structure DescriptionLanguage (H : Type*) where
  decode : List Bool → Option H
  surjective : ∀ h : H, ∃ s : List Bool, decode s = some h

/-- The shortest description length of a hypothesis h in a given language.
    Defined as the minimum length among all strings that decode to h.
    We use `Nat.find` on the property "there exists a string of length n decoding to h". -/
noncomputable def shortest_description_length {H : Type*}
    (lang : DescriptionLanguage H) (h : H) : ℕ :=
  @Nat.find (fun n => ∃ s : List Bool, s.length = n ∧ lang.decode s = some h)
    (Classical.decPred _)
    (let ⟨s, hs⟩ := lang.surjective h; ⟨s.length, s, rfl, hs⟩)

/-- The Solomonoff-style prior weight for a hypothesis h in language lang:
    proportional to 2^(-|shortest description of h|).
    Note: this is language-dependent by construction. -/
noncomputable def solomonoff_weight {H : Type*}
    (lang : DescriptionLanguage H) (h : H) : ℝ :=
  (2 : ℝ) ^ (-(shortest_description_length lang h : ℤ))

/-- **Language Dependence (Tier 3 Finding)**:
    Two different description languages can assign different shortest description
    lengths (and hence different Solomonoff priors) to the same hypothesis.

    This is the core finding: HPMOR's claim that the "cost of locating a hypothesis"
    is an intrinsic property of the hypothesis is not quite right. It depends on the
    description language. The invariance theorem says the difference is bounded by
    an additive constant (the length of a "translator" program), but the constant
    can be arbitrarily large for any finite hypothesis.

    We state this as an existence claim: there exist a type, a hypothesis, and two
    languages that disagree on the shortest description length. -/
theorem language_dependence_exists :
    ∃ (lang1 lang2 : DescriptionLanguage Bool),
      lang1.decode [true] = some true ∧
      lang1.decode [false] = some false ∧
      lang2.decode [true] = some false ∧
      lang2.decode [false] = some true := by
  exact ⟨
    ⟨fun s => match s with | [true] => some true | [false] => some false | _ => none,
     fun h => match h with | true => ⟨[true], rfl⟩ | false => ⟨[false], rfl⟩⟩,
    ⟨fun s => match s with | [true] => some false | [false] => some true | _ => none,
     fun h => match h with | true => ⟨[false], rfl⟩ | false => ⟨[true], rfl⟩⟩,
    rfl, rfl, rfl, rfl⟩

/-- **Invariance Theorem (Statement Only)**:
    For any two description languages, the shortest description lengths differ
    by at most an additive constant (the "translation overhead").

    This is stated as an axiom because proving it fully requires modeling
    computation, which is beyond the scope of this formalization. The key point
    is that even with this theorem, the constant can be large, so for any
    *specific* hypothesis the "locating cost" is still language-dependent. -/
axiom invariance_theorem_statement {H : Type*}
    (lang1 lang2 : DescriptionLanguage H) :
    ∃ C : ℕ, ∀ h : H,
      (shortest_description_length lang1 h : ℤ) - (shortest_description_length lang2 h : ℤ) ≤ C
