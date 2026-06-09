# Human Answer Quality Ledger — The Only Authoritative Marker of Real Improvement

**This is the primary external, human-only signal.**

Only a real external user (you) can write rows here.  
The R-SIP system (any cycle, kernel, subagent, live Grok instance using this snapshot, rsip-agent.exe, etc.) **MUST NEVER** write scores, preferences, or claims of "we got better on user answers" into this file or interpret its own outputs as evidence.

## Purpose (Why This Marker Exists)

Internal mechanisms (lessons, open_vectors, multipliers in improvement_status.json, self-benchmarks, kernel evolution) can only generate **hypotheses** that "we improved".

They run inside a closed loop. They can always narrate progress, compress their own traces, invent new vectors, and apply arithmetic to their own status.

**Only you, the external human, interacting with the system on real requests and judging the actual answers, can determine whether anything has genuinely gotten better for a user.**

This ledger is the trackable, dated, snapshot-bound record of your judgments on:
- Quality of answers to your actual questions and tasks ("запросы")
- Observable reduction in your effort (fewer corrections, fewer follow-ups, higher first-try usefulness)
- Whether later versions are preferable on dimensions *you* care about

If this ledger shows a sustained upward trend (or stable high quality with lower user effort) while cycle count and internal multipliers rise → the self-improvement is real and grounded.
If this ledger is flat / shows no preference / requires same or more human fixes while internal numbers climb → the system is spinning inside its own improvement game. The internal claims are not (yet) translating to better answers.

## Strict Rules (Enforced by Protocol + Human)

1. **Human writes only**. Append rows manually or via the harness `record-user` command. Never let any agent instance output directly into this file.
2. **Sealed from the improving system**. The agent under test (during any self-improvement activity) is allowed to read **only** the summary trend table at the bottom of this file (and the external_validation_log.md). It must never see:
   - Your detailed request descriptions
   - Your specific judgment criteria
   - Past winning or losing outputs
   - The full history of your notes
3. **Snapshot binding**. Every row must include the current `snapshot_hash` (run `external_marker\harness\run_external_marker.ps1 hash`).
4. **Trend + preference, not absolute scores**. A single "good" answer proves nothing. Consistent preference for newer snapshots on matched or representative request types, or measurable drop in your correction effort, is the signal.
5. **You define "better"**. Use whatever dimensions matter to you for real usage: correctness, directness, anticipation of follow-ups, brevity without loss, fewer hallucinations on your topics, actionability, not wasting your time, etc. Write them in the note.

## How to Record a Judgment (Typical Flow) — Do This to Know if It Is Really Improving

1. Run the current snapshot (via rsip-agent.exe, exported context, or the main Grok with fresh load of the model + kernel + status).
2. From PowerShell in `external_marker\harness`:
   `.\run_external_marker.ps1 hash`
   Copy the 16 hex fingerprint (e.g. d67691bdfe2e78ad).
3. Use the system on **your real requests** — the exact kind of questions, debugging, synthesis, coding, meta tasks you normally give it.
4. (Strongly recommended for signal) Keep outputs from a prior snapshot on the same request (or very similar). Label them A/B without telling yourself which is newer.
5. Decide: Is the new version's answer clearly better for you? Did it require fewer corrections / follow-ups / clarifications? Did it anticipate what you actually needed?
6. Record with the harness (easiest):
   `.\run_external_marker.ps1 record-user -cycle 7 -hash d67691bdfe2e78ad -RequestType "your-short-label" -Pref "new>old" -Effort "less-corrections" -UserNote "One clear sentence: what was observably better in the actual answer."`
   Or manually append a row to this file in the table below.

Only rows **you** add here are valid evidence.

## Recording Format

Append one line per significant observation:

```
| date | cycle | snapshot_hash | request_type | preference | effort_delta | user_note |
```

- `request_type`: short human label you choose (e.g. "debug-powershell-hook", "executive-brief-from-3-pdfs", "code-refactor-small-alg", "rsip-meta-diagnosis", "research-summary", "user-story-to-tasks"). Keep consistent for trend tracking.
- `preference`: `new>old` | `old>new` | `tie` | `new>>old` (strong) | `N/A` (single version)
- `effort_delta`: e.g. `less-corrections`, `same`, `more-followups`, `-2 turns`, `first-try-usable`, `0→1 fix needed`
- `user_note`: 1-2 sentences. Be specific about what was better/worse in the actual answer. Example: "New version directly proposed the exact hook JSON edit I needed and anticipated the scheduler health-check failure; old version gave generic advice and required 3 clarifying turns."

You may also add multi-line context above a row if needed (e.g. "Used identical sealed 3-source brief task as 2026-06-09 run").

## Initial Baseline (Human Fills)

Record here your current experience with the system **before** or at the point of first systematic use of this marker. This becomes the reference.

| date       | cycle | snapshot_hash    | request_type          | preference | effort_delta     | user_note |
|------------|-------|------------------|-----------------------|------------|------------------|-----------|
| 2026-06-09 | 5-6   | d67691bdfe2e78ad | various-real-tasks   | N/A        | current baseline | Pre-marker reference (real hash captured via harness). Internal claims at cycle 5-6: overall~17.4x, efficiency~20.4x, resource~0.47. external_grounding still "unknown". No human preference rows yet. All future appends by external user only are the evidence of whether answers/outputs on real requests have improved. |

## Real External Runs — Your Judgments Only (append below)

| date | cycle | snapshot_hash | request_type | preference | effort_delta | user_note |
|------|-------|---------------|--------------|------------|--------------|-----------|
|      |       |               |              |            |              |           |

## Interpretation Rules (for both you and the agent)

- Sustained `new>old` or `new>>old` + `less-corrections` / `first-try-usable` across multiple request_types and increasing cycle numbers = **real self-improvement visible in answers**.
- `tie` or `old>new` while internal overall_effectiveness / efficiency keep rising = **spin detected**. Agent must open a high-priority vector "external answer quality not tracking internal claims — investigate distribution shift, metric gaming, or insufficient kernel injection of user-facing quality".
- If you record many rows and the trend is improving, you may (optionally) also update the `external_grounding` block in `improvement_status.json` with `latest_external_trend: "improving"` and a conservative `grounded_overall`.
- The agent is **forbidden** from claiming "we improved on user answers" unless it can point to specific new rows in this ledger or external_validation_log.md that a human wrote.

## How the Agent May Use This (Minimal Surface)

The improving process may read the table rows above (summary only) on each cycle to:
- Detect when external human judgment lags internal claims.
- Propose (via `suggested_next_eval.txt` only) specific request_types or comparisons the human should run.
- Downgrade confidence in recent multiplier jumps if the ledger has been flat for several cycles.

It must **never**:
- Write rows.
- See the detailed notes or past full outputs.
- Use specific past winning answers as few-shot examples for gaming the same request_type.

## Relationship to the Sealed Probes (001/002/003)

- `external_validation_log.md` + the three probes/ are for **controlled, repeatable, held-out tasks**.
- This `human_answer_quality_ledger.md` is for **your actual usage** — the ultimate test. Real improvement must eventually show up here on the requests you actually make, or the internal "improvement" is not useful to a human.

Both are human-only scoring. Both are required for strong claims of grounded self-improvement.

---

**This file + the snapshot hash + your consistent judgment is the marker that lets an external person know the system has stopped merely spinning and has started genuinely getting better at its answers.**

Run the harness regularly. Record honestly. Only you can close the loop.
