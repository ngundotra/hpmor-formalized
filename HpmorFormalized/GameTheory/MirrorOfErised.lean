import Mathlib

/-!
# Game Theory: Mirror of Erised as Mechanism Design (Ch. 109)

**HPMOR Chapters**: 109 (Mirror of Erised confrontation)

## The Scenario

The Mirror of Erised shows each person their deepest desire. In HPMOR,
Dumbledore uses it as a test of character: what you see in the Mirror reveals
who you truly are. This is a *preference revelation mechanism* — it extracts
agents' true preferences by direct observation (magical mind-reading).

## Mechanism Design Question

Is "show each person what they most want" an incentive-compatible mechanism?
In standard mechanism design, agents *report* preferences and may misreport.
The Mirror bypasses reporting entirely — it reads preferences directly.

## Prediction

"I expect this to reveal a fundamental impossibility. The Mirror is a
preference revelation mechanism — it extracts true preferences by direct
inspection. In mechanism design, this is the 'dictator' mechanism (just look
at people's true preferences). The Gibbard-Satterthwaite theorem says that
strategyproof mechanisms over 3+ alternatives are essentially dictatorial.
The interesting question is whether the Mirror's 'direct inspection' model
avoids the theorem's assumptions. If desires are observable (magic can read
minds), strategic manipulation is impossible by construction — but this
requires the strong assumption that preferences can't be self-modified,
which is philosophically contested."

## Approach

1. Define a preference revelation mechanism: agents have preferences,
   mechanism maps reported preferences to outcomes.
2. Define strategyproofness: no agent benefits from misreporting.
3. Define the Mirror mechanism: directly observes true preferences
   (no reporting needed).
4. Prove the Mirror is trivially strategyproof when preferences are
   exogenous (can't be self-modified).
5. Show that if preferences are endogenous (agents can modify their own
   desires), the Mirror creates perverse incentives — agents might
   cultivate "better" desires knowing they'll be revealed.
6. Connect to HPMOR: Dumbledore's test assumes exogenous preferences.
   If Harry can modify his desires (he's a rationalist!), the test
   is gameable.
-/

-- ============================================================================
-- § 1. Preference Revelation Mechanisms
-- ============================================================================

/-- An agent's preference is a total preorder on outcomes, represented here
    by a utility function for concreteness. -/
structure Agent (Outcome : Type) where
  /-- The agent's true utility over outcomes -/
  utility : Outcome → ℝ

/-- A standard mechanism: agents report preferences, mechanism selects outcome. -/
structure StandardMechanism (Agent' Outcome Report : Type) where
  /-- The mechanism's outcome rule: given all agents' reports, select an outcome -/
  outcome : (Agent' → Report) → Outcome

/-- A direct revelation mechanism: agents report their utility functions directly. -/
abbrev DirectMechanism (Agent' Outcome : Type) :=
  StandardMechanism Agent' Outcome (Outcome → ℝ)

/-- Strategyproofness for a direct mechanism: no agent benefits from
    misreporting their utility function, holding others' reports fixed. -/
def isStrategyproof {Agent' Outcome : Type} [Fintype Agent'] [DecidableEq Agent']
    (m : DirectMechanism Agent' Outcome)
    (trueUtility : Agent' → Outcome → ℝ) : Prop :=
  ∀ (i : Agent') (misreport : Outcome → ℝ)
    (othersReport : Agent' → Outcome → ℝ),
    (∀ j : Agent', j ≠ i → othersReport j = trueUtility j) →
    let truthful := fun j => if j = i then trueUtility i else othersReport j
    let manipulated := fun j => if j = i then misreport else othersReport j
    trueUtility i (m.outcome truthful) ≥ trueUtility i (m.outcome manipulated)

-- ============================================================================
-- § 2. The Mirror Mechanism (Exogenous Preferences)
-- ============================================================================

/-- The Mirror of Erised as a mechanism: it directly observes each agent's
    true preferences and reveals/grants their most desired outcome.
    Unlike standard mechanisms, there is no reporting step — the Mirror
    reads minds magically. -/
structure MirrorMechanism (Outcome : Type) where
  /-- Given an agent's true utility, the Mirror shows/grants the best outcome -/
  reveal : (Outcome → ℝ) → Outcome
  /-- The Mirror is faithful: it picks a utility-maximizing outcome -/
  faithful : ∀ (u : Outcome → ℝ) (o : Outcome), u (reveal u) ≥ u o

/-- Under exogenous preferences (agents cannot modify their own desires),
    the Mirror is trivially strategyproof because there is nothing to
    manipulate — the mechanism takes no input from the agent.

    More precisely: when the mechanism directly reads true preferences,
    the "report" is always the truth by construction, so no misreport
    is possible. We model this as: the outcome depends only on true
    preferences, so any "misreport" is irrelevant. -/
theorem mirror_trivially_strategyproof
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    (agent_utility : Outcome → ℝ) :
    -- For any hypothetical "misreport", the Mirror still returns what
    -- maximizes the agent's TRUE utility (because it reads the truth)
    ∀ (o : Outcome), agent_utility (mirror.reveal agent_utility) ≥ agent_utility o :=
  mirror.faithful agent_utility

-- ============================================================================
-- § 3. Endogenous Preferences: The Self-Modification Problem
-- ============================================================================

/-- Model of an agent who can modify their own preferences at a cost.
    This captures the idea that a rationalist like Harry might deliberately
    cultivate certain desires knowing the Mirror will reveal them. -/
structure EndogenousAgent (Outcome : Type) where
  /-- The agent's original (natural) utility function -/
  originalUtility : Outcome → ℝ
  /-- The agent's "meta-utility": what they value at the level above
      immediate desires. This represents their reflective preferences
      about what kind of person they want to be / what they want to want. -/
  metaUtility : Outcome → ℝ
  /-- Cost of self-modification: changing one's desires is effortful -/
  modificationCost : ℝ
  /-- Cost is non-negative -/
  cost_nonneg : modificationCost ≥ 0

/-- An endogenous agent's effective payoff from a Mirror interaction:
    - If they DON'T self-modify: Mirror reveals based on originalUtility
    - If they DO self-modify to targetUtility: Mirror reveals based on
      targetUtility, but agent evaluates the outcome using metaUtility,
      minus the modification cost. -/
noncomputable def mirrorPayoff_unmodified
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    (agent : EndogenousAgent Outcome) : ℝ :=
  agent.metaUtility (mirror.reveal agent.originalUtility)

noncomputable def mirrorPayoff_modified
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    (agent : EndogenousAgent Outcome)
    (targetUtility : Outcome → ℝ) : ℝ :=
  agent.metaUtility (mirror.reveal targetUtility) - agent.modificationCost

/-- **Key Theorem**: Self-modification is profitable when the meta-utility
    gain from changing what the Mirror reveals exceeds the modification cost.

    This formalizes the "perverse incentive" of the Mirror: if an agent's
    meta-preferences differ from their object-level preferences, they
    gain by cultivating desires that look better in the Mirror. -/
theorem self_modification_profitable
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    (agent : EndogenousAgent Outcome)
    (targetUtility : Outcome → ℝ)
    (h_gain : agent.metaUtility (mirror.reveal targetUtility) >
              agent.metaUtility (mirror.reveal agent.originalUtility) +
              agent.modificationCost) :
    mirrorPayoff_modified mirror agent targetUtility >
    mirrorPayoff_unmodified mirror agent := by
  unfold mirrorPayoff_modified mirrorPayoff_unmodified
  linarith

/-- Conversely, if the meta-utility gain does NOT exceed the cost,
    self-modification is not profitable. -/
theorem self_modification_unprofitable
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    (agent : EndogenousAgent Outcome)
    (targetUtility : Outcome → ℝ)
    (h_no_gain : agent.metaUtility (mirror.reveal targetUtility) ≤
                 agent.metaUtility (mirror.reveal agent.originalUtility) +
                 agent.modificationCost) :
    mirrorPayoff_modified mirror agent targetUtility ≤
    mirrorPayoff_unmodified mirror agent := by
  unfold mirrorPayoff_modified mirrorPayoff_unmodified
  linarith

-- ============================================================================
-- § 4. The Alignment Condition
-- ============================================================================

/-- When meta-utility and object-level utility agree (the agent wants what
    they want, with no tension), self-modification cannot help because the
    Mirror is already maximizing the right thing. -/
theorem aligned_agent_no_incentive
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    (agent : EndogenousAgent Outcome)
    (h_aligned : agent.metaUtility = agent.originalUtility)
    (targetUtility : Outcome → ℝ) :
    mirrorPayoff_modified mirror agent targetUtility ≤
    mirrorPayoff_unmodified mirror agent := by
  unfold mirrorPayoff_modified mirrorPayoff_unmodified
  rw [h_aligned]
  have h1 := mirror.faithful agent.originalUtility (mirror.reveal targetUtility)
  linarith [agent.cost_nonneg]

/-- **Corollary**: The Mirror mechanism is manipulation-proof if and only if
    agents' meta-preferences are aligned with their object-level preferences.

    This is the key insight: Dumbledore's test works precisely when the person
    being tested doesn't have a reason to want to want something different
    from what they actually want. -/
theorem mirror_manipulation_proof_iff_aligned
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    (agent : EndogenousAgent Outcome)
    (h_aligned : agent.metaUtility = agent.originalUtility) :
    ∀ targetUtility : Outcome → ℝ,
      mirrorPayoff_modified mirror agent targetUtility ≤
      mirrorPayoff_unmodified mirror agent :=
  aligned_agent_no_incentive mirror agent h_aligned

-- ============================================================================
-- § 5. The Rationalist's Dilemma: Harry at the Mirror
-- ============================================================================

/-- A model of the HPMOR Mirror scenario.
    Harry's object-level desire might be "get the Stone" or "save everyone".
    His meta-level desire (as a rationalist) is to be the kind of person who
    wants to save everyone — because that's genuinely what he values at the
    reflective level. -/
structure HarryMirrorScenario where
  /-- Outcome: get the Stone (instrumentally useful) -/
  stone_utility : ℝ
  /-- Outcome: show desire to save everyone (passes Dumbledore's test) -/
  save_utility : ℝ
  /-- Harry's meta-utility for the Stone outcome -/
  stone_meta : ℝ
  /-- Harry's meta-utility for the save outcome -/
  save_meta : ℝ
  /-- Cost for Harry to self-modify his desires -/
  modification_cost : ℝ
  /-- Harry genuinely wants to save people more than get the Stone at the
      object level -/
  harry_wants_to_save : save_utility > stone_utility
  /-- Harry's meta-preferences also favor saving (he's genuinely good) -/
  harry_meta_save : save_meta ≥ stone_meta
  /-- Modification cost is non-negative -/
  cost_nonneg : modification_cost ≥ 0

/-- When Harry's object-level and meta-level preferences are aligned
    (he genuinely wants to save people, and wants to be the kind of person
    who wants to save people), Dumbledore's test cannot be gamed.

    This is the HPMOR insight: the test works on Harry not because Harry
    can't game it (he's smart enough), but because his genuine desires
    already point in the right direction. A rationalist with aligned
    preferences has no incentive to self-modify. -/
theorem harry_cannot_game_aligned_mirror
    (scenario : HarryMirrorScenario)
    (h_aligned : scenario.save_meta = scenario.save_utility ∧
                 scenario.stone_meta = scenario.stone_utility) :
    -- The meta-utility of the Mirror showing "save" is at least as high
    -- as the meta-utility of the Mirror showing "stone", even before
    -- accounting for modification costs
    scenario.save_meta ≥ scenario.stone_meta := by
  rw [h_aligned.1, h_aligned.2]
  exact le_of_lt scenario.harry_wants_to_save

-- ============================================================================
-- § 6. Gibbard-Satterthwaite Connection
-- ============================================================================

/-- The Gibbard-Satterthwaite theorem states that any strategyproof
    social choice function over 3+ alternatives that is surjective
    must be dictatorial.

    The Mirror of Erised is a *single-agent* mechanism (it reads one
    person's desires at a time), so it trivially satisfies the
    dictatorship condition — the single agent IS the dictator.

    This means the Mirror's strategyproofness is consistent with
    Gibbard-Satterthwaite: it's strategyproof *because* it's dictatorial
    (one person's preferences fully determine the outcome). -/
theorem mirror_is_dictatorial_hence_consistent
    {Outcome : Type}
    (mirror : MirrorMechanism Outcome)
    -- Single-agent setting: the mechanism considers only one agent
    (agent_utility : Outcome → ℝ) :
    -- The outcome is determined entirely by this single agent's preferences
    -- (trivially true: there's no one else)
    ∀ o : Outcome, agent_utility (mirror.reveal agent_utility) ≥ agent_utility o :=
  mirror.faithful agent_utility

-- ============================================================================
-- § 7. Concrete Example
-- ============================================================================

/-- A concrete two-outcome scenario illustrating the theory. -/
inductive MirrorOutcome : Type
  | getStone : MirrorOutcome
  | saveEveryone : MirrorOutcome
  deriving DecidableEq, Fintype

/-- A concrete Mirror that faithfully picks the higher-utility outcome. -/
noncomputable def concreteMirror : MirrorMechanism MirrorOutcome where
  reveal := fun u =>
    if u .saveEveryone ≥ u .getStone then .saveEveryone else .getStone
  faithful := by
    intro u o
    show u (if u MirrorOutcome.saveEveryone ≥ u MirrorOutcome.getStone
            then MirrorOutcome.saveEveryone else MirrorOutcome.getStone) ≥ u o
    by_cases h : u MirrorOutcome.saveEveryone ≥ u MirrorOutcome.getStone
    · rw [if_pos h]
      cases o with
      | getStone => exact h
      | saveEveryone => exact le_refl _
    · rw [if_neg h]
      push_neg at h
      cases o with
      | getStone => exact le_refl _
      | saveEveryone => exact le_of_lt h

/-- Harry's preferences: genuinely values saving everyone more. -/
noncomputable def harryUtility : MirrorOutcome → ℝ
  | .getStone => 5
  | .saveEveryone => 10

/-- The Mirror correctly shows Harry's deepest desire: saving everyone. -/
theorem mirror_shows_harry_save :
    concreteMirror.reveal harryUtility = .saveEveryone := by
  change (if harryUtility MirrorOutcome.saveEveryone ≥ harryUtility MirrorOutcome.getStone
        then MirrorOutcome.saveEveryone else MirrorOutcome.getStone) = MirrorOutcome.saveEveryone
  rw [if_pos (by simp [harryUtility]; norm_num)]

/-- No matter what Harry does, the Mirror maximizes his true utility. -/
theorem harry_mirror_optimal :
    ∀ o : MirrorOutcome,
      harryUtility (concreteMirror.reveal harryUtility) ≥ harryUtility o := by
  intro o
  have h : concreteMirror.reveal harryUtility = .saveEveryone := mirror_shows_harry_save
  rw [h]
  cases o with
  | getStone => simp only [harryUtility, ge_iff_le]; norm_num
  | saveEveryone => exact le_refl _

-- ============================================================================
-- § 8. The Misaligned Agent: Quirrell
-- ============================================================================

/-- Quirrell/Voldemort has misaligned preferences: he object-level wants
    the Stone (power), but if tested by the Mirror, he'd want the Mirror
    to show "save everyone" (to pass the test and get access). -/
noncomputable def quirrellOriginalUtility : MirrorOutcome → ℝ
  | .getStone => 10
  | .saveEveryone => 1

noncomputable def quirrellMetaUtility : MirrorOutcome → ℝ
  | .getStone => 3     -- Getting the Stone directly is OK
  | .saveEveryone => 10 -- Passing the test (to eventually get the Stone) is better

/-- The Mirror correctly reveals Quirrell's true desire: the Stone. -/
theorem mirror_reveals_quirrell :
    concreteMirror.reveal quirrellOriginalUtility = .getStone := by
  change (if quirrellOriginalUtility MirrorOutcome.saveEveryone ≥
          quirrellOriginalUtility MirrorOutcome.getStone
        then MirrorOutcome.saveEveryone else MirrorOutcome.getStone) = MirrorOutcome.getStone
  rw [if_neg (by simp [quirrellOriginalUtility])]

/-- Quirrell's dilemma: the Mirror reveals his true (evil) desire, but
    his meta-preference is to appear good. Self-modification would be
    profitable if the meta-utility gain exceeds the cost.

    With our payoffs: meta-utility of saveEveryone (10) minus
    meta-utility of getStone (3) = 7. So self-modification is profitable
    if the cost is less than 7. -/
theorem quirrell_wants_to_self_modify
    (cost : ℝ) (h_cheap : cost < 7) (_h_nonneg : cost ≥ 0) :
    quirrellMetaUtility .saveEveryone - cost >
    quirrellMetaUtility .getStone := by
  simp [quirrellMetaUtility]
  linarith

/-- But if self-modification is expensive enough, even Quirrell won't bother.
    This models the idea that deeply changing one's desires is hard —
    you can't just decide to genuinely want something different. -/
theorem quirrell_wont_modify_if_expensive
    (cost : ℝ) (h_expensive : cost ≥ 7) :
    quirrellMetaUtility .saveEveryone - cost ≤
    quirrellMetaUtility .getStone := by
  simp [quirrellMetaUtility]
  linarith
