# Session 04: Basic Software Engineering Workflows

* **Module:** Module 00: Foundations of Data Science
* **Duration:** 180 Minutes (3 Blocks $\times$ 60 mins)
* **Subtitle:** Reproducibility, Isolation, and Production-Grade Code Hygiene
* **Session North-Star Question:** *"Engineer A builds a correct feature on their laptop; Engineer B builds a correct feature on their laptop. Every test passes locally. They merge branches, deploy to production, and the application crashes at 2 AM. How can two independently correct pieces of software compose into a broken system, and how do isolated virtual environments, Git's Directed Acyclic Graph, and automated testing suites guarantee that our data science and ML systems run identically anywhere in the world?"*
* **Session Narrative Arc:**
  $$\text{The 'Works on My Machine' Trap: Environments \& Lockfiles} \xrightarrow{\text{Bridge}} \text{Time Travel \& Parallel Realities: Git DAG Internals \& Merging} \xrightarrow{\text{Bridge}} \text{Silent Failure Prevention: Pytest \& Quality Hygiene}$$

---

## ⏱️ Detailed 60-Minute Teaching Arcs

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 1 [00:00 - 01:00]: The "Works on My Machine" Curse: Python Environments & Packaging          │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *Hook 1 (The Global Dependency Collision):* You run `pip install package-a` which requires `pydantic==1.10`. Next week, on the same machine, you run `pip install package-b` which silently upgrades `pydantic` to version `2.8`. Suddenly, your old project completely stops working with cryptic `AttributeError` tracebacks. Why does Python's default behavior allow one project's dependencies to silently corrupt another project's runtime?
  * *Hook 2 (The Phantom Module Hijack):* You create a small utility script named `math.py` or `random.py` in your project directory and write `import math`. Suddenly, your script crashes with an `AttributeError: module 'math' has no attribute 'sqrt'`, or built-in standard library functions disappear. How does Python locate modules when you type `import`, and why did your local file hijack the Python standard library?
  * *Hook 3 (The Floating Dependency Trap):* Your `requirements.txt` lists `pandas>=2.0.0`. It runs flawlessly on your laptop today. Six months later, your cloud pipeline builds a fresh Docker image for deployment and immediately crashes in production because `pandas 3.0` was released overnight with breaking API changes. Why is a standard `requirements.txt` fundamentally incapable of guaranteeing true reproducibility?
* **Learner Starting State & Misconceptions:**
  * *Naive Model 1:* Python packages live in a single global folder; `pip install <package>` is the safe, standard way to install libraries.
  * *Naive Model 2:* Listing package names in `requirements.txt` guarantees that anyone who runs `pip install -r requirements.txt` will get an identical environment.
  * *Dissonance:* Global `site-packages` share a single flat namespace where version collisions are destructive; unpinned transitive dependencies continuously drift over time unless locked with exact cryptographic hashes.
* **Prediction & Commitment Task:**
  * *Prediction Task 1 (Module Resolution Shadowing):* If your working directory contains a file named `numpy.py` and you run `import numpy as np; print(np.array([1, 2]))`, predict what Python does:
    - **A)** Imports the official NumPy package and prints the array.
    - **B)** Imports your local `numpy.py` file and crashes with an `AttributeError`.
    - **C)** Displays a warning and resolves both.
  * *Prediction Task 2 (Transitive Dependency Drill):* If Package X requires `lib >= 1.0` and Package Y requires `lib < 1.5`, what happens if you run `pip install package-x package-y` without a lockfile when `lib 2.0` is released?
* **The Reveal Ladder (Step-by-Step Resolution):**
  * **Reveal 1 (Python's Search Path Engine — `sys.path`):**
    - What actually happens when you type `import foo`: Python sequentially scans the list of directory strings in `sys.path`:
      1. The directory containing the input script (or current working directory `""`).
      2. Standard library directories (`lib/python3.12/`).
      3. Third-party site-packages (`site-packages/`).
    - The first directory containing a matching `foo.py` or `foo/` directory wins—explaining why local filenames shadow built-in standard libraries!
  * **Reveal 2 (Virtual Environments as Isolated Pointer Sandboxes):**
    - What a virtual environment *actually* is under the hood: it is NOT a heavy VM or container. It is simply a lightweight directory structure containing:
      - A `pyvenv.cfg` configuration file pointing back to the base Python executable (`home = /usr/bin`).
      - A local `bin/` (or `Scripts/`) folder containing isolated symlinks to the `python` and `pip` binaries.
      - A dedicated, isolated `lib/python3.12/site-packages/` directory.
    - When activated (`source .venv/bin/activate`), the activation script simply modifies the shell's `PATH` environment variable, prepending `.venv/bin` to the front of `PATH` so `which python` resolves to the virtual environment.
  * **Reveal 3 (Modern Ultra-Fast Tooling: `uv` vs Legacy `venv`/`pip`):**
    - How modern Rust-based tooling (`uv`) solves legacy performance bottlenecks: global content-addressable wheel caching and copy-on-write hardlinks enable sub-second virtual environment creation and package installation ($10\times - 100\times$ faster than `pip`).
  * **Reveal 4 (Declarative Project Specification: `pyproject.toml`):**
    - The modern PEP 517/518/621 standard: Replacing fragile `setup.py` scripts and loose `requirements.txt` with structured project metadata:
      - `[project]` definitions, metadata, and core runtime dependencies.
      - `[project.optional-dependencies]` (e.g. `dev = ["pytest", "mypy", "ruff"]`).
  * **Reveal 5 (The Lockfile & Cryptographic Hash Pinning):**
    - Direct vs Transitive dependencies: When you request `fastapi`, it pulls a tree of transitive dependencies (`starlette`, `pydantic`, `anyio`, `sniffio`, `idna`).
    - A lockfile (`uv.lock` or `poetry.lock`) resolves the complete deterministic dependency graph, pinning every direct and transitive library to an exact version and cryptographic `sha256` hash.
* **Mechanistic Mental Model & Formal Theory:**
  * *Python Import Mechanics:* `sys.modules` cache lookup $\to$ `sys.meta_path` finders $\to$ `sys.path` directory traversal $\to$ bytecode compilation (`__pycache__/*.pyc`) $\to$ module object execution.
  * *Key Environment Variables:* `PATH` (executable discovery order), `PYTHONPATH` (custom module search paths), `VIRTUAL_ENV` (active environment root).
  * *Semantic Versioning (SemVer):* `MAJOR.MINOR.PATCH` ($X.Y.Z$) — breaking changes vs backwards-compatible feature additions vs backwards-compatible bug fixes.
* **Authentic Production Application:**
  * Initializing a modern, production-grade Python data science project from scratch using `uv` and `pyproject.toml`:
    - Creating an isolated `.venv` environment in sub-second time.
    - Specifying core runtime dependencies (`numpy`, `pandas`, `scipy`) and development dependencies (`pytest`, `mypy`, `ruff`).
    - Generating and validating a deterministic `uv.lock` file.
    - Inspecting module resolution in real-time via `python -c "import sys; print(sys.path)"`.
* **Boundary & Failure Modes:**
  * Binary C-extension compilation mismatches (e.g. wheel compiled for GLIBC 2.35 failing when deployed to an Alpine Linux musl-based container); environment variable leaks (`PYTHONPATH` leaking host packages into isolated environments).
* **Transfer Challenge:**
  * A Docker container fails to start in production with `ModuleNotFoundError: No module named 'src'`. Explain why executing `python src/app.py` failed while running `python -m src.app` succeeds, analyzing how both execution styles populate `sys.path[0]`.
* **Synthesis & Narrative Bridge:**
  * *Synthesis:* A Python virtual environment is an isolated file-system sandbox that isolates `sys.path`. Combining `pyproject.toml` with cryptographic lockfiles guarantees that every developer and deployment server executes the exact same deterministic dependency tree.
  * *Bridge to Block 2:* *"Now our code runs in an isolated, reproducible environment. But software is not built by one person in a single moment—it evolves across time and across distributed teams. How does Git let dozens of engineers work on the same files in parallel, travel back in time, and merge their changes without destroying each other's work?"*

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 2 [01:00 - 02:00]: Time Travel & Parallel Realities: Git DAG Internals & Team Merging        │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *Hook 1 (The Folder-Copying Nightmare vs The Tiny `.git` Directory):* Why is naming folders `project_v1_final_FINAL_v2.zip` a recipe for disaster, and how does Git track a 10-year-old project with 100,000 files in a tiny `.git` directory that takes up almost no extra storage space?
  * *Hook 2 (The Ghost Commit / Detached HEAD):* You run `git checkout <commit-hash>`. Git displays an ominous warning: *"You are in 'detached HEAD' state"*. You make changes, create three commits, and switch back to `main`. Suddenly, your new commits vanish from the log! Where did they go? Are they deleted forever, or do they still exist in Git's memory?
  * *Hook 3 (The Merge Conflict Paradox):* Engineer A edits line 40 in `train.py`. Engineer B edits line 120 in `train.py`. Git merges both branches automatically without error. But if both engineers edit line 40 to different values, Git halts execution with `CONFLICT (content)`. How does Git know when two changes are safe to combine, and how does the 3-Way Merge algorithm calculate truth?
* **Learner Starting State & Misconceptions:**
  * *Naive Model 1:* Git saves file differences (diffs/deltas) for each commit, like a running changelog.
  * *Naive Model 2:* Branches are heavy, separate copies or duplicate folders of the entire codebase.
  * *Dissonance:* Git never stores diffs—Git stores complete immutable snapshots of the entire project tree as a content-addressable directed acyclic graph (DAG); branches are lightweight 41-byte text pointers containing a commit hash.
* **Prediction & Commitment Task:**
  * *Prediction Task 1 (Git Storage Efficiency):* If your repository contains a 100 MB data file and you commit a 1-character change to a 2 KB Python script, how much storage does Git add to `.git/objects`?
    - **A)** Another 100 MB.
    - **B)** Approximately 2 KB (compressed).
    - **C)** 0 bytes.
  * *Prediction Task 2 (3-Way Merge Prediction):* Branch `feature` and branch `main` both diverge from ancestor commit `C1`. In `feature`, line 15 is changed from `"red"` to `"blue"`. In `main`, line 15 is left unchanged (`"red"`). When `feature` is merged into `main`, what will Git do?
    - **A)** Trigger a merge conflict because the lines differ.
    - **B)** Keep `"blue"` automatically.
    - **C)** Keep `"red"` automatically.
* **The Reveal Ladder (Step-by-Step Resolution):**
  * **Reveal 1 (The Git Object Store — Content-Addressable Cryptography):**
    - Every object in `.git/objects/` is compressed with zlib and addressed by the SHA-1/SHA-256 hash ($40$ hex characters) of its contents:
      1. **Blob (Binary Large Object):** Stores raw file contents (no filename, no timestamps, no permissions).
      2. **Tree:** Represents a directory listing, mapping file modes and filenames to Blob and sub-Tree hashes.
      3. **Commit:** An immutable snapshot pointing to a top-level Tree hash, parent commit hash(es), author, timestamp, and commit message.
      4. **Annotated Tag:** A permanent named pointer with cryptographic signatures.
    - If a file is unchanged between commits, the new Tree simply references the *existing* Blob hash (zero duplication!).
  * **Reveal 2 (References, Branches & HEAD):**
    - What is a branch? It is literally a plain text file in `.git/refs/heads/main` containing exactly 40 characters: the hash of the latest commit.
    - What is `HEAD`? A reference pointer in `.git/HEAD` that tracks your current location (typically `ref: refs/heads/main`).
    - *Detached HEAD Explained:* When `HEAD` points directly to a commit hash rather than a branch name. Commits made in detached HEAD state become "unreachable" when switching branches, but remain recoverable via `git reflog`.
  * **Reveal 3 (The Three Trees / States of Git):**
    - **Working Directory** (physical files on disk) $\xrightarrow{\text{git add}}$ **Index / Staging Area** (`.git/index` binary cache) $\xrightarrow{\text{git commit}}$ **Commit History** (immutable DAG in `.git/objects`).
  * **Reveal 4 (The 3-Way Merge Algorithm):**
    - *Fast-Forward Merge:* When the target branch has no new commits, Git simply moves the branch pointer forward.
    - *3-Way Merge:* When branches have diverged, Git identifies their **Lowest Common Ancestor (Base)**:
      - If Base = A and Base $\ne$ B $\implies$ Cleanly apply change B.
      - If Base = B and Base $\ne$ A $\implies$ Cleanly apply change A.
      - If A $\ne$ Base, B $\ne$ Base, and A $\ne$ B $\implies$ **MERGE CONFLICT** (Git stops and inserts conflict markers).
  * **Reveal 5 (Rebase vs Merge Mechanics):**
    - `git merge`: Preserves complete historical topology with an explicit merge commit.
    - `git rebase`: Re-writes history by reapplying commits one by one on top of a new base (Golden Rule: *Never rebase shared public branches!*).
  * **Reveal 6 (Repository Hygiene & `.gitignore`):**
    - How `.gitignore` prevents secrets (`.env`), dataset artifacts (`*.parquet`, `*.csv`), build artifacts, and virtual environments (`.venv/`) from polluting Git's immutable DAG.
* **Mechanistic Mental Model & Formal Theory:**
  * *Directed Acyclic Graph (DAG) Invariants:* Commits are immutable nodes; parent pointers point backwards in time; SHA hashes ensure cryptographic integrity (changing one byte changes all downstream hashes).
  * *Git Reflog & Safety Nets:* `git reflog` records every sequential change of `HEAD`, allowing engineers to rescue "lost" commits before `git gc` runs.
* **Authentic Production Application:**
  * Simulating a full professional Git collaboration cycle in the terminal:
    - Creating isolated feature branches (`git checkout -b feature/model-pipeline`).
    - Making atomic commits, inspecting raw objects via `git cat-file -p <hash>`.
    - Deliberately creating a 3-way merge conflict, inspecting conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`), resolving it cleanly, and verifying branch topology via `git log --graph --oneline --all`.
* **Boundary & Failure Modes:**
  * Accidental commit of API keys or credentials into Git history (deleting the file in a subsequent commit does NOT remove it from history $\to$ requires `git filter-repo` or BFG repo-cleaner); tracking massive multi-gigabyte datasets directly in Git causing repository bloat (requiring Git LFS).
* **Transfer Challenge:**
  * An engineer accidentally executes `git reset --hard HEAD~2` on their local branch and destroys two critical commits. Using your knowledge of Git's DAG, `HEAD` tracking, and the object store, write the exact commands (`git reflog`, `git branch` or `git reset`) to restore the lost commits.
* **Synthesis & Narrative Bridge:**
  * *Synthesis:* Git is an immutable, content-addressable directed acyclic graph of snapshots. Branches and tags are lightweight 41-byte text pointers, and the 3-way merge algorithm allows distributed engineering teams to work concurrently with mathematical conflict detection.
  * *Bridge to Block 3:* *"Now we can collaborate safely and version our code. But how do we know our code actually works? How do we prevent silent regressions, edge-case bugs, and corrupted data pipelines before code ever reaches production?"*

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 3 [02:00 - 03:00]: Silent Failure Prevention: Pytest, Test Fixtures & Quality Hygiene         │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *Hook 1 (The Silent NaN Contamination):* A data cleaning pipeline processes 1,000,000 customer transactions. In row 842, a single missing value (`None`) is silently converted to `NaN`. The pipeline does not crash, but downstream gradient descent weights become `NaN`, outputting broken model predictions in production for weeks. Why are silent data corruption bugs $100\times$ more dangerous than crashing bugs, and how does automated testing catch them immediately?
  * *Hook 2 (The Brittle Test Trap):* An engineer writes 40 unit tests, but each test manually creates a 60-line mock database connection and sample dataset. When the database schema changes slightly, all 40 tests break simultaneously, taking 2 days of tedious copy-paste edits to fix. How do modern testing frameworks provide clean, modular, reusable test setups without boilerplate?
  * *Hook 3 (The Python Type Hint Illusion):* You write a function `def calculate_discount(price: float, discount: float) -> float`. A teammate calls `calculate_discount("100", "0.2")`. Python executes the function without syntax errors and crashes at runtime. If Python has type annotations, why didn't it prevent the invalid call?
* **Learner Starting State & Misconceptions:**
  * *Naive Model 1:* Testing code means running a script manually, printing variables with `print()`, and visually inspecting the console output.
  * *Naive Model 2:* Python type annotations (`x: int`) enforce strict data types at runtime like Java or C++.
  * *Dissonance:* Manual `print()` checks are non-deterministic, untracked, and fail to prevent regressions; Python type annotations are strictly ignored by CPython at runtime, requiring static analyzers (`mypy`) to catch type bugs before code execution.
* **Prediction & Commitment Task:**
  * *Prediction Task 1 (Pytest Discovery Rules):* If you create a test file named `test_pipeline.py` containing a function `def verify_scaling(): assert 1 == 1`, predict what happens when you run `pytest` in your terminal. Will it execute the test?
    - **A)** Yes, it discovers all functions in test files.
    - **B)** No, Pytest requires test functions to explicitly begin with the prefix `test_`.
  * *Prediction Task 2 (Floating-Point Precision Assertion):* In Python, predict the result of `assert (0.1 + 0.2) == 0.3`. Will this test pass or raise an `AssertionError`? Why is `pytest.approx()` mandatory for numerical data science assertions?
* **The Reveal Ladder (Step-by-Step Resolution):**
  * **Reveal 1 (The Economics & Architecture of Automated Testing):**
    - The Cost Escalation of Bugs: Catching a bug during Unit Testing costs $1\times$; during Integration/Staging costs $10\times$; in Live Production costs $100\times+$.
    - The Pytest philosophy: Utilizing standard Python `assert` expressions with rich AST (Abstract Syntax Tree) bytecode rewriting for deep, introspective failure reporting.
  * **Reveal 2 (Pytest Test Discovery & Assertion Mechanics):**
    - Automatic discovery rules: Files named `test_*.py` or `*_test.py`, test functions named `test_*`, test classes named `Test*`.
    - Testing expected failure modes cleanly with `with pytest.raises(ValueError, match="..."):`.
    - Handling floating-point numerical imprecision with `pytest.approx(0.3, rel=1e-5)` and `numpy.testing.assert_allclose()`.
  * **Reveal 3 (Dependency Injection via Pytest Fixtures — `@pytest.fixture`):**
    - Eliminating boilerplate: Fixtures provide modular, reusable, isolated test resources:
      - Scope hierarchy: `function` (default, fresh instance per test), `class`, `module`, `session`.
      - Setup and Tear-down mechanics using Python generator `yield` statements (automatic resource cleanup).
  * **Reveal 4 (Table-Driven Testing with `@pytest.mark.parametrize`):**
    - Testing dozens of edge cases (empty dataframes, negative values, null inputs, extreme boundary conditions) with a single elegant test function driven by a parameter matrix.
  * **Reveal 5 (Static Analysis & Type Hygiene with `mypy`):**
    - Static Type Checking vs Dynamic Runtime: Running `mypy` to statically verify type correctness across data pipelines, catching `None` dereferences and type mismatches before any code runs.
  * **Reveal 6 (Sub-Millisecond Linting & Formatting with `ruff`):**
    - Replacing legacy tools (`flake8`, `black`, `isort`, `pylint`) with a single ultra-fast Rust-based linter and formatter. Enforcing code quality, clean imports, and PEP 8 compliance across entire codebases in milliseconds.
* **Mechanistic Mental Model & Formal Theory:**
  * *The Testing Pyramid:* Unit Tests (Fast, isolated, high volume) $\to$ Integration Tests (Component interaction) $\to$ End-to-End Tests (Full pipeline execution).
  * *Arrange-Act-Assert (AAA) Pattern:* Structuring every test into deterministic setup (Arrange), execution (Act), and verification (Assert) phases.
  * *Continuous Integration (CI) Quality Gates:* Automating `ruff check`, `mypy`, and `pytest` in pre-commit hooks and GitHub Actions workflows on every Pull Request.
* **Authentic Production Application:**
  * Building a comprehensive production test suite for a Data Cleaning & Feature Scaling pipeline:
    - Creating a `@pytest.fixture` generating raw mock customer datasets with intentional anomalies.
    - Implementing `@pytest.mark.parametrize` to validate normalizers across valid, zero-variance, and boundary inputs.
    - Writing unit tests validating custom exceptions (`pytest.raises(ValueError)`) and numerical outputs (`pytest.approx`).
    - Running `ruff` and `mypy` to achieve clean, error-free quality gates.
* **Boundary & Failure Modes:**
  * *The Over-Mocking Trap:* Mocking internal implementation details rather than public interface contracts, causing tests to pass while the real system fails; flaky tests caused by unseeded random number generators (`np.random.seed` fixture required).
* **Transfer Challenge:**
  * You are testing a text tokenizer function `tokenize_text(text: str) -> list[str]` for a Natural Language Processing model. Write a parametrized Pytest function (`@pytest.mark.parametrize`) that validates 4 critical edge cases: an empty string `""`, a string with excessive whitespace `" hello   world "`, a string with punctuation `"Data Science!"`, and non-string invalid input triggering a `TypeError`.
* **Session Synthesis & North-Star Resolution:**
  * *Synthesis:* Software engineering rigor transforms fragile data science scripts into robust, enterprise-grade production platforms. Virtual environments isolate dependencies, Git DAGs provide deterministic version tracking and team collaboration, and automated pytest suites with static type hygiene eliminate silent failures before code ever reaches production.
  * *Module 00 Capstone Bridge:* *"We have completed the 4 foundational pillars of Data Science & AI engineering: Python object internals & memory, applied linear algebra with NumPy, statistical probability & inferential decision theory, and production software workflows. You now possess both the theoretical foundation and the engineering discipline to build, optimize, and deploy modern machine learning systems."*
