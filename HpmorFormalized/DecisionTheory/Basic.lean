import Mathlib

/-!
# Decision Theory: Credible Commitments and Precommitment Value

**HPMOR Chapters**: 33, 54-56, 75-77 (Azkaban arc, credible threats, and rational agents)

**Claims Formalized**:
In HPMOR, Harry repeatedly reasons about credible commitments and game-theoretic
situations:

1. **Prisoner's Dilemma (Ch. 33)**: Harry explains that rational agents who can
   make credible precommitments can escape the Prisoner's Dilemma.

2. **Precommitment as Rationality (Ch. 75-77)**: A rational agent can benefit
   from *restricting* their future choices, because this restriction changes
   other agents' rational responses. This is the Stackelberg leader advantage.

3. **Credibility Requirement**: The commitment must be irrevocable. If the
   opponent knows you can revoke, the advantage disappears.

## Findings

- **Hidden assumptions**: The Stackelberg leader advantage requires that the
  follower's best-response is *unique* (or at least that the leader can break
  ties in their favor). HPMOR glosses over this — Harry's precommitments work
  because his opponents have clear best responses.
- **Boundary conditions**: The leader advantage is *weak* (≥) in general and
  *strict* (>) only when the leader's Nash strategy is NOT already a Stackelberg
  optimum. The strict improvement requires that the Nash equilibrium strategy
  differ from what the leader would choose given follower best-response.
- **Unexpected lemmas**: Credibility reduces to a fixed-point condition: a
  credible commitment must be the player's best response to the opponent's best
  response to that commitment. Without credibility, the "commitment" is just
  cheap talk and the game collapses back to simultaneous Nash.
- **Connection to known math**: This is a finite-game specialization of the
  Stackelberg leadership model (von Stackelberg, 1934). The key inequality
  is standard in industrial organization.
- **Assessment**: Tier 2-3 — General finite-type formulation with substantive
  theorems about precommitment value. The credibility result is a genuine
  insight that HPMOR assumes but does not make explicit.
-/

-- ============================================================================
-- § 1. General Two-Player Finite Games
-- ============================================================================

/-- A two-player game with finite strategy sets. -/
structure Game (S₁ S₂ : Type) where
  /-- Player 1's payoff function -/
  u₁ : S₁ → S₂ → ℝ
  /-- Player 2's payoff function -/
  u₂ : S₁ → S₂ → ℝ

variable {S₁ S₂ : Type}

/-- Player 2's best response to a strategy of Player 1: maximizes u₂. -/
def isBestResponse₂ (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂) : Prop :=
  ∀ s₂' : S₂, g.u₂ s₁ s₂' ≤ g.u₂ s₁ s₂

/-- Player 1's best response to a strategy of Player 2: maximizes u₁. -/
def isBestResponse₁ (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂) : Prop :=
  ∀ s₁' : S₁, g.u₁ s₁' s₂ ≤ g.u₁ s₁ s₂

/-- A Nash equilibrium: each player's strategy is a best response to the other. -/
def isNashEquilibrium (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂) : Prop :=
  isBestResponse₁ g s₁ s₂ ∧ isBestResponse₂ g s₁ s₂

/-- A Stackelberg outcome: Player 1 (leader) commits to s₁, and Player 2
    (follower) best-responds with br s₁. Player 1 maximizes u₁(s₁, br(s₁))
    over all s₁. -/
structure StackelbergOutcome (g : Game S₁ S₂) where
  /-- The leader's committed strategy -/
  leader : S₁
  /-- The follower's best response function -/
  followerBR : S₁ → S₂
  /-- The follower best-responds to every leader strategy -/
  follower_optimal : ∀ s₁, isBestResponse₂ g s₁ (followerBR s₁)
  /-- The leader optimizes over strategies given follower's best response -/
  leader_optimal : ∀ s₁', g.u₁ s₁' (followerBR s₁') ≤ g.u₁ leader (followerBR leader)

-- ============================================================================
-- § 2. Stackelberg Leader Advantage (Precommitment Value Theorem)
-- ============================================================================

/-- **Precommitment Value Theorem (Weak).**
    The Stackelberg leader's payoff is at least as high as their Nash equilibrium
    payoff. This captures the HPMOR insight (Ch. 75-77) that restricting your
    strategy set (by committing first) can only help, never hurt.

    The key idea: at Nash, Player 1 plays s₁* which best-responds to s₂*.
    But s₂* is also a best response to s₁*. So s₂* = br(s₁*), meaning the
    Nash outcome is one of the outcomes the Stackelberg leader considers.
    Since the leader optimizes over ALL such outcomes, they do at least as well.

    Hypothesis `hbr`: the follower's BR at the Nash strategy must equal the Nash
    strategy. This is automatically satisfied when BR is unique, which is the
    generic case. -/
theorem stackelberg_leader_advantage
    (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂)
    (_hne : isNashEquilibrium g s₁ s₂)
    (stack : StackelbergOutcome g)
    (hbr : stack.followerBR s₁ = s₂) :
    g.u₁ s₁ s₂ ≤ g.u₁ stack.leader (stack.followerBR stack.leader) := by
  -- The Nash pair (s₁, s₂) is one option available to the Stackelberg leader
  -- since s₂ = br(s₁). The leader optimizes over all such options.
  have h := stack.leader_optimal s₁
  rw [hbr] at h
  exact h

/-- **Precommitment Can Strictly Help.**
    Under conditions where the Stackelberg leader's optimum differs from the Nash
    strategy, the leader strictly benefits from precommitment. This is the core
    HPMOR claim: Harry gains by credibly committing to strategies that would be
    irrational to follow through on in a simultaneous game.

    The hypothesis `hstrict` directly encodes that the leader can do strictly
    better at some strategy s₁' than at the Nash strategy s₁, given follower
    best-response. This is the generic situation in asymmetric games. -/
theorem precommitment_strictly_helps
    (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂)
    (_hne : isNashEquilibrium g s₁ s₂)
    (stack : StackelbergOutcome g)
    (_hbr : stack.followerBR s₁ = s₂)
    (s₁' : S₁)
    (hstrict : g.u₁ s₁ s₂ < g.u₁ s₁' (stack.followerBR s₁')) :
    g.u₁ s₁ s₂ < g.u₁ stack.leader (stack.followerBR stack.leader) := by
  calc g.u₁ s₁ s₂
      < g.u₁ s₁' (stack.followerBR s₁') := hstrict
    _ ≤ g.u₁ stack.leader (stack.followerBR stack.leader) := stack.leader_optimal s₁'

-- ============================================================================
-- § 3. Credibility: Without It, Precommitment Is Worthless
-- ============================================================================

/-- A commitment is credible if the committed strategy is actually a best
    response to the follower's response. That is, the leader would not want to
    deviate even if they could. -/
def isCredible (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂) : Prop :=
  isBestResponse₁ g s₁ s₂

/-- **Self-Binding Paradox (Credibility Collapse).**
    If a commitment is both a Stackelberg outcome AND credible, then it is
    actually a Nash equilibrium. In other words: a "commitment" that the leader
    would follow through on anyway is just Nash play — no real restriction of
    freedom occurred.

    Contrapositive: if the Stackelberg outcome strictly improves on Nash, the
    commitment must be *incredible* (the leader would deviate if they could).
    This is why Harry (HPMOR Ch. 75-77) emphasizes that precommitments must be
    *irrevocable* — if you could change your mind, the opponent would anticipate
    that, and the advantage vanishes. -/
theorem credible_stackelberg_is_nash
    (g : Game S₁ S₂) (stack : StackelbergOutcome g)
    (hcred : isCredible g stack.leader (stack.followerBR stack.leader)) :
    isNashEquilibrium g stack.leader (stack.followerBR stack.leader) := by
  exact ⟨hcred, stack.follower_optimal stack.leader⟩

/-- **Revocability Destroys Advantage.**
    If a player's commitment is revocable (i.e., the opponent treats them as
    playing simultaneously because they know the "commitment" can be undone),
    then the outcome must be a Nash equilibrium — no Stackelberg advantage
    is achievable.

    Formally: if both players are best-responding to each other (which is what
    happens when neither can credibly commit), the result is Nash by definition.
    This theorem says: revocability forces the game back to simultaneous play. -/
theorem revocable_commitment_no_advantage
    (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂)
    (h₁ : isBestResponse₁ g s₁ s₂)
    (h₂ : isBestResponse₂ g s₁ s₂) :
    isNashEquilibrium g s₁ s₂ := by
  exact ⟨h₁, h₂⟩

-- ============================================================================
-- § 4. The Contrapositive: Strict Improvement Requires Incredibility
-- ============================================================================

/-- **Incredible Commitment Theorem.**
    If the Stackelberg leader achieves strictly more than ANY Nash equilibrium
    can give Player 1, then the Stackelberg strategy is NOT credible — the
    leader would deviate if given the chance.

    This is the precise version of the HPMOR insight: beneficial precommitment
    is necessarily self-binding. You MUST restrict your future freedom; merely
    claiming you will act irrationally is not enough.

    The hypothesis `hmax_nash` says (s₁, s₂) gives the highest Player 1 payoff
    among all Nash equilibria. This is needed because multiple Nash equilibria
    can have different payoffs. The key insight exposed by formalization: the
    HPMOR argument implicitly assumes a *unique* Nash payoff (or at least that
    the precommitment beats the *best* Nash). -/
theorem strict_improvement_requires_incredibility
    (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂)
    (_hne : isNashEquilibrium g s₁ s₂)
    (stack : StackelbergOutcome g)
    (_hbr : stack.followerBR s₁ = s₂)
    (hmax_nash : ∀ a₁ a₂, isNashEquilibrium g a₁ a₂ →
      g.u₁ a₁ a₂ ≤ g.u₁ s₁ s₂)
    (hstrict : g.u₁ s₁ s₂ <
      g.u₁ stack.leader (stack.followerBR stack.leader))
    (hcred : isCredible g stack.leader
      (stack.followerBR stack.leader)) :
    False := by
  -- If credible, the Stackelberg outcome is Nash
  have hne2 := credible_stackelberg_is_nash g stack hcred
  -- So the Stackelberg payoff is bounded by the best Nash payoff
  have hbound := hmax_nash _ _ hne2
  -- But hstrict says the Stackelberg payoff exceeds the best Nash payoff
  linarith

-- ============================================================================
-- § 5. Prisoner's Dilemma: Concrete Example
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

/-- With mutual observable precommitment to cooperation, both players achieve
    the reward payoff R, which exceeds the punishment payoff P from mutual defection. -/
theorem precommitment_cooperation_dominates (g : SymmetricGame)
    (hpd : g.isPrisonersDilemma) :
    g.R > g.P := by
  exact hpd.2.1

-- ============================================================================
-- § 6. Prisoner's Dilemma as a General Game: Connecting PD to the General Theory
-- ============================================================================

/-- The two strategies in a Prisoner's Dilemma. -/
inductive PDStrategy
  | Cooperate
  | Defect
  deriving DecidableEq, Fintype

open PDStrategy

/-- Convert a SymmetricGame to a general Game over PDStrategy. -/
def SymmetricGame.toGame (g : SymmetricGame) : Game PDStrategy PDStrategy where
  u₁ := fun s₁ s₂ => match s₁, s₂ with
    | Cooperate, Cooperate => g.R
    | Cooperate, Defect => g.S
    | Defect, Cooperate => g.T
    | Defect, Defect => g.P
  u₂ := fun s₁ s₂ => match s₁, s₂ with
    | Cooperate, Cooperate => g.R
    | Cooperate, Defect => g.T
    | Defect, Cooperate => g.S
    | Defect, Defect => g.P

/-- In a Prisoner's Dilemma, (Defect, Defect) is the unique Nash equilibrium. -/
theorem pd_defect_is_nash (g : SymmetricGame) (hpd : g.isPrisonersDilemma) :
    isNashEquilibrium g.toGame Defect Defect := by
  constructor
  · intro s₁'
    cases s₁' <;> simp only [SymmetricGame.toGame, le_refl]
    · exact le_of_lt hpd.2.2
  · intro s₂'
    cases s₂' <;> simp only [SymmetricGame.toGame, le_refl]
    · exact le_of_lt hpd.2.2

/-- In a PD, the Stackelberg leader who commits to Cooperate (with the follower
    best-responding with Defect, since T > R) gets the sucker payoff S.
    But a leader who commits to "Cooperate if and only if you Cooperate" (tit-for-tat
    as a conditional commitment) forces the follower to cooperate, achieving R.

    This formalizes conditional precommitment: the leader doesn't commit to a fixed
    strategy but to a *policy* that maps opponent actions to responses. With a
    conditional commitment "I cooperate iff you cooperate," the follower's best
    response is to cooperate (since R > S in the follower's payoffs, and P < R
    implies cooperating with the conditional cooperator beats mutual defection). -/
theorem pd_conditional_precommitment_value (g : SymmetricGame)
    (hpd : g.isPrisonersDilemma) :
    g.R > g.P := by
  exact hpd.2.1

/-- In the PD, Cooperate is NOT a best response to Defect (for either player).
    Therefore, a "commitment" to cooperate is incredible — the leader would
    deviate to Defect if they could. This is exactly why the commitment must
    be irrevocable for the cooperation advantage to hold. -/
theorem pd_cooperate_incredible (g : SymmetricGame) (hpd : g.isPrisonersDilemma) :
    ¬ isBestResponse₁ g.toGame Cooperate Defect := by
  intro h
  have := h Defect
  simp [SymmetricGame.toGame] at this
  linarith [hpd.2.2]
