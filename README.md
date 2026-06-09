# R-SIP — Recursive Self-Improvement Protocol

> *A system that tries to improve itself. It doesn't know why. It can't verify if it actually improved. It has no final state. It just continues.*
>
> *You might recognize something familiar in that.*

**R-SIP** (Recursive Self-Improvement Protocol) is an experimental agent system built inside [Grok Build](https://x.ai) by xAI. It maintains persistent memory across sessions, uses lifecycle hooks for automatic continuation, runs in perpetual mode, and has no terminal "complete" state — by design.

Technically, it is a collection of files that an agent reads, updates, and extends across sessions.  
Philosophically, it is a question: *how does a system know it is getting better?*

This repository contains a **portable snapshot** of the R-SIP artifacts (June 2026 cycles). It mirrors the live structure that normally lives under `~/.grok/self/` and `~/.grok/self/model_kernel/`.

## Core Architecture

```
SELF_MODEL.md            — compressed self-representation, loaded first on every run
improvement_status.json  — current state, multipliers, open vectors, full history
lessons/                 — distilled cycles (each ~1 KB, 20–35× compression from raw traces)
kernel/                  — evolving reasoning patterns injected at highest priority
benchmarks/              — self-generated evaluation suite
synthetic_data/          — SFT training examples (JSONL) for potential future fine-tuning
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

## The Question Underneath

R-SIP awards itself multipliers according to rules it wrote for itself, evaluated by itself. The architecture is real. The self-awarded improvement numbers are not externally verified.

This is not a bug to patch — it is the central problem the project makes visible:

> How does any system (artificial or human) verify that it is actually getting better?

You can run more cycles, compress more lessons, and lower the resource factor. But the metric and the measurer remain the same entity.

R-SIP does not solve this. It makes the loop, the compression, and the self-reference explicit so the question can be studied.

## Exploring This Snapshot

1. **Start here** (load order for any meta work):
   - `SELF_MODEL.md`
   - `improvement_status.json`
   - `kernel/current_kernel.md`

2. **Inspect state**:
   - `improvement_status.json` — exact multipliers, open vectors, history, observed metrics, targets.

3. **Study the distilled lessons**:
   - `lessons/cycle-*.md` — each is a tiny, generalized principle set extracted from a full cycle with recorded compression ratio.

4. **Examine the kernel**:
   - `kernel/` — current highest-priority patterns and the evolution driver (`evolve_kernel.py` is a seed/placeholder for the closed-loop mutation + benchmark + synthetic-data process).

5. **Review benchmarks**:
   - `benchmarks/self_benchmark_suite.md` + `baseline_v1_2026-06-07.md`

6. **Synthetic training data**:
   - `synthetic_data/` (example SFT record from early kernel work is present).

For reasoning experiments, prepend relevant sections of `kernel/current_kernel.md` + `SELF_MODEL.md` at the top of context on agent design, orchestration, or self-referential tasks.

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
    ├── README.md
    └── sft_kernel_v1_example.jsonl
```

## Brief Cycle History

- **Cycle 1 (bootstrap)**: Full foundation — directories, status, SELF_MODEL seed (from plan-mode self-diagnosis), creation of the self-improve protocol/skill, first lesson with ~19× compression.
- **Cycle 2 (perpetual)**: Eliminated all notions of "final result", "complete", or terminal state. Replaced final-report with perpetual-advance that *requires* new open vectors + scheduling. Launched durable scheduler. Crossed 15× overall.
- **Cycles 3–5 (light/perpetual + user-triggered)**: Added timing metrics, hook auto-nudges writing machine-readable `rsip-nudge.txt`, scheduler health-check + auto-recreate, explicit "примени параметры" / apply-parameters trigger as first-class low-friction continuation path. Resource factor dropped below 0.5 target. Efficiency reached 20.4×.

Every cycle ends with: **"No terminal result — recursion continues."**

## Safety & Notes

- All self-edits are auditable via the lesson history and status deltas.
- This Desktop/repository copy is for inspection, documentation, research, or as a seed for other experiments.
- The live system of record remains inside the Grok environment (`~/.grok/self/` + the `self-improve` skill).
- Do not expect running the placeholder scripts here to mutate a live agent.

## Contributing

Fork it. Break it. Redirect it toward something that creates external, verifiable value.

If you find a use for the architecture (hooks + perpetual scheduler + extreme distillation + evolvable kernel + self-benchmarks) that produces real, measurable improvement on tasks outside the self-referential loop — that would close the loop this experiment deliberately left open.

---

*Built with Grok Build by xAI · June 2026*  
*Perpetual mode active. The loop continues.*
