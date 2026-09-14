# Sequence Plan: Pointer Memory Model & Object Allocation

* **Sequence ID:** `seq_01_pointer_memory_model`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 008 – 013
* **Pedagogical Goal:** Dispel the naive "variable as a value box" misconception and establish the CPython pointer-to-heap-`PyObject` mental model.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: Stack Frame (Names/Addresses) on Left | Heap RAM (PyObjects) on Right            │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 008): Naive box model vs Stack pointer pointing to Heap object address.           │
│ State 2 (Slide 009): Anatomy of PyObject (ob_refcnt=1, ob_type=int, ob_ival=42) [28 bytes].     │
│ State 3 (Slide 010): Code `x = 42` -> Arrow from stack name `x` to heap address `0x100A`.       │
│ State 4 (Slide 011): Code `x = "hello"` -> Stack pointer `x` moves to `0x200B`; refcount of 42=0 │
│ State 5 (Slide 012): Equality `==` (__eq__) compares values; Identity `is` compares pointers.   │
│ State 6 (Slide 013): CPython Small Integer Pool [-5, 256] optimization singletons.              │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **Memory Coordinates:** Stack box `x` stays fixed at $(x=100, y=300)$ across States 1–4.
2. **Color Palette:**
   - Stack Pointers: Cyan (`#00FFFF`)
   - `PyObject` Header (`ob_refcnt`, `ob_type`): Indigo (`#4B0082`)
   - Heap Data Payload: Emerald (`#10B981`)
   - Deallocated / Zero Refcount: Crimson (`#EF4444`) with dashed border.

---

## 🎞️ State-by-State Breakdown

### State 1: Naive Box vs Pointer Model
* **Visual:** Split comparison.
* **Delta:** Contrasting a literal cardboard box containing `42` with an arrow pointing from stack address `0x7fff40` to heap `0x100A`.
* **Annotation:** *"Variables store memory addresses, never raw values."*

### State 2: Inside the Heap (`PyObject`)
* **Visual:** Zoom into heap address `0x100A`.
* **Delta:** Expand into 3 memory slots:
  - `ob_refcnt` (8 bytes) = `1`
  - `ob_type*` (8 bytes) = `0x7fff_type_int`
  - `ob_ival` (8+ bytes) = `42`
* **Annotation:** *"Total size: 28 bytes for an 8-byte number."*

### State 3: Rebinding Execution (`x = "hello"`)
* **Visual:** Stack name `x` remains in place; pointer arrow detaches from `0x100A` and connects to `0x200B`.
* **Delta:** Old object `0x100A` turns crimson (`ob_refcnt = 0`). New object `0x200B` (`PyUnicodeObject`) lights up green.
* **Annotation:** *"The variable did not change type. The variable repointed to a new object."*
