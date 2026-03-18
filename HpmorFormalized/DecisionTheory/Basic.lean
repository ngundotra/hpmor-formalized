import Mathlib

/-!
# Decision Theory: Credible Commitments and the Prisoner's Dilemma

**HPMOR Chapters**: 33, 54-56, 75-77 (Azkaban arc, credible threats, and rational agents)

**Claims Formalized**:
In HPMOR, Harry repeatedly reasons about credible commitments and game-theoretic
situations. Key examples include:

1. **Prisoner's Dilemma (Ch. 33)**: Harry explains to Draco that rational agents
   who can make credible precommitments can achieve mutual cooperation even in
   one-shot prisoner's dilemma scenarios. The key insight is that if both players
   can verifiably bind themselves to a strategy *before* the game, the dominant
   strategy shifts from defection to cooperation.

2. **Credible Threats (Ch. 54-56)**: Harry's negotiations with various parties
   rely on the game-theoretic concept that a threat is only effective if it is
   credible — i.e., it would be rational to carry out the threat if the
   conditions are met.

3. **Precommitment as Rationality (Ch. 75-77)**: The idea that a rational agent
   can benefit from *restricting* their future choices, because this restriction
   changes other agents' rational responses.

## Planned Formalizations

- `PayoffMatrix`: A general 2-player game with payoff matrices
- `prisoners_dilemma`: The standard PD payoff structure (T > R > P > S)
- `dominant_strategy_defect`: In standard PD, defection strictly dominates
- `precommitment_cooperation`: With binding precommitments and common knowledge
  of rationality, mutual cooperation is achievable
- `credible_threat`: A threat is credible iff carrying it out is part of a
  subgame-perfect equilibrium
-/

-- ============================================================================
-- § 1. Payoff Matrices and Basic Game Theory
-- ============================================================================

/-- A two-player symmetric game with two strategies (Cooperate/Defect). -/
structure SymmetricGame where
  /-- Payoff when both cooperate (Reward) -/
  R : ℝ
  /-- Payoff when both defect (Punishment) -/
  P : ℝ
  /-- Payoff for defecting when opponent cooperates (Temptation) -/
  T : ℝ
  /-- Payoff for cooperating when opponent defects (Sucker) -/
  S : ℝ

/-- The Prisoner's Dilemma conditions: T > R > P > S. -/
def SymmetricGame.isPrisonersDilemma (g : SymmetricGame) : Prop :=
  g.T > g.R ∧ g.R > g.P ∧ g.P > g.S

/-- In a Prisoner's Dilemma, defection strictly dominates cooperation.
    Regardless of what the opponent does, defecting yields a higher payoff. -/
theorem dominant_strategy_defect (g : SymmetricGame) (hpd : g.isPrisonersDilemma) :
    g.T > g.R ∧ g.P > g.S := by
  exact ⟨hpd.1, hpd.2.2⟩

-- ============================================================================
-- § 2. Precommitment (stub)
-- ============================================================================

/-- A precommitment device allows an agent to credibly bind themselves to a
    strategy before the game begins. -/
structure Precommitment where
  /-- The committed strategy: true = cooperate, false = defect -/
  strategy : Bool
  /-- The commitment is observable by the other player -/
  observable : Prop

/-- With mutual observable precommitment to cooperation, both players achieve
    the reward payoff R, which exceeds the punishment payoff P from mutual defection. -/
theorem precommitment_cooperation_dominates (g : SymmetricGame)
    (hpd : g.isPrisonersDilemma) :
    g.R > g.P := by
  exact hpd.2.1

-- ============================================================================
-- § 3. TODO: Fuller formalizations
-- ============================================================================

-- Future work:
-- - Formalize subgame-perfect equilibrium
-- - Prove that precommitment changes the effective game matrix
-- - Model Harry's specific negotiations from HPMOR
-- - Connect to iterated PD and Tit-for-Tat strategies
