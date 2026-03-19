In HPMOR Chapters 48 and 101, Harry discusses scope insensitivity -- the empirical finding that people's willingness to pay (WTP) to save 2,000 birds is not much more than their WTP to save 200 birds (Desvousges et al., 1993). Harry treats this as straightforwardly irrational: a rational agent should value n lives at n times the value of one life.

We formalized a cost-of-evaluation model with two types of agents: a linear evaluator who processes every unit of scope (paying cognitive cost c per unit) and a heuristic evaluator who uses a sublinear valuation function (e.g., square root) and processes fewer effective units. The key results:

1. `scope_insensitivity_irrational_at_zero_cost`: Under zero evaluation cost, linear valuation strictly dominates any strictly sublinear valuation at every scope n > 1. Harry is right: if cognition is free, scope insensitivity is irrational.

2. `heuristic_dominates_when_costly`: Under the processing-cost model, when per-unit cognitive cost c exceeds per-unit value v, a sublinear evaluator loses less than a linear evaluator. The linear evaluator's net utility is (v - c) * n, while the sqrt evaluator's is (v - c) * sqrt(n). Since v - c < 0 and sqrt(n) < n, the sqrt evaluator dominates.

3. `scope_insensitivity_rational_at_positive_cost`: Concrete witness -- with v = 1 and c = 2, the heuristic evaluator beats the linear evaluator at every scope n > 1.

4. `scope_insensitivity_irrational_iff_zero_cost`: The full characterization. Scope insensitivity is irrational at zero cost (part a) but can be optimal at positive cost (part b).

The formalization reveals that Harry's claim in HPMOR is correct under the implicit assumption of unbounded cognitive resources (c = 0). But the general claim that scope insensitivity is irrational requires qualification: under bounded rationality with positive evaluation costs, sublinear valuation can be the optimal heuristic. The irrationality of scope insensitivity depends on whether we measure against an ideal Bayesian with unlimited processing power or against the best feasible strategy under cognitive constraints.
