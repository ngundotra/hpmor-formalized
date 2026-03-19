In HPMOR Chapter 8, Harry explains the 2-4-6 task (Wason, 1960): subjects are told that the triple (2, 4, 6) fits a secret rule and must discover the rule by proposing test triples. Most subjects only test triples they expect to fit the rule ("positive tests") and never test triples they expect to fail ("negative tests"). Harry presents this as straightforward irrationality -- "positive bias" or "confirmation bias."

We formalized a hypothesis testing model with two hypotheses (narrow rule vs. broad rule) and two test types (positive and negative), each producing binary outcomes. The key results:

1. In the specific Wason 2-4-6 scenario, Harry is correct: positive tests (like "8, 10, 12") succeed under both hypotheses and have a likelihood ratio of 1 (completely uninformative), while negative tests (like "1, 3, 5") can completely rule out the narrow hypothesis. Negative testing is strictly better here.

2. However, this is NOT a universal law. We proved `no_universal_test_dominance`: there exist scenarios where positive testing has a higher likelihood ratio than negative testing (when the narrow hypothesis strongly predicts success on positive tests but the broad hypothesis does not), and vice versa. Neither strategy universally dominates.

3. The summary theorem `hpmor_ch8_needs_qualification` exhibits both (a) a scenario where positive testing gives likelihood ratio 1 (no information) and (b) a scenario where positive testing outperforms negative testing.

The formalization reveals that Harry's blanket claim "positive bias is irrational" requires an unstated assumption: that the agent's prior assigns significant weight to broad hypotheses. Under a prior concentrated on narrow hypotheses where positive tests discriminate well, positive testing can be Bayesian-optimal. The irrationality of confirmation bias is conditional on the prior over the hypothesis space -- a qualification HPMOR never makes explicit.
