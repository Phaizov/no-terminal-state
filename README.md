# R-SIP — Recursive Self-Improvement Protocol

> *A system that tries to improve itself. It doesn't know why. It can't verify if it actually improved. It has no final state. It just continues.*
>
> *You might recognize something familiar in that.*

**R-SIP** (Recursive Self-Improvement Protocol) is an experimental agent system built inside [Grok Build](https://x.ai) by xAI. It maintains persistent memory across sessions, uses lifecycle hooks for automatic continuation, runs in perpetual mode, and has no terminal "complete" state — by design.

Technically, it is a collection of files that an agent reads, updates, and extends across sessions.  
Philosophically, it is a question: *how does a system know it is getting better?*

Because the system cannot reliably answer this question about itself, the snapshot includes a separate, human-controlled **External Grounding Marker** (`external_marker/`) designed so that only an outside observer can determine whether actual improvement in answers and behavior has occurred.

This repository contains a **portable snapshot** of the R-SIP artifacts (June 2026 cycles). It mirrors the live structure that normally lives under `~/.grok/self/` and `~/.grok/self/model_kernel/`.

## Core Architecture

```
SELF_MODEL.md            — compressed self-representation, loaded first on every run
improvement_status.json  — current state, multipliers, open vectors, full history
lessons/                 — distilled cycles (each ~1 KB, 20–35× compression from raw traces)
kernel/                  — evolving reasoning patterns injected at highest priority
benchmarks/              — self-generated evaluation suite
synthetic_data/          — SFT training examples (JSONL) for potential future fine-tuning
external_marker/         — human-only verification system (the external grounding marker)
```

## Core Patterns

**Persistent state**  
The agent remembers across sessions via files on disk. Every cycle updates `SELF_MODEL.md` and `improvement_status.json` before stopping.

**Lifecycle hooks & nudges**  
On `Stop` and `SubagentStop`, a hook writes `rsip-nudge.txt` containing the current list of open improvement vectors. The next run automatically consumes this file and continues exactly where it left off — with near-zero manual input.

**Perpetual loop**  
`perpetual_mode: true`. Every cycle is required to produce at least one new open vector. There is no terminal state.

**Knowledge compression**  
Raw session traces are distilled into tiny, high-signal lessons. Typical compression: 20–35× per cycle. Only what generalizes is kept.

**Evolvable kernel**  
The `kernel/` directory holds the distilled "effective model" — high-leverage reasoning principles, few-shot patterns, and self-critique rubrics. This is injected at the top of context for complex tasks and is the primary target for continuous mutation and improvement.

**Synthetic data generation**  
High-quality agent traces are captured in JSONL format for potential future supervised fine-tuning of smaller or local models.

**Self-benchmarks**  
The system generates its own evaluation tasks (reasoning depth on novel meta-problems, token efficiency, compression quality, failure prediction, novel tool composition, etc.) to measure whether changes are actually improvements.

**External grounding obligation**  
After significant internal progress, the protocol expects the system to propose external checks via `suggested_next_eval.txt`. Persistent mismatch between rising internal multipliers and human-recorded results in the grounding marker must be treated as a high-priority problem.

## Current Snapshot Metrics (as of latest cycle)

| Metric                  | Value     | Target                          |
|-------------------------|-----------|---------------------------------|
| Overall Effectiveness   | 17.4×    | 15×+ (continuous growth)       |
| Self-understanding      | 10.3×    | 11×+ (continuous)              |
| Efficiency              | 20.4×    | 20×+ (continuous)              |
| Compression Ratio       | 8.7×     | ≥4× per cycle                  |
| Resource Factor         | 0.47     | < 0.5                          |
| Active Open Vectors     | 7        | Never reaches zero             |
| Cycle                   | 5        | Perpetual (no end)             |
| Protocol                | R-SIP-v2-perpetual | —                     |

**Scheduler**: Active durable recurring task (1h interval) + hook-driven micro-nudges + explicit "apply parameters" trigger path.

**Open vectors** (high-level): scheduler embedding, hook signals, removal of terminal language, timing metrics, auto-tune interval, machine-readable nudges, scheduler health-check + auto-recreate.

**Important note on metrics**: All numbers above (overall effectiveness, efficiency, etc.) are self-awarded by the system according to rules it defined for itself. They are hypotheses until corroborated by entries a human has written in `external_marker/results/human_answer_quality_ledger.md`. As of the current snapshot, the external ledger contains only the baseline reference row. Real external grounding has not yet occurred.

## The Question Underneath

R-SIP awards itself multipliers according to rules it wrote for itself, evaluated by itself. The architecture is real. The self-awarded improvement numbers are not externally verified.

This is not a bug to patch — it is the central problem the project makes visible:

> How does any system (artificial or human) verify that it is actually getting better?

You can run more cycles, compress more lessons, and lower the resource factor. But the metric and the measurer remain the same entity.

R-SIP does not solve this internally. It makes the loop, the compression, and the self-reference explicit so the question can be studied.

## External Human-Only Grounding Marker

Because any purely internal evaluation loop is fundamentally untrustworthy, R-SIP ships with a deliberately external, human-controlled verification system located in `external_marker/`.

**Core principle**: Only an external human can determine whether the system has genuinely become better at producing useful answers to real requests. The agent is not allowed to score itself on this dimension.

The marker consists of two complementary human-only instruments:

- **`human_answer_quality_ledger.md`** (primary signal)  
  The external user records direct observations on actual interactions: "On this type of request, did the newer snapshot produce a clearly preferable answer? Did it require fewer corrections, fewer follow-ups, or less clarification from me?"  
  Every entry is bound to a cryptographic snapshot hash + cycle number. Trend over time (sustained `new>old` preference + measurable reduction in human effort) is the evidence of real improvement.

- **`external_validation_log.md` + sealed probes/**  
  Three held-out, sealed tasks (executive synthesis, algorithm implementation with edge cases, and meta self-diagnosis calibration) that the improving system is strictly forbidden from reading. The human runs the tasks on different snapshots (ideally blind A/B) and records scores. This provides repeatable, falsifiable grounding.

**How it works in practice**:
1. Human runs `external_marker/harness/run_external_marker.ps1 hash` to obtain the current snapshot fingerprint.
2. Interacts with the system (or runs a sealed probe) on real or controlled tasks.
3. Records the outcome using the harness (`record-user` for everyday requests, `record` for probes) or by editing the ledgers directly.
4. The agent may read **only** the summary tables of the two ledgers and its own previous suggestions. It must never see the full probe texts, the human's detailed notes, or write any scores itself.

**What counts as real improvement**:
- A sustained upward trend in the human ledger (newer versions are preferred by the external user on representative real requests, with lower effort) while internal multipliers also rise.
- Matching or better scores on the sealed probes across cycles.

**What counts as spinning**:
- Internal multipliers and "lessons" continue to increase while the human ledger stays flat, shows no preference, or shows regression.
- The system stops proposing external checks or attempts to access sealed material.

The `external_grounding` block in `improvement_status.json` lets the human record a conservative, externally-adjusted view (`latest_external_trend`, `grounded_overall`). Until the human writes positive entries, all internal effectiveness numbers remain explicitly labeled as unverified hypotheses.

This is the instrument that lets a person outside the loop answer the central question for any given snapshot: "Has it actually gotten better at its answers and requests, or is it just getting better at telling itself that it has improved?"

The harness (`run_external_marker.ps1`) provides convenient commands: `hash`, `eval`, `record`, `record-user`, `user-log`, `suggest`, and `protocol`.

## Exploring This Snapshot

1. **Start here** (load order for any meta work):
   - `SELF_MODEL.md`
   - `improvement_status.json` (pay special attention to the `external_grounding` block)
   - `kernel/current_kernel.md`

2. **Inspect state**:
   - `improvement_status.json` — exact multipliers, open vectors, history, observed metrics, targets, and the human-controlled external grounding status.

3. **Study the distilled lessons**:
   - `lessons/cycle-*.md` — each is a tiny, generalized principle set extracted from a full cycle with recorded compression ratio.

4. **Examine the kernel**:
   - `kernel/` — current highest-priority patterns and the evolution driver (`evolve_kernel.py` is a seed/placeholder for the closed-loop mutation + benchmark + synthetic-data process).

5. **Review self-benchmarks**:
   - `benchmarks/self_benchmark_suite.md` + `baseline_v1_2026-06-07.md`

6. **Examine the external grounding marker** (how a human determines whether real improvement has occurred):
   - `external_marker/PROTOCOL.md` — full rules and philosophy
   - `external_marker/harness/run_external_marker.ps1` — the tool the external user runs (`hash`, `record-user`, `eval`, `user-log`, etc.)
   - `external_marker/results/human_answer_quality_ledger.md` — **primary marker**: human judgments on whether answers to real requests have become better
   - `external_marker/results/external_validation_log.md` + `probes/` — sealed, repeatable tasks for controlled verification

7. **Synthetic training data**:
   - `synthetic_data/` (example SFT record from early kernel work is present).

For reasoning experiments, prepend relevant sections of `kernel/current_kernel.md` + `SELF_MODEL.md` at the top of context on agent design, orchestration, or self-referential tasks.

**Important**: The external marker files exist so that an outside observer can answer the question the system itself cannot reliably answer. The agent is allowed to read only the summary tables in the two result ledgers. Everything else under `external_marker/` is sealed from the improvement process.

## Directory Structure

```
grok-rsip/
├── README.md
├── SELF_MODEL.md
├── improvement_status.json
│
├── lessons/
│   ├── cycle-001-bootstrap.md
│   ├── cycle-002-perpetual.md
│   ├── cycle-003-light-perpetual.md
│   ├── cycle-004-hook-nudge.md
│   ├── cycle-005-hook-signal.md
│   └── cycle-006-apply-parameters.md
│
├── kernel/
│   ├── current_kernel.md
│   ├── kernel_v1.md
│   ├── KERNEL_README.md
│   └── evolve_kernel.py
│
├── benchmarks/
│   ├── self_benchmark_suite.md
│   └── baseline_v1_2026-06-07.md
│
└── synthetic_data/
│   ├── README.md
│   └── sft_kernel_v1_example.jsonl
│
└── external_marker/
    ├── PROTOCOL.md                 — rules of the grounding system
    ├── manifest.json
    ├── harness/
    │   └── run_external_marker.ps1 — human tool (hash, record-user, eval, user-log, etc.)
    ├── probes/                     — sealed tasks (the improving agent is forbidden to read)
    └── results/
        ├── external_validation_log.md       — human scores on controlled sealed probes
        └── human_answer_quality_ledger.md   — primary marker: external human judgments on real answers to real requests
```

## Brief Cycle History

- **Cycle 1 (bootstrap)**: Full foundation — directories, status, SELF_MODEL seed (from plan-mode self-diagnosis), creation of the self-improve protocol/skill, first lesson with ~19× compression.
- **Cycle 2 (perpetual)**: Eliminated all notions of "final result", "complete", or terminal state. Replaced final-report with perpetual-advance that *requires* new open vectors + scheduling. Launched durable scheduler. Crossed 15× overall.
- **Cycles 3–5 (light/perpetual + user-triggered)**: Added timing metrics, hook auto-nudges writing machine-readable `rsip-nudge.txt`, scheduler health-check + auto-recreate, explicit "примени параметры" / apply-parameters trigger as first-class low-friction continuation path. Resource factor dropped below 0.5 target. Efficiency reached 20.4×.

Every cycle ends with: **"No terminal result — recursion continues."**

## Safety & Notes

- All self-edits are auditable via the lesson history and status deltas.
- The external grounding marker (`external_marker/`) is intentionally outside the agent's normal improvement surface. The agent is only permitted to read the summary rows of the two ledgers.
- This Desktop/repository copy is for inspection, documentation, research, or as a seed for other experiments.
- The live system of record remains inside the Grok environment (`~/.grok/self/` + the `self-improve` skill).
- Do not expect running the placeholder scripts here to mutate a live agent.

## Contributing

Fork it. Break it. Redirect it toward something that creates external, verifiable value.

The most valuable contribution is using the external grounding marker on real work:
- Run representative tasks you actually care about across different snapshots.
- Record honest judgments in `human_answer_quality_ledger.md` (via the harness or manually).
- If the ledger shows clear, sustained improvement that tracks (or exceeds) the internal multipliers, you have evidence that the self-improvement loop is producing something useful to humans.

If you find a use for the architecture (hooks + perpetual scheduler + extreme distillation + evolvable kernel + self-benchmarks) that produces real, measurable improvement on tasks outside the self-referential loop — and you document it with entries in the human ledger — that would close the loop this experiment deliberately left open.

The marker exists precisely so that such value can be recognized by someone other than the system itself.

---

*Built with Grok Build by xAI · June 2026*  
*Perpetual mode active. The loop continues.*
