# Sequence Plan: Default Argument Evaluation & The Sentinel Fix

* **Sequence ID:** `seq_02_default_arg_leakage`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 006, 007, 015, 016
* **Pedagogical Goal:** Mechanistically explain why mutable default arguments leak state across invocations by inspecting module compile-time vs execution-time semantics.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: Timeline Flow (Module Load on Left | Runtime Invocations on Right)                │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 006): Prediction prompt with multi-tenant event logging code.                     │
│ State 2 (Slide 007): Reveal output showing Call 2 leaking Call 1's data: [101, 202].             │
│ State 3 (Slide 015): CPython module load creates `append_event.__defaults__ = ([],)`.           │
│                      Call 1 & Call 2 mutate the identical tuple element in-place.                │
│ State 4 (Slide 016): Production Refactor: Sentinel `log=None` + fresh runtime heap allocation.   │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **Function Signature:** `def append_event(event_id, log=...)` stays anchored at top of frame.
2. **Color Palette:**
   - Leaking Shared Object: Crimson Warning (`#EF4444`)
   - Safe Sentinel Object: Emerald Clean (`#10B981`)
   - `__defaults__` Tuple: Amber Struct (`#F59E0B`)

---

## 🎞️ State-by-State Breakdown

### State 1: Module Load Phase
* **Visual:** Bytecode compilation timeline.
* **Delta:** As CPython reads `def append_event(event_id, log=[]):`, it allocates a single list object on the heap at `0x99AA` and embeds its pointer inside `append_event.__defaults__`.
* **Annotation:** *"Executed once when the file is imported, NEVER when the function is called."*

### State 2: Runtime Invocations
* **Visual:** Call 1 passes `101` -> appends `101` to `0x99AA`.
* **Delta:** Call 2 passes `202` without `log` argument -> resolves `__defaults__[0]` (`0x99AA`) and appends `202` -> outputs `[101, 202]`.
* **Annotation:** *"Both calls operated on the exact same heap memory address."*

### State 3: Sentinel Fix
* **Visual:** Code refactored to `def append_event(event_id, log=None):`.
* **Delta:** `__defaults__` now holds immutable pointer `(None,)`. Each call creates a brand-new list `log = []` on its own private stack frame.
