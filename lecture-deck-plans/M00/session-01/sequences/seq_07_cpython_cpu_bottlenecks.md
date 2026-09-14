# Sequence Plan: The 3 CPU Bottlenecks of Pure Python

* **Sequence ID:** `seq_07_cpython_cpu_bottlenecks`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 049 – 055
* **Pedagogical Goal:** Anatomize the 3 low-level hardware bottlenecks that make pure Python loops slow for numerical computation (Boxing, Cache Misses, Dynamic Dispatch) and show how SIMD solves them.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: CPU Registers -> L1/L2 Cache -> System DRAM Memory Bus Hierarchy                  │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 049): Benchmark: 28.5s Matrix Multiplication in Python vs 3.8ms in NumPy.         │
│ State 2 (Slide 051): Bottleneck 1: Boxed PyObject (360 MB) vs Unboxed raw C buffer (80 MB).       │
│ State 3 (Slide 052): Bottleneck 2: Pointer chasing causes continuous L1 cache misses.            │
│ State 4 (Slide 053): Bottleneck 3: Dynamic type checking & opcode dispatch on every single iter. │
│ State 5 (Slide 054): NumPy ndarray anatomy: Small metadata struct + contiguous raw buffer.       │
│ State 6 (Slide 055): SIMD AVX-512 vector registers: 8 float64 additions in 1 CPU clock cycle!    │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **CPU Memory Bus:** L1 Cache (4 cycles) vs DRAM (200 cycles) latency bar stays anchored.
2. **Color Palette:**
   - Boxed Python Overhead: Crimson Alert (`#DC2626`)
   - Unboxed NumPy Buffer: Emerald Fast (`#10B981`)
   - SIMD Vector Register: Electric Cyan (`#06B6D4`)

---

## 🎞️ State-by-State Breakdown

### State 1: Memory Layout Contrast
* **Visual:** Top: Python list of 10M pointers pointing to scattered `PyLongObject` structs (360 MB). Bottom: NumPy flat 80 MB array.
* **Delta:** 4.5x memory expansion purely due to CPython object headers.

### State 2: Cache Line Loading
* **Visual:** Hardware CPU cache line (64 bytes).
* **Delta:**
  - Python: Loads 64 bytes of pointers. Each pointer dereferences a different DRAM address $\to$ Cache Stalls!
  - NumPy: Loads 8 contiguous 64-bit floats directly into L1 cache in 1 fetch $\to$ Zero Stalls!

### State 3: SIMD Register Parallelism
* **Visual:** 512-bit ZMM register executing `_mm512_add_pd`.
* **Delta:** 8 floats added simultaneously in a single CPU cycle via compiled BLAS kernels.
