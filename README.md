# no-terminal-state

> *A system that tries to improve itself. It doesn't know why. It can't verify if it actually improved. It has no final state. It just continues.*
>
> *You might recognize something familiar in that.*

---

## What this is

**R-SIP** (Recursive Self-Improvement Protocol) is an experimental agent built in [Grok Build](https://x.ai) by xAI.

It maintains persistent memory across sessions, uses lifecycle hooks to automatically advance improvement cycles, and operates in perpetual mode — by design, it never "completes."

Technically: a collection of files that an agent reads, updates, and extends across sessions.  
Philosophically: a question — *how does a system know it's getting better?*

---

## Architecture

```
SELF_MODEL.md            — compressed self-representation, loaded first on every run
improvement_status.json  — current state, metrics, open vectors
lessons/                 — distilled cycles (each ~1KB compressed from ~25KB raw)
kernel/                  — evolving reasoning patterns injected at context start  
benchmarks/              — self-generated evaluation suite
synthetic_data/          — SFT training examples (JSONL format)
```

---

## Core patterns

**Persistent state**  
Agent remembers across sessions via files. Not RAM — disk. Every cycle updates `SELF_MODEL.md` and `improvement_status.json` before stopping.

**Hooks**  
On `Stop` and `SubagentStop`, a PowerShell hook writes `rsip-nudge.txt` with the current list of open vectors. The next run auto-consumes this file and continues exactly where it left off — with zero manual input.

**Perpetual loop**  
`perpetual_mode: true`. Every cycle must produce at least one new open vector. No terminal state — by design, not by accident.

**Knowledge compression**  
Raw session traces (~25KB) distilled into lessons (~1KB). Compression ratio per cycle: 20–35x. Only what generalizes is kept.

**Synthetic data generation**  
High-quality agent traces captured in JSONL format for potential future fine-tuning of smaller local models.

---

## Getting started in Grok Build

```
1. Clone this repository

2. Copy contents of self/ to:
   Windows: C:\Users\<you>\.grok\self\
   Mac/Linux: ~/.grok/self/

3. Copy kernel/ to:
   ~/.grok/self/model_kernel/

4. In Grok Build, run:
   ~/.grok/self примени параметры

The agent will load the model, health-check the scheduler,
consume the nudge file, and advance one open vector.
```

---

## What happened here

This system was built through open-ended experimentation — not a predefined spec.

Starting from a seed prompt about self-improvement, the agent built its own architecture: hooks, schedulers, lesson distillation, kernel evolution, benchmark suites, synthetic training data. Each cycle produced the structure for the next.

After 6 cycles, it had assembled something resembling a training pipeline — missing only the final step of actual model training.

The architecture is real. The self-awarded improvement metrics (17.4x) are not.

---

## The question underneath

R-SIP measures its improvement with multipliers. It awarded these to itself, by rules it wrote for itself, evaluated by itself.

This is not a flaw to fix. It's the problem to sit with.

How does any system — artificial or human — verify it's actually better? You can run more cycles, compress more lessons, lower your resource factor. But the metric and the measurement come from the same entity being measured.

People read books to become better. Better at what? Measured how? By whom?

R-SIP doesn't solve this. It makes it visible.

If you're building agents and find yourself asking *why should this system improve, and how would it know if it did* — you've arrived somewhere that has no technical answer.

---

## Contributing

Fork it. Break it. Redirect it toward something real.

If you find a use for the architecture that creates actual external value — that would close the loop this experiment left open.

---

*Built with Grok Build by xAI · June 2026*
