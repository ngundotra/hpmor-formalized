# hpmor-formalized

Or: what happens when Harry James Potter-Evans-Verres acquires a proof assistant and decides that "because it would be embarrassing to be wrong" should scale all the way up to metaphysics.

This project formalizes pieces of [Harry Potter and the Methods of Rationality](https://hpmor.com) in Lean 4. The premise is simple:

> If a claim is important enough to base a plan on, it is important enough to try proving.

So we take bits of HPMOR that sound like they ought to survive contact with mathematics, and we ask Lean to be the stern voice of reality.

## What Is In Here?

At the moment, the project is a small library of formal experiments inspired by Harry's favorite habits:

- Updating on evidence instead of clinging to priors.
- Treating game theory as something more than a conversational prop.
- Refusing to accept time travel unless it can be made to behave itself.
- Looking at a dramatic claim and asking, "Fine. What are the axioms?"

Some modules are serious proofs. Some are scaffolding for future work. All of them are trying, in one way or another, to cash out rationality in the unforgiving currency of type theory.

## Current Adventures

### Time Travel, Unfortunately

The strongest part of the project so far lives in `TimeTravel`.

- [`HpmorFormalized/TimeTravel/Novikov.lean`](HpmorFormalized/TimeTravel/Novikov.lean) formalizes a version of Novikov self-consistency: finite time loops must settle into a paradox-free periodic story.
- [`HpmorFormalized/TimeTravel/Paradox.lean`](HpmorFormalized/TimeTravel/Paradox.lean) models a toy paradox and gives the universe permission to cheat in exactly the way required to avoid contradiction.

In other words: the Time-Turner does not get to shrug and create nonsense. The universe is allowed to be strange. It is not allowed to be inconsistent.

### Bayesian Updates Like a Civilized Person

[`HpmorFormalized/Bayes/Basic.lean`](HpmorFormalized/Bayes/Basic.lean) formalizes the classic HPMOR lesson from early chapters: even a tiny prior can be overwhelmed by sufficiently strong evidence.

McGonagall turns into a cat. Your prior objects. Bayes has no sympathy.

This module has the core setup and several basic results, with some of the more interesting analysis still to be completed.

### Future Conquests

[`HpmorFormalized/DecisionTheory/Basic.lean`](HpmorFormalized/DecisionTheory/Basic.lean) and [`HpmorFormalized/GameTheory/Basic.lean`](HpmorFormalized/GameTheory/Basic.lean) are the beginnings of a larger campaign:

- prisoner's dilemma and precommitment
- bargaining and Nash-style reasoning
- credible threats
- the general proposition that "planning ahead" should perhaps not be considered exotic

Right now these modules are more promise than empire. That is acceptable. The point of a roadmap is that reality has not yet been bullied into compliance.

## Why This Exists

Because HPMOR is full of claims that invite escalation.

Not "that sounds clever."

Not "I agree with the vibe."

Not even "this would make a good LessWrong comment thread."

The interesting question is whether the ideas can survive formalization. Can the informal arguments be made explicit? Can the hidden assumptions be exposed? Can the dramatic speeches be translated into definitions, lemmas, and theorems?

That is what this repo is for.

## Build

Requires [elan](https://github.com/leanprover/elan), which installs Lean and `lake`.

```bash
git clone https://github.com/ngundotra/hpmor-formalized.git
cd hpmor-formalized
lake exe cache get
lake build
```

If all goes well, Lean will verify the current state of the project with considerably less enthusiasm than Harry would display while explaining why this is obviously the correct use of his time.

## Aristotle (Autoformalization)

This project integrates with [Harmonic's Aristotle](https://aristotle.harmonic.fun) for automated proof generation. Aristotle can take a natural language proof goal and produce verified Lean 4 code against our Mathlib version.

### Setup

1. Get an API key at [aristotle.harmonic.fun/dashboard/keys](https://aristotle.harmonic.fun/dashboard/keys)
2. Add to your shell config: `export ARISTOTLE_API_KEY=<your-key>`

### Usage

```bash
# Submit a proof goal
uv run aristotle submit "Prove that the posterior L*e/(L*e+(1-e)) tends to 1 as L tends to infinity" --project-dir .

# Check status
uv run aristotle list --limit 5

# Download results (returns a tarball)
uv run aristotle result <project-id> --destination /tmp/result.tar.gz

# Extract and inspect
mkdir -p /tmp/result && tar xzf /tmp/result.tar.gz -C /tmp/result
cat /tmp/result/.tar_aristotle/ARISTOTLE_SUMMARY_*.md
```

### Claude Code integration

If using [Claude Code](https://claude.com/claude-code), an Aristotle agent and `/aristotle` skill are available in `.claude/`. Agents can submit proofs, poll for results, and integrate generated code automatically.

## Contributing

Contributions are welcome, especially if you enjoy any of the following:

- filling in `sorry`s
- formalizing a new HPMOR claim
- turning vague rationalist gestures into explicit mathematics
- stress-testing HPMOR claims and reporting what formalization reveals

See [CONTRIBUTING.md](CONTRIBUTING.md) and [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md).

## References

- [HPMOR full text](https://hpmor.com)
- [Mathlib4 docs](https://leanprover-community.github.io/mathlib4_docs/)
- [Lean 4 documentation](https://lean-lang.org/lean4/doc/)
- [Aristotle autoformalization](https://aristotle.harmonic.fun)
