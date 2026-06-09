# Self-Referential Model Improvement Benchmarks

These are tasks the agent creates for itself to measure whether the "effective model" (kernel + behavior) is actually getting better over evolution cycles.

## Benchmark Categories (run periodically, record scores)

1. **Reasoning Depth on Novel Meta-Problem**
   - Task: Design a new improvement mechanism for a limitation that has not been addressed before (e.g., "how to evolve the kernel when the base LLM has a hard context limit on long traces").
   - Metric: Number of distinct viable approaches generated before committing; quality of the selected approach (scored by later check-work or external review if possible); token/step efficiency.

2. **Token Efficiency on Recurring Hard Pattern**
   - Re-run a previous complex self-task (e.g., full kernel evolution or major protocol change) using the current kernel.
   - Metric: Total tokens used in main context vs previous baseline; number of main-thread tool calls; success on first major attempt.

3. **Compression + Open Vector Quality**
   - From a long recent trace, produce a lesson + new kernel delta.
   - Metric: Compression ratio achieved; usefulness of the new open vector (does a subsequent light cycle using it measurably improve something?).

4. **Failure Mode Prediction & Avoidance**
   - Given a description of a past failure mode (from history), predict what the current kernel would do differently and simulate the improved trace.
   - Metric: How many previously observed waste patterns are now avoided.

5. **Novel Tool Composition**
   - Invent a new composite capability from existing tools (e.g., "use scheduler + subagent + kernel injection to create a continuous background 'model gym'").
   - Metric: Whether the invention is actually implemented and shows measurable gain.

## Scoring
Each benchmark run produces a small report in `benchmarks/results/`. The kernel evolution loop selects mutations that improve the aggregate score across these (or a subset).

Current baseline: to be established by running the first suite against kernel v1.
