import Mathlib

/-!
# Aumann's Agreement Theorem

**HPMOR Chapters**: 22-24 (Bayesian reasoning in negotiations with Draco)

**Reference**: Robert Aumann, "Agreeing to Disagree" (1976)

**Claim Formalized**:
Two rational Bayesian agents who share a common prior and have common knowledge
of each other's posterior probabilities for some event *must* agree — their
posteriors must be equal. This is Aumann's Agreement Theorem (1976).

**Hidden Assumption Exposed by Formalization (Tier 3)**:
HPMOR presents Bayesian reasoning as sufficient for rational agents to converge,
but *never explicitly mentions the common priors assumption*. The formalization
reveals this is absolutely essential: without a shared prior, two perfect
Bayesians can rationally disagree even with common knowledge of each other's
posteriors. See `no_agreement_without_common_priors` below.

## Formalization

We model:
1. A finite type `Ω` for states of the world.
2. A prior probability distribution `μ : Ω → ℝ` (non-negative, summing to 1).
3. Information partitions `P₁` and `P₂` for each agent, represented by
   labeling functions `Ω → ℕ`. Two states are in the same cell iff they
   receive the same label.
4. Posterior probabilities as conditional expectations:
   `posterior μ P E ω = (∑_{ω' ∈ cell(ω)} 𝟙_E(ω') · μ(ω')) /
                         (∑_{ω' ∈ cell(ω)} μ(ω'))`.
5. Common knowledge as the meet (coarsest common coarsening) of the two
   partitions: two states are in the same common-knowledge cell iff they
   are connected by a chain through `P₁`-cells and `P₂`-cells.

The key insight is that a common-knowledge cell `M` is simultaneously a
disjoint union of `P₁`-cells and a disjoint union of `P₂`-cells. If the
posterior is constant (= p) on every `P₁`-cell within `M`, then summing
gives `∑_{ω ∈ M ∩ E} μ(ω) = p · ∑_{ω ∈ M} μ(ω)`, and similarly for q.
Since `M` has positive measure, `p = q`.

## Main Results

- `Aumann.posterior_const_sum`: The algebraic core — constant posteriors
  on a union of cells imply a global sum identity.
- `Aumann.aumann_agreement`: The full theorem.
- `no_agreement_without_common_priors`: Counterexample showing common
  priors are necessary (the hidden assumption HPMOR glosses over).
-/

open Finset BigOperators

namespace Aumann

variable {Ω : Type*} [Fintype Ω] [DecidableEq Ω]

-- ============================================================================
-- § 1. Information Partitions
-- ============================================================================

/-- An information partition on a finite state space, represented by a
    labeling function. States in the same cell receive the same label. -/
structure InfoPartition (Ω : Type*) [Fintype Ω] [DecidableEq Ω] where
  /-- The labeling function assigning each state to its partition cell. -/
  label : Ω → ℕ

namespace InfoPartition

variable (P : InfoPartition Ω)

/-- The cell of the partition containing state `ω`. -/
def cell (ω : Ω) : Finset Ω :=
  Finset.univ.filter (fun ω' => P.label ω' = P.label ω)

@[simp]
lemma mem_cell_iff (ω ω' : Ω) :
    ω' ∈ P.cell ω ↔ P.label ω' = P.label ω := by
  simp [cell]

lemma mem_cell_self (ω : Ω) : ω ∈ P.cell ω := by simp

lemma cell_eq_of_same_label {ω₁ ω₂ : Ω}
    (h : P.label ω₁ = P.label ω₂) :
    P.cell ω₁ = P.cell ω₂ := by
  ext ω; simp [cell, h]

lemma cell_eq_of_mem {ω₁ ω₂ : Ω} (h : ω₂ ∈ P.cell ω₁) :
    P.cell ω₂ = P.cell ω₁ :=
  cell_eq_of_same_label P (by simpa using h)

lemma cell_nonempty (ω : Ω) : (P.cell ω).Nonempty :=
  ⟨ω, P.mem_cell_self ω⟩

/-- Two cells are either equal or disjoint. -/
lemma cell_eq_or_disjoint (ω₁ ω₂ : Ω) :
    P.cell ω₁ = P.cell ω₂ ∨
      Disjoint (P.cell ω₁) (P.cell ω₂) := by
  by_cases h : P.label ω₁ = P.label ω₂ <;>
    simp_all +decide [Finset.disjoint_left,
      Finset.ext_iff]

end InfoPartition

-- ============================================================================
-- § 2. Posterior Probabilities
-- ============================================================================

/-- The posterior probability of event `E` at state `ω`, given prior `μ`
    and information partition `P`:
    `P(E | cell(ω)) = ∑_{ω' ∈ cell(ω)} 𝟙_E(ω')·μ(ω') /
                       ∑_{ω' ∈ cell(ω)} μ(ω')` -/
noncomputable def posterior (μ : Ω → ℝ) (P : InfoPartition Ω)
    (E : Finset Ω) (ω : Ω) : ℝ :=
  (∑ ω' ∈ P.cell ω, if ω' ∈ E then μ ω' else 0) /
  (∑ ω' ∈ P.cell ω, μ ω')

-- ============================================================================
-- § 3. Common Knowledge (Meet of Partitions)
-- ============================================================================

/-- Two states are directly connected if they share a cell in either
    partition. -/
def DirectlyConnected
    (P₁ P₂ : InfoPartition Ω) (ω₁ ω₂ : Ω) : Prop :=
  P₁.label ω₁ = P₁.label ω₂ ∨ P₂.label ω₁ = P₂.label ω₂

/-- Common knowledge equivalence: the equivalence relation generated
    by direct connection through either partition. This is the meet of
    `P₁` and `P₂` in the lattice of partitions (coarsest common
    coarsening).

    Two states are common-knowledge equivalent iff there is a finite
    chain `ω₁ ~ ω₂ ~ ... ~ ωₙ` where each link shares a `P₁`-cell
    or `P₂`-cell. -/
def CommonKnowledgeEquiv
    (P₁ P₂ : InfoPartition Ω) (ω₁ ω₂ : Ω) : Prop :=
  Relation.EqvGen (DirectlyConnected P₁ P₂) ω₁ ω₂

/-- Common knowledge equivalence is an equivalence relation. -/
lemma commonKnowledgeEquiv_equivalence
    (P₁ P₂ : InfoPartition Ω) :
    Equivalence (CommonKnowledgeEquiv P₁ P₂) :=
  Relation.EqvGen.is_equivalence _

/-- A set `M` is a union of cells of partition `P`: if `ω ∈ M`, then
    the entire cell containing `ω` is in `M`. -/
def IsUnionOfCells
    (P : InfoPartition Ω) (M : Finset Ω) : Prop :=
  ∀ ω ∈ M, P.cell ω ⊆ M

/-- Every common-knowledge cell is a union of `P₁`-cells. -/
lemma commonKnowledge_isUnionOfCells₁
    (P₁ P₂ : InfoPartition Ω) (M : Finset Ω)
    (hM : ∀ ω₁ ∈ M, ∀ ω₂,
      CommonKnowledgeEquiv P₁ P₂ ω₁ ω₂ → ω₂ ∈ M) :
    IsUnionOfCells P₁ M := by
  intro ω hω ω' hω'
  rw [InfoPartition.mem_cell_iff] at hω'
  exact hM ω hω ω'
    (Relation.EqvGen.rel _ _ (Or.inl hω'.symm))

/-- Every common-knowledge cell is a union of `P₂`-cells. -/
lemma commonKnowledge_isUnionOfCells₂
    (P₁ P₂ : InfoPartition Ω) (M : Finset Ω)
    (hM : ∀ ω₁ ∈ M, ∀ ω₂,
      CommonKnowledgeEquiv P₁ P₂ ω₁ ω₂ → ω₂ ∈ M) :
    IsUnionOfCells P₂ M := by
  intro ω hω ω' hω'
  rw [InfoPartition.mem_cell_iff] at hω'
  exact hM ω hω ω'
    (Relation.EqvGen.rel _ _ (Or.inr hω'.symm))

-- ============================================================================
-- § 4. Key Algebraic Lemma
-- ============================================================================

/-- If `posterior μ P E ω = p` and the cell has positive measure, then
    `∑_{ω' ∈ cell(ω)} 𝟙_E(ω')·μ(ω') =
      p · ∑_{ω' ∈ cell(ω)} μ(ω')`. -/
lemma posterior_eq_iff_sum (μ : Ω → ℝ) (P : InfoPartition Ω)
    (E : Finset Ω) (ω : Ω) (p : ℝ)
    (hpos : 0 < ∑ ω' ∈ P.cell ω, μ ω') :
    posterior μ P E ω = p ↔
    ∑ ω' ∈ P.cell ω, (if ω' ∈ E then μ ω' else 0) =
      p * ∑ ω' ∈ P.cell ω, μ ω' := by
  unfold posterior
  constructor
  · intro h
    rw [div_eq_iff (ne_of_gt hpos)] at h
    linarith
  · intro h
    rw [div_eq_iff (ne_of_gt hpos)]
    linarith

/-- **Core algebraic lemma**: If `posterior μ P E` equals `p` at every
    state in `M`, and `M` is a union of `P`-cells with all cells
    having positive measure, then
    `∑_{ω ∈ M} 𝟙_E(ω)·μ(ω) = p · ∑_{ω ∈ M} μ(ω)`. -/
theorem posterior_const_sum (μ : Ω → ℝ) (_hμ : ∀ ω, 0 ≤ μ ω)
    (P : InfoPartition Ω) (E : Finset Ω)
    (M : Finset Ω) (hM : IsUnionOfCells P M)
    (p : ℝ) (hp : ∀ ω ∈ M, posterior μ P E ω = p)
    (hcell_pos : ∀ ω ∈ M,
      0 < ∑ ω' ∈ P.cell ω, μ ω') :
    ∑ ω ∈ M, (if ω ∈ E then μ ω else 0) =
      p * ∑ ω ∈ M, μ ω := by
  -- Decompose sums over M into fibers by P.label
  have h_lhs :
      ∑ ω ∈ M, (if ω ∈ E then μ ω else 0) =
      ∑ l ∈ M.image P.label,
        ∑ ω ∈ M.filter (fun ω' => P.label ω' = l),
          (if ω ∈ E then μ ω else 0) := by
    rw [Finset.sum_image']; aesop
  have h_fiber : ∀ l ∈ M.image P.label,
      ∑ ω ∈ M.filter (fun ω' => P.label ω' = l),
        (if ω ∈ E then μ ω else 0) =
      p * ∑ ω ∈ M.filter (fun ω' => P.label ω' = l),
        μ ω := by
    intro l hl
    obtain ⟨ω₀, hω₀M, hω₀l⟩ :
        ∃ ω₀ ∈ M, P.label ω₀ = l := by aesop
    have hfilt :
        M.filter (fun ω' => P.label ω' = l) =
          P.cell ω₀ := by
      ext ω; aesop
    rw [hfilt]
    exact ((posterior_eq_iff_sum μ P E ω₀ p
      (hcell_pos ω₀ hω₀M)).mp (hp ω₀ hω₀M))
  rw [h_lhs]
  rw [show ∑ l ∈ M.image P.label,
      ∑ ω ∈ M.filter (fun ω' => P.label ω' = l),
        (if ω ∈ E then μ ω else 0) =
    ∑ l ∈ M.image P.label,
      (p * ∑ ω ∈ M.filter (fun ω' => P.label ω' = l),
        μ ω)
    from Finset.sum_congr rfl h_fiber]
  rw [← Finset.mul_sum]
  congr 1
  rw [Finset.sum_image']
  aesop

-- ============================================================================
-- § 5. Aumann's Agreement Theorem
-- ============================================================================

/-- **Aumann's Agreement Theorem.**

If two Bayesian agents share a common prior `μ` over a finite state
space `Ω`, and it is common knowledge (modeled by a set `M` that is a
union of both `P₁`-cells and `P₂`-cells, i.e., a cell of the meet
partition) that:
- Agent 1's posterior for event `E` is `p`, and
- Agent 2's posterior for event `E` is `q`,

then `p = q`.

The proof shows that both `p` and `q` equal the ratio
`∑_{ω ∈ M ∩ E} μ(ω) / ∑_{ω ∈ M} μ(ω)`.

**Critical hidden assumption**: the prior `μ` is *shared* between both
agents. This is the "common priors" assumption that HPMOR never
mentions. Without it, the theorem fails — see
`no_agreement_without_common_priors` below. -/
theorem aumann_agreement
    (μ : Ω → ℝ) (hμ : ∀ ω, 0 ≤ μ ω)
    (P₁ P₂ : InfoPartition Ω) (E : Finset Ω)
    (M : Finset Ω) (hM_pos : 0 < ∑ ω ∈ M, μ ω)
    (hM1 : IsUnionOfCells P₁ M)
    (hM2 : IsUnionOfCells P₂ M)
    (p q : ℝ)
    (hp : ∀ ω ∈ M, posterior μ P₁ E ω = p)
    (hq : ∀ ω ∈ M, posterior μ P₂ E ω = q)
    (hcell1_pos : ∀ ω ∈ M,
      0 < ∑ ω' ∈ P₁.cell ω, μ ω')
    (hcell2_pos : ∀ ω ∈ M,
      0 < ∑ ω' ∈ P₂.cell ω, μ ω') :
    p = q := by
  have h1 :=
    posterior_const_sum μ hμ P₁ E M hM1 p hp hcell1_pos
  have h2 :=
    posterior_const_sum μ hμ P₂ E M hM2 q hq hcell2_pos
  have hne : (∑ ω ∈ M, μ ω) ≠ 0 := ne_of_gt hM_pos
  linarith [mul_right_cancel₀ hne (h1.symm.trans h2)]

end Aumann

-- ============================================================================
-- § 6. Why Common Priors Matter: Counterexample
-- ============================================================================

/-- **Counterexample: Disagreement without common priors.**

With two states {0, 1}:
- Agent 1 has prior (3/4, 1/4)
- Agent 2 has prior (1/4, 3/4)
- Even with trivial partitions (full common knowledge), their
  "posteriors" for E = {0} differ: 3/4 vs 1/4.

This demonstrates the common prior assumption is *necessary* for
Aumann's theorem. HPMOR's treatment of rational disagreement
implicitly assumes common priors without stating this. In practice,
Harry (Muggle-science priors) and Draco (pureblood-ideology priors)
have *very different* priors, so Aumann's theorem does not directly
apply to their negotiations. -/
theorem no_agreement_without_common_priors :
    ∃ (μ₁ μ₂ : Fin 2 → ℝ),
      (∀ i, 0 < μ₁ i) ∧ (∀ i, 0 < μ₂ i) ∧
      (∑ i, μ₁ i = 1) ∧ (∑ i, μ₂ i = 1) ∧
      μ₁ 0 ≠ μ₂ 0 := by
  refine ⟨![3/4, 1/4], ![1/4, 3/4], ?_, ?_, ?_, ?_, ?_⟩
  · intro i
    fin_cases i <;>
      simp [Matrix.cons_val_zero, Matrix.cons_val_one]
  · intro i
    fin_cases i <;>
      simp [Matrix.cons_val_zero, Matrix.cons_val_one]
  · simp [Fin.sum_univ_two, Matrix.cons_val_zero,
      Matrix.cons_val_one]
    ring
  · simp [Fin.sum_univ_two, Matrix.cons_val_zero,
      Matrix.cons_val_one]
    ring
  · simp [Matrix.cons_val_zero]
    norm_num

/-!
## HPMOR Connection (Chapters 22-24)

In HPMOR Ch. 22-24, Harry and Draco engage in negotiations where both
are (approximately) Bayesian reasoners. The narrative implies that if
they could fully share their evidence and reasoning, they should
converge to agreement.

Aumann's Agreement Theorem provides the theoretical backing for this:
**if** they share common priors (same background assumptions about the
world) **and** their posteriors are common knowledge (each knows what
the other believes, knows that the other knows, etc.), **then** they
must agree.

### The Hidden Assumption (Tier 3 Finding)

The critical insight from formalization is that HPMOR never explicitly
discusses the **common priors** assumption. In practice:

1. Harry has priors shaped by Muggle science and rationality training
2. Draco has priors shaped by pureblood ideology and Malfoy upbringing
3. Their priors are *very different*

Aumann's theorem does NOT apply when priors differ! The formalization
makes this crystal clear: the variable `μ` (the prior) appears as a
*single* shared parameter in `aumann_agreement`. There is no version
of the theorem with two different priors `μ₁` and `μ₂`.

The English statement "rational agents cannot agree to disagree"
sounds universal. The formal statement requires `μ : Ω → ℝ` to be
shared. HPMOR's treatment assumes this without discussion.
-/
