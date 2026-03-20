-- Precommitment can strictly help — but only when
-- there exists a strategy that beats Nash given
-- follower best-response.
theorem precommitment_strictly_helps
    (g : Game S₁ S₂) (s₁ : S₁) (s₂ : S₂)
    (_hne : isNashEquilibrium g s₁ s₂)
    (stack : StackelbergOutcome g)
    (_hbr : stack.followerBR s₁ = s₂)
    (s₁' : S₁)
    (hstrict : g.u₁ s₁ s₂ <
      g.u₁ s₁' (stack.followerBR s₁')) :
    g.u₁ s₁ s₂ <
      g.u₁ stack.leader (stack.followerBR stack.leader) := by
  calc g.u₁ s₁ s₂
      < g.u₁ s₁' (stack.followerBR s₁') := hstrict
    _ ≤ g.u₁ stack.leader
          (stack.followerBR stack.leader)
        := stack.leader_optimal s₁'

-- The catch: strict improvement requires incredibility.
-- If the commitment is credible, it's just Nash.
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
  have hne2 := credible_stackelberg_is_nash g stack hcred
  have hbound := hmax_nash _ _ hne2
  linarith
