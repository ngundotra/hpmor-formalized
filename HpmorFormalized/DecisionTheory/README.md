# DecisionTheory

HPMOR Chapters: 33, 43-47, 54-56, 75-77, 82, 119

## Goal

Formalize HPMOR's decision-theoretic claims: that precommitment has
strategic value, that expected utility works under existential risk,
that sacred values are irrational, and that Timeless Decision Theory
is a genuine advance. Determine where these arguments hold and where
they silently rely on unstated assumptions.

## What's here

| File | What it does | Tier | Finding |
|------|-------------|------|---------|
| Basic.lean | Stackelberg leader advantage, precommitment value, incredible commitment theorem | 2-3 | #2 |
| ExistentialRisk.lean | EU with -infinity via EReal. Proves standard EU is self-defeating; formalizes lexicographic and bounded alternatives. | 3 | #3 |
| TabooTradeoffs.lean | Utility representation on finite sets. Lexicographic preferences as counterexample to "sacred values are irrational." | 3 | #8 |
| TDT.lean | Formalizes CDT, EDT, and TDT. Proves TDT=EDT in Newcomb's, TDT≠EDT in Smoking Lesion. Logical counterfactuals underdetermined. | 3 | #14 |
| KnowledgeRisk.lean | Information hazard model. Proves containment degrades as (1-q)^N. | 1-2 | #13 |

## Findings so far

- **#2 Precommitment** (Novel): Requires unique Nash — multiple equilibria change the analysis.
- **#3 EU existential risk** (Novel): Standard EU self-defeats with -infinity. Harry implicitly uses lexicographic preferences.
- **#8 Taboo tradeoffs** (Novel): Sacred values are rational on infinite choice sets. Lexicographic preferences are the exact counterexample.
- **#13 Knowledge risk** (Weak): (1-q)^N is basic probability. Known result.
- **#14 TDT** (Novel): TDT is a genuine intermediate theory but requires causal structure as hidden input. Logical counterfactuals are underdetermined.

## What's next

| Claim | Prediction | Uncertainty |
|-------|-----------|-------------|
| Subgame-perfect equilibrium (Ch. 54-56) | Probably straightforward — the interesting question is whether HPMOR's examples actually require SPE or just NE | Medium |
| Can "logical correlation" be distinguished from "common-cause correlation" without assuming the causal graph? | If yes, TDT has a complete decision procedure. If no, TDT = CDT + Newcomb. | Very high |
