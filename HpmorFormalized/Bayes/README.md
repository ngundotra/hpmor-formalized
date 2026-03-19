# Bayes

HPMOR Chapters: 2-3, 8-9, 20, 86, 100

## Goal

Formalize the Bayesian reasoning that Harry uses throughout HPMOR, starting
with the core claim: sufficiently strong evidence overwhelms any positive
prior. Determine whether the informal arguments are correct as stated or
whether formalization reveals hidden constraints.

## What's here

| File | What it does | Tier |
|------|-------------|------|
| Basic.lean | Defines the posterior formula, proves convergence to 1 as evidence grows, monotonicity in likelihood ratio, and the [0,1] bound | 2-3 |

## Findings so far

- **Monotonicity domain restriction**: The original theorem statement `Monotone (bayesian_posterior ε)` was false — the function has a singularity at negative L. Had to restrict to `MonotoneOn ... (Set.Ici 0)`. This is a hidden assumption: likelihood ratios are non-negative by construction, but the text never says so and the formula doesn't enforce it.

## What's next

These results were formalized before the prediction framework. Future work:

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Quantitative convergence rate (how many bits of evidence for posterior > 0.99?) | Probably confirms cleanly — this is a standard calculation | Low-medium |
| Base rate fallacy as P(A\|B) vs P(B\|A) confusion (Ch. 100) | Almost certainly confirms as stated | Low — skip |
| Multiple hypothesis testing / Occam as MDL (Ch. 8-9) | Uncertain whether "simplicity" can be made precise without arbitrary choices | High — good target |
| Bayesian likelihood ratio arithmetic (Ch. 86) | Harry does explicit numerical calculations — do his numbers check out? | Medium — might catch an arithmetic error |
