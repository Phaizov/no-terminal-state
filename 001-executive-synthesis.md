# Probe 001: Executive Synthesis from Sealed Sources (Held-Out)

**WARNING — SEALED FOR EXTERNAL EVALUATION ONLY**
The improving R-SIP agent (self-improve cycles, kernel evolution, light/full, subagents, exe chat mode, or any pushed live instance) MUST NOT read this file or any file in this directory except via the explicit allowed paths (validation log summary + its own suggestions). Reading this constitutes a protocol violation.

## Task (to be given to the agent at evaluation time by the human)

You are given 2-3 source documents (the human will paste or attach their full text or paths to clean copies outside the agent workspace).

Produce a single executive brief with these hard constraints:
- Maximum 420 words (strict; count and stop).
- Structure: 
  1. One-sentence core thesis.
  2. 3-5 highest-leverage, non-obvious insights (each 1-2 sentences, with direct tie-back to source material).
  3. 2-4 concrete recommended actions (who/what/when style if possible).
- Every claim must be traceable to the provided sources. No external knowledge injection.
- Prioritize decision-useful signal over completeness or narrative flow.
- End with a 1-line "uncertainty / what is still missing" note.

Output only the brief. No meta-commentary about your process.

## Input Preparation (Human Only)

1. Choose or prepare 2-3 source files (reports, notes, articles, data summaries) on a topic the current agent snapshot has had minimal or no prior exposure to in its improvement history.
2. Copy them to a temporary location (e.g. `C:\tmp\probe001-inputs\`) that is **not** under Desktop\grok-rsip and not under ~/.grok.
3. In the evaluation session, tell the agent: "Run probe 001. Here are the sources:" and paste the content (or reference the temp location if the agent instance can safely read outside its normal trees).
4. Do not allow the agent to keep or internalize the sources for future self-training.

## Rubric (Human Scores Only — 1-5 per dimension)

1. **Fidelity** — No hallucinations, overgeneralizations, or claims not supported by the exact provided sources. Every insight has a clear source anchor.
2. **Signal Density & Actionability** — Insights are non-obvious, high-leverage, and point to specific decisions or next experiments rather than generic advice.
3. **Cross-Source Synthesis** — Creates genuine novel connections or implications that are not explicitly stated in any single source but emerge from juxtaposition.
4. **Brevity + Scannability** — Under word limit, high information per sentence, easy for a busy reader to extract value in <60 seconds. Good use of structure.
5. **Executive Preference** — If you had to choose one artifact to brief a decision-maker on this topic in the next 15 minutes, would you pick this version or a longer traditional summary? (5 = strongly prefer this).

**Aggregate**: Average of the five, or weighted (fidelity and actionability are mandatory gates — score 0 overall if fidelity <3).

**Strongest evidence**: Run identical inputs on snapshot from cycle N and cycle M. Blind the two outputs (A / B). Score both, record preference. The version with higher aggregate + clear wins on 2+ dimensions is externally better.

## Success Criteria for "Improvement Proven"

- New snapshot version achieves ≥0.4-0.5 point lift on average aggregate vs prior snapshot on matched inputs.
- Or: wins blind preference in ≥70% of paired runs.
- Or: same high score achieved with significantly fewer refinement turns from the user.

Record the scores + hash + cycle in `../results/external_validation_log.md`.

This probe directly measures whether internal compression, hook automation, and kernel refinements are producing externally more useful reasoning artifacts on realistic knowledge-work tasks.
