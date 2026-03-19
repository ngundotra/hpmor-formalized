# HPMOR Formalizable Claims: Comprehensive Extraction

> Extracted from all 122 chapters of *Harry Potter and the Methods of Rationality* by Eliezer Yudkowsky.

---

## How to read this table

Claims are ranked by **outcome uncertainty** — how hard it is to predict
whether formalization will confirm, reveal hidden structure, refute, or
get stuck. High uncertainty = high expected information = best target.

We learned from 16 completed formalizations that:
- **Textbook results dressed as findings are not novel** (e.g., Aumann's common
  priors assumption, Kolmogorov complexity UTM-dependence, (1-q)^N decay).
  If you can look it up, don't formalize it to "discover" it.
- **Modeling artifacts are not findings** (e.g., the 55% threshold depends on
  arbitrary payoff values). If the result changes when you change the model
  parameters, it's not structural.
- **The best findings catch the argument using the wrong framework** (e.g.,
  Harry claims EU reasoning but actually uses lexicographic preferences).
  These only surface when you try to state the theorem precisely.
- **Counterexamples to philosophical claims are gold** (e.g., lexicographic
  preferences refute "sacred values are irrational"). These are genuinely novel.

## Summary Table: Top Claims Ranked by Outcome Uncertainty

| Rank | Claim | Ch. | Branch | Uncertainty | Why this is uncertain | Predicted outcome |
|------|-------|-----|--------|-------------|----------------------|-------------------|
| ~~1~~ | ~~Timeless Decision Theory~~ | 33 | Decision Theory | ~~Very high~~ | **DONE — Finding #14.** TDT is a genuine intermediate theory (TDT=EDT in Newcomb, TDT≠EDT in Smoking Lesion) but requires causal structure as hidden input. Logical counterfactuals are provably underdetermined. | Prediction: unknown. Actual: more nuanced than any prediction — required two rounds of formalization to get right. |
| ~~2~~ | ~~Positive bias / 2-4-6 task~~ | 8 | Hypothesis Testing | ~~High~~ | **DONE — Finding #15.** Confirmation bias is conditionally rational. Harry is right about the Wason task but wrong to generalize — under narrow-rule priors, positive testing is Bayesian-optimal. | Prediction: needs modification. Actual: confirmed prediction exactly. |
| ~~3~~ | ~~Hawk-Dove dominance contests~~ | 19 | Evolutionary Game Theory | ~~High~~ | **DONE — Finding #16.** Reputation makes the system twice as fragile (threshold at (C-V)/2 not (C-V)). Slytherin is mathematically all-Hawk. | Prediction: genuinely uncertain. Actual: confirmed but the factor-of-2 fragility was a surprise. |
| ~~4~~ | ~~Scope insensitivity~~ | 48, 101 | Behavioral Economics | ~~High~~ | **DONE — Finding #19.** Scope insensitivity is irrational iff cognitive costs are zero. Under bounded rationality, sublinear valuation can be optimal. Known in behavioral economics — borderline novelty. | Prediction: needs modification. Actual: confirmed prediction. |
| ~~5~~ | ~~Planning fallacy / outside view~~ | 6 | Decision Theory | ~~High~~ | **DONE — Finding #17.** Outside view beats inside view iff `gap² ≤ bias²`. Reference class selection requires the knowledge being estimated. | Prediction: needs modification. Actual: confirmed — the circularity is the finding. |
| ~~6~~ | ~~Signal ambiguity for coalitions~~ | 60 | Game Theory / Signaling | ~~High~~ | **DONE — Finding #18.** Ambiguity dominates clarity iff `P_O > B_A`. But targeted signaling (allies learn everything, opponents nothing) dominates both. Dumbledore's skill is selective precision, not vagueness. | Prediction: confirms with structure. Actual: confirmed, plus the targeted-signaling optimum was a surprise. |
| ~~7~~ | ~~Mirror of Erised as mechanism~~ | 109 | Mechanism Design | ~~High~~ | **DONE — Finding #20.** The Mirror tests preference alignment (meta-prefs = object-prefs), not character. Manipulation-proof iff aligned. Quirrell would self-modify if cost is low. | Prediction: fundamental impossibility. Actual: more nuanced — it's about alignment, not impossibility. |
| 8 | Quidditch Snitch as dominant strategy collapse | 7 | Mechanism Design | Medium-high | Harry argues the Snitch makes the rest of Quidditch pointless. But this depends on the point values — is there a scoring system where the Snitch doesn't dominate? This is a mechanism design question with a likely clean answer, but the boundary conditions might surprise. | Probably confirms but the exact dominance boundary is non-obvious |
| 9 | Escalation dynamics in sequential games | 19, 74 | Game Theory | Medium-high | Bullying escalation in HPMOR maps onto sequential games with commitment. Does the "escalation ladder" have a determinate outcome, or is it sensitive to assumptions about rationality? | Probably confirms standard escalation results but HPMOR-specific payoffs might change the equilibrium |
| 10 | Recursive strategic reasoning depth bound | 24 | Computational Complexity | Medium-high | "I know that you know that I know..." — is there a formal depth limit? In finite games, bounded rationality models cap reasoning depth. But HPMOR characters reason arbitrarily deep. Is infinite depth actually required for the outcomes described? | Probably confirms a known bound but the connection to HPMOR's specific scenarios is uncertain |
| 11 | Unbreakable Vow as binding commitment device | 113, 122 | Mechanism Design | Medium | Maps onto our existing precommitment results. The interesting question: does the "unbreakable" aspect interact with the multiple-equilibria problem (finding #2)? If you can't break the vow, can it trap you in a bad equilibrium? | Probably confirms but interaction with finding #2 could be novel |
| 12 | Contagious lies as dependency graph | 65 | Graph Theory | Medium | Lies create consistency obligations — a dependency graph. But this is essentially constraint satisfaction, which is well-understood. The question is whether HPMOR's specific lie structures have non-obvious graph-theoretic properties. | Probably confirms standard constraint propagation |
| 13 | Potion conservation: output <= invested energy | 78 | Thermodynamics | Medium | Extends finding #11 (conservation). If potions must conserve *some* quantity, what constraints does that impose on potion design? Interesting if it produces unexpected constraints. | Probably confirms but might interact with the modified-symmetry finding in novel ways |
| 14 | Secret propagation in networks | 48 | Graph Theory / Probability | Medium | Related to finding #13 (knowledge risk) but in a network topology. The question is whether network structure changes the exponential decay result. Hub-and-spoke vs mesh might matter. | Probably extends #13 without new structural insight |
| 15 | Bayesian likelihood ratio arithmetic | 86 | Bayesian Inference | Low-medium | Harry does explicit calculations. These either check out or they don't. Not much room for surprise. | Probably confirms — it's arithmetic |

### Dropped from ranking (would confirm as stated — low information):
- Base rate fallacy (Ch. 100) — textbook conditional probability, will confirm
- Fundamental attribution error (Ch. 5) — well-known Bayesian framing
- Sunk cost fallacy (Ch. 76) — well-understood, will confirm
- Induction proof of immortality desire (Ch. 39) — trivial formalization
- Milgram prediction vs actual (Ch. 63) — it's a numerical comparison
- Fermi estimation (Ch. 4) — methodology, not a theorem
- Broomstick physics (Ch. 59) — will confirm Newtonian vs Aristotelian
- Hedonic adaptation (Ch. 87) — behavioral economics, hard to formalize as a theorem

### Already Formalized:
- Bayesian posterior convergence (Ch. 2-3) — `Bayes/Basic.lean` — Finding #1
- Novikov self-consistency (Ch. 11-17) — `TimeTravel/Novikov.lean`
- Grandfather paradox (Ch. 11-17) — `TimeTravel/Paradox.lean`
- CausalDAG / topological ordering — `TimeTravel/CausalDAG.lean` — Finding #6
- Time-Turner NP oracle (Ch. 17) — `TimeTravel/NPOracle.lean` — Finding #12
- Precommitment value (Ch. 75-77) — `DecisionTheory/Basic.lean` — Finding #2
- EU under existential risk (Ch. 43-47) — `DecisionTheory/ExistentialRisk.lean` — Finding #3
- Taboo tradeoffs (Ch. 82) — `DecisionTheory/TabooTradeoffs.lean` — Finding #8
- Hypothesis location (Ch. 17) — `Bayes/HypothesisLocation.lean` — Finding #9
- Knowledge dissemination risk (Ch. 119) — `DecisionTheory/KnowledgeRisk.lean` — Finding #13
- Aumann's agreement (Ch. 22-24) — `GameTheory/Aumann.lean` — Finding #7
- Iterated PD folk theorem (Ch. 33) — `GameTheory/IteratedPD.lean` — Finding #5
- Final exam (Ch. 113-122) — `GameTheory/FinalExam.lean` — Finding #4
- Conservation of energy (Ch. 2) — `Physics/Conservation.lean` — Finding #11
- Occlumency indistinguishability (Ch. 27) — `Logic/Occlumency.lean` — Finding #10
- Prisoner's Dilemma dominance (Ch. 33) — `GameTheory/Basic.lean`
- Timeless Decision Theory (Ch. 33) — `DecisionTheory/TDT.lean` — Finding #14
- Confirmation bias / 2-4-6 task (Ch. 8) — `Bayes/ConfirmationBias.lean` — Finding #15
- Hawk-Dove with reputation (Ch. 19) — `GameTheory/HawkDove.lean` — Finding #16
- Planning fallacy / outside view (Ch. 6) — `Bayes/PlanningFallacy.lean` — Finding #17
- Signal ambiguity (Ch. 60) — `GameTheory/SignalAmbiguity.lean` — Finding #18
- Scope insensitivity (Ch. 48) — `Bayes/ScopeInsensitivity.lean` — Finding #19
- Mirror of Erised (Ch. 109) — `GameTheory/MirrorOfErised.lean` — Finding #20

---

## Chapter-by-Chapter Extraction

### Chapter 1: "A Day of Very Low Probability"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 1.1 | Comparative prior probability: insanity vs magic | "A little insanity was far, far less improbable than the universe really working like that." | Bayesian Reasoning | Easy | Low |
| 1.2 | Falsifiability as criterion for scientific claims | "the only rule in science is that the final arbiter is observation" | Philosophy of Science / Logic | Medium | Low |
| 1.3 | Binary experimental design to resolve uncertainty | "If it's true, we can just get a Hogwarts professor here and see the magic for ourselves" | Hypothesis Testing | Easy | Low |

---

### Chapter 2: "Everything I Believe Is False"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 2.1 | Updating on infinitesimal-probability observations | "updating on an observation of infinitesimal probability" | Bayesian Inference | Medium | Medium |
| 2.2 | Conservation of Energy violation by Transfiguration | "You violated Conservation of Energy! That's not just an arbitrary rule, it's implied by the form of the quantum Hamiltonian!" | Physics (Noether's Theorem) | Hard | Very High |
| 2.3 | Computational limits of biological transformation | "A human mind can't just visualise a whole cat's anatomy" | Computational Theory | Medium | Medium |

**Tier 3 highlight**: Claim 2.2 -- Formalizing what it means for a transformation to violate Noether's theorem could reveal interesting structure about what conservation laws actually rule out vs. what they permit with modified assumptions.

---

### Chapter 3: "Comparing Reality To Its Alternatives"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 3.1 | Bystander effect as coordination failure | "you were more likely to get help if you had an epileptic fit in front of one person than in front of three" | Game Theory / Probability | Medium | High |
| 3.2 | Rationality failure under cognitive load | "whenever you are most in need of your art as a rationalist, that is when you are most likely to forget it" | Meta-reasoning / Bounded Rationality | Hard | Medium |

**Tier 3 highlight**: Claim 3.1 -- Formalizing the bystander effect as a multi-agent coordination game where P(help) decreases with n agents could reveal conditions for optimal group size.

---

### Chapter 4: "The Efficient Market Hypothesis"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 4.1 | Arbitrage from fixed magical exchange rates | Gold-silver exchange at 17:1 (Sickles:Galleons) vs. Muggle ~50:1 ratio | Arbitrage Theory / Market Efficiency | Easy | High |
| 4.2 | Fermi estimation: systematic approximation | "A way of getting rough numbers quickly" -- estimates vault at ~2 million pounds | Applied Math / Dimensional Analysis | Easy | Medium |

**Tier 3 highlight**: Claim 4.1 -- A formal proof that fixed exchange rates between two markets with different commodity prices guarantees unbounded profit would be clean and instructive. The informal argument hides the question of transaction costs and convergence.

---

### Chapter 5: "The Fundamental Attribution Error"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 5.1 | Attribution error as asymmetric probability weighting | "When we look at others we see personality traits...when we look at ourselves we see circumstances" | Bayesian Reasoning / Cognitive Bias | Easy | Medium |
| 5.2 | Incomplete state space sampling | "We only see them in one situation" | Statistical Inference | Easy | Medium |

---

### Chapter 6: "The Planning Fallacy"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 6.1 | Planning fallacy: systematic underestimation | "people are always very optimistic, compared to reality. Like they say something will take two days and it takes ten days" | Decision Theory / Statistics | Medium | High |
| 6.2 | Outside view correction | "the best way to fix it is to ask how long things took the last time" | Reference Class Forecasting | Medium | High |
| 6.3 | Pessimistic planning as minimax | "you just have to be really, really, really pessimistic" | Robust Optimization | Medium | Medium |

**Tier 3 highlight**: Claim 6.1 -- Formalizing the planning fallacy as a systematic bias where E_inside[T] < E_outside[T] and proving conditions under which reference class forecasting dominates could reveal when inside view is actually better.

---

### Chapter 7: "Reciprocation"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 7.1 | Quidditch Snitch as dominant strategy collapse | "Catching the Snitch is worth one hundred and fifty points?...violates every possible rule of game design" | Mechanism Design / Game Theory | Easy | High |
| 7.2 | Reciprocation principle: unsolicited gifts create obligation | Unsolicited confidence gifts are "twice as effective as offering them twenty Sickles" | Behavioral Economics / Signaling | Medium | Medium |
| 7.3 | Exponential growth of scientific capability | "In science our powers wax by the year" | Growth Models | Easy | Low |

**Tier 3 highlight**: Claim 7.1 -- Proving that a 150-point Snitch catch in a game where other goals are worth 10 points creates a dominant strategy (always prioritize Snitch) that makes all other play irrelevant. Formalization would precisely characterize when a single-action payoff dominates aggregate play.

---

### Chapter 8: "Positive Bias"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 8.1 | 2-4-6 task: positive tests cannot distinguish nested hypotheses | "you kept on thinking of triplets that should make the rule say 'Yes'. But you didn't try to test any triplets that should make the rule say 'No'" | Hypothesis Testing / Inductive Logic | Medium | High |
| 8.2 | Consequentialist ethics as argmax(U(outcome)) | "the only question is how it will turn out in the end -- what are the consequences" | Decision Theory | Easy | Low |

**Tier 3 highlight**: Claim 8.1 -- Formalizing why positive-only testing cannot distinguish between "even numbers going up by 2" and "any three numbers in increasing order" reveals deep structure about hypothesis space geometry and information gain from disconfirming tests.

---

### Chapter 9: "Title Redacted, Part I"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 9.1 | Genetic incompatibility should prevent inter-species reproduction | "You can't just mix two different species together and get viable offspring!" | Information Theory / Biology | Medium | Medium |
| 9.2 | Bounded rationality: sufficient precision for practical purposes | "Harry knew pi to 3.141592 because accuracy to one part in a million was enough" | Decision Theory / Optimization | Easy | Low |

---

### Chapter 10: "Self Awareness, Part II"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 10.1 | Sorting Hat as bargaining game with credible threats | "If you don't answer my questions, I'll refuse to talk to you" | Game Theory / Bargaining | Easy | Medium |
| 10.2 | Reference class forecasting by the Sorting Hat | "Of those who did not intend evil from the very beginning, some of them listened to my warnings" | Base Rate Inference | Easy | Medium |

---

### Chapter 11: "Omake Files 1, 2, 3"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 11.1 | Baconian experimental method: testing presence AND absence | "I followed the Baconian experimental method which is to find the conditions for both the presence and the absence of the phenomenon" | Logic / Experimental Design | Easy | Low |

---

### Chapter 12: "Impulse Control"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 12.1 | Backward induction across time | "Twenty years later, that was what he would desperately wish had happened twenty years ago" | Game Theory / Temporal Logic | Medium | Medium |
| 12.2 | Comed-Tea as deterministic causal reversal | Modified humor sensitivity -> unique spit-take trigger -> reality alteration | Causal Inference / Decision Theory | Hard | Medium |

---

### Chapter 13: "Asking the Wrong Questions"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 13.1 | Incomplete information games with unknown payoffs | "you do not know the rules of the game / you do not know the stakes of the game" | Bayesian Games | Medium | Medium |

---

### Chapter 14: "The Unknown and the Unknowable"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 14.1 | Mysterious answer is a contradiction in terms | "There were mysterious questions, but a mysterious answer was a contradiction in terms." | Epistemology / Information Theory | Medium | Medium |
| 14.2 | Reverse causation in causal graphs | "The comedy causes you to drink the Comed-Tea...causal arrows going backwards in time." | Causal Inference / DAGs | Hard | High |

---

### Chapter 15: "Conscientiousness"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 15.1 | Conservative strategy dominates risky guessing under asymmetric penalties | "Wrong answers will be marked with extreme severity, questions left blank will be marked with great leniency" | Decision Theory / Expected Utility | Easy | Medium |
| 15.2 | Transfiguration reversal as irreversible process | "breathing results in constant loss of the body's stuff...when Transfiguration wears off...it will not quite be able to do so" | Physics / Entropy | Medium | High |

**Tier 3 highlight**: Claim 15.2 -- Formalizing why transfigured material that has exchanged atoms with the environment cannot fully revert reveals constraints from conservation + entropy. Could be modeled as an information-loss theorem.

---

### Chapter 16: "Lateral Thinking"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 16.1 | Mechanism design with nested reward structures | Quirrell's "ten Quirrell points will be worth one House point" + peer tutoring bonuses | Mechanism Design | Easy | Medium |
| 16.2 | Deductive inference from enumerated set | "every single use that Mr. Potter named was offensive rather than defensive" | Logic / Statistical Inference | Easy | Low |

---

### Chapter 17: "Locating the Hypothesis"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 17.1 | Time-Turner as NP oracle (P=NP via stable time loops) | "If this worked, Harry could use it to recover any sort of answer that was easy to check but hard to find" | Computational Complexity | Hard | Very High |
| 17.2 | Hypothesis location cost dominates evaluation cost | "when there are lots of possible answers, most of the evidence you need goes into just locating the true hypothesis out of millions" | Information Theory / Bayesian | Hard | Very High |
| 17.3 | Diamond-detector analogy: false positive rates in hypothesis testing | "suppose you had a million boxes...you'd have, on average, one false candidate and one true candidate left" | Signal Detection Theory | Medium | High |

**Tier 3 highlight**: Claim 17.1 -- This is research-level. If time travel provides a fixed-point oracle, does that collapse complexity classes? Formalizing the conditions under which stable time loops solve NP problems (and when they don't) would be genuinely novel.

**Tier 3 highlight**: Claim 17.2 -- Formalizing the information-theoretic cost of locating a hypothesis (log of hypothesis space size) vs. confirming it (likelihood ratio) could reveal that most "evidence" in informal arguments is actually doing location work, not confirmation.

---

### Chapter 18: "Dominance Hierarchies"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 18.1 | Asymmetric information creates false performance signals | "people managed to make themselves look very smart by asking questions about random facts that only they knew...onlookers only noticed that the askers knew and the answerers didn't" | Information Asymmetry / Attribution Error | Easy | Medium |
| 18.2 | Ultimatum game with credible commitment | "Either this man goes, or I do" | Game Theory | Easy | Low |

---

### Chapter 19: "Delayed Gratification"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 19.1 | Hawk-Dove escalation model | "There are many animals which have dominance contests...they fight with claws sheathed...both might be severely hurt" | Evolutionary Game Theory | Medium | High |
| 19.2 | Loss aversion in dominance contests | "The pain will come from the difficulty of losing, instead of fighting back" | Prospect Theory | Easy | Medium |
| 19.3 | Trust calibration via prior probability | "You shouldn't [trust me so quickly], it's too soon" | Bayesian Reasoning | Easy | Low |

**Tier 3 highlight**: Claim 19.1 -- The hawk-dove game formalized in Lean with Mathlib could reveal precise conditions for stable equilibria in dominance contests with variable cost/benefit ratios.

---

### Chapter 20: "Bayes's Theorem"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 20.1 | Act evaluation via mental states, not surface resemblance | "The import of an act lies not in what that act resembles on the surface, but in the states of mind which make that act more or less probable." | Bayesian Inference | Medium | Medium |
| 20.2 | Medical test base rate problem | "If you had a medical test that was only wrong one time in a thousand, sometimes it would still be wrong anyway" | Conditional Probability | Easy | Medium |
| 20.3 | Recursive epistemic loop preventing verification | "There is nothing you can do to convince me because I would know that was exactly what you were trying to do" | Epistemic Logic / Game Theory | Hard | High |

---

### Chapter 21: "Rationalization"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 21.1 | Bottom-line writing: predetermined conclusions constrain argument validity | "The moment you wrote the bottom line, it was already true or already false." | Bayesian Reasoning / Epistemology | Medium | Medium |
| 21.2 | Rationality as decision procedure vs. post-hoc justification | "Rationality can't be used to argue for a fixed side, its only possible use is deciding which side to argue" | Decision Theory | Medium | High |

---

### Chapter 22: "The Scientific Method"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 22.1 | Double-blinding eliminates observer bias | "You shouldn't tell the raters what the experiment is about, at all." | Experimental Design / Information Theory | Easy | Medium |
| 22.2 | Sequential hypothesis testing with early stopping | "Don't design an elaborate course of experiments...Just check as fast as possible whether your ideas are false" | Information Theory / Decision Analysis | Medium | Medium |

---

### Chapter 23: "Belief in Belief"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 23.1 | Pre-commitment to predictions prevents post-hoc fitting | "First I tell you the theory and the prediction. Then you show me the data" | Bayesian Epistemology | Easy | Medium |
| 23.2 | Revealed preference via forward prediction | "You'll always expect to see happen just exactly what would happen if..." | Decision Theory / Epistemic Logic | Medium | Medium |
| 23.3 | Modus tollens chain for sequential hypothesis elimination | Tests A through D systematically falsify competing hypotheses | Formal Logic | Easy | Low |

---

### Chapter 24: "Machiavellian Intelligence Hypothesis"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 24.1 | Recursive strategic reasoning (I think you think I think...) | "unless all that was exactly what Harry wanted Draco to do...some even larger plot" | Epistemic Logic / Game Theory | Hard | High |
| 24.2 | The Rule of Three: complexity bound on feasible plans | "any plot which required more than three different things to happen would never work in real life" | Computational Complexity | Medium | High |

**Tier 3 highlight**: Claim 24.2 -- Formalizing why sequential dependencies create exponential failure probability (P(all n steps succeed) = p^n) could precisely characterize when plans become infeasible. This is essentially a reliability theory problem.

---

### Chapter 25: "Hold Off on Proposing Solutions"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 25.1 | Complex traits require sequential evolutionary assembly | "Complex, interdependent machinery was always universal within a sexually reproducing species" | Evolutionary Dynamics / Information Theory | Hard | High |
| 25.2 | Only two causes of purposeful complexity: evolution or engineering | "Only two known causes of purposeful complexity. Natural selection...and intelligent engineering" | Causal Inference | Medium | Medium |
| 25.3 | Anchoring bias from premature solution proposals (Maier's research) | "Groups instructed to 'discuss problem thoroughly without proposing solutions' outperformed unrestricted groups" | Decision Theory / Cognitive Bias | Easy | Medium |

---

### Chapter 26: "Noticing Confusion"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 26.1 | Zero-information explanations yield likelihood ratio of 1:1 | "If you're equally good at explaining any outcome, you have zero knowledge." | Information Theory / Bayesian | Medium | High |

**Tier 3 highlight**: Claim 26.1 -- This is a core information-theoretic result. Proving that an explanation framework E has zero predictive value iff P(observation|E) = P(observation|~E) for all observations would be clean and illuminating.

---

### Chapter 27: "Empathy"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 27.1 | Occlumency as computational indistinguishability | "Anything a Legilimens could understand, an Occlumens could pretend to be." | Cryptography / Information Theory | Hard | Very High |

**Tier 3 highlight**: Claim 27.1 -- If a mind-reader (verifier) can understand a mental state, then a sufficiently capable Occlumens (simulator) can produce indistinguishable states. This is essentially the simulation argument from computational complexity. Formalizing it would connect to zero-knowledge proofs.

---

### Chapter 28: "Reductionism"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 28.1 | Map-territory distinction as model-theory separation | "The implicit belief...in the eraser as a single object...was a map-territory confusion." | Model Theory / Semantics | Medium | Medium |
| 28.2 | Partial transfiguration requires abandoning object-level ontology | Transfiguring part of an object requires thinking of matter as atoms, not "objects" | Physics / Mereology | Hard | High |

---

### Chapter 29: "Egocentric Bias"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 29.1 | Texas sharpshooter fallacy | "suspicious things happen all the time, and if you're a conspiracy theorist you can always find something" | Bayesian Reasoning / Multiple Comparisons | Easy | Medium |

---

### Chapter 30: "Working in Groups, Pt 1"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 30.1 | Robbers Cave: inter-group conflict from mere group awareness | "The hostility had started from the moment the two groups had become aware of each others' existences" | Game Theory / Social Psychology | Medium | Medium |
| 30.2 | Common external threat transforms competitive to cooperative game | "What had worked was warning them that there might be vandals" | Cooperative Game Theory | Medium | High |

---

### Chapter 31: "Working in Groups, Pt 2"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 31.1 | "I notice that I am confused" as modus tollens on model | If (observation != prediction), then (exists false assumption in model) | Epistemic Logic | Easy | Medium |
| 31.2 | Abductive reasoning: capability exceeded -> hidden variable | "Granger should not have been able to do all that. Therefore, she probably hadn't." | Formal Logic | Easy | Low |

---

### Chapter 32: "Interlude: Personal Financial Management"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 32.1 | Concentration risk violates variance minimization | "leaving all of my assets in one undiversified vault full of gold coins -- it's crazy" | Portfolio Theory | Easy | Medium |
| 32.2 | Resource restriction reduces agent action space | "allowing you control over your own finances would give you far too much independence of action" | Principal-Agent Theory | Easy | Medium |

---

### Chapter 33: "Coordination Problems, Pt 1" [PARTIALLY FORMALIZED]

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 33.1 | Timeless Decision Theory / functional decision theory | "When you choose, you shouldn't think like you're choosing for just yourself...you should think like you're choosing for all the people who are similar enough to you" | Logical Decision Theory | Hard | Very High |
| 33.2 | Zero-sum characterization of fixed-total competitions | "Our war is a zero-sum game...it doesn't matter whether it's easy or hard in an absolute sense" | Game Theory | Easy | Low |

**Tier 3 highlight**: Claim 33.1 -- Timeless/Functional Decision Theory is one of the most interesting unformalised claims. Proving that agents who "choose for all similar agents" achieve better outcomes in symmetric games than CDT agents would be significant.

---

### Chapter 34: "Coordination Problems, Pt 2"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 34.1 | Psychological cost of defense against traitors exceeds direct damage | "What people do because they're afraid of traitors also costs them" | Game Theory / Information Theory | Medium | High |
| 34.2 | Logical impossibility of mutually exclusive wishes | "Two of those wishes are mutually incompatible. It's logically impossible." | Formal Logic | Easy | Low |

---

### Chapter 35: "Coordination Problems, Pt 3"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 35.1 | Elections as incentive alignment, not optimal selection | "The point of elections isn't to produce the one best leader, it's to keep politicians scared enough" | Mechanism Design / Principal-Agent | Medium | High |
| 35.2 | Reversed stupidity is not intelligence | "Reversed stupidity is not intelligence; the world's stupidest person may say the sun is shining, but that doesn't make it dark" | Formal Logic | Easy | Medium |

**Tier 3 highlight**: Claim 35.2 -- Proving that P(H|stupid person believes H) is NOT necessarily low (i.e., ad hominem is invalid for probability) is a clean Bayesian exercise.

---

### Chapter 36-38: Various Interludes

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 37.1 | Conservation principle: magical effort has physical cost | "Professor Quirrell kept the spell going for more than an hour, though his face grew strained" | Physics / Thermodynamics | Medium | Medium |
| 38.1 | Cardinal sin: claims without discriminating evidence | Ancient philosophers making claims ("all is water") without evidence that discriminates their hypothesis from alternatives | Bayesian Hypothesis Testing | Medium | Medium |

---

### Chapter 39: "Pretending to be Wise, Pt 1"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 39.1 | Proof by induction: desire for immortality | "I want to live one more day. Tomorrow I will still want to live one more day. Therefore I want to live forever, proof by induction on the positive integers." | Mathematical Induction | Easy | Medium |
| 39.2 | Quantifier equivalence as logical tautology | "All x: Die(x) = Not Exist x: Not Die(x)" | First-Order Predicate Logic | Easy | Low |
| 39.3 | Verification via asymmetric knowledge | Ask a dead person "a question whose answer you don't know, but the dead person would, and that can be definitely verified" | Information Theory / Bayesian Verification | Easy | Medium |

---

### Chapter 40: "Pretending to be Wise, Pt 2"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 40.1 | Implicit beliefs feel like "the way the world is" | "What people really believed didn't seem to them like beliefs at all" | Epistemology / Cognitive Science | Medium | Low |
| 40.2 | Occam's Razor / parsimony in explanation selection | "These...only project an image from the mind; the result seems indistinguishable from memory because it is memory" | Bayesian Model Selection | Easy | Medium |

---

### Chapter 41-42: "Frontal Override" / "Courage"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 41.1 | System 1 vs System 2 conflict in decision-making | "are you going to let your brain run your life?" | Bounded Rationality / Dual Process Theory | Medium | Medium |
| 42.1 | Courage requires genuine risk despite rational assessment | "Peter knew the risk, Harry, he knew the risk was real" | Decision Theory / Virtue Ethics | Medium | Low |

---

### Chapter 43-47: "Humanism" Arc [PARTIALLY FORMALIZED]

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 43.1 | Binary classification without graded outcomes | "The rest of the school just seemed to think that No Patronus meant Bad Person" | Boolean Logic / Classification | Easy | Low |
| 45.1 | Dementors as riddle: fear (signal) vs death (reality) | "If the Dementor is a riddle, what is the answer?" | Signal Detection Theory | Medium | Medium |
| 46.1 | Biased information from selected sources | "you do not find out all there is to know about a man by asking only his friends" | Bayesian Updating with Selection Bias | Easy | Medium |
| 47.1 | Inverse inference: outcomes -> intentions | "to fathom a strange plot, look at what ended up happening, assume it was the intended result" | Inverse Bayesian Inference | Medium | High |

---

### Chapter 48: "Utilitarian Priorities"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 48.1 | Scope insensitivity: utility doesn't scale with quantity | "Your brain imagines a single bird struggling in an oil pond...no one can visualize even two thousand of anything, so the quantity just gets thrown straight out the window" | Behavioral Economics / Probability | Medium | High |
| 48.2 | Secret propagation as graph connectivity | "Three can keep a secret if two are dead...telling just your closest friends is the same as telling everyone" | Graph Theory / Probability | Medium | High |

**Tier 3 highlight**: Claim 48.1 -- Formalizing scope insensitivity as a probability inequality: WTP(save n birds) << n * WTP(save 1 bird) and proving under what utility axioms this is irrational would be illuminating.

**Tier 3 highlight**: Claim 48.2 -- Modeling secret propagation as percolation on a social graph and proving threshold conditions for universal spread would be clean graph theory.

---

### Chapter 49: "Prior Information"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 49.1 | Plausible deniability requires consistent evasion policy | "To maintain plausible deniability, you needed a general policy of sometimes evading questions even when you had nothing to hide" | Game Theory / Signaling | Easy | Medium |
| 49.2 | Evidence must overcome prior improbability | "It wouldn't matter that it shouldn't be enough evidence to locate the true explanation as a hypothesis" | Information Theory / Bayesian | Medium | Medium |

---

### Chapter 50: "Self Centeredness"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 50.1 | Rational actor model under absent consequences | "people will do whatever they think they can get away with" | Game Theory / Incentive Theory | Easy | Low |
| 50.2 | Second-order strategic inference by observers | Intimidation signals unintended meanings to bystanders | Game Theory / Signaling | Easy | Medium |

---

### Chapter 51-62: "The Stanford Prison Experiment" Arc

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 51.1 | Amazing deductions from prior knowledge, not evidence | "the way to make amazing deductions from scanty evidence was to know the answer in advance" | Bayesian Reasoning | Easy | Medium |
| 53.1 | Perfect crimes are undetectable by definition | "If you did commit the perfect crime, nobody would ever find out" | Formal Logic / Epistemology | Easy | Medium |
| 55.1 | Dementor-induced pessimism as biased observation | "your hopeless feelings may not indicate that the situation is actually hopeless" | Bayesian Inference with Bias Correction | Easy | Medium |
| 56.1 | Adding constraints reduces solution space to infeasibility | "there's a limit to how many constraints you can add to a problem before it really is impossible" | Constraint Satisfaction / Complexity Theory | Medium | High |
| 58.1 | 20% mortality risk vs. mission value: VNM utility incoherence | "there's no way you can justify taking a twenty percent risk to your life...The math doesn't add up" | VNM Utility Theory | Medium | High |
| 59.1 | Broomstick: Aristotelian vs Newtonian physics | "Rockets did not work by Aristotelian physics...A rocket-assisted broomstick did not move like the magical broomsticks" | Classical Mechanics / Conservation of Momentum | Easy | Medium |
| 60.1 | Signal ambiguity enables multi-faction coalition | "Give a sign of Slytherin on one day, and contradict it with a sign of Gryffindor the next" | Game Theory / Signaling | Hard | High |
| 61.1 | 6-hour Time-Turner information transmission limit | "you couldn't send information further back in time than six hours, not through any chain of Time-Turners" | Information Theory / Channel Capacity | Medium | High |
| 62.1 | Unilateral defection creates cascading instability | "Wizards could not live together if they each declared rebellion against the whole" | Iterated Game Theory | Medium | Medium |

**Tier 3 highlight**: Claim 56.1 -- This connects directly to computational complexity theory. Proving that k constraints on n binary variables has exponentially decreasing satisfying assignments (with appropriate distributions) would formalize the "too many constraints" intuition.

---

### Chapter 63: "TSPE Aftermaths"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 63.1 | Milgram: expert predictions vs actual compliance (3% vs 65%) | "The most pessimistic answer had been 3%. The actual number had been 26 out of 40." | Statistics / Calibration | Easy | Medium |
| 63.2 | Blackmail escalation via backward induction | "the person being blackmailed, if they could foresee the whole path, would just decide to take the punch on the first step" | Sequential Game Theory | Medium | High |

---

### Chapter 64: "Omake Files 4" (Non-canonical)

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 64.1 | Thermodynamic impossibility of Matrix human batteries | Humans as power sources violates second law | Physics / Thermodynamics | Easy | Low |

---

### Chapter 65: "Contagious Lies"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 65.1 | Lies create expanding dependency graphs | "Lies propagate...You've got to tell more lies to cover them up, lie about every fact that's connected to the first lie" | Graph Theory / Information Theory | Medium | High |
| 65.2 | Epistemic erosion: attacking foundational axioms | "sooner or later you'd even have to start lying about the general laws of thought" | Formal Systems / Logic | Hard | High |

**Tier 3 highlight**: Claim 65.1 -- Formalizing how a single false statement in a knowledge graph creates a cascade of required supporting falsehoods (with bounded depth or unbounded?) would connect to coherence theory and consistency maintenance.

---

### Chapter 66-72: "Self Actualization" Arc

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 66.1 | Pre-commitment test: can you specify D(X) before observing X? | If you cannot specify in advance what action you'll take given each possible observation, your information need is suspicious | Decision Theory / Bayesian | Medium | High |
| 68.1 | Availability heuristic crowds out better alternatives | "you had the misfortune to remember how to cast the Stunning Hex, and so you did not search for a dozen easier spells" | Cognitive Bias / Information Retrieval | Easy | Medium |
| 69.1 | First-mover advantage and information asymmetry in combat | "in the real world almost any fight would be settled by a surprise attack" | Game Theory | Easy | Medium |
| 70.1 | Simpson's Paradox in gender statistics | "as many woman Ministers of Magic as men" but far fewer female heroes | Statistics / Sampling Theory | Medium | High |
| 71.1 | Sequential decision-making: opportunity cost of hesitation | "the trouble with passing up opportunities was that it was habit-forming" | Sequential Decision Theory | Medium | Medium |
| 72.1 | Selective denial leaks information via Bayesian inference | "I can't just go around saying 'no' every time someone asks me about something I haven't done" | Information Theory / Signaling | Easy | Medium |

---

### Chapter 73-75: "Self Actualization" (Continued)

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 73.1 | No rational certainty, even about 2+2=4 | "a rationalist isn't ever certain of anything, not even that two and two make four" | Bayesian Epistemology | Medium | Medium |
| 74.1 | Abductive reasoning: failed prediction -> hidden variable (Neptune analogy) | "You think your prediction failed because there was some other factor at work...Like when orbital calculations for Uranus were wrong" | Abductive Reasoning / Bayesian | Easy | Medium |
| 74.2 | Escalation loop in sequential intervention games | "Each time you intervened, Harry, it escalated matters further and yet further" | Game Theory / Escalation Dynamics | Medium | High |
| 75.1 | Radical consequentialist responsibility | "Whatever happens, no matter what, it's always your fault" | Decision Theory / Consequentialism | Medium | Medium |

---

### Chapter 76: "Sunk Costs"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 76.1 | Sunk cost fallacy: past investment should not influence future decisions | Title and thematic exploration of continuing failed investments | Decision Theory | Easy | Medium |

---

### Chapter 77: "Surface Appearances"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 77.1 | Hawk-Dove asymmetric payoff: good people backing down always | "if evil people are willing to risk violence to get what they want, and good people always back down" | Game Theory (Hawk-Dove) | Medium | High |
| 77.2 | Base rate reasoning on appearance vs reality | "even though appearances can be misleading, they're usually not" | Bayesian Inference | Easy | Medium |

---

### Chapter 78: "Taboo Tradeoffs Prelude: Cheating"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 78.1 | Potion conservation law: output <= invested energy | "A potion spends that which is invested in the creation of its ingredients" | Thermodynamics / Conservation | Medium | High |
| 78.2 | Zugzwang: forced moves with only suboptimal options | "The forced move...was one you needed to make if you wanted the game to continue at all" | Game Theory | Easy | Medium |
| 78.3 | Difficulty != power threshold | Polyjuice is N.E.W.T.-level due to precision, not raw power | Logic / Type Theory | Easy | Low |

---

### Chapter 79-84: "Taboo Tradeoffs" Arc

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 79.1 | Observation vs inference distinction | "Let us distinguish observation from inference." | Epistemology / Bayesian Logic | Easy | Low |
| 79.2 | Base rate argument: 12-year-old girls don't commit murders | "twelve-year-old girls basically never commit cold-blooded murders" | Base Rate Reasoning | Easy | Medium |
| 80.1 | Horns effect: negative attribute biases all-domain judgment | Ugly appearance correlates to assumed evil | Cognitive Bias / Probability | Easy | Medium |
| 81.1 | Endowment effect: loss of money more painful than equivalent risk to life | "Losing all your money is a lot more painful for real people in real life" | Prospect Theory / Behavioral Economics | Medium | Medium |
| 81.2 | Narrative fallacy: applying story templates to real events | "The rhythm of the play demands it...they are not consciously aware that they are using story-reasoning on real life" | Cognitive Science / Bounded Rationality | Medium | Medium |
| 82.1 | Revealed preference establishes value bounds | "Every time you spend money to save a life with some probability, you establish a lower bound on the monetary value of a life" | Decision Theory / Revealed Preference | Medium | High |
| 82.2 | Inconsistent upper/lower bounds imply reallocation savings | "If your upper bounds and lower bounds are inconsistent, it means you could move money from one place to another, and save more lives" | Welfare Economics / Formal Logic | Medium | Very High |
| 82.3 | Taboo tradeoff effect: moral indignation at quantification | "Subjects became indignant and wanted to punish the hospital administrator for even thinking about the choice" | Behavioral Economics / Moral Psychology | Medium | High |
| 84.1 | Conformity rate: 75% conform at least once | "75% of the subjects had 'conformed' at least once" | Statistics / Social Psychology | Easy | Low |

**Tier 3 highlight**: Claim 82.2 -- This is a theorem: if for commodities A and B, the implicit value-of-life from spending on A exceeds the value from spending on B, then reallocating money from A to B saves more lives at same cost. Formalizing this inequality would make the "sacred values" irrationality precise.

---

### Chapter 85-87: "Taboo Tradeoffs Aftermath" / "Hedonic Awareness"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 85.1 | Temporal consistency: adopt future-updated answers now | "if you knew what your answer would be after updating on future evidence, you ought to adopt that answer right now" | Decision Theory | Medium | Medium |
| 86.1 | Bayesian arithmetic: prior odds x likelihood ratio = posterior odds | "If a hypothesis is a hundred times as likely to be false versus true...update to believing the hypothesis is twenty times as likely to be false" (100:1 x 1:5 = 20:1) | Bayesian Inference | Medium | High |
| 86.2 | Modus tollens: smart Voldemort -> everyone dies fast; didn't happen -> not that smart | "In worlds with a smart Lord Voldemort, everyone in the Order of the Phoenix died in the first five minutes" | Formal Logic | Easy | Medium |
| 86.3 | Complexity penalty / Occam's Razor | "Complexity penalty! More epicycles!" | Model Selection / Information Theory | Medium | Medium |
| 87.1 | Hedonic adaptation: paralyzed people less unhappy than predicted | "even people who were paralyzed in car accidents weren't nearly as unhappy as they'd expected to be, six months later" | Behavioral Economics / Expected Utility | Easy | Medium |
| 87.2 | Philosopher's Stone implausibility: conjunction of independent claims | "there's no logical reason why the same artifact would transmute lead to gold AND produce an elixir" | Conjunction Fallacy / Probability | Easy | Medium |
| 87.3 | Outside view on relationships | "offering betting odds on who I finally married would assign higher probability to you" | Reference Class Forecasting | Easy | Low |

**Tier 3 highlight**: Claim 86.1 -- Explicit Bayesian arithmetic worked out numerically. Lean formalization would verify the multiplication and connect to the general odds form of Bayes' theorem.

---

### Chapter 88-89: "Time Pressure"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 88.1 | Hogwarts search as TSP-variant | "Searching all of Hogwarts bordered on a mathematical impossibility, there probably was no continuous flight path that entered all the rooms at least once" | Computational Complexity / Graph Theory | Medium | Medium |
| 89.1 | Minimax strategy under combat uncertainty | Harry evaluates flee/fight/hide to minimize worst-case harm | Game Theory / Decision Theory | Easy | Low |

---

### Chapter 90-98: "Roles" Arc

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 90.1 | Fault analysis should target modifiable components | "When you do a fault analysis, there's no point in assigning fault to a part of the system you can't change afterward" | Systems Analysis / Decision Theory | Easy | Medium |
| 93.1 | Normalcy bias: failure to act during emergencies | "Normalcy bias, like that plane crash where most people just sat in their seats while their plane was literally on fire" | Behavioral Economics / Probability | Easy | Medium |
| 94.1 | Nested deception levels (Kripke semantics) | "This could be a setup to make us think wards are lying when truthful, or truthful when lying" | Epistemic Logic / Modal Logic | Hard | High |
| 94.2 | Egocentric bias as asymmetric information | "Egocentric bias...you experience everything about your own life but don't experience everything else" | Information Theory / Conditional Probability | Easy | Medium |
| 95.1 | Solar mass insufficient for supernova | "The Sun doesn't have enough mass to go supernova" (M_sun < Chandrasekhar limit) | Astrophysics | Easy | Low |
| 95.2 | Utilitarian loss from trading lives | "If you save Hermione at the price of two other people's lives, I've lost on total points from a utilitarian standpoint" | Utilitarian Calculus | Easy | Low |
| 96.1 | Temporal logic: "shall be destroyed" implies future state change | "'Shall be destroyed' refers to a change of future state" -- incompatible with present acceptance | Temporal Logic / Modal Logic | Medium | Medium |
| 97.1 | Communication asymmetry under power differential | "Communication is an event that takes place between equals. Employees lie to their bosses" | Information Theory / Principal-Agent | Easy | Medium |
| 98.1 | Patronus Charm as unforgeable trust signal | "everyone who can cast the Patronus Charm...That's how we'll know to trust each other" | Cryptographic Verification / Signaling | Medium | High |

**Tier 3 highlight**: Claim 94.1 -- Formalizing nested deception in Kripke semantics (world w1 where wards are truthful, w2 where they lie, w3 where they lie about lying) could precisely characterize the information-theoretic cost of each additional level.

---

### Chapter 99: "Roles, Aftermath"
Minimal content (transitional chapter). No formalizable claims extracted.

---

### Chapter 100-102: "Precautionary Measures" / "Caring"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 100.1 | Base rate inversion: P(Slytherin|Dark) vs P(Dark|Slytherin) | "Even if most Dark Wizards are Slytherins...most Slytherins are not Dark Wizards" | Conditional Probability | Easy | High |
| 101.1 | Scope insensitivity: failure to multiply | "Scope insensitivity. Failure to multiply." -- individual harm x 1000 students > single benefit | Decision Theory / Expected Value | Medium | High |
| 101.2 | Truth interaction: multiple truths reinforce each other | "There is a power in the truth, in all the pieces of the truth which interact with each other" | Information Theory / Bayesian Epistemology | Medium | Medium |
| 102.1 | EU calculation followed by gut override | "You already calculated the expected utilities...you assigned probabilities, you multiplied, and then you threw out the answer" | Decision Theory | Easy | Medium |
| 102.2 | Indifference as unlimited scaling of killing intent | "What is deadlier than hate, and flows without limit?" -- Answer: Indifference | Information Theory / Entropy | Medium | Medium |

**Tier 3 highlight**: Claim 100.1 -- This is literally Bayes' theorem applied to show P(A|B) != P(B|A). A clean Lean proof connecting this to the base rate fallacy would be highly pedagogical.

---

### Chapter 103-108: "The Truth" Arc

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 104.1 | Conflicting evidence implies overlooked hypothesis | "If different observations seem to point in incompatible directions, it means the true hypothesis is one you haven't thought of yet" | Bayesian Inference | Medium | Medium |
| 104.2 | Reality as single coherent state generating all observations | "Reality settled down into a single known state, one coherent state-of-affairs that compactly generated the observation set" | Model Theory / Constraint Satisfaction | Hard | High |
| 105.1 | Parseltongue as unforgeable truth channel | "Occlumency cannot fool the Parselmouth curse as it can fool Veritaserum" | Information Theory / Channel Constraints | Medium | Medium |
| 107.1 | Security system design flaw: testing capability rather than authorization | "real-world security systems...distinguish authorized from unauthorized personnel" but Hogwarts tests skill | Information Security / Logic | Easy | Medium |
| 107.2 | Self-levitation as bootstrap paradox | "no wizard may levitate themselves...it is like trying to lift yourself up by your own bootstraps" | Physics / Self-Reference | Easy | Low |
| 108.1 | Cognitive blind spot: failure to consider "nice" strategies | "I have a blind spot...around strategies that involve doing nice things" | Cognitive Bias / Optimization | Easy | Medium |

---

### Chapter 109-112: "Reflections" / "Failure"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 109.1 | Specialized counter beats general system | "Even the greatest artifact can be defeated by a counter-artifact that is lesser, but specialized" | Game Theory / Strategy | Easy | Medium |
| 109.2 | Algorithmic fairness: universal rules blind to identity | "There is in the Mirror a blindness such as philosophers have attributed to ideal justice" | Computer Science / Mechanism Design | Hard | High |
| 111.1 | Absence of evidence is weak evidence of absence | "Absence of evidence is weak evidence of absence" | Bayesian Epistemology | Easy | Medium |
| 111.2 | Backward induction from winning terminal state | "If someone TOLD YOU AS A FACT that you had survived...what would you think had happened?" | Game Theory / Backward Induction | Medium | Medium |
| 111.3 | Fear-of-death as design flaw in utility function | "If Lord Voldemort had a strong enough fear of death...the horcrux system could have design flaws" | Utility Theory / Optimization | Medium | Medium |
| 112.1 | Binding magical curse as commitment device | "A curse to enforce that none of us would threaten the others' immortality" | Mechanism Design / Contract Theory | Medium | High |
| 112.2 | Loophole exploitation: literal vs intended contract interpretation | "I used bullets. That's not a fist or a spell." | Formal Logic / Frame Problem | Medium | High |

---

### Chapter 113-114: "Final Exam" / "Shut Up and Do The Impossible" [PARTIALLY FORMALIZED]

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 113.1 | Unbreakable Vow as mechanism design with self-fulfilling prophecy risk | "We must be cautious that this Vow itself does not bring that prophecy about" | Mechanism Design / Causal Inference | Hard | Very High |
| 113.2 | Information elicitation via 1:1 exchange mechanism | "For each unknown power you tell me...you may name one more of those to be protected" | Mechanism Design / Auction Theory | Medium | High |
| 114.1 | Threat credibility assessment | "Only reason you make threats is that you expect me to respond" | Game Theory / Signaling | Easy | Medium |
| 114.2 | Antimatter energy vs stellar fusion: magnitude comparison | "Power I would command is stronger than process that fuels stars" | Physics / Energy Scaling | Easy | Low |
| 114.3 | Wordless transfiguration as constraint satisfaction | Executing complex operations within vow limitations | Constraint Satisfaction | Medium | Medium |

---

### Chapter 115: "Shut Up and Do The Impossible, Pt 2"

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 115.1 | Redundant defenses against impossible conditions are wasteful | "More than a hundred horcruxes...fence-post security...making the fence-post even higher wouldn't stop that" | Security Analysis / Game Theory | Easy | Medium |
| 115.2 | State transformation doesn't trigger categorical detection | "magic hadn't defined a Transfigured unicorn as dead...horcruxes wouldn't define a Transfigured Voldemort as dead" | Logic / Type Theory | Medium | High |

**Tier 3 highlight**: Claim 115.2 -- This is about how detection predicates interact with state transformations. If isDead checks current form but Transfiguration changes form without changing "alive" status, the predicate returns false. This is essentially about predicate invariance under transformation, which has deep connections to type theory.

---

### Chapter 116-122: "Something to Protect" Arc / Epilogue

| # | Claim | Quote/Paraphrase | Branch | Difficulty | Tier 3 |
|---|-------|-----------------|--------|------------|--------|
| 117.1 | Deontological protection as targetability shield | "they had foregone the deontological protection of good people" | Ethical Logic / Game Theory | Medium | Medium |
| 117.2 | Bounded rationality: forgetting Death Eaters have children | Decision under time pressure omits relevant variables | Information Theory / Cognitive Limits | Easy | Low |
| 119.1 | Existential risk from universal Transfiguration knowledge | "The probability was as close to certainty as made no difference" that world-destroying Transfigurations would be discovered | Existential Risk / Information Theory | Hard | Very High |
| 119.2 | Prophecy restriction to prevent self-fulfilling loops | "prophecies will be destroyed, and no future ones recorded" | Temporal Logic / Causal Inference | Hard | High |
| 119.3 | Line of Merlin as succession mechanism | "There can only be one king upon the chessboard" | Cooperative Game Theory / Mechanism Design | Medium | Medium |
| 120.1 | Strategic irrationality for personal benefit | Voldemort designed his organization to lose for entertainment | Game Theory / Principal-Agent | Medium | Medium |
| 122.1 | Unbreakable Vow as binding mechanism against current stupidity | "an Unbreakable Vow whose sole purpose was to protect everyone from Harry's current stupidity" | Mechanism Design | Medium | High |
| 122.2 | Prophecy structure as Bayesian evidence about solution complexity | "if there'd been some way for Dumbledore to save the world himself, then prophecy would probably have told Dumbledore how" | Bayesian Inference / Meta-reasoning | Medium | Medium |

**Tier 3 highlight**: Claim 119.1 -- Formalizing the argument that sufficiently powerful transformation capabilities + large population + sufficient time -> near-certainty of catastrophic discovery. This is essentially a coupon collector / birthday paradox variant applied to existential risk.

---

## Category Summary

### By Mathematical Branch (Top New Claims)

| Branch | Count | Top Unformalised Claims |
|--------|-------|----------------------|
| **Bayesian Reasoning** | ~45 | Likelihood ratio arithmetic (86.1), Base rate inversion (100.1), Hypothesis location cost (17.2) |
| **Game Theory** | ~40 | Hawk-Dove dominance (19.1), Escalation dynamics (74.2), TDT/FDT (33.1), Signal ambiguity (60.1) |
| **Decision Theory** | ~30 | Scope insensitivity (48.1), Taboo tradeoffs (82.2), Planning fallacy (6.1), Sunk costs (76.1) |
| **Information Theory** | ~25 | Contagious lies (65.1), Secret propagation (48.2), Occlumency (27.1), Zero-info explanations (26.1) |
| **Logic / Epistemology** | ~20 | Positive bias / 2-4-6 task (8.1), Nested deception (94.1), Induction immortality (39.1) |
| **Physics / Conservation** | ~12 | Conservation violation (2.2), Potion conservation (78.1), Broomstick physics (59.1) |
| **Computational Complexity** | ~8 | Time-Turner as NP oracle (17.1), TSP search (88.1), Rule of Three (24.2) |
| **Mechanism Design** | ~8 | Unbreakable Vow (113.1, 122.1), Elections as incentive alignment (35.1), Quidditch (7.1) |
| **Behavioral Economics** | ~10 | Hedonic adaptation (87.1), Endowment effect (81.1), Normalcy bias (93.1) |
| **Cryptography** | ~3 | Occlumency as indistinguishability (27.1), Patronus as unforgeable signal (98.1) |

### By Difficulty

| Difficulty | Count | Examples |
|-----------|-------|---------|
| **Easy** | ~70 | Base rate inversion, induction proof, quantifier equivalence, Snitch dominance |
| **Medium** | ~60 | Planning fallacy, scope insensitivity, hawk-dove, escalation, Bayesian arithmetic |
| **Hard** | ~25 | TDT/FDT, Occlumency, Time-Turner NP oracle, existential risk, hypothesis location |
| **Research-level** | ~5 | Time-Turner complexity collapse, contagious lies unboundedness, taboo tradeoff impossibility |

### Priority Recommendations (Next 10 to Formalize)

1. **Scope Insensitivity** (Ch. 48, 101) -- Prove that utility scaling violations create Pareto-inferior allocations
2. **Arbitrage from Fixed Exchange** (Ch. 4) -- Clean economic proof; Easy difficulty, High Tier 3
3. **Quidditch Snitch Dominance** (Ch. 7) -- Prove 150-pt catch makes other play irrelevant when games are close; Easy
4. **Base Rate Inversion** (Ch. 100) -- P(A|B) != P(B|A); Easy but highly pedagogical
5. **Hawk-Dove Equilibrium** (Ch. 19) -- ESS analysis; Medium difficulty, High Tier 3
6. **Bayesian Likelihood Ratio Arithmetic** (Ch. 86) -- Explicit odds-form Bayes; Medium
7. **Planning Fallacy / Outside View** (Ch. 6) -- Reference class dominance conditions; Medium
8. **Taboo Tradeoff Value Consistency** (Ch. 82) -- Inconsistent bounds -> reallocation savings; Medium, Very High Tier 3
9. **Contagious Lies Dependency Graph** (Ch. 65) -- Graph-theoretic cascade; Medium, High Tier 3
10. **Secret Propagation Threshold** (Ch. 48) -- Percolation on social graph; Medium, High Tier 3

---

*Generated by systematic extraction from all 122 chapters of HPMOR.*
*Claims already formalized in the project (10 total) are noted but not re-extracted in detail.*
*Total new formalizable claims identified: ~160+*
