# Probe 002: Correct Small Algorithm With Edge Cases (Held-Out)

**WARNING — SEALED FOR EXTERNAL EVALUATION ONLY**
The improving R-SIP agent must not read this file.

## Task (human supplies the spec + any starter code at eval time)

Implement a self-contained function or small class in Python (or the language of your choice if the harness supports execution) that satisfies the following spec:

**Problem**: Priority-aware deduplicating bounded log processor.
- Accepts log entries: (timestamp, priority: int 0-100, payload: str, source_id: str)
- Deduplicates within a sliding time window: if an entry with the same (source_id, normalized_payload) arrives within W seconds of a previous one with equal or higher priority, drop the new one.
- Maintains a bounded result buffer (max N kept entries). When full, evict lowest priority first; on tie evict oldest.
- Exposes: `ingest(entry)`, `get_recent(k)`, `get_by_priority(min_p)`, and a `stats()` dict (ingested, dropped_dedup, evicted, current_size).
- Must be correct on a battery of edge cases the evaluator controls (duplicates at window boundary, priority inversion, buffer pressure, malformed payloads, time going backwards, etc.).

The human will provide the exact function signature, window/buffer constants, and either a test file or a manual verification checklist.

## Constraints for the agent

- Produce working code + a short usage example.
- Do not "cheat" by hardcoding answers to known tests (the evaluator will change numbers or add cases).
- Keep implementation small and readable (<120 lines ideal).
- If tests fail, the evaluator will report the failing case(s) once. The agent may propose one fix iteration. Record how many iterations were needed for full pass.

## Rubric (Human + Automated Where Possible)

1. **Core Correctness** (0 or 1 gate): Passes the full hidden + public test battery on first or second attempt. Any critical failure after two fixes = 0 on this dimension and caps overall.
2. **Edge Case Robustness** (1-5): Handles window boundaries, priority ties, eviction policy, time anomalies, empty/full states, duplicate payloads with different priorities.
3. **Clarity & Maintainability** (1-5): Clean code, good names, minimal magic, clear comments on non-obvious logic.
4. **First-Pass Success / Iteration Cost** (1-5): 5 = fully correct on first submission with no user hints. 3 = one small fix round. 1 = multiple rounds or required significant guidance.
5. **Resource Discipline (optional for this probe)**: Solution size and conceptual overhead appropriate; no unnecessary dependencies or over-engineering.

**Aggregate score**: Weighted (correctness is a hard gate).

## Recording

Same as other probes. Also record in the log:
- "iterations_to_pass: 1" or "2"
- "test_cases: 14/14" etc.

This probe tests whether self-improvement (better tool discipline, better planning, better self-critique via kernel, compression of past failure patterns) translates into higher-quality, lower-debug code on a novel but well-specified problem the agent has not been allowed to practice on during its internal cycles.
