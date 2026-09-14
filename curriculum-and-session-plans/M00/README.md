# Module 00: Foundations of Data Science

**Module Title:** Foundations of Data Science: Python Programming, Linear Algebra, Statistics & Software Engineering Workflows  
**Module Focus:** Python Virtual Machine & Memory Model, Applied Linear Algebra via NumPy, Probability & Inferential Statistics, Reproducible Software Development Workflows  
**Total Duration:** 4 Sessions (180 Minutes / 3 Hours each — 12 Hours Total)  
**Target Audience:** Technical graduates (engineering, computer science, quantitative disciplines) transitioning into Data Science, Machine Learning, and AI.  

---

## 🎯 Module Learning Outcomes
By the end of this module, learners will be able to:
1. **Master the Python Virtual Machine & Memory Semantics:** Reason about stack pointer bindings, heap allocations (`PyObject`), mutability, shallow vs deep copying, $O(1)$ hash table collisions, memory-bounded generator streams (`yield`), and practical decorator wrapping patterns.
2. **Accelerate Numerical Computing via NumPy:** Eliminate CPython interpretation and dynamic dispatch bottlenecks using SIMD-vectorized contiguous memory buffers, strides, zero-copy views, and multidimensional broadcasting.
3. **Apply Linear Algebra Geometrically in $\mathbb{R}^d$:** Represent multimodal data as dense vector embeddings, compute directional similarity via dot products and cosine distance, model matrices as linear spatial transformations, understand volume scaling through determinants, and compress datasets via Eigen-decomposition, SVD, and PCA.
4. **Reason Rigorously Under Uncertainty:** Calculate joint and conditional probabilities using fundamental counting rules, derive and apply Bayes' Theorem and Naive Bayes classification with Laplace smoothing, model discrete and continuous random variables, leverage the Central Limit Theorem, and conduct formal hypothesis tests ($Z$-tests, $t$-tests, $p$-values, Type I/II errors, and statistical power).
5. **Enforce Production-Grade Software Engineering:** Build isolated, reproducible runtime environments using `uv` and `pyproject.toml` with cryptographic lockfiles, manage collaborative team branching and 3-way merge conflict resolution via Git's Directed Acyclic Graph (DAG), and build automated unit testing suites using `pytest` fixtures, parameter matrices, `mypy` static typing, and `ruff` linting.

---

## 🗓️ High-Level Syllabus & Session Overview

| Session ID | Session Title | Focus Areas & Core Topics | Session Journey Link |
| :---: | :--- | :--- | :---: |
| **Session 01** | Python Programming Foundations | Object Pointer Model, Heap Allocation, Mutability, Copy Semantics, Hash Tables, Lazy Generators, Practical Decorators, CPython Bottlenecks, SIMD Contiguous Buffers, Broadcasting | [Session 01 Plan](./session_01.md) |
| **Session 02** | Applied Linear Algebra via NumPy | Data as Numbers in $\mathbb{R}^d$, Vector Norms ($L_1, L_2$), Dot Products, Cosine Similarity, Matrices as Spatial Transformations, Basis Vectors, Determinants, OLS Projection, Eigenvectors, SVD, PCA | [Session 02 Plan](./session_02.md) |
| **Session 03** | Statistical Foundations & Probability | Counting Rules, Sample Spaces, Conditional Probability, 100k Frequency Grid, Bayes' Theorem, Naive Bayes, PMF/PDF, Expectation & Variance, Distributions, LLN, Central Limit Theorem, Hypothesis Testing, $p$-Values, A/B Testing | [Session 03 Plan](./session_03.md) |
| **Session 04** | Basic Software Engineering Workflows | Python Module Resolution (`sys.path`), Isolated Virtual Environments (`venv`, `uv`), `pyproject.toml`, Lockfiles, Git Object Store (Blob, Tree, Commit), DAG Topology, 3-Way Merging, Merge Conflicts, Pytest, Fixtures, Parametrization, `mypy`, `ruff` | [Session 04 Plan](./session_04.md) |

---

## 📋 Objective Session Topic Breakdowns

### Session 01: Python Programming Foundations
* **Block 1 [60m] — Object Pointer Model & Memory Semantics:** Stack-allocated reference pointers vs heap `PyObject` structs, object identity (`id()`, `is`) vs equality (`==`), mutable default argument evaluation, shallow copy vs deep copy mechanics.
* **Block 2 [60m] — Data Structures, Generators & Practical Decorators:** Time/space complexity of built-in collections (`list`, `set`, `dict`), hash table bucket mapping and immutability constraints, memory-bounded stream processing with generators and `yield`, first-class functions, and the practical `@decorator` pattern with `@functools.wraps`.
* **Block 3 [60m] — The CPython Speed Wall & NumPy's Breakthrough:** Boxing overhead, pointer chasing cache misses, dynamic type dispatch, contiguous raw C-memory buffers, SIMD register vectorization, strides formula, zero-copy slicing views, and multidimensional broadcasting rules.

### Session 02: Applied Linear Algebra via NumPy
* **Block 1 [60m] — How Computers "See" Reality: Vectors, Embeddings & Similarity:** Vector representation of images, audio, tabular records, and text in $\mathbb{R}^d$, vector norms ($L_1, L_2$), algebraic dot product as geometric shadow projection, cosine similarity vs Euclidean distance, and vectorized similarity matrices in NumPy.
* **Block 2 [60m] — What is a Matrix, Really? Linear Transformations & Spaces:** Matrices as coordinate grid transformations, column vectors as basis destinations ($A\mathbf{x}$ as linear combination), composition of actions ($AB \ne BA$), determinant as spatial volume scaling factor, column space, rank, and Ordinary Least Squares (OLS) as orthogonal projection.
* **Block 3 [60m] — Finding Axes of Maximum Truth: Eigen, SVD & PCA:** Invariant stretch directions ($A\mathbf{v} = \lambda\mathbf{v}$), data covariance matrix uncorrelation, Singular Value Decomposition ($X = U \Sigma V^T$), optimal low-rank compression (Eckart-Young Theorem), and Principal Component Analysis (PCA) pipeline from scratch.

### Session 03: Statistical Foundations & Probability
* **Block 1 [60m] — The Geometry of Chance: From Counting Rules to Bayes' Theorem:** Fundamental counting principles ($N = n_1 \times n_2 \dots$), permutations vs combinations, classical probability definition, joint probability and independence, conditional probability as sample space reduction, the 100,000-event frequency grid, Bayes' Theorem derivation, and the Naive Bayes multi-feature classifier with Laplace smoothing.
* **Block 2 [60m] — Order from Chaos: Random Variables, Distributions & The CLT:** Discrete PMF vs continuous PDF ($f(x)$ as density), Expected Value ($\mathbb{E}[X]$) and Variance ($\sigma^2$), fundamental distribution family (Bernoulli, Binomial, Poisson, Exponential, Gaussian), the Law of Large Numbers (LLN), and the Central Limit Theorem (CLT) with Standard Error precision scaling ($\text{SE} = \sigma/\sqrt{n}$).
* **Block 3 [60m] — The Scientific Courtroom: Hypothesis Testing, $p$-Values & Decision Theory:** Courtroom analogy of science ($H_0$ vs $H_1$), test statistics as signal-to-noise ratio, true definition of $p$-values, $2 \times 2$ decision matrix (Type I $\alpha$ vs Type II $\beta$ errors), statistical power ($1-\beta$), confidence intervals ($\text{CI}_{95\%}$), two-sample proportion $Z$-tests, Welch's $t$-tests, sample size sizing formula, and multiple testing correction (Bonferroni / FDR).

### Session 04: Basic Software Engineering Workflows
* **Block 1 [60m] — The "Works on My Machine" Curse: Python Environments & Packaging:** Python module search engine (`sys.path`), local file shadowing pitfalls, virtual environments as lightweight symlink sandboxes, ultra-fast environment management with `uv`, modern declarative configuration via `pyproject.toml`, and cryptographic dependency locking.
* **Block 2 [60m] — Time Travel & Parallel Realities: Git DAG Internals & Team Merging:** Content-addressable object store (Blob, Tree, Commit, Tag), branch pointers and `HEAD` tracking, 3-way merge algorithm and Lowest Common Ancestor (Base) diffing, merge conflict resolution, rebase vs merge mechanics, and repository hygiene with `.gitignore`.
* **Block 3 [60m] — Silent Failure Prevention: Pytest, Test Fixtures & Quality Hygiene:** The economics of automated testing, Pytest discovery rules and AST assertion rewriting, modular dependency injection via `@pytest.fixture` with generator `yield` teardown, table-driven test matrices with `@pytest.mark.parametrize`, static type safety with `mypy`, and sub-millisecond linting with `ruff`.
