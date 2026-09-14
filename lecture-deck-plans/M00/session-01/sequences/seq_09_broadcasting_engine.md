# Sequence Plan: The NumPy Broadcasting Engine & Multi-Dimensional Array Math

* **Sequence ID:** `seq_09_broadcasting_engine`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 059 – 062, 064 – 065
* **Pedagogical Goal:** Master the 2 broadcasting invariants, virtual stride 0 expansion, and 3D pairwise distance calculation without loops.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: Trailing Dimension Alignment Grid -> Virtual Memory Strides -> Vectorized Math   │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 059): Problem Motivation: Normalizing (1000, 50) matrix by (50,) mean vector.      │
│ State 2 (Slide 060): 2 Rules of Broadcasting: Right-to-Left alignment & Compatibility test (1/eq).│
│ State 3 (Slide 061): Virtual Strides: Dimension expanded with stride=0 (zero memory allocated).   │
│ State 4 (Slide 062): Failure Mode: Accidental outer product (100k, 1) + (1, 100k) blows 80 GB RAM!│
│ State 5 (Slide 064): Transfer Challenge: 3D pairwise distance vectorization without loops.       │
│ State 6 (Slide 065): Solution: X[:, None, :] - C[None, :, :] broadcasted in (M, N, d).           │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **Dimension Alignment Grid:** Right-to-left alignment columns stay visually locked.
2. **Color Palette:**
   - Dimension Match: Emerald Compatible (`#10B981`)
   - Singleton Dimension 1: Sky Expandable (`#0284C7`)
   - Incompatible Mismatch: Crimson Error (`#DC2626`)
   - Virtual Stride 0: Amber Zero (`#F59E0B`)

---

## 🎞️ State-by-State Breakdown

### State 1: Right-to-Left Alignment Rule
* **Visual:** Shape matching grid:
  ```text
  Array A:  (4,  1,  8)
  Array B:      (6,  8)  --> Padded to (1, 6, 8)
  ----------------------------------------------
  Output:   (4,  6,  8)  --> Valid!
  ```
* **Delta:** Green checkmarks on each aligned dimension column.

### State 2: Virtual Stride 0 Mechanics
* **Visual:** Vector `[10, 20, 30, 40]` of shape `(1, 4)`.
* **Delta:** Expanded to `(1000, 4)` by setting row stride $s_0 = 0$. Each row jump adds 0 bytes $\to$ CPU re-reads identical buffer line across all 1,000 iterations.

### State 3: 3D Pairwise Distance Vectorization
* **Visual:** Aligning data points `(M, d)` and centroids `(N, d)`.
* **Delta:**
  - `X[:, np.newaxis, :]` $\to$ `(M, 1, d)`
  - `C[np.newaxis, :, :]` $\to$ `(1, N, d)`
  - `diff = X[:, None, :] - C[None, :, :]` $\to$ `(M, N, d)`
  - `np.linalg.norm(diff, axis=2)` $\to$ `(M, N)` output matrix in 1 vectorized SIMD operation.
