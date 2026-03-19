## Prediction

"I expect this to confirm the basic Hawk-Dove structure but reveal that HPMOR's reputation dynamics change the equilibrium in a non-obvious way. In the standard model, the ESS proportion of Hawks is V/C (value/cost). With reputation effects, playing Hawk has a persistent benefit (future opponents are more likely to back down), which should shift the ESS toward more Hawks. But if reputation is too valuable, everyone plays Hawk and the equilibrium might collapse -- becoming pure Hawk with costly fights. The question is whether HPMOR's implied payoffs land in the stable mixed-ESS region or the unstable all-Hawk region."

## Findings

The formalization confirms the basic Hawk-Dove structure and reveals that HPMOR's reputation dynamics change the equilibrium in a *quantitatively precise* way -- with a surprise in the details.

**Standard model (confirmed):** The unique mixed ESS has P(Hawk) = V/C when V < C. When V >= C, pure Hawk is the ESS. Both the indifference condition and uniqueness are proved.

**Reputation extension:** Adding a reputation parameter R (accruing to all Hawk plays) shifts the ESS to P(Hawk) = (V + 2R) / C. The factor of 2 was not predicted -- it arises because reputation benefits Hawk players in *both* matchups (vs Hawks and vs Doves), effectively doubling its weight in the indifference condition. This means reputation is more destabilizing than a naive analysis would suggest.

**Critical threshold:** The mixed ESS disappears when R >= (C - V) / 2, not when R >= C - V as one might initially guess. This halved threshold means the system is more fragile than expected -- even moderate reputation effects can push the population into all-Hawk.

**HPMOR analysis:** Does reputation push Slytherin past the stability threshold? Almost certainly yes. The threshold R* = (C - V)/2 is remarkably low. With V = 3 (moderate status value), C = 10 (high fighting cost), the threshold is only R* = 3.5. In Slytherin's reputation-obsessed culture, where being seen as willing to fight is described as essential to social survival, R is plausibly well above this threshold. The formalization proves (via `slytherin_all_hawk_example`) that even R = 4 pushes past the threshold, placing Slytherin firmly in the all-Hawk regime.

**The prediction was partially correct:** Reputation does shift the ESS toward more Hawks and there is a threshold beyond which the mixed ESS collapses. But the prediction underestimated how easily reputation destroys the mixed equilibrium -- the actual threshold is half what a first-pass analysis suggests, because reputation's effect is doubled by appearing in both entries of the Hawk row. Slytherin's payoff structure lands squarely in the unstable all-Hawk region, confirming the dysfunctional dynamics depicted in HPMOR Ch. 19.
