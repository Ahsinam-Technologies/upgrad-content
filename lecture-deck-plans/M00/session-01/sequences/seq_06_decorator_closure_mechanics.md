# Sequence Plan: Closures, Decorators & Metadata Preservation

* **Sequence ID:** `seq_06_decorator_closure_mechanics`
* **Session:** M00 — Session 01 (Python Programming Foundations)
* **Target Slides:** Slides 037 – 042, 044 – 045
* **Pedagogical Goal:** Demystify decorator syntax `@` by desugaring it to higher-order function composition, explaining `__closure__` cell persistence, and enforcing `@functools.wraps`.

---

## 🎯 Sequence Storyboard & Invariants

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ STABLE CANVAS: Higher-Order Function Composition Pipeline                                        │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ State 1 (Slide 037): Functions as First-Class Heap Objects (assigned, passed, returned).         │
│ State 2 (Slide 038): Function Closures: Inner function retaining outer variable via cell object.│
│ State 3 (Slide 039): Syntactic Sugar: `@timed def f()` is literally `f = timed(f)`.             │
│ State 4 (Slide 040): The Canonical 2-Level Decorator Blueprint (*args, **kwargs).                │
│ State 5 (Slide 041): Why `@functools.wraps(func)` is mandatory (__name__, __doc__ preservation). │
│ State 6 (Slide 042): Everyday DS/ML Decorators (@st.cache_data, @torch.no_grad, @pytest.fixture). │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 📐 Invariants & Visual Continuity
1. **Original Function:** `fetch_data()` remains the target throughout the explanation.
2. **Color Palette:**
   - Outer Decorator: Deep Purple (`#7E22CE`)
   - Inner Wrapper: Electric Blue (`#3B82F6`)
   - Target Function: Emerald Green (`#10B981`)
   - Metadata / `@wraps`: Amber Shield (`#F59E0B`)

---

## 🎞️ State-by-State Breakdown

### State 1: Closure Cell Capture
* **Visual:** Stack frame of `make_multiplier` disappears after returning.
* **Delta:** Inner function `multiply` holds a pointer to `__closure__[0]`, which references an immutable `cell` object containing `factor = 3` on the heap.

### State 2: Decorator Desugaring
* **Visual:** Code transformation equation.
* **Delta:** Show `@timer` above `def fetch_data():` dynamically morphing into `fetch_data = timer(fetch_data)`.

### State 3: Metadata Preservation with `@wraps`
* **Visual:** Inspection of `fetch_data.__name__`.
* **Delta:**
  - Without `@wraps`: Returns `"wrapper"`, breaks frameworks.
  - With `@wraps`: Copies `__name__`, `__doc__`, `__annotations__` from original function to wrapper object.
