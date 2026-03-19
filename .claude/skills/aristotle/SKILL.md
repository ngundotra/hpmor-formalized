---
name: aristotle
description: |
  Submit a Lean proof goal to Harmonic's Aristotle autoformalization service.
  Use when you want to auto-prove a theorem, strengthen an existing result, or formalize a
  natural language claim into Lean 4.
argument-hint: "<proof goal or theorem description>"
user-invocable: true
allowed-tools: Bash, Read
---

# Aristotle Proof Submission

Submit a proof goal to Aristotle for autoformalization.

## Usage

```
/aristotle Prove that the Bayesian posterior is bounded above by 1
/aristotle Strengthen the Bayes module by proving a quantitative convergence bound
```

## Process

1. If `$ARGUMENTS` describes a specific file/theorem, read that file first to
   get the exact theorem statement and surrounding context.

2. Craft a clear natural language prompt for Aristotle. Include:
   - The exact theorem statement from the Lean source
   - The definition of any custom types used
   - What Mathlib imports are available

3. Submit to Aristotle:
   ```bash
   source ~/.zshrc && uv run aristotle submit "$ARGUMENTS" --project-dir .
   ```

4. Report the project ID to the user so they can check on it later:
   ```bash
   source ~/.zshrc && uv run aristotle list --limit 5
   ```

5. If the user wants to wait, use `--wait --destination /tmp/aristotle-output`:
   ```bash
   source ~/.zshrc && uv run aristotle submit "$ARGUMENTS" --project-dir . --wait --destination /tmp/aristotle-output
   ```

## Checking results later

```bash
source ~/.zshrc && uv run aristotle result <project-id> --destination /tmp/aristotle-output
```

## Notes

- Always source `~/.zshrc` to load the `ARISTOTLE_API_KEY`
- Always pass `--project-dir` pointing to the repo root
- Review generated proofs before integrating -- see ACCEPTANCE_CRITERIA.md
