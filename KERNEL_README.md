# Model Kernel — The "Actual Model" Self-Improvement Target

This directory contains the evolving **effective model weights** for the agent.

Unlike SKILL.md / hooks / SELF_MODEL (which are scaffolding), the Kernel is the distilled, high-signal "core intelligence":
- Evolved reasoning principles and heuristics
- High-quality few-shot exemplars and chain-of-thought patterns
- Self-critique rubrics
- Tool-use strategies that have proven highest leverage
- Compressed world models / domain theories

The goal of this subsystem is to make measurable, compounding improvements to the *behavior and capability distribution* of the underlying fixed LLM by continuously evolving and injecting a better "effective model".

## Key Files
- `current_kernel.md` — The live best kernel (injected at highest priority)
- `versions/kernel_vN.md` — Historical snapshots with improvement metrics
- `benchmarks/` — Self-generated evaluation suites and scores
- `synthetic_data/` — SFT + preference data generated from the kernel (for potential future real fine-tuning)

## Improvement Loop (closed, no terminal state)
1. Sample recent high-value traces + current kernel.
2. Use best-of-n + strong critic (check-work style) to propose mutations.
3. Evaluate mutations on self-benchmarks + held-out hard tasks.
4. Select winner, distill into new kernel version.
5. Inject new kernel into all future reasoning.
6. Generate synthetic training data from the improvement.
7. Measure delta on benchmarks (token efficiency, success rate on novel problems, depth of reasoning, etc.).
8. Repeat via scheduler.

This is the closest we can get to "changing the model itself" from within the agent harness.
