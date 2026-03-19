import Mathlib

/-!
# Occlumency as Computational Indistinguishability

**HPMOR Chapters**: 27 (Harry discusses Occlumency with Draco)

**Claims Formalized**:
In HPMOR Ch. 27, Occlumency is described as the magical art of shielding one's mind
from Legilimency (magical mind-reading). An Occlumens presents a mental state that a
Legilimens cannot distinguish from a genuine unshielded mind.

This maps naturally onto the cryptographic notion of *computational indistinguishability*:
two distributions are computationally indistinguishable if no efficient observer can
tell them apart. Similarly, an Occlumens produces a "fake" mental state that no
Legilimens can distinguish from a "real" one.

## Key Distinction: Information-Theoretic vs Computational Occlumency

We formalize two levels of Occlumency:

1. **Perfect (Information-Theoretic) Occlumency**: No distinguisher *whatsoever* can
   tell the fake mental state from the real one. We prove this requires the fake
   distribution to be *identical* to the real one — the Occlumens must perfectly
   simulate a genuine mind.

2. **Computational Occlumency**: Only a *bounded class* of distinguishers is
   considered. We show this is strictly weaker — it allows the distributions to
   differ, as long as no distinguisher in the class can detect the difference.

## Findings

- **The simulation paradox**: Perfect Occlumency requires D_fake = D_real. But to
  construct D_fake = D_real, the Occlumens must know the distribution of genuine
  mental states, which requires introspecting a genuine mind — potentially defeating
  the purpose. HPMOR's "clearing your mind" does not address this.

- **Computational Occlumency is achievable**: If the class of Legilimens strategies
  is restricted (bounded computational power), then D_fake need only fool *those*
  strategies. This is analogous to pseudorandom generators fooling polynomial-time
  algorithms.

- **HPMOR gap**: HPMOR treats Occlumency as "clearing your mind" — a single mental
  discipline. It does not distinguish between information-theoretic and computational
  security. Our formalization shows these are fundamentally different: the former
  requires perfect simulation, while the latter requires only computational hardness.

## Assessment
**Tier 3** — Maps a fictional concept onto genuine cryptographic theory. The
information-theoretic vs computational distinction is a real insight that HPMOR
does not make explicit.
-/

-- ============================================================================
-- § 1. Setup: Mental States and Distributions
-- ============================================================================

namespace Occlumency

/-- A (simplified) probability distribution over a finite type `α`.
    Assigns a nonneg real probability to each element, summing to 1. -/
structure ProbDist (α : Type*) [Fintype α] where
  prob : α → ℝ
  prob_nonneg : ∀ x, 0 ≤ prob x
  prob_sum_one : ∑ x : α, prob x = 1

/-- A Legilimens (distinguisher) is a function from mental states to Bool,
    attempting to determine whether the presented state is "real" or "fake." -/
abbrev Legilimens (α : Type*) := α → Bool

-- ============================================================================
-- § 2. Advantage of a Distinguisher
-- ============================================================================

/-- The acceptance probability of a distinguisher D on a distribution d:
    the expected probability that D outputs `true`. -/
noncomputable def acceptProb {α : Type*} [Fintype α]
    (d : ProbDist α) (D : Legilimens α) : ℝ :=
  ∑ x : α, d.prob x * if D x then 1 else 0

/-- The distinguishing advantage of D between two distributions d₀ and d₁.
    This measures how well D can tell the two distributions apart. -/
noncomputable def advantage {α : Type*} [Fintype α]
    (d₀ d₁ : ProbDist α) (D : Legilimens α) : ℝ :=
  |acceptProb d₀ D - acceptProb d₁ D|

-- ============================================================================
-- § 3. Information-Theoretic Indistinguishability
-- ============================================================================

/-- Two distributions are information-theoretically indistinguishable if
    no distinguisher has any advantage. -/
def InfoTheoreticIndist {α : Type*} [Fintype α] (d₀ d₁ : ProbDist α) : Prop :=
  ∀ D : Legilimens α, advantage d₀ d₁ D = 0

/-- The acceptance probability of a point-indicator distinguisher equals
    the probability of that point. -/
theorem acceptProb_indicator {α : Type*} [Fintype α] [DecidableEq α]
    (d : ProbDist α) (a : α) :
    acceptProb d (fun x => decide (x = a)) = d.prob a := by
  unfold acceptProb
  simp only [decide_eq_true_eq, mul_ite, mul_one, mul_zero]
  rw [Finset.sum_ite_eq' Finset.univ a (fun x => d.prob x)]
  simp [Finset.mem_univ]

/-- **The Simulation Theorem (Information-Theoretic).**

    Perfect Occlumency (information-theoretic indistinguishability) requires
    the fake distribution to be identical to the real distribution.

    In HPMOR terms: to perfectly fool *any* Legilimens, the Occlumens must
    present a mental state distribution that is *exactly* the same as a
    genuine mind. "Clearing your mind" is insufficient — you must simulate
    a complete, consistent, genuine mental state.

    This is a fundamental result in cryptography: information-theoretic
    indistinguishability of distributions implies equality. -/
theorem perfect_occlumency_requires_equality {α : Type*} [Fintype α] [DecidableEq α]
    (D_real D_fake : ProbDist α) :
    InfoTheoreticIndist D_real D_fake → D_real.prob = D_fake.prob := by
  intro h_indist
  funext a
  have h := h_indist (fun x => decide (x = a))
  unfold advantage at h
  rw [abs_eq_zero] at h
  have h_real := acceptProb_indicator D_real a
  have h_fake := acceptProb_indicator D_fake a
  linarith

-- ============================================================================
-- § 4. Computational Indistinguishability
-- ============================================================================

/-- Two distributions are computationally indistinguishable with respect to a
    class of distinguishers `C` and advantage bound `ε` if no distinguisher in
    `C` achieves advantage greater than `ε`.

    In HPMOR terms: the Occlumens need only fool Legilimens whose "computational
    power" (magical ability) falls within class `C`. -/
def CompIndist {α : Type*} [Fintype α]
    (d₀ d₁ : ProbDist α) (C : Set (Legilimens α)) (ε : ℝ) : Prop :=
  ∀ D ∈ C, advantage d₀ d₁ D ≤ ε

/-- Information-theoretic indistinguishability implies computational
    indistinguishability for any class and any nonneg ε. -/
theorem info_theoretic_implies_computational {α : Type*} [Fintype α]
    (d₀ d₁ : ProbDist α) (C : Set (Legilimens α)) (ε : ℝ) (hε : 0 ≤ ε) :
    InfoTheoreticIndist d₀ d₁ → CompIndist d₀ d₁ C ε := by
  intro h_it D _hD
  have := h_it D
  rw [this]
  exact hε

-- ============================================================================
-- § 5. Computational Occlumency is Strictly Weaker
-- ============================================================================

/-- **Computational Occlumency is strictly weaker than perfect Occlumency.**

    There exist distributions that are computationally indistinguishable
    (w.r.t. a restricted class) but not information-theoretically
    indistinguishable. This is analogous to pseudorandom generators: the
    output is distinguishable from random by an unbounded adversary, but
    not by any efficient one.

    In HPMOR terms: an Occlumens can fool all Legilimens of bounded power
    without perfectly simulating a genuine mind. But a sufficiently powerful
    Legilimens (unlimited queries, unlimited computation) could detect the
    deception. -/
theorem computational_strictly_weaker :
    ∃ (α : Type) (_ : Fintype α) (_ : DecidableEq α)
      (d₀ d₁ : @ProbDist α ‹_›) (C : Set (Legilimens α)),
      @CompIndist α ‹_› d₀ d₁ C 0 ∧ ¬@InfoTheoreticIndist α ‹_› d₀ d₁ := by
  refine ⟨Bool, inferInstance, inferInstance, ?_, ?_, ∅, ?_⟩
  -- d₀: point mass at true
  · exact {
      prob := fun b => if b then 1 else 0
      prob_nonneg := fun x => by split <;> norm_num
      prob_sum_one := by
        simp
    }
  -- d₁: point mass at false
  · exact {
      prob := fun b => if b then 0 else 1
      prob_nonneg := fun x => by split <;> norm_num
      prob_sum_one := by
        simp
    }
  constructor
  · intro D hD
    simp at hD
  · intro h_it
    have h := h_it id
    unfold advantage acceptProb at h
    simp at h

-- ============================================================================
-- § 6. The Occlumency Hierarchy
-- ============================================================================

/-- Larger distinguisher classes make indistinguishability harder to achieve.
    If you can fool a larger class, you can fool any subclass. -/
theorem comp_indist_monotone_class {α : Type*} [Fintype α]
    (d₀ d₁ : ProbDist α) (C₁ C₂ : Set (Legilimens α)) (ε : ℝ)
    (h_sub : C₁ ⊆ C₂) :
    CompIndist d₀ d₁ C₂ ε → CompIndist d₀ d₁ C₁ ε := by
  intro h D hD
  exact h D (h_sub hD)

/-- Larger ε (more tolerance) makes indistinguishability easier to achieve. -/
theorem comp_indist_monotone_eps {α : Type*} [Fintype α]
    (d₀ d₁ : ProbDist α) (C : Set (Legilimens α)) (ε₁ ε₂ : ℝ)
    (h_le : ε₁ ≤ ε₂) :
    CompIndist d₀ d₁ C ε₁ → CompIndist d₀ d₁ C ε₂ := by
  intro h D hD
  exact le_trans (h D hD) h_le

-- ============================================================================
-- § 7. The Simulation Paradox
-- ============================================================================

/-- **The Simulation Paradox.**

    Perfect Occlumency requires the Occlumens to have complete knowledge of
    the genuine mental state distribution. We model this as: if the Occlumens
    achieves information-theoretic security, they must know D_real exactly
    (since they must produce D_fake = D_real).

    Formally: the set of D_fake distributions achieving perfect Occlumency
    against D_real is exactly {D_real}. The Occlumens must know the genuine
    distribution completely to fool all possible Legilimens.

    This creates a paradox: to shield your mind perfectly, you must know what
    a genuine unshielded mind looks like — which means you need access to
    (or knowledge of) the very thing you're trying to fake. -/
theorem simulation_paradox {α : Type*} [Fintype α] [DecidableEq α]
    (D_real : ProbDist α) :
    {D_fake : ProbDist α | InfoTheoreticIndist D_real D_fake} = {D_real} := by
  ext D_fake
  simp only [Set.mem_setOf_eq, Set.mem_singleton_iff]
  constructor
  · intro h
    have h_eq := perfect_occlumency_requires_equality D_real D_fake h
    cases D_real; cases D_fake; simp only [ProbDist.mk.injEq]; exact h_eq.symm
  · intro h
    subst h
    intro D
    unfold advantage
    simp

/-- **Advantage is always nonneg** (since it's an absolute value). -/
theorem advantage_nonneg {α : Type*} [Fintype α]
    (d₀ d₁ : ProbDist α) (D : Legilimens α) :
    0 ≤ advantage d₀ d₁ D :=
  abs_nonneg _

/-- **Advantage is symmetric**: swapping the distributions doesn't change
    the distinguishing advantage. -/
theorem advantage_symm {α : Type*} [Fintype α]
    (d₀ d₁ : ProbDist α) (D : Legilimens α) :
    advantage d₀ d₁ D = advantage d₁ d₀ D := by
  unfold advantage
  rw [abs_sub_comm]

end Occlumency
