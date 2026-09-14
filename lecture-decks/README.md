# UpGrad lecture decks

This is a content-first Beamer framework for lecture sessions and pre-reads. A
deck folder contains both its editable `.tex` source and its deliverable PDF;
the shared theme lives once in `theme/`. The framework deliberately uses the
current official upGrad wordmark red (`#EE2F3D`) with an accessible neutral
layout. No local logo, presentation PDF, screenshot, or brand-kit asset was
present in this repository, so no unverified logo treatment was recreated.

## Layout

```text
lecture-decks/
├── Makefile                         # compile sessions, topics, validate and clean
├── theme/
│   ├── upgradbeamer.sty             # the single visual/component layer
│   └── assets/                      # approved assets shared across decks
├── templates/
│   ├── deck-template.tex             # starting point for a standalone pre-read
│   ├── session-template.tex          # session assembler
│   └── topic-template.tex            # independently compilable topic
├── _sample_/                        # living documentation + visual test suite
│   ├── sample-deck.tex
│   └── assets/                      # sample-only images and code snippets
├── M00/session-01/
│   ├── m00-session-01.tex            # assembled session deck
│   └── topics/topic-01-workspace.tex # independently compiled topic
├── M00/session-02/m00-session-02.tex
├── M00/session-03/m00-session-03.tex # transparent content-status scaffold
├── M00/session-04/m00-session-04.tex
├── M01/pre-read/m01-pre-read.tex
├── M01/session-01/ ... session-04/
└── M02/ ... M11/                    # each has pre-read/ and session-01/ ... session-04/
```

The direct `session-01/` and `pre-read/` convention is retained from the
repository's original `lecture-decks/README.md`; it was the only existing
lecture-deck hierarchy. `_sample_` intentionally appears before `M00`.

Use lowercase predictable names: `m03-session-02.tex` / `m03-session-02.pdf`
and `m03-pre-read.tex` / `m03-pre-read.pdf`. A session's own `assets/` folder
holds screenshots, diagrams and code snippets used only by that session. Put
only genuinely cross-deck material in `theme/assets/`.

Every session now has a `topics/` directory. Its parent `.tex` is the session
assembler; each topic is a valid `subfiles` document and receives its own PDF.
Where reviewed material was unavailable, the session contains a clearly labelled
topic-level content-status scaffold rather than invented courseware.

## Compile

The system uses `latexmk` with the reliable `listings` backend, so it does not
need `-shell-escape`. PDFs remain next to their sources; successful builds clean
their rebuildable LaTeX auxiliary files automatically, and `make clean` removes
any stale auxiliary files without touching PDFs.

From the repository root:

```bash
make decks
make deck DECK=M00/session-01/m00-session-01.tex
make session SESSION=M00/session-01
make topic TOPIC=M00/session-01/topics/topic-01-workspace.tex
make topics SESSION=M00/session-01
make validate-decks
make clean-decks
```

Or, from this directory:

```bash
make all
make deck DECK=_sample_/sample-deck.tex
make session SESSION=M00/session-01
make topic TOPIC=M00/session-01/topics/topic-01-workspace.tex
make topics SESSION=M00/session-01
make validate
make clean
```

`make topic` is the fast authoring loop for a 200--300-slide session: it loads
the shared preamble but renders only the selected topic. `make session` assembles
every topic into the learner-facing session PDF. `make topics` builds all topic
PDFs for one session; `make validate` builds and checks every parent and topic.
`make deck` remains available for any direct source path.

## Create a session, topic or pre-read

```bash
cp templates/session-template.tex M02/session-03/m02-session-03.tex
mkdir -p M02/session-03/topics
cp templates/topic-template.tex M02/session-03/topics/topic-01-name.tex
# Point the topic template at its parent and add it with \subfile{...}.
make topic TOPIC=M02/session-03/topics/topic-01-name.tex
make session SESSION=M02/session-03
```

For a pre-read, copy `deck-template.tex` to `M02/pre-read/m02-pre-read.tex` and
change the final title-slide argument to `Pre-read`. Keep theme changes out of
individual decks; extend `theme/upgradbeamer.sty` when a pattern will be reused.

## Topic authoring API

The parent session sets metadata in its preamble, introduces the session, lists
its topics, then includes the files in teaching order:

```tex
\usepackage{subfiles}
\usepackage{upgradbeamer}
\DeckMetadata{M02}{Session 03}
...
\SessionTopicsSlide{
  \TopicEntry{01}{Data contract}{Make the scoring timestamp explicit.}
  \TopicEntry{02}{Baseline}{Train and inspect a reproducible model.}
}
\subfile{topics/topic-01-data-contract}
\subfile{topics/topic-02-baseline}
```

Each topic starts and ends as a normal `subfiles` document. The standalone title
appears only for a topic PDF; the divider appears in both its standalone PDF and
the assembled session.

```tex
\documentclass[../m02-session-03.tex]{subfiles}
\begin{document}
\TopicStandaloneTitle{01}{Data contract}{Session title}
\TopicDivider{01}{Data contract}{Make the scoring timestamp explicit.}
% topic frames
\end{document}
```

## Author-facing slide API

Every deck begins with:

```tex
\documentclass[aspectratio=169,10pt]{beamer}
\usepackage{upgradbeamer}
\author{UpGrad Learning Team}
\date{}
\begin{document}
\UpGradTitleSlide{Title}{Subtitle}{M02}{Session 03}
```

The sample deck is the full visual test suite. Common patterns are:

```tex
\TopicDivider{01}{A clear topic title}{One sentence on why this matters.}

\begin{LearningObjectives}{By the end, learners can}
  \begin{itemize}\item Apply an observable outcome.\end{itemize}
\end{LearningObjectives}

\begin{DefinitionBox}{Feature leakage} ... \end{DefinitionBox}
\begin{ConceptBox}{Mental model} ... \end{ConceptBox}
\begin{ExampleBox}{Worked example} ... \end{ExampleBox}
\begin{WarningBox}{Common failure} ... \end{WarningBox}
\begin{QuestionBox}{Discuss} ... \end{QuestionBox}
\begin{ExerciseBox}{Try it} ... \end{ExerciseBox}
\begin{CaseStudyBox}{Context} ... \end{CaseStudyBox}
\begin{TakeawayBox}{Remember} ... \end{TakeawayBox}

\TwoColumnLayout{left column content}{right column content}
\begin{UpGradTable}{p{.22\linewidth} X}
  \TableHeaderRow \TableHead{A} & \TableHead{B}\\ ...
\end{UpGradTable}
```

For diagrams, use normal TikZ with the supplied styles
`upgrad/service`, `upgrad/data`, `upgrad/model`, and `upgrad/flow`. This keeps
architectures editable instead of turning them into opaque images.

### TeXScience diagrams

`upgradbeamer` now includes a local TeXScience layer. Use
`\usepackage[science]{upgradbeamer}` in a session that needs `siunitx`,
`circuitikz`, `chemfig` or `tikz-3dplot`; `pgfplots` and the shared plot styles
remain available in the base theme. This keeps ordinary topic compiles lean. It
is intentionally TeX-native: no shell escape, external renderer or network
dependency is needed. Use
`ScientificFigure`, the `upgrad/science plot` axis style, `\ScienceUnit`, and
the `upgrad/science node` / `upgrad/measurement` TikZ styles. The sample's
`topics/topic-04-texscience.tex` is a compiled working example.

```tex
\begin{ScientificFigure}{Validation curve}
  \begin{tikzpicture}
    \begin{axis}[upgrad/science plot,xlabel={complexity},ylabel={loss}]
      \addplot[color=UpGradRed,domain=0:10] {.03*(x-5)^2+.2};
    \end{axis}
  \end{tikzpicture}
  \ScienceCaption{Editable PGFPlots source.}
\end{ScientificFigure}
```

## Code and technical annotations

`listings` is selected intentionally as the zero-shell-escape fallback that is
installed with the local toolchain. It supports Python, SQL and Bash directly;
the theme also defines JSON and YAML. Line numbers are on by default so a class
can talk about a precise line; a normal block is:

```tex
\begin{CodeBlock}[numbers=left]{Python}
model.fit(X_train, y_train)
\end{CodeBlock}
```

Highlight precise line numbers with a readable background:

```tex
\begin{HighlightedCodeBlock}[numbers=left]{Python}{3,4}
# lines 3 and 4 are highlighted
\end{HighlightedCodeBlock}
```

For code and a teaching note that stay aligned without manual positioning, keep
the snippet in the local `assets/code/` directory and use:

```tex
\CodeFromFileWithCallout{Python}{assets/code/train.py}{11,13,14}
  {Lines 11, 13--14}{Explain model fitting and inference here.}
```

The optional first argument accepts ordinary `listings` options, so authors can
set `firstline`, `lastline`, `numbers`, or language-specific options per use.

## Images, screenshots and citations

Use `\DeckImage[trim=0 10 0 0,clip]{assets/feature-store.png}{Caption}` for a
bounded full-width image; it cannot exceed the frame height by default. Use
`\SideBySideFigures{left.png}{Left caption}{right.png}{Right caption}` for a
comparison. For annotated screenshots:

```tex
\begin{AnnotatedScreenshot}{assets/sagemaker-endpoint.png}{Create endpoint}
  \ScreenshotCallout{65}{68}{choose the approved model}
  \ScreenshotCallout{71}{18}{record the endpoint name}
\end{AnnotatedScreenshot}
```

Coordinates are percentages of the image, so annotations survive an image being
rescaled. The sample's AWS Console mock shows the intended visual density when
an approved screenshot is not yet available. Use `\Citation{Source or note}`
for a slide-local attribution and the `References` environment for a final
reference slide.

## Migration ledger

There were no Markdown-based deck files, session folders, PDFs, screenshots or
brand assets in the repository when this framework was introduced. Therefore
there was nothing to convert and no original deck was deleted or overwritten.
The source curriculum files remain unchanged in `curriculum-and-session-plans/`.

`M00/session-01`, `M00/session-02`, and `M01/pre-read` are conservative seed
decks derived from the documented high-level curriculum (Python, cloud
fundamentals, S3, Git and data-engineering concepts). They are not represented
as a lossless migration because the corresponding session plans are explicitly
draft placeholders. The other 56 session/pre-read folders have compiled,
transparent content-status scaffolds: they preserve the requested deliverable
pair without claiming that unprovided instructional material was migrated. Add
approved material by replacing the scaffold with the template or a reviewed deck.
