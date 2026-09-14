# Sequence Plan: Shallow vs Deep Copy Mechanics

* **Sequence ID:** `seq_03_shallow_vs_deep_copy`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 017 – 019, 023 – 024
* **Pedagogical Goal:** Make the 2-tier memory graph visible to explain why shallow copy fails to isolate nested mutable compound objects.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: 2-Tier Nested Structure: a = [1, [2, 3]]                                         │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 017): Reference Assignment (b = a) -> Two names point to outer list 0x100.       │
│ State 2 (Slide 018): Shallow Copy (b = a.copy()) -> New outer list 0x300, SHARED inner list 0x200│
│ State 3 (Slide 019): Deep Copy (b = deepcopy(a)) -> New outer list 0x300, NEW inner list 0x400. │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **Base Object Structure:** Original compound tree `a -> [1, [2, 3]]` remains locked on the left side of the canvas.
2. **Inner List Address:** Inner list remains anchored at `0x200`.
3. **Color Palette:**
   - Original Tree `a`: Sky Blue (`#0284C7`)
   - Cloned Nodes `b`: Purple (`#8B5CF6`)
   - Shared Inner Node: Warning Amber (`#F59E0B`)

---

## 🎞️ State-by-State Breakdown

### State 1: Reference Assignment (`b = a`)
* **Visual:** Stack names `a` and `b` both point with arrows to Outer List `0x100`.
* **Delta:** Outer List `0x100` points to element `1` and Inner List `0x200`. Zero duplication.

### State 2: Shallow Copy (`b = a.copy()`)
* **Visual:** Brand new outer list allocated at `0x300` for `b`.
* **Delta:**
  - `b` points to `0x300`.
  - Outer List `0x300` contains independent primitive `1`, but its second slot points directly to **existing inner list `0x200`**!
  - Callout: `b[1].append(99)` mutates `0x200` $\to$ visible in `a[1]`.

### State 3: Deep Copy (`b = copy.deepcopy(a)`)
* **Visual:** Recursive traversal cloning.
* **Delta:**
  - New outer list allocated at `0x300`.
  - New inner list allocated at `0x400` containing copies of `2` and `3`.
  - Arrow from `0x300` points to `0x400`. Zero shared mutable nodes between `a` and `b`.
