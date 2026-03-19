# Timeless Decision Theory: Formalization and Analysis

**HPMOR Chapters**: 33, 16, 20, 75-77
**Lean file**: `HpmorFormalized/DecisionTheory/TDT.lean`

## Prediction

I expect this to reveal that TDT is underspecified. The informal description relies on 'logical counterfactuals' -- what would happen if my algorithm produced a different output -- but there is no standard mathematical formalization of this concept. Attempts to make it precise will likely either (a) collapse into standard extensive-form game theory with correlated strategies, or (b) require axioms about logical uncertainty that are not available in current mathematics. Either outcome is a genuine finding about HPMOR.

## Background

In HPMOR Ch. 33, Harry references Timeless Decision Theory (TDT), proposed by Eliezer Yudkowsky. The core idea: "Choose as if you're choosing the output of the algorithm that you are." TDT claims to give better answers than both Causal Decision Theory (CDT) and Evidential Decision Theory (EDT) in problems like Newcomb's Problem and the Prisoner's Dilemma against a copy of yourself.

## What Was Formalized

### Decision Framework (all compiled, no sorry)
- `DecisionProblem`: States, actions, utility function
- `cdtExpectedUtility` / `edtExpectedUtility` / `tdtExpectedUtility`: EU under causal, conditional, and "logical" probabilities
- `cdtRecommends` / `edtRecommends`: Optimality predicates

### Newcomb's Problem (all compiled, no sorry)
- Full payoff matrix with predictor accuracy parameter `p`
- **`cdt_newcomb_two_box_dominates`**: CDT always two-boxes (causal independence of prediction from action)
- **`cdt_two_boxes`**: CDT recommends two-boxing for all p in [0,1]
- **`edt_one_boxes`**: EDT one-boxes when p > 1001/2000 (approximately 0.5005)
- **`tdt_one_boxes`**: TDT one-boxes under the same condition

### PD Against a Copy (all compiled, no sorry)
- `PDCopy` structure with standard PD payoff ordering T > R > P > S
- **`cdt_defects_in_pd`**: CDT finds defection dominant
- **`logical_correlation_cooperation`**: Under logical correlation constraint, cooperation wins (R > P on the diagonal)

### Collapse Theorems (all compiled, no sorry)
- **`tdt_equals_edt_in_newcomb`**: TDT and EDT give *identical* expected utilities in Newcomb's Problem -- the "logical counterfactual" probability is exactly the conditional probability
- **`tdt_pd_is_diagonal_optimization`**: TDT's PD recommendation reduces to "R > P", i.e., optimizing over the diagonal of the payoff matrix

### Underspecification Result (compiled, no sorry)
- `LogicalCounterfactual`: The type of logical counterfactual functions
- **`logical_counterfactual_underdetermined`**: Any two logical counterfactual functions that agree on actual behavior can disagree arbitrarily on counterfactual behavior -- the concept is underdetermined by its constraints

## Findings

### Finding 1: TDT's expected utility function is structurally identical to EDT's

The `tdtExpectedUtility` function has the same type signature as `edtExpectedUtility`:
```
(dp : DecisionProblem State Action) -> (prob : Action -> State -> R) -> Action -> List State -> R
```
Both compute `sum over states of prob(a,s) * utility(a,s)`. The only difference is the *source* of the probability function -- but that source is informal (causal reasoning vs. evidential conditioning vs. logical counterfactuals).

The theorem `tdt_equals_edt_in_newcomb` proves the probabilities are literally the same function in Newcomb's Problem.

### Finding 2: TDT = standard game theory + a correlation constraint

TDT's key axiom is `LogicalCorrelation.same_algorithm_same_choice`: agents running the same algorithm must produce the same output. This restricts the joint strategy space from `Action x Action` to the diagonal `{(a,a) : a in Action}`.

This is a standard concept in game theory: it is a **perfectly correlated strategy profile**. The "cooperation in PD against a copy" result is simply the observation that `R > P` on the diagonal -- standard constrained optimization.

### Finding 3: Logical counterfactuals are underdetermined

The `logical_counterfactual_underdetermined` theorem shows that the constraint "match actual behavior at the actual output" leaves the counterfactual completely free at all other outputs. This means TDT, as stated, does not uniquely determine a decision -- it requires an additional specification of the logical counterfactual function, which is precisely the part that is missing from the informal theory.

### Finding 4: Where TDT might diverge from EDT

TDT was designed to handle problems like the "Smoking Lesion" differently from EDT. In such problems, EDT gives counterintuitive advice because it conditions on non-causal correlations. TDT claims to use only "logical" correlations (from shared algorithms) not "mere" evidential correlations (from common causes).

Formalizing this distinction requires a formal criterion for when a correlation is "logical" vs. "merely evidential." No such criterion exists in standard mathematics. The formalization attempt reveals this as the exact point where TDT becomes underspecified.

## Assessment

**Tier 2** -- Substantive formalization with genuine theorems (no sorry). The prediction was confirmed: TDT collapses into standard game theory with correlated strategies in every case that can be precisely formalized. The residual "TDT is different from EDT" claim requires the concept of logical counterfactuals, which remains unformalized and, per the underspecification theorem, underdetermined by its stated constraints.

**Bottom line for HPMOR**: Harry's Ch. 33 claim that TDT is a distinct decision theory is not supported by the formalization. What IS supported is the insight that correlation structure matters -- when facing a predictor that simulates you, modeling the game with correlated strategies (rather than independent ones) changes the optimal action. But this insight is standard game theory, not a new decision theory.
