# Asset Plan: Figures & Diagrams — M00 Session 01

* **Module:** M00: Foundations of Data Science
* **Session:** Session 01: Python Programming Foundations

---

## 🎨 Required Designed Figures

| Asset ID | Target Slide | Description / Pedagogical Purpose | Visual Archetype | Format / Specs |
| :--- | :---: | :--- | :--- | :--- |
| `FIG-M00-S01-001` | S01-008 | **Box Model vs Pointer Model:** Cardboard box vs Stack pointer pointing to Heap memory address. | 2-Column Vector Diagram | TikZ / Vector SVG |
| `FIG-M00-S01-002` | S01-009 | **CPython `PyObject` Memory Struct:** 28-byte breakdown (`ob_refcnt`, `ob_type*`, `ob_ival`). | Layered Memory Struct | TikZ / Vector SVG |
| `FIG-M00-S01-003` | S01-010..011 | **Variable Rebinding Memory Trace:** Stack address repointing from `0x100A` (42) to `0x200B` ("hello"). | 2-State Flipbook Diagram | TikZ / Vector SVG |
| `FIG-M00-S01-004` | S01-013 | **Small Integer Cache Pool `[-5, 256]`:** Global pre-allocated singleton array in CPython. | Array Pointer Diagram | TikZ / Vector SVG |
| `FIG-M00-S01-005` | S01-015 | **Module Load vs Runtime Timeline:** `append_event.__defaults__` tuple persistence across calls. | Horizontal Timeline | TikZ / Vector SVG |
| `FIG-M00-S01-006` | S01-017..019 | **Assignment vs Shallow Copy vs Deep Copy:** 2-tier tree with shared vs cloned nested pointers. | 3-State Graph Diagram | TikZ / Graphviz |
| `FIG-M00-S01-007` | S01-021 | **Cyclic Reference Memory Island:** Self-referencing list with non-zero refcount unreachable from stack. | Circular Graph | TikZ / Graphviz |
| `FIG-M00-S01-008` | S01-031 | **Hash Table Modulo Indexing:** Key $\to$ `hash()` $\to$ modulo capacity $\to$ direct bucket slot jump. | Flowchart & Bucket Array | TikZ / Vector SVG |
| `FIG-M00-S01-009` | S01-032 | **Mutable Key Bucket Chaos:** Key mutating in-place and becoming unsearchable in old bucket. | 2-State Memory Diagram | TikZ / Vector SVG |
| `FIG-M00-S01-010` | S01-036 | **Generator State Suspension Machine:** Bytecode instruction pointer freezing on `yield`. | State Machine Flowchart | TikZ / Vector SVG |
| `FIG-M00-S01-011` | S01-038 | **Closure Cell Object:** Nested scope capturing free variable into heap cell object. | Scoping Hierarchy Box | TikZ / Vector SVG |
| `FIG-M00-S01-012` | S01-051 | **Boxed Python List vs Flat NumPy Array:** 360 MB scattered pointers vs 80 MB contiguous buffer. | Layered RAM Blocks | TikZ / Vector SVG |
| `FIG-M00-S01-013` | S01-052 | **CPU Cache Line vs DRAM Pointer Chasing:** L1 cache miss stalls vs contiguous prefetching hits. | Hardware Architecture | TikZ / Vector SVG |
| `FIG-M00-S01-014` | S01-054 | **NumPy `ndarray` Anatomy:** Small metadata header pointing to raw contiguous C-buffer. | Struct & Buffer Blueprint | TikZ / Vector SVG |
| `FIG-M00-S01-015` | S01-055 | **SIMD AVX-512 Register Parallelism:** 8 float64 additions executed in 1 CPU clock cycle. | Hardware Register Grid | TikZ / Vector SVG |
| `FIG-M00-S01-016` | S01-056 | **2D Strides Mapping to 1D RAM:** Strides formula calculating flat byte offsets. | 2D Grid to 1D Array Map | TikZ / Vector SVG |
| `FIG-M00-S01-017` | S01-057 | **Zero-Copy Transposition:** Two array headers swapping strides over identical shared buffer. | Shared Memory Blueprint | TikZ / Vector SVG |
| `FIG-M00-S01-018` | S01-060 | **Broadcasting Trailing Dimension Alignment:** Right-to-left dimension matching rules. | Alignment Grid Matrix | TikZ / Vector SVG |
| `FIG-M00-S01-019` | S01-061 | **Virtual Stride 0 Memory Reuse:** Dimension expansion without allocating additional RAM. | Stride Multiplier Diagram | TikZ / Vector SVG |
