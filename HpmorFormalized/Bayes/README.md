# Bayes

HPMOR Chapters: 2-3, 6, 8-9, 17, 20, 48, 86, 100, 101

## Goal

Formalize the Bayesian reasoning that Harry uses throughout HPMOR, starting
with the core claim: sufficiently strong evidence overwhelms any positive
prior. Determine whether the informal arguments are correct as stated or
whether formalization reveals hidden constraints.

## What's here

| File | What it does | Tier | Finding |
|------|-------------|------|---------|
| Basic.lean | Posterior formula, convergence to 1 as evidence grows, monotonicity, [0,1] bound | 2-3 | #1 |
| ConfirmationBias.lean | Information-theoretic analysis of positive testing strategy. Proves confirmation bias is conditionally rational. | 2-3 | #15 |
| HypothesisLocation.lean | Information-theoretic cost of "locating" a hypothesis. Proves language-dependence. | 2 | #9 |
| PlanningFallacy.lean | Outside view vs inside view under squared-error loss. Proves reference class selection is the hidden assumption. | 2-3 | #17 |
| ScopeInsensitivity.lean | Scope insensitivity as optimal heuristic under bounded rationality. | 2 | #19 |

## Findings so far

- **#1 Monotonicity domain restriction** (Weak): Likelihood ratios are non-negative by definition — a Lean technicality, not a real insight.
- **#9 Hypothesis location** (Weak): Locating cost is language-relative. Known result in algorithmic information theory.
- **#15 Confirmation bias** (Novel): Positive testing is Bayesian-optimal under narrow-rule priors. Harry's blanket claim is conditional on the prior.
- **#17 Planning fallacy** (Novel): Outside view beats inside view iff `gap² ≤ bias²`. Reference class selection requires the knowledge being estimated.
- **#19 Scope insensitivity** (Borderline): Sublinear valuation is optimal when cognitive costs are positive. Known in bounded rationality literature.

## What's next

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Quantitative convergence rate (how many bits for posterior > 0.99?) | Probably confirms | Low-medium |
| Multiple hypothesis testing / Occam as MDL (Ch. 8-9) | Uncertain whether "simplicity" can be made precise without arbitrary choices | High — good target |
| Bayesian likelihood ratio arithmetic (Ch. 86) | Harry's numbers either check out or don't | Low-medium |
