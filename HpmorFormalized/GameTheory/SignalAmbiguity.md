## Prediction

"I expect this to confirm with interesting structure. In standard signaling games, clarity (separating equilibria) is usually preferred because it resolves uncertainty. But when the sender faces multiple audiences with conflicting interests, ambiguity (pooling or semi-separating equilibria) can dominate. The hidden assumption in HPMOR is that Dumbledore's audience is heterogeneous -- if everyone had aligned interests, clarity would be better. The formalization should identify the exact audience-heterogeneity condition under which ambiguity dominates."

## Findings

The formalization confirms the prediction and identifies a clean, precise boundary condition for when ambiguity dominates clarity.

**Homogeneous audience (confirmed):** With a single audience or aligned interests (opponent penalty P_O = 0), clarity weakly dominates ambiguity. The ally's benefit from learning the sender's type is never negative, so revealing information is always (weakly) better. This matches the standard signaling game result that separating equilibria are preferred when interests are aligned.

**Heterogeneous audience (confirmed):** When the opponent penalty exceeds the ally benefit (P_O > B_A), ambiguity strictly dominates clarity. The sender sacrifices the ally's information benefit to deny the opponent exploitable information. This is formalized as a simple but exact inequality condition.

**Boundary condition (new insight):** The critical threshold is the *heterogeneity ratio* r = P_O / B_A:
- r < 1: clarity dominates (allies matter more than opponents)
- r = 1: indifference
- r > 1: ambiguity dominates (opponents are more dangerous than allies are helpful)

This ratio cleanly captures what HPMOR depicts intuitively. The formalization shows that the relevant quantity is not the absolute magnitude of opponent threat or ally benefit, but their *ratio*.

**Partial ambiguity and targeted signaling:** The extended model with continuous revelation probabilities (alpha for allies, beta for opponents) reveals that the *ideal* strategy is not full ambiguity but *targeted communication*: alpha = 1 (allies learn everything), beta = 0 (opponents learn nothing). This is formally proved as the global optimum. Full ambiguity (alpha = beta = 0) is only preferred over clarity (alpha = beta = 1) when r > 1 -- but targeted signaling (alpha = 1, beta = 0) dominates both, always.

**Ambiguity premium:** The value of being able to switch from clarity to ambiguity is max(0, P_O - B_A). This is the most the sender would pay for the ability to be ambiguous. It is zero when allies are more important than opponents, and grows linearly with the opponent penalty thereafter.

**HPMOR analysis:** Dumbledore faces P_O >> B_A (heterogeneity ratio around 4 in our calibration). Death Eaters and Voldemort can do enormous damage with clear information about Dumbledore's true assessments, while Order members can partially compensate through trust and private channels. The formalization confirms that ambiguity is strictly optimal in this regime. Moreover, Dumbledore's *skill* as a communicator is formalized as achieving high alpha (allies decode his enigmatic statements) with low beta (opponents cannot) -- approaching the globally optimal targeted signal. His famous cryptic speech style is not a character quirk but the *mathematically optimal communication strategy* for his strategic environment.

**The prediction was correct:** Audience heterogeneity is both necessary and sufficient for ambiguity to dominate clarity. The exact condition (P_O > B_A, or equivalently r > 1) is simple and interpretable. The additional insight beyond the prediction is the targeted-signaling result: the true optimum is not ambiguity per se, but *differential revelation* -- and Dumbledore's behavior matches this more refined optimum rather than pure ambiguity.
