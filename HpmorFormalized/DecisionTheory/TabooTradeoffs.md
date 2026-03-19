In HPMOR Chapter 82, Harry argues that refusing to make tradeoffs between "sacred values" leads to inconsistency: if you claim "no amount of X is worth one life" for multiple goods, you can be money-pumped through a cycle of individually-acceptable trades. His implicit claim is that rational values must admit a utility representation allowing tradeoffs between all goods.

We formalized this argument and found that Harry is right for practical purposes but wrong as a general philosophical claim. The key results:

1. **Money-pump avoidance**: Cyclic strict preferences are exploitable, and complete + transitive (rational) preferences are provably acyclic, hence money-pump invulnerable.

2. **Finite utility representation**: On finite outcome spaces with decidable preference, completeness + transitivity guarantee the existence of a real-valued utility function (via counting how many outcomes each option is preferred to). This means that on finite sets, rational preferences force implicit tradeoff rates between all goods -- Harry is correct.

3. **Lexicographic counterexample**: Lexicographic preferences on R x R (where the first component takes absolute priority) are complete, transitive, and money-pump invulnerable -- fully rational by any consistency criterion. Yet they are provably not representable by any real-valued utility function (stated as an axiom with full proof sketch; the standard argument uses density of Q in R and uncountability).

4. **The hidden assumption is finiteness**: Harry's argument works because practical decisions involve finitely many options. But the philosophical claim that "sacred values are irrational" is too strong -- lexicographic preferences formalize exactly the sacred-value structure Harry criticizes, and they are perfectly consistent on uncountable spaces.

This is a Tier 3 finding: formalization reveals that HPMOR's argument has a hidden assumption (finiteness of the outcome space) that is never mentioned. The precise boundary is: finite outcome space implies forced tradeoffs (Harry right), uncountable outcome space allows sacred values without inconsistency (Harry wrong), with countable spaces as an intermediate case depending on continuity assumptions (Debreu's theorem).
