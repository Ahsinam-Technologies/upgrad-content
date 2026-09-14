# Sequence Plan: Hash Table Lookups & Collection Complexity

* **Sequence ID:** `seq_04_hash_lookup_and_structures`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 028 – 033
* **Pedagogical Goal:** Visually demonstrate how hash tables bypass sequential $O(n)$ scanning to achieve 45ns $O(1)$ lookups, and why mutability destroys the hash contract.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: Modulo Hash Pipeline -> Hash Code -> Modulo Capacity -> Bucket Array Index       │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 028): Benchmark chart: 120ms List scan vs 45ns Set lookup on 10M IDs.            │
│ State 2 (Slide 029): Prediction Task: Tuple vs List vs Nested Tuple hashability.                 │
│ State 3 (Slide 030): The Hashability Contract: Immutable __hash__() + __eq__() required.         │
│ State 4 (Slide 031): Hash Mapping: key -> hash(key) -> modulo 8 -> direct index jump (O(1)).    │
│ State 5 (Slide 032): The Failure Mode: Why mutating a key in-place causes bucket chaos.          │
│ State 6 (Slide 033): Big-O Complexity Matrix across List, Deque, Set, Dict.                     │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **Bucket Array:** An 8-slot array $(0 \dots 7)$ remains fixed in the center right.
2. **Color Palette:**
   - Hash Output: Violet (`#7C3AED`)
   - Target Slot: Emerald Found (`#10B981`)
   - Unhashable/Error: Crimson Red (`#DC2626`)

---

## 🎞️ State-by-State Breakdown

### State 1: Hash Function to Direct Index
* **Visual:** Key `"user_99"` enters `hash()` block.
* **Delta:**
  - `hash("user_99") = 8492048572`
  - $8492048572 \pmod 8 = 4$
  - Blue arrow jumps straight from CPU register to Bucket Index 4.
  - Zero comparisons with Buckets 0, 1, 2, 3, 5, 6, 7.

### State 2: Mutating a Key in Place (Disaster)
* **Visual:** Mutable key `[1, 2]` placed in Bucket 3.
* **Delta:**
  - In-place mutation `.append(3)` changes key content to `[1, 2, 3]`.
  - Recomputed hash maps to Bucket 7.
  - Query `d[[1, 2, 3]]` checks Bucket 7 (empty!), while data sits orphaned in Bucket 3.
  - Explains why CPython enforces `TypeError: unhashable type: 'list'`.
