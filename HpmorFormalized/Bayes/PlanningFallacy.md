In HPMOR Chapter 6, Harry advocates "the outside view" or reference class forecasting: instead of estimating how long your project will take based on project-specific reasoning (the "inside view"), look at how long similar projects actually took (the "outside view"). Harry presents this as straightforwardly correct -- the planning fallacy shows people are systematically biased when using the inside view, so the outside view dominates.

We formalized this as an estimation problem under squared-error loss with the standard bias-variance decomposition (MSE = bias^2 + variance). The inside view is modeled as an estimator with a nonzero bias (the planning fallacy) and some variance. The outside view is modeled as an estimator whose bias equals the "reference class gap" -- the difference between the reference class mean and the true project duration.

Key results:

1. `outside_view_dominates_biased_inside`: When the reference class is perfectly calibrated (gap = 0) and has no greater variance, the outside view strictly dominates a biased inside view. This is the formal content of Harry's claim.

2. `outside_view_fails_bad_class`: When the reference class gap exceeds the inside view's bias in squared magnitude, the outside view has *higher* MSE. A badly chosen reference class makes estimation worse, not better.

3. `outside_beats_inside_iff`: The outside view beats the inside view if and only if the reference class gap squared is at most the planning bias squared (at equal variance). This makes explicit the hidden condition in Harry's argument.

4. `reference_class_selection_requires_judgment`: For any poorly-calibrated reference class, a less-biased inside view beats it; and for any biased inside view, a well-calibrated outside view beats it. Neither approach universally dominates.

5. `no_universal_reference_class`: Two reference classes with different squared gaps always admit a strict ordering, but which is better depends on the gaps -- which depend on the true duration that we are trying to estimate.

Concrete examples illustrate the point: a project with true duration 10, inside-view bias of -3 (estimating 7), and a good reference class (mean 10) gives MSE_outside = var vs MSE_inside = 9 + var. But with a reference class of "all government projects" (mean 50, gap 40), the outside view's MSE is 1600 + var -- catastrophically worse than the biased inside view.

The formalization reveals that Harry's advocacy of the outside view is correct under the unstated assumption that a well-calibrated reference class is available. But choosing such a class requires knowing approximately what the true duration is -- which is the very quantity being estimated. The outside view pushes the epistemic problem back one level (from "estimate the duration" to "choose the right reference class") without eliminating it. This is a Tier 2 finding: the claim is true but requires an assumption HPMOR does not make explicit.
