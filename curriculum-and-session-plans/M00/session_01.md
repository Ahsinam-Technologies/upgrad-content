# Session 01: Python Programming Foundations

* **Module:** Module 00: Foundations of Data Science
* **Duration:** 180 Minutes (3 Blocks $\times$ 60 mins)
* **Subtitle:** Mastering the Python Virtual Machine, Memory Semantics & Vectorized Mechanics
* **Session North-Star Question:** *"How can Python let the same variable appear to become an integer, a collection, or even a function wrapper—and what does that dynamic flexibility cost us when scaling numerical computations in pure Python vs NumPy?"*
* **Session Narrative Arc:**
  $$\text{The Object Pointer Model} \xrightarrow{\text{Bridge}} \text{Data Structures, Generators \& Decorators} \xrightarrow{\text{Bridge}} \text{The CPython Speed Wall \& NumPy's Breakthrough}$$

---

## ⏱️ Detailed 60-Minute Teaching Arcs

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 1 [00:00 - 01:00]: The Object Pointer Mental Model & Memory Semantics                     │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *The Mystery:* In C++/Java, `int x = 42; x = "hello";` causes a fatal compiler error. In Python, `x = 42; x = 3.14; x = "hello"` executes effortlessly. Furthermore, when `b = a` and `b.append(3)`, why does `a` secretly change value? What *is* a Python variable if not a typed storage box in memory?
* **Learner Starting State & Misconceptions:**
  * *Naive Model:* Variables are labeled memory boxes holding values; assigning `b = a` copies the value of `a` into `b`.
  * *Dissonance:* Shared mutation bugs and mutable default argument leakage across isolated function invocations.
* **Prediction & Commitment Task:**
  * Learners predict the console output and draw the stack/heap memory state for:
    ```python
    def append_event(event_id, log=[]):
        log.append(event_id)
        return log
    print(append_event(101))  # Predict output
    print(append_event(202))  # Predict output (isolated call?)
    ```
  * In-place mutation vs rebinding prediction:
    ```python
    x = [1, 2]; y = x; x += [3]; print(y)      # In-place mutation
    a = [1, 2]; b = a; a = a + [3]; print(b)   # Reference rebinding
    ```
* **The Reveal Ladder:**
  * **Reveal 1 (Observation):** Call 2 outputs `[101, 202]`. User B's audit log leaks User A's data.
  * **Reveal 2 (Identity Clue):** Inspecting `id(a) == id(b)` reveals both names bind to the identical 64-bit heap memory address.
  * **Reveal 3 (CPython Architecture):** Python names are stack-allocated pointer references; objects live on the heap as `PyObject` structs (`ob_refcnt`, `ob_type`, payload).
  * **Reveal 4 (Compilation Timing):** Default arguments are evaluated *once at module definition time*, pinning a single mutable heap list to the function's `__defaults__` tuple.
  * **Reveal 5 (Copy Mechanics):** Reference assignment (`b = a`) vs Shallow Copy (`b = a.copy()`, `copy.copy(a)`) vs Deep Copy (`copy.deepcopy(a)`).
* **Mechanistic Mental Model & Formal Theory:**
  * *Memory Model:* Stack names $\to$ 64-bit pointers $\to$ Heap `PyObject` structs (`PyLongObject`, `PyListObject`, `PyUnicodeObject`).
  * *Value Equality vs Identity:* `==` calls `__eq__()` comparing values; `is` compares memory pointers (`id(a) == id(b)`).
  * *Reference Counting & GC:* `sys.getrefcount()`, deallocation on zero refcount, cyclic garbage collection (`gc` module), small integer caching pool ($[-5, 256]$) and string interning.
  * *Copy Semantics Formalism:* Shallow copy duplicates container pointer arrays; deep copy recursively clones all nested compound objects.
* **Authentic Production Application:**
  * Authoring defensive, memory-safe data ingestion pipelines using immutable sentinel patterns (`log=None`) to eliminate state leakage in multi-tenant batch jobs.
* **Boundary & Failure Modes:**
  * Self-referential cyclic data structures (`lst.append(lst)`), recursion depth limit during deep copying, copy failures on thread locks/file handles.
* **Transfer Challenge:**
  * Analyze nested dictionaries: `d1 = {'meta': [10, 20], 'id': 1}; d2 = d1.copy(); d2['meta'].append(30); d2['id'] = 2`. Predict `d1` and explain why shallow copy failed to isolate nested state.
* **Synthesis & Narrative Bridge:**
  * *Synthesis:* A Python variable is not a value box—it is a pointer to a heap `PyObject`. Mutation modifies the heap object; rebinding moves the pointer.
  * *Bridge to Block 2:* *"If every variable is merely a pointer to a heap object, why do different collection containers take vastly different amounts of time to find the exact same pointer?"*

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 2 [01:00 - 02:00]: Data Structures, Generators & Practical Decorators                      │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *Mystery A (Lookup Speed):* A `list` and a `set` both store 10,000,000 IDs. Checking membership in the list takes **120 milliseconds** ($O(n)$); in the set it takes **45 nanoseconds** ($O(1)$). Why does changing brackets from `[]` to `{}` speed up lookups by $2,500,000\times$?
  * *Mystery B (Memory & Wrapping):* Why does building a 10,000,000-item list crash with Out-of-Memory while a `generator` streams it in 8 KB of RAM? And how do modern ML libraries (Streamlit, PyTorch, FastAPI, Pytest) modify and enhance functions using simple `@decorator` syntax without touching original code?
* **Learner Starting State & Misconceptions:**
  * *Naive Model 1:* Collections are all simple sequential arrays in memory.
  * *Naive Model 2:* Adding timing, logging, or caching to functions requires manually editing their internal code and adding boilerplate.
* **Prediction & Commitment Task:**
  * Benchmark scaling prediction: Compare `list` vs `set` lookup times at $N=10^4, 10^5, 10^6, 10^7$.
  * Hashability prediction: Predict which dictionary key assignments succeed and which throw a `TypeError`:
    ```python
    d = {}
    d[(1, 2)] = "tuple_key"    # Predict: Success or TypeError?
    d[[1, 2]] = "list_key"     # Predict: Success or TypeError?
    d[(1, [2, 3])] = "nested"  # Predict: Success or TypeError?
    ```
  * Memory prediction: Compare memory footprint of `[x * 2 for x in range(10_000_000)]` vs `(x * 2 for x in range(10_000_000))`.
  * Decorator prediction: Predict how `@time_it` wraps execution around a data processing function without altering its return output:
    ```python
    @time_it
    def load_dataset(filename):
        return [f"row_{i}" for i in range(100_000)]
    ```
* **The Reveal Ladder:**
  * **Reveal 1 (Hash Mechanics):** Sets and Dicts use `hash(key)` to map keys directly to bucket indices ($O(1)$), requiring immutable/hashable keys.
  * **Reveal 2 (Generator Streams):** Eager list comprehensions allocate all items in RAM immediately ($O(n)$); generator expressions and `yield` stream items on-demand with $O(1)$ memory.
  * **Reveal 3 (Functions as First-Class Objects):** In Python, functions are ordinary objects—they can be assigned to variables, passed into other functions, and returned from functions.
  * **Reveal 4 (The Decorator Pattern):** A decorator is simply a function that accepts a function, wraps additional functionality around it (timing, retry, caching), and returns the wrapped function:
    $$\text{@decorator} \iff \text{func} = \text{decorator}(\text{func})$$
  * **Reveal 5 (Metadata Preservation):** Using `@functools.wraps(func)` preserves original function names and docstrings across library toolchains.
* **Mechanistic Mental Model & Practical Mechanics:**
  * *Complexity Matrix:* Big-$O$ time/space comparison (Access, Search, Insert, Delete) for `list`, `deque`, `set`, `dict`.
  * *Generator Stream Processing:* `yield` execution suspension vs eager list materialization for memory-bounded data pipelines.
  * *Standard 2-Level Decorator Pattern:*
    ```python
    import functools, time

    def timer(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            t0 = time.perf_counter()
            result = func(*args, **kwargs)
            print(f"[{func.__name__}] executed in {time.perf_counter() - t0:.4f}s")
            return result
        return wrapper
    ```
  * *Everyday DS/ML Decorators Demystified:*
    - `@st.cache_data` (Streamlit data caching)
    - `@pytest.fixture` (Test dependency injection)
    - `@torch.no_grad()` (Disabling gradient tracking in inference)
    - `@dataclass` (Auto-generating boilerplate init/repr methods)
* **Authentic Production Application:**
  * Building a memory-bounded data streaming & profiling pipeline: streaming multi-gigabyte server logs with generators, deduplicating IDs in $O(1)$ with sets, and auto-logging latency via a `@timer` decorator.
* **Boundary & Failure Modes:**
  * Unhashable dictionary keys (`TypeError: unhashable type: 'list'`), generator single-pass exhaustion (cannot re-iterate consumed generators), missing `@functools.wraps` (breaking introspection in debugging and FastAPI/Click CLIs).
* **Transfer Challenge:**
  * Write a practical `@retry(max_retries=3)` decorator that catches network/database errors and retries the data ingestion call up to 3 times before raising an exception.
* **Synthesis & Narrative Bridge:**
  * *Synthesis:* Collections provide algorithmic speed ($O(1)$ hash tables), generators provide memory efficiency ($O(1)$ streaming), and decorators provide non-invasive function enhancement across modern Python libraries.
  * *Bridge to Block 3:* *"We now know how to manage memory, stream data, and wrap functions with decorators. But what happens when we need to run intensive mathematical calculations across millions of numbers? Why does pure Python hit a brutal speed wall, and how does NumPy solve it?"*

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 3 [02:00 - 03:00]: The CPython Speed Wall & NumPy's Breakthrough                           │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *The Mystery:* Multiplying two $1,000 \times 1,000$ matrices in pure Python takes **28.5 seconds**. In NumPy, it executes in **3.8 milliseconds** ($>7,500\times$ speedup) on the exact same CPU. Where did the other 99.98% of our compute time go in pure Python?
* **Learner Starting State & Misconceptions:**
  * *Naive Model:* Python loops are slow simply because Python is interpreted; writing cleaner loops will make numerical code fast.
  * *Dissonance:* No algorithmic loop optimization in pure Python comes close to C-speed.
* **Prediction & Commitment Task:**
  * Predict the memory layout and execution time ratio between:
    ```python
    # Approach A: Pure Python List
    res = [x * 2 for x in range(10_000_000)]
    # Approach B: NumPy Vectorized ndarray
    arr = np.arange(10_000_000, dtype=np.int64) * 2
    ```
  * Broadcasting prediction: Predict the resulting shape of broadcasting arrays with shapes `(4, 1, 8)` and `(1, 6, 8)`.
* **The Reveal Ladder:**
  * **Reveal 1 (The 3 CPU Bottlenecks):**
    1. *Boxed Object Overhead:* An 8-byte C integer requires a 28-byte `PyLongObject` in Python. A list of 10M integers consumes $\sim 80\text{ MB}$ of pointer references $+$ $\sim 280\text{ MB}$ of heap objects ($360\text{ MB}$ vs $80\text{ MB}$ in NumPy).
    2. *Pointer Chasing & Cache Misses:* Python list elements are scattered across heap DRAM, causing continuous CPU L1/L2 cache misses.
    3. *Dynamic Dispatch Overhead:* Pure Python checks types, checks operator methods, and dispatches dynamic lookups *on every single iteration*.
  * **Reveal 2 (The ndarray Memory Anatomy):** A NumPy `ndarray` consists of a single contiguous raw C-memory buffer $+$ a metadata header (`dtype`, `shape`, `strides`, `offset`).
  * **Reveal 3 (SIMD & Native Acceleration):** Contiguous homogeneous memory allows the CPU to load vector registers (AVX-512/AVX2) and execute 8 to 16 arithmetic operations per clock cycle via optimized C/Fortran BLAS libraries.
  * **Reveal 4 (Strides & Zero-Copy Views):** Transposing, reshaping, and slicing do not copy data—they merely recalculate stride offsets ($\text{offset} = \sum i_k \times \text{stride}_k$).
  * **Reveal 5 (Broadcasting Engine):** Element-wise arithmetic automatically stretches singleton dimensions without allocating duplicate memory.
* **Mechanistic Mental Model & Formal Theory:**
  * *Strides Formula:* Byte address calculation in multidimensional indexing: $\text{Address}(\mathbf{i}) = \text{data\_ptr} + \sum_{k=0}^{D-1} i_k \cdot s_k$.
  * *Memory Layout:* C-order (Row-Major, contiguous rows) vs Fortran-order (Column-Major, contiguous columns) and cache-line locality implications.
  * *Broadcasting Arithmetic Rules:* Trailing dimensions are aligned; two dimensions are compatible if they are equal or one of them is 1.
  * *Universal Functions (`ufuncs`):* Fast element-wise compiled C loops supporting type casting, buffering, and reduction methods (`reduce`, `accumulate`, `outer`).
  * *Views vs Copies:* Basic slicing produces zero-copy views; advanced boolean/fancy indexing triggers memory copies.
* **Authentic Production Application:**
  * Zero-loop vectorized feature normalization: Implementing batch Min-Max scaling and Z-score standardization across a 1,000,000-row feature matrix using vectorized ufuncs and broadcasting.
* **Boundary & Failure Modes:**
  * Memory explosion from accidental broadcasting of mismatched dimensions, cache thrashing from non-contiguous strided memory access, unintended side-effects when mutating array views.
* **Transfer Challenge:**
  * Vectorize pairwise Euclidean distance computation between $M$ data points and $N$ cluster centroids in $\mathbb{R}^d$ using only 3D broadcasting `(M, 1, d) - (1, N, d)` without a single Python `for` loop.
* **Session Synthesis & North-Star Resolution:**
  * *Synthesis:* The dynamic object model that gives Python its expressive power (pointer references, dynamic typing, heap objects) is the exact source of overhead in tight loops. NumPy breaks through the speed wall by bypassing Python objects and executing compiled SIMD operations directly on contiguous memory buffers.
  * *Bridge to Session 2 (Applied Linear Algebra via NumPy):* *"We now know how to compute on contiguous multi-dimensional arrays at native hardware speed. But what do these arrays, matrices, and transformations actually mean geometrically when building machine learning algorithms?"*
