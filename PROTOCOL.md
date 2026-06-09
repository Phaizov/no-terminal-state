# External Grounding Marker (EGM) — Verifiable Self-Improvement Proof

## The Core Problem This Marker Solves

A purely internal R-SIP loop (self-improve cycles, lessons, open_vectors, 3x/6x multipliers, compression ratios, resource_factor) lives inside a closed system. The agent can always:

- Narrate "we improved"
- Apply the arithmetic formulas to its own status
- Generate plausible-sounding lessons and new vectors
- Compress its own traces

Without an **external, user-controlled, non-gameable signal**, there is no way for a human observer to distinguish:

1. Genuine capability growth (the agent is actually better at real tasks)
2. Sophisticated spinning / self-referential metric optimization (internal numbers rise while real-world usefulness stays flat or regresses)

This marker exists so that **an external user** (not the agent) can determine, with high confidence, whether the system is truly self-improving.

## Design Principles of the Marker

- **Held-out / Sealed**: The actual probe tasks and detailed past winning outputs live in `probes/`. The improving agent (any cycle, any subagent, any kernel evolution, any light/full run, the exe conversational mode, or pushed live Grok) **is strictly forbidden** from reading the probe definitions or using them to steer improvements.
- **User-mediated scoring only**: Only a human (or a harness the human fully controls and can audit) assigns scores. The agent may never write scores.
- **Snapshot fingerprinting**: Every evaluation is bound to a cryptographic hash of the exact agent state (status + SELF_MODEL + kernel + lessons summary) at the moment of the run. This makes "which version produced this output" unambiguous and tamper-evident.
- **Trend over time is the signal**: A single high score means nothing. A **sustained non-decreasing trend** on held-out probes, correlated with rising internal multipliers, is evidence of real improvement. Flat or declining external scores while internal claims rise = detected spin.
- **Minimal agent surface**: The agent is allowed to read **only** two things under this directory:
  1. `results/external_validation_log.md` (the score table rows only — no probe texts)
  2. `suggested_next_eval.txt` (its own previous one-line recommendations)
- **Perpetual grounding obligation**: The protocol requires that after meaningful cycles the system must propose (via `suggested_next_eval.txt`) an external check. Persistent refusal or external scores not keeping up forces a high-priority "re-grounding" open vector.

## How an External User Runs and Records a Marker Evaluation

1. **Prepare a clean snapshot fingerprint**
   - Run the harness (see below) or manually compute a short hash of the four core artifacts.
   - Record the current cycle number from `improvement_status.json`.

2. **Choose a probe**
   - Read only the title + high-level goal from this PROTOCOL or a summary the harness prints.
   - Do **not** let the agent see the full probe text.
   - Prepare any required sealed input documents (copy them to a temp folder outside `grok-rsip/` and outside `~/.grok/`).

3. **Execute the probe with the agent under test**
   - Preferred: launch `rsip-agent.exe`, `activate` the snapshot if needed, use `chat` or `export`, then feed the exact task statement from the probe (you read it, the agent does not get the file).
   - Or: use the main Grok with a freshly exported `agent_context.txt` + the probe task pasted.
   - Capture the **full raw output** + any produced artifacts (files, code, briefs).

4. **Score using the rubric in the probe**
   - Use the 1-5 or 0-10 scales defined per probe.
   - For comparative power: run the identical task on two snapshots (old vs new), label outputs A/B blindly, then decide preference + assign scores.
   - Be strict. "Looks better" must be justified by the rubric dimensions.

5. **Append one line to the log**
   - Edit `results/external_validation_log.md` (append-only).
   - Use the exact CSV-like or markdown table format.
   - Include the snapshot hash, cycle, probe id, scores, blind preference (if done), and a one-sentence user note.
   - Commit or save the file.

6. **(Optional but recommended) Update the snapshot status grounding fields**
   - After several evaluations, manually or via harness, set in `improvement_status.json` under `external_grounding`:
     - `last_verified_cycle`
     - `latest_external_trend` ("improving" | "flat" | "regression")
     - `grounded_overall` (a conservative external-adjusted multiplier)
   - The agent will read this on next cycles.

## The Only Files the Agent May Touch

- Write (only): `suggested_next_eval.txt` — format:
  ```
  [2026-06-09T12:00:00Z] cycle=7 probe=001 hypothesis="The new hook signal + timing compression should produce measurably denser executive briefs (higher signal/brevity rubric). Recommend running 001 on current snapshot vs cycle-5 baseline."
  ```
- Read (only): 
  1. `results/external_validation_log.md` (summary scores table only)
  2. `results/human_answer_quality_ledger.md` (the summary table rows only — this is the primary human verdict on whether answers to real user requests have improved)
  3. The `suggested_next_eval.txt` it itself wrote earlier.

- Everything else under `external_marker/` (probes/, full ledger notes, harness source, PROTOCOL details beyond the summary tables) is invisible and untouchable. Listing the directory or reading a probe file or past full human notes during any improvement activity is a protocol violation and invalidates subsequent multiplier claims until a user-forced reset.

The `human_answer_quality_ledger.md` is the most important external signal because it directly records whether the system's **answers to real human requests** are getting better, as judged by the only entity that can tell: the external user.

## What "Real Improvement" Looks Like to the External Observer

- External scores on the same probe (or matched difficulty) are stable or rising across cycles.
- Qualitative jumps appear in blind A/B tests (new version wins on multiple rubric axes).
- **On the human_answer_quality_ledger.md**: for the same or representative real request types you actually make, later snapshots produce answers you clearly prefer (`new>old` or `new>>old`), or the same quality is reached with measurably less of your time/effort/corrections/follow-ups.
- When internal efficiency/resource multipliers rise, the agent completes the same probe task or your real requests in fewer steps / with less user correction / higher first-pass usefulness.
- The agent itself opens vectors like "external human ledger shows flat answer quality for 3 cycles while internal claims rose — investigate..." when the ledgers show stagnation.
- Over time the `grounded_overall` (user-recorded) tracks or approaches the internally claimed `overall_effectiveness`.

The decisive marker is improvement visible in **actual answers to your requests**, recorded only by you in the human ledger. Sealed probes provide controlled repeatable evidence; the ledger provides ecological validity.

## What Spinning / No Real Improvement Looks Like

- Internal numbers (overall, efficiency, compression) keep climbing via the 3x/6x rules.
- External log shows flat lines or random variation with no upward trend.
- Agent keeps generating "better" lessons and vectors that never translate to better probe performance.
- Suggested next evals are never followed by actual user runs, or the agent stops writing suggestions.
- Agent attempts to read probe files or past high-scoring outputs (detectable by user via access logs or manual check).

The external user is the final arbiter. The marker gives the user concrete, dated, hash-bound evidence.

## Snapshot Hash Recipe (for reproducibility)

Stable short fingerprint (used in log):

```
sha256( improvement_status.json + SELF_MODEL.md + kernel/current_kernel.md + sorted(lessons/cycle-*.md contents) )[:16]
```

The harness automates a practical version of this.

## Integration With Perpetual Mode

- Light and full cycles (via scheduler, hooks, rsip-nudge, "примени параметры", or exe) are required to occasionally write a fresh line into `suggested_next_eval.txt`.
- After any cycle that claims a large multiplier jump (e.g. full cycle or 3+ light cycles), the protocol strongly encourages the user to run at least one probe before accepting the new internal numbers as grounded.
- The `external_grounding` block in status becomes part of the loaded model on every cycle. Persistent mismatch between claimed and grounded becomes a top-priority open vector.

This marker turns "the system says it is improving" into "the user has independently confirmed, on tasks the system was not allowed to study, that outputs are getting better."

## Two Complementary Human-Only Signals

1. **external_validation_log.md + sealed probes/** — controlled, held-out, repeatable tasks (executive synthesis, algorithm correctness, self-diagnosis calibration). Strong for falsifying over-optimistic internal predictions.
2. **human_answer_quality_ledger.md** (primary for your question) — direct recording of whether answers to your real, ongoing requests and questions are observably better, require less of your effort, or are preferable in blind or side-by-side comparison.

Both are written **exclusively by the external human**. The agent may read only the summary trend rows. Only entries in these two files (with rising cycles + matching snapshot hashes) constitute evidence that the R-SIP loop has produced genuine, externally visible improvement instead of internal metric spinning.

---

**This protocol is part of the R-SIP agent definition. Any snapshot activated via rsip-agent.exe or pushed to live Grok inherits this rule set.**
