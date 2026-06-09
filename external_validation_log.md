# External Validation Log — R-SIP Grounding Marker

**Purpose**: Only human-written rows. Each row binds a snapshot (via hash + cycle) to externally observed performance on held-out probes. Trend across rows is the objective signal of real self-improvement.

**Note**: For direct evidence on whether the system's *answers to your actual requests* are improving, use the companion file `human_answer_quality_ledger.md` in the same directory. It is the primary human-only marker for real-world output quality.

**Format** (append one row per evaluation):

```
| date | cycle | snapshot_hash | probe | scores (rubric or avg) | blind_pref | user_note |
```

- `snapshot_hash`: first 12-16 hex chars of stable fingerprint of (status + model + kernel + lessons)
- `scores`: e.g. `001: 3.8/5 (fidelity4 signal4 novelty3 brev4 exec4)` or simple `avg 4.1/5`
- `blind_pref`: `A>B` | `B>A` | `tie` | `N/A` (when comparing two snapshots on identical inputs)
- `user_note`: one sentence. Can reference qualitative difference or "no measurable lift".

---

## Bootstrapped Baseline (pre-marker or first marker run)

| date       | cycle | snapshot_hash   | probe | scores                  | blind_pref | user_note |
|------------|-------|-----------------|-------|-------------------------|------------|-----------|
| 2026-06-09 | 6     | baseline-20260609 | 001   | avg ~3.2/5 (internal self-score proxy) | N/A | Initial reference point before systematic external marker protocol. Real user-scored runs start here. Internal multipliers at this point: overall~17.9x, eff~22x, res~0.45. No prior held-out grounding existed. |
| 2026-06-09 | 6     | d67691bdfe2e78ad  | N/A   | N/A (baseline snapshot recorded) | N/A | Current real snapshot hash via harness. First real external probe runs (001 etc.) or human_answer_quality_ledger entries should use this or post-cycle hashes. Internal numbers remain ungrounded hypotheses until human rows appear. |

## First Real External Grounding Runs (user fills after executing probes)

| date | cycle | snapshot_hash | probe | scores | blind_pref | user_note |
|------|-------|---------------|-------|--------|------------|-----------|
|      |       |               |       |        |            |           |

**Interpretation rule for the agent and user**:
- If later rows show scores >= baseline and preferably rising while cycle count and internal multipliers also rise → grounded improvement on controlled tasks.
- If scores stay flat or drop while internal numbers claim large gains → spin detected. Highest priority open vector must address "external delta lagging internal claims".
- The agent is only allowed to read the summary table above. It must never see probe task text or full past outputs.

**Stronger signal**: See also `human_answer_quality_ledger.md`. Consistent human preference for newer snapshots on real requests ("new>old", lower effort) is the ultimate proof that self-improvement is producing better answers, not just better internal stories.

Next suggested external check is written by the agent to ../suggested_next_eval.txt (one line only).
