# hpmor-formalized

A proof assistant walks into a rationality fanfic and starts checking the math.

Some of the math checks out. Some of it doesn't. The parts that don't are more interesting.

This project takes claims from [Harry Potter and the Methods of Rationality](https://hpmor.com) — the ones that sound like they should survive contact with a theorem prover — and runs them through [Lean 4](https://lean-lang.org). The results are machine-checked, human-readable, and occasionally embarrassing for the source material.

**Current status:** 21 modules, 0 `sorry`s, 21 Tier 3 findings where formalization revealed something the informal reasoning missed.

---

## Greatest Hits

Six results where the proof assistant found something nobody had noticed.

### Harry doesn't need quantum field theory

**The claim:** Harry discovers partial transfiguration by realizing matter is continuous quantum fields, not discrete objects (Ch. 28-29). This is the pivotal insight that wins the final exam.

**What we proved:** Harry's insight works, but his explanation is massive overkill. The theorem [`harry_doesnt_need_qft`](HpmorFormalized/Physics/PartialTransfiguration.lean) constructs a finite, 3-element, non-continuous structure that supports partial transfiguration perfectly well. What Harry actually needs isn't physics — it's a single axiom from analytic metaphysics: *unrestricted mereological composition* (any collection of parts is a valid whole). A wizard who understood that axiom could skip quantum field theory entirely.

The real dichotomy isn't objects vs. fields. It's restricted composition (only designated wholes are targets) vs. unrestricted composition (any parts are a target).

[Full writeup](HpmorFormalized/Physics/PartialTransfiguration.md)

### TDT is real, intermediate, and incomplete

**The claim:** Timeless Decision Theory is a novel decision framework that outperforms both CDT and EDT (Ch. 33).

**What we proved:** TDT is genuinely intermediate — it agrees with EDT where EDT is right (Newcomb's Problem: [`tdt_equals_edt_in_newcomb`](HpmorFormalized/DecisionTheory/TDT.lean)) and with CDT where CDT is right (Smoking Lesion: [`opposite_recommendations_smoking_lesion`](HpmorFormalized/DecisionTheory/TDT.lean)). It is not redundant. But [`logical_counterfactual_underdetermined`](HpmorFormalized/DecisionTheory/TDT.lean) proves that "logical counterfactuals" — TDT's core concept — are underdetermined: multiple consistent definitions exist, giving different answers, with no way to choose between them. TDT gets the right answers in known problems but can't make unique predictions in novel ones without additional axioms nobody has stated.

This is, to our knowledge, the first machine-checked characterization. It settles the structural question that 15 years of informal debate left open.

We initially proved TDT collapses entirely into EDT (finding v1). Then we tested the Smoking Lesion — and TDT *didn't* collapse there. So we corrected the finding. This is the methodology working as designed.

[Full writeup](HpmorFormalized/DecisionTheory/TDT.md)

### Expected utility self-destructs at the end of the world

**The claim:** Any probability of total annihilation times negative infinity utility equals negative infinity, so preventing existential catastrophe trumps everything (Ch. 43-47).

**What we proved:** Harry's calculation is correct and useless. If *every* available action has some nonzero chance of catastrophe, then every action scores negative infinity and the framework can't rank them. Harry's *actual* reasoning secretly uses lexicographic preferences: first minimize annihilation probability, then optimize everything else. That's a different decision theory than what he says he's using. He got the right answer with the wrong framework.

[Full writeup](HpmorFormalized/DecisionTheory/ExistentialRisk.md)

### Sacred values can be perfectly rational

**The claim:** Refusing to trade off sacred values is irrational because it lets people money-pump you (Ch. 82).

**What we proved:** Harry is right at the grocery store and wrong in the philosophy seminar. On finite choice sets, yes — complete and transitive preferences force implicit tradeoff rates. But lexicographic preferences (where life always outranks money, period) are provably complete, transitive, and money-pump invulnerable on infinite choice sets. This is precisely the mathematical structure of a "sacred value," and it is perfectly rational. The hidden assumption is finiteness — which Harry never states.

[Full writeup](HpmorFormalized/DecisionTheory/TabooTradeoffs.md)

### Confirmation bias is sometimes Bayesian-optimal

**The claim:** Positive testing (trying to confirm your hypothesis rather than disconfirm it) is irrational (Ch. 8).

**What we proved:** In the specific 2-4-6 task Harry discusses, he's right — positive tests have a likelihood ratio of exactly 1 (completely uninformative). But [`no_universal_test_dominance`](HpmorFormalized/Bayes/ConfirmationBias.lean) proves this is not a universal law. Under priors concentrated on narrow hypotheses, positive testing yields *higher* likelihood ratios than negative testing. Whether "confirmation bias" is irrational depends on your prior over the hypothesis space, which Harry never specifies.

[Full writeup](HpmorFormalized/Bayes/ConfirmationBias.md)

### Reputation makes dominance games twice as fragile

**The claim:** Slytherin's dominance contests are dysfunctional (Ch. 19).

**What we proved:** Mapping Draco's world onto a Hawk-Dove game with reputation effects, the mixed equilibrium (where some people fight and some back down) breaks at a threshold of `R* = (C-V)/2` — *half* the naive expectation. The factor of 2 arises because reputation helps Hawks in both matchups, making the system doubly fragile. Even small social rewards for dominance collapse the mixed equilibrium into universal aggression. Slytherin isn't just culturally dysfunctional — it's mathematically guaranteed to be.

[Full writeup](HpmorFormalized/GameTheory/HawkDove.md)

---

## What Else Is Here

Beyond the greatest hits, the project includes machine-checked results on:

- **Time travel**: Novikov self-consistency for finite state spaces, causal DAG consistency (forests only — [finding #6](ROADMAP.md)), and a proof that time-travel-as-NP-oracle [fails because "do nothing" is always a valid fixed point](HpmorFormalized/TimeTravel/NPOracle.md)
- **Bayesian updating**: Posterior convergence, the planning fallacy's circularity ([the outside view requires knowing what you're estimating](HpmorFormalized/Bayes/PlanningFallacy.md)), scope insensitivity as bounded-rational optimality
- **Game theory**: Aumann's agreement theorem (common priors are required — Harry and Draco don't share them), iterated PD cooperation thresholds (independent of the sucker payoff), Mirror of Erised as a preference-alignment mechanism
- **Signaling**: Dumbledore's ambiguity is optimal when opponents are more dangerous than allies are helpful — but targeted signaling dominates both clarity and ambiguity
- **Information security**: The Interdict of Merlin only works because magic enforces it; mundane containment degrades exponentially with population
- **Occlumency**: Perfect mind-shielding requires either impossible information-theoretic security or computational hardness assumptions HPMOR never states

The full findings table (21 entries, each with novelty assessment) is in [ROADMAP.md](ROADMAP.md).

---

## Limitations

Some things this project is not:

- **Not a complete formalization of HPMOR.** We picked claims that seemed like they should be formalizable and might teach us something. Many HPMOR arguments are too informal or too literary to formalize meaningfully. We left those alone.
- **Not a refutation of HPMOR.** Most of Harry's conclusions hold up. The findings are about hidden assumptions, missing qualifications, and cases where the right answer came from the wrong framework. The book is smarter than most fiction. It is also occasionally wrong in ways that are more interesting than being right.
- **Not fully general.** Some models are toy-sized. Some findings are sensitive to modeling choices. Each finding's writeup includes an honest novelty assessment (genuinely novel, borderline, known result, or modeling artifact). We don't pretend a 3-element counterexample is the same as a deep structural theorem.
- **Not peer-reviewed.** The proofs are machine-checked (0 `sorry`s), but the *models* — whether the Lean definitions faithfully capture the HPMOR claims — are judgment calls. Read the docstrings. Disagree if you see a better model.

---

## Build

Requires [elan](https://github.com/leanprover/elan) (installs Lean and `lake`).

```bash
git clone https://github.com/ngundotra/hpmor-formalized.git
cd hpmor-formalized
lake exe cache get
lake build
```

Lean will verify the project with considerably less enthusiasm than the protagonist would display while explaining why this is obviously the correct use of his time.

## Autoformalization (Aristotle)

The project integrates with [Harmonic's Aristotle](https://aristotle.harmonic.fun) for automated proof generation.

```bash
# Setup: get an API key at aristotle.harmonic.fun/dashboard/keys
export ARISTOTLE_API_KEY=<your-key>

# Submit a proof goal
uv run aristotle submit "Prove that the posterior L*e/(L*e+(1-e)) tends to 1 as L tends to infinity" --project-dir .

# Check status / download results
uv run aristotle list --limit 5
uv run aristotle result <project-id> --destination /tmp/result.tar.gz
```

If using [Claude Code](https://claude.com/claude-code), an Aristotle agent and `/aristotle` skill are available in `.claude/`.

**Honest note:** Every substantive proof in this project was written by LLM-assisted manual formalization, not Aristotle. The bottleneck is modeling decisions (choosing the right definitions), not proof search. Aristotle may be more useful for filling `sorry`s in well-structured files than for novel formalizations from scratch. See [ROADMAP.md](ROADMAP.md) for details.

## Contributing

If you enjoy the experience of taking a confident informal argument and discovering exactly which unstated assumption it was leaning on, you will like it here.

See [CONTRIBUTING.md](CONTRIBUTING.md) and [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md).

## References

- [HPMOR full text](https://hpmor.com)
- [Mathlib4 docs](https://leanprover-community.github.io/mathlib4_docs/)
- [Lean 4 documentation](https://lean-lang.org/lean4/doc/)
- [Aristotle autoformalization](https://aristotle.harmonic.fun)
- [Full claims extraction (160+ formalizable claims)](HPMOR_CLAIMS.md)
