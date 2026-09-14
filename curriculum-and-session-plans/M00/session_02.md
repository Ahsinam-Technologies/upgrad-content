# Session 02: Applied Linear Algebra via NumPy

* **Module:** Module 00: Foundations of Data Science
* **Duration:** 180 Minutes (3 Blocks $\times$ 60 mins)
* **Subtitle:** Spatial Transformations, Data Geometry, and Dimensionality Reduction
* **Session North-Star Question:** *"We are surrounded by wildly diverse data—geographic maps, financial ledgers, images, spoken audio, and text. Yet a computer is fundamentally just a fast calculator that only understands numbers. How does a computer convert all of these rich realities into numbers, and how do geometric vector transformations and matrix decompositions allow machines to discover similarity, project relationships, and compress high-dimensional data?"*
* **Session Narrative Arc:**
  $$\text{How Computers Represent Reality (Vectors \& Similarity)} \xrightarrow{\text{Bridge}} \text{How Computers Transform Reality (Matrices \& Spaces)} \xrightarrow{\text{Bridge}} \text{How Computers Compress Reality (Eigen, SVD \& PCA)}$$

---

## ⏱️ Detailed 60-Minute Teaching Arcs

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 1 [00:00 - 01:00]: How Computers "See" Reality: Vectors, Embeddings & Similarity           │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *The Mystery:* A computer has no eyes, ears, or understanding of language; it can only execute arithmetic on numbers. How can a list of numbers capture the texture of an image, the sentiment of a sentence, or the risk of a loan? And once converted into numbers, how can simple geometry—like angles and shadows between arrows in space—instantly tell a computer whether two customer profiles or documents mean the same thing?
* **Learner Starting State & Misconceptions:**
  * *Naive Model:* Diverse data formats (images, audio, text) require completely different, opaque heuristic rules to compare and process.
  * *Dissonance:* A computer translates all data types into coordinate vectors in a unified geometric space $\mathbb{R}^d$, where semantic similarity is measured purely by geometric angles and dot products.
* **Prediction & Commitment Task:**
  * Semantic arithmetic prediction: When words are mapped to vector coordinates, what concept emerges from vector arithmetic:
    $$\mathbf{v}_{\text{King}} - \mathbf{v}_{\text{Man}} + \mathbf{v}_{\text{Woman}} \approx ?$$
  * Similarity metric prediction: Document A has 50 words; Document B has 5,000 words on the exact same topic. Predict why Euclidean distance ($L_2$) flags them as completely dissimilar while Cosine Similarity recognizes them as nearly identical ($0.98$).
* **The Reveal Ladder:**
  * **Reveal 1 (Universal Vector Encoding):** Every real-world data modality maps to coordinate vectors $\mathbf{x} \in \mathbb{R}^d$:
    - *Images:* Grid of pixel intensity values or convolutional feature maps.
    - *Audio:* Frequency spectrogram energy levels across time slices.
    - *Tabular Records:* Feature coordinates (e.g. $[ \text{income}, \text{credit\_score}, \text{debt} ]$).
    - *Text:* Dense semantic embeddings (e.g. 768-dimensional language models).
  * **Reveal 2 (Vector Arithmetic as Semantic Mixing):** Adding vectors combines attributes (parallelogram law); scalar multiplication modulates intensity.
  * **Reveal 3 (The Dot Product as Geometric Projection):**
    $$\mathbf{u} \cdot \mathbf{v} = \sum_{i=1}^d u_i v_i = \|\mathbf{u}\| \|\mathbf{v}\| \cos\theta$$
    The algebraic sum of element-wise products exactly computes the geometric shadow (scalar projection) of one vector onto another.
  * **Reveal 4 (Cosine Similarity — Direction over Scale):**
    $$\text{Cosine Similarity} = \cos\theta = \frac{\mathbf{u} \cdot \mathbf{v}}{\|\mathbf{u}\| \|\mathbf{v}\|}$$
    Normalizing by vector length isolates *semantic orientation* from document length or volume.
* **Mechanistic Mental Model & Formal Theory:**
  * *Vector Space Axioms:* Linear combinations, span, and linear independence in $\mathbb{R}^d$.
  * *Vector Norms:* $L_2$ Euclidean distance ($\|\mathbf{x}\|_2 = \sqrt{\sum x_i^2}$) vs $L_1$ Manhattan distance ($\|\mathbf{x}\|_1 = \sum |x_i|$).
  * *The Geometric Spectrum of Similarity:* Acute angle ($\cos\theta > 0$, positive correlation), Orthogonal ($\cos\theta = 0$, independent/unrelated), Obtuse angle ($\cos\theta < 0$, opposing concepts).
  * *Vectorized Matrix Formulation:* Computing pairwise cosine similarity across $N$ data points in a single vectorized NumPy operation:
    $$S = \tilde{X} \tilde{X}^T \quad \text{where } \tilde{X}_i = \frac{X_i}{\|X_i\|_2}$$
* **Authentic Production Application:**
  * Building a high-performance Vector Semantic Search & Product Recommendation Engine from scratch in NumPy: taking user queries and product embeddings, normalizing coordinates, and computing Top-$K$ nearest neighbors in sub-millisecond batch execution.
* **Boundary & Failure Modes:**
  * Division-by-zero during cosine normalization of null vectors ($\|\mathbf{x}\| = 0$); the Curse of Dimensionality in high dimensions ($d > 10,000$) where random vectors become nearly orthogonal.
* **Transfer Challenge:**
  * Given a user query vector $\mathbf{q} \in \mathbb{R}^{128}$ and a matrix of 100,000 document embeddings $X \in \mathbb{R}^{100000 \times 128}$, write the single-line vectorized NumPy expression to retrieve the indices of the top 5 most semantically relevant documents.
* **Synthesis & Narrative Bridge:**
  * *Synthesis:* Computers understand reality by encoding entities into vectors in $\mathbb{R}^d$. The dot product and cosine similarity turn geometric angles into semantic comparisons.
  * *Bridge to Block 2:* *"Now that we have mapped real-world data into points and arrows in space, how do we manipulate, rotate, filter, and project entire datasets simultaneously? What is a matrix, really?"*

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 2 [01:00 - 02:00]: What is a Matrix, Really? Linear Transformations & Spaces                │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *The Mystery:* Matrix multiplication is usually taught as an arbitrary, mechanical rule ("row times column"). But why does multiplying a dataset by a matrix rotate a 3D object, while multiplying by another matrix flattens space into a 2D shadow? And why does a matrix with $\det(A) = 0$ permanently destroy data, making it mathematically impossible to recover the original information?
* **Learner Starting State & Misconceptions:**
  * *Naive Model:* A matrix is just a 2D spreadsheet container; matrix multiplication is an arbitrary algebra formula.
  * *Dissonance:* Matrices act as dynamic spatial transformation machines that bend, rotate, scale, or collapse coordinate grids.
* **Prediction & Commitment Task:**
  * Basis vector landing prediction: Where do standard unit basis vectors $\hat{i} = [1, 0]^T$ and $\hat{j} = [0, 1]^T$ land under matrix $A = \begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix}$? Predict the geometric transformation (a $90^\circ$ counter-clockwise rotation).
  * Dimension collapse prediction: What happens to a 2D image when transformed by $A = \begin{bmatrix} 1 & 2 \\ 2 & 4 \end{bmatrix}$? Predict whether the transformation can ever be undone ($A^{-1}$).
* **The Reveal Ladder:**
  * **Reveal 1 (Columns as Basis Vector Destinations):** The columns of matrix $A$ are simply the coordinates of where the unit basis vectors $\hat{i}, \hat{j}, \dots$ land after transformation:
    $$A \mathbf{x} = x_1 \mathbf{a}_1 + x_2 \mathbf{a}_2 + \dots + x_d \mathbf{a}_d$$
    Matrix-vector multiplication is nothing more than taking a linear combination of the matrix's columns!
  * **Reveal 2 (Matrix Multiplication as Composition of Actions):** Multiplying $A B$ means applying transformation $B$ first, then transformation $A$ on the result: $(A B)\mathbf{x} = A(B\mathbf{x})$. (Explaining why $A B \ne B A$).
  * **Reveal 3 (The Determinant as Spatial Volume Scaling):** $\det(A)$ represents the exact factor by which spatial areas (in 2D) or volumes (in $n\text{D}$) are scaled:
    - $\det(A) = 0 \implies$ Volume collapses to zero (loss of a dimension $\to$ non-invertible/singular).
    - $\det(A) < 0 \implies$ Spatial orientation is inverted (mirror reflection).
  * **Reveal 4 (Column Space & Rank):** Column Space $\text{Col}(A)$ is the span of all possible outputs. Matrix Rank is the true dimensionality of the output space.
  * **Reveal 5 (Solving Linear Systems $A\mathbf{x} = \mathbf{b}$):** Recovering the original input $\mathbf{x}$ via matrix inversion $A^{-1}$ or orthogonal projection.
* **Mechanistic Mental Model & Formal Theory:**
  * *Linear Transformation Invariants:* Lines remain straight, origin $\mathbf{0}$ stays fixed, and grid lines remain parallel and evenly spaced.
  * *Geometric Operators in Code:* Rotation matrices ($R_\theta$), Scaling matrices, Shear matrices, and Orthogonal Projection matrices ($P = A(A^T A)^{-1} A^T$).
  * *Linear Regression as Geometric Projection:* Solving Ordinary Least Squares (OLS) normal equations $\hat{\mathbf{w}} = (X^T X)^{-1} X^T \mathbf{y}$ as the orthogonal projection of target $\mathbf{y}$ onto the column space of feature matrix $X$.
* **Authentic Production Application:**
  * Implementing spatial coordinate transformations, 2D/3D image warping, and computing an Ordinary Least Squares (OLS) linear regression model directly through geometric projection in NumPy.
* **Boundary & Failure Modes:**
  * Collinear features causing singular matrices ($\det(X^T X) = 0$), making $(X^T X)^{-1}$ impossible to compute; catastrophic numerical instability when using `np.linalg.inv` vs stable `np.linalg.lstsq`.
* **Transfer Challenge:**
  * If a transformation matrix $A \in \mathbb{R}^{3 \times 3}$ has rank 2, describe geometrically what happens to a 3D sphere of data points transformed by $A$, and explain why no inverse matrix $A^{-1}$ can ever restore the original sphere.
* **Synthesis & Narrative Bridge:**
  * *Synthesis:* A matrix is a linear transformation machine. Its columns tell us where basis vectors land, its determinant measures volume scaling, and its rank measures output dimensionality.
  * *Bridge to Block 3:* *"When a matrix transforms space, almost all vectors are rotated and pushed off their original lines. But are there special, invariant directions that only get stretched without rotating? How do these directions unlock data compression and Principal Component Analysis?"*

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ BLOCK 3 [02:00 - 03:00]: Finding Axes of Maximum Truth: Eigen, SVD & Dimensionality Reduction     │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```
* **Local Mystery / Cognitive Hook:**
  * *The Mystery:* An image contains $1,000 \times 1,000$ pixels ($1,000,000$ numbers) and a customer database contains 500 features. Most of these numbers are redundant and correlated. By calculating just a handful of special vectors, we can compress the entire dataset down to 20 numbers while preserving 98% of all patterns and information. How does linear algebra find these exact "axes of maximum variance", and how does SVD discover them automatically?
* **Learner Starting State & Misconceptions:**
  * *Naive Model:* Dimensionality reduction means manually dropping or deleting columns from a dataset.
  * *Dissonance:* Deleting columns throws away unique information; rotating the coordinate space to align with principal directions captures shared variation across all columns simultaneously.
* **Prediction & Commitment Task:**
  * Invariant direction prediction: For a 2D transformation that stretches the x-axis by 3 and the y-axis by 2, which vectors do not change their directional angle?
  * Covariance orientation prediction: If height and weight are strongly positively correlated, where does the axis of greatest spread lie relative to the standard horizontal/vertical axes?
* **The Reveal Ladder:**
  * **Reveal 1 (The Eigenvector Phenomenon):** When a matrix $A$ acts on vector $\mathbf{v}$, it generally changes both direction and length. But for special vectors, the transformation only scales length without changing direction:
    $$A \mathbf{v} = \lambda \mathbf{v}$$
    $\mathbf{v}$ is an **Eigenvector**, and $\lambda$ is its **Eigenvalue** (stretch factor).
  * **Reveal 2 (The Data Covariance Matrix):** For centered data $X \in \mathbb{R}^{n \times d}$, $\Sigma = \frac{1}{n} X^T X$ captures the variance of each feature on the diagonal and pairwise correlations on the off-diagonals.
  * **Reveal 3 (Spectral Decomposition):** Diagonalizing $\Sigma = Q \Lambda Q^T$ rotates the coordinate grid so that all off-diagonal correlations become zero—uncorrelating the features completely!
  * **Reveal 4 (Singular Value Decomposition — The Master Tool):** Any rectangular data matrix $X \in \mathbb{R}^{n \times d}$ can be factored into:
    $$X = U \Sigma V^T$$
    - $U$ ($n \times k$): Sample coordinates in the new latent space.
    - $\Sigma$ ($k \times k$): Singular values $\sigma_i$ measuring the importance/energy of each axis.
    - $V^T$ ($k \times d$): Principal component direction vectors in feature space.
  * **Reveal 5 (Optimal Low-Rank Compression):** Keeping only the top $k$ singular values ($X_k = U_k \Sigma_k V_k^T$) gives the mathematically optimal rank-$k$ approximation of the original dataset (Eckart-Young-Mirsky Theorem).
* **Mechanistic Mental Model & Formal Theory:**
  * *Principal Component Analysis (PCA) Algorithm:*
    1. Zero-center the data: $X_{\text{centered}} = X - \bar{X}$.
    2. Compute SVD: $U, S, V^T = \text{np.linalg.svd}(X_{\text{centered}}, \text{full\_matrices}=\text{False})$.
    3. Calculate Explained Variance Ratio: $\text{EVR}_i = \frac{\sigma_i^2}{\sum \sigma_j^2}$.
    4. Project onto top $k$ principal components: $Z = X_{\text{centered}} V_{:, :k} = U_{:, :k} S_{:k}$.
  * *Scree Plot & Cumulative Variance:* Determining the optimal number of dimensions $k$ where the elbow curve captures $\ge 95\%$ of total variance.
* **Authentic Production Application:**
  * Building an end-to-end Image Compression & Tabular Feature Reduction pipeline in NumPy from scratch: decomposing high-dimensional matrices, plotting explained variance, and reconstructing data with $90\%+$ storage reduction.
* **Boundary & Failure Modes:**
  * PCA assumes linear relationships (fails on non-linear manifolds like Swiss rolls); unstandardized features with large numerical ranges (e.g. Income in dollars vs Age in years) distorting principal axes without proper scaling.
* **Transfer Challenge:**
  * Explain how SVD powers Recommendation Systems (Collaborative Filtering) by factorizing an incomplete User-Movie rating matrix into latent User preference vectors ($U$) and latent Movie genre vectors ($V$).
* **Session Synthesis & North-Star Resolution:**
  * *Synthesis:* A computer understands the world by converting entities into vectors in $\mathbb{R}^d$. Matrices act as spatial transformations, and matrix decompositions (SVD/PCA) discover the natural, un-correlated coordinate axes of reality, allowing us to compress massive datasets while preserving their fundamental meaning.
  * *Bridge to Session 3 (Statistical Foundations & Probability):* *"Linear algebra gives us the geometry of clean, deterministic vector spaces. But real-world data is plagued by noise, randomness, and sampling bias. How do we reason mathematically when our measurements themselves are uncertain?"*
