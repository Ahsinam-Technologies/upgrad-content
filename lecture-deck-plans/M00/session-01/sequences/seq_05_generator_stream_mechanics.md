# Sequence Plan: Generator Stream Processing & State Suspension

* **Sequence ID:** `seq_05_generator_stream_mechanics`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 034 – 036
* **Pedagogical Goal:** Contrast eager memory materialization with lazy iterator frame suspension using `yield`.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: Memory Consumption Graph & Call Frame Execution Stack                             │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 034): Eager List Comprehension -> 10M integers materialized in RAM (450 MB).      │
│ State 2 (Slide 035): Lazy Generator Expression -> 1 integer generated on-demand (8.4 KB).        │
│ State 3 (Slide 036): Inside `yield`: Frame suspension, bytecode pointer freezing, StopIteration. │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **Dataset Size:** $N = 10,000,000$ integers across both approaches.
2. **Color Palette:**
   - Eager RAM Spike: Severe Crimson (`#DC2626`)
   - Lazy Stream: Cool Cyan (`#06B6D4`)
   - Frozen Bytecode Frame: Amber Pause (`#F59E0B`)

---

## 🎞️ State-by-State Breakdown

### State 1: Eager List Materialization
* **Visual:** RAM usage bar chart spiking to 450 MB.
* **Delta:** Python loops over range, creates 10M separate `PyLongObject` instances, and populates a 10M-pointer array simultaneously.

### State 2: Lazy Generator Stream
* **Visual:** Constant 8.4 KB RAM footprint flatline.
* **Delta:** Generator object created with pointer to code object and local variable dictionary. Only 1 item exists in memory at any single instant.

### State 3: The `yield` Suspension Machine
* **Visual:** Function bytecode instruction pointer trace.
* **Delta:**
  - `next()` called $\to$ Execution advances to `yield val` $\to$ Returns `val`.
  - Stack frame is detached and frozen on heap (instruction pointer saved).
  - Subsequent `next()` resumes execution immediately after `yield` line.
  - Final return raises `StopIteration`.
