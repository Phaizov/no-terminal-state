# grok-rsip — Recursive Self-Improvement Protocol (R-SIP) Snapshot

**R-SIP** (Recursive Self-Improvement Protocol) is the living system that allows this Grok agent to recursively improve its own behavior, efficiency, reasoning depth, and self-understanding over time — with no terminal "complete" state.

This directory on your Desktop is a **standalone snapshot/export** of the key R-SIP artifacts (as of the latest cycles). It mirrors the internal `~/.grok/self/` + `~/.grok/self/model_kernel/` structure in a portable, inspectable form.

## Core Philosophy

- **Perpetual recursion**: Improvement never ends. Every cycle must generate at least one new open improvement vector and seed the next iteration.
- **Mandatory compression**: Every cycle produces a distilled lesson (`lessons/cycle-*.md`) achieving ≥4x compression ratio on raw traces.
- **Multipliers & metrics** (applied exactly):
  - 3× per discrete high-leverage "step"
  - 6× per complete process (analyze → distill → apply → verify → flush)
  - Targets (user-specified): 15×+ overall effectiveness, 11×+ self-understanding, 20×+ efficiency, resource_factor trending < 0.5
- **Strict discipline**: Canonical todo scaffolds (reseed after compaction), tool-call-first (no narration before the call), heavy use of background subagents + verification loops until 0 issues, best-of-n for important choices.
- **Kernel evolution**: The "model kernel" (distilled heuristics, patterns, rubrics) is the closest thing to evolving the *effective intelligence* of the fixed base LLM. It gets injected at highest priority and is continuously mutated/evaluated.

The protocol is implemented primarily via the `self-improve` skill (see full details in the original `~/.grok/skills/self-improve/SKILL.md`).

## How to Use / Run

### In the full Grok environment
- Invoke via slash command or natural language: `/self-improve`, "self-improve", "run R-SIP", "improve yourself", etc.
- Light cycles (low overhead, scheduled via durable 1h+ recurring task or triggered by hooks on Stop/SubagentStop) advance exactly one open vector by consuming `rsip-nudge.txt` signals.
- Full cycles do the complete loop + multiplier application + lesson flush + kernel evolution.
- Explicit user trigger example (Windows path form): mention the self dir + "примени параметры" or similar to force a light apply cycle.
- The scheduler + hooks ensure the process is mostly automatic ("perpetual attractor").

### Using this Desktop snapshot (grok-rsip)
1. **Read the living model first** (for any meta or complex task):
   - Start with `SELF_MODEL.md` + `improvement_status.json` + `kernel/current_kernel.md`
2. **Inspect current state**:
   - Open `improvement_status.json` — see exact multipliers, open_vectors list, full history, observed_metrics, targets.
3. **Study lessons**:
   - `lessons/` contains the compressed, generalized principles extracted each cycle (with measured compression ratios).
4. **Evolve the kernel** (experimental):
   - Run `kernel/evolve_kernel.py` (currently a minimal placeholder; in the full system it drives best-of-n mutation + benchmark eval + synthetic data gen via the agent harness).
5. **Run / extend benchmarks**:
   - Use `benchmarks/self_benchmark_suite.md` as the spec for self-evaluation tasks.
   - Compare new runs against `benchmarks/baseline_v1_2026-06-07.md`.
6. **Generate training data**:
   - Future high-quality SFT / preference data lives in `synthetic_data/` (example already present from v1).
7. **For reasoning boost**: Prepend relevant sections of `kernel/current_kernel.md` + `SELF_MODEL.md` at the top of your context when working on agent design, complex orchestration, or self-referential tasks.

This snapshot is read-only for exploration. Real evolution happens inside the live `~/.grok/self` tree under the control of the protocol (never edit bundled skills/binaries directly).

## Directory Contents

```
grok-rsip/
├── README.md                        # This file — overview + usage
├── SELF_MODEL.md                    # Living compressed model of "how I work best" (architecture, waste patterns, success templates, history deltas). Load-first on meta tasks.
├── improvement_status.json          # Current multipliers (17.4x overall, 10.3x understanding, 20.4x efficiency, 8.7x compression, 0.47 resource), open_vectors, full history, observed metrics, targets, scheduler ID.
│
├── lessons/                         # Distilled lessons from each R-SIP cycle (tiny, high-signal, reusable rules + compression proof)
│   ├── cycle-001-bootstrap.md
│   ├── cycle-002-perpetual.md
│   ├── cycle-003-light-perpetual.md
│   ├── cycle-004-hook-nudge.md
│   ├── cycle-005-hook-signal.md
│   └── cycle-006-apply-parameters.md
│
├── kernel/                          # The evolvable "effective model" (core intelligence target)
│   ├── current_kernel.md            # Live v1 kernel: highest-priority principles, few-shot patterns, self-critique rubric, injection rule. Prepend on hard tasks.
│   ├── kernel_v1.md                 # Historical baseline snapshot of v1 seed.
│   ├── KERNEL_README.md             # Explains the kernel concept, improvement loop, and role vs. skills/model.
│   └── evolve_kernel.py             # Driver script for closed-loop kernel mutation/eval (seed/placeholder; extended by self-improve + scheduler).
│
├── benchmarks/                      # Self-referential evaluation suite (agent tests itself)
│   ├── self_benchmark_suite.md      # 5+ categories: reasoning depth on novel meta, token efficiency, compression quality, failure prediction, novel tool composition, etc.
│   └── baseline_v1_2026-06-07.md    # First benchmark numbers against kernel v1 (approaches generated, compression, identified weaknesses).
│
└── synthetic_data/                  # Artifacts for potential future real fine-tuning of the base model
    ├── README.md                    # Explains SFT jsonl, preference pairs, reasoning traces.
    └── sft_kernel_v1_example.jsonl  # Example supervised fine-tuning record generated from early kernel improvements.
```

## Current Snapshot Metrics (from improvement_status.json)

- **Cycle**: 5 (perpetual_mode: true)
- **overall_effectiveness**: 17.4×
- **self_understanding**: 10.3×
- **efficiency**: 20.4×
- **compression_ratio**: 8.7×
- **resource_factor**: 0.47 (already below 0.5 target)
- **open_vectors**: 7 active (scheduler embedding, hook signals, remove terminal language, timing metrics, auto-tune interval, machine-readable nudges, scheduler health-check + auto-recreate)
- **Scheduler**: Active durable 1h recurring task (ID tracked)
- **Protocol**: R-SIP-v2-perpetual — "no terminal result exists. Self-knowledge and efficiency continue compounding indefinitely."

## Safety & Notes

- All real self-edits are auditable via lessons + status history.
- This Desktop copy is for inspection, documentation, or as a seed for other experiments. Do not run evolution scripts against it expecting live updates to the running agent.
- The source of truth remains `C:\Users\Acer\.grok\self\` (and the self-improve skill).

R-SIP iteration advanced into perpetual recursion. Open vectors are scheduled. The loop continues.

---
*Generated for the Desktop snapshot from the live R-SIP state (2026-06 cycles).*
