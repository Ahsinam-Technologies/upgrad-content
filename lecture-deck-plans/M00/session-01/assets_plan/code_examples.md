# Asset Plan: Code Examples — M00 Session 01

* **Module:** M00: Foundations of Data Science
* **Session:** Session 01: Python Programming Foundations

---

## 💻 Verified Code Snippets & Demonstrations

### 1. The Multi-Tenant Leaking Default Argument (`CODE-M00-S01-001`)
* **Target Slides:** S01-006, S01-007, S01-015
```python
def append_event(event_id, log=[]):
    log.append(event_id)
    return log

print("Call 1:", append_event(101))       # Output: [101]
print("Call 2:", append_event(202))       # Output: [101, 202] (State leak!)
print("Defaults:", append_event.__defaults__)  # Output: ([101, 202],)
```

### 2. In-Place Mutation vs Reference Rebinding (`CODE-M00-S01-002`)
* **Target Slide:** S01-014
```python
# In-place mutation calls __iadd__
x = [1, 2]; y = x
x += [3]
print("y after in-place:", y)  # [1, 2, 3]

# Rebinding calls __add__
a = [1, 2]; b = a
a = a + [3]
print("b after rebinding:", b)  # [1, 2]
```

### 3. Production Multi-Tenant Batch Ingestor (`CODE-M00-S01-003`)
* **Target Slide:** S01-022
```python
import copy

class BatchIngestor:
    def __init__(self, tenant_id: str, default_meta: dict | None = None):
        self.tenant_id = tenant_id
        # Defensively clone mutable configs
        self.meta = copy.deepcopy(default_meta) if default_meta is not None else {}
        self.records: list[dict] = []

    def ingest(self, batch: list[dict]) -> None:
        self.records.extend(batch.copy())
```

### 4. Canonical 2-Level Latency Timer Decorator (`CODE-M00-S01-004`)
* **Target Slide:** S01-040
```python
import time
import functools

def timer(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        t0 = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - t0
        print(f"[{func.__name__}] took {elapsed:.4f}s")
        return result
    return wrapper
```

### 5. Resilient Parameterized `@retry` Decorator (`CODE-M00-S01-005`)
* **Target Slide:** S01-045
```python
import time
import functools

def retry(max_retries: int = 3, delay: float = 1.0):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, max_retries + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_retries:
                        raise e
                    print(f"[Retry {attempt}/{max_retries}] Waiting {delay}s...")
                    time.sleep(delay)
        return wrapper
    return decorator
```

### 6. Vectorized Batch Standard Scaler (`CODE-M00-S01-006`)
* **Target Slide:** S01-063
```python
import numpy as np

class VectorizedStandardScaler:
    def __init__(self):
        self.mean_: np.ndarray | None = None
        self.std_: np.ndarray | None = None

    def fit(self, X: np.ndarray) -> "VectorizedStandardScaler":
        self.mean_ = np.mean(X, axis=0)
        self.std_ = np.std(X, axis=0)
        self.std_[self.std_ == 0.0] = 1.0
        return self

    def transform(self, X: np.ndarray) -> np.ndarray:
        return (X - self.mean_) / self.std_
```

### 7. Vectorized Pairwise Distance Computation (`CODE-M00-S01-007`)
* **Target Slide:** S01-065
```python
import numpy as np

def pairwise_distances_vectorized(X: np.ndarray, C: np.ndarray) -> np.ndarray:
    """
    X: shape (M, d)
    C: shape (N, d)
    Returns: Distance matrix of shape (M, N)
    """
    # 3D broadcasting: (M, 1, d) - (1, N, d) -> (M, N, d)
    diff = X[:, np.newaxis, :] - C[np.newaxis, :, :]
    return np.linalg.norm(diff, axis=2)
```
