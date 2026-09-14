# Run from lecture-decks/. A session is assembled from topics/; PDFs are written
# beside their matching source. Editing one topic never requires compiling the
# complete session until you explicitly ask for its assembled PDF.
LATEXMK ?= latexmk
LATEXMK_FLAGS := -xelatex -interaction=nonstopmode -halt-on-error -file-line-error
THEME_DIR := $(abspath theme)
DECKS := $(shell find . -type f -name '*.tex' ! -path './theme/*' ! -path './templates/*' ! -path '*/topics/*' | sort)
TOPIC_SOURCES := $(shell find . -type f -path '*/topics/*.tex' | sort)
ALL_SOURCES := $(DECKS) $(TOPIC_SOURCES)

.PHONY: all deck session topic topics topic-all clean validate list list-topics sample-deck help

help:
	@echo "make all                                         Compile assembled sessions, pre-reads and sample"
	@echo "make sample-deck                                 Compile reference Data Science on AWS masterclass deck"
	@echo "make deck DECK=M00/session-01/m00-session-01.tex Compile one assembled deck"
	@echo "make session SESSION=M00/session-01              Compile one assembled session"
	@echo "make topic TOPIC=M00/session-01/topics/topic-01-workspace.tex"
	@echo "make topics SESSION=M00/session-01               Compile every topic in one session"
	@echo "make validate                                    Compile all sources and check every PDF"
	@echo "make clean                                       Remove auxiliary LaTeX files"

list:
	@printf '%s\n' $(DECKS)

list-topics:
	@printf '%s\n' $(TOPIC_SOURCES)

sample-deck:
	@$(MAKE) --no-print-directory deck DECK=_sample_/sample-deck.tex

all:
	@failed=0; \
	for source in $(DECKS); do \
	  $(MAKE) --no-print-directory deck DECK="$$source" || failed=1; \
	done; \
	exit $$failed

deck:
	@test -n "$(DECK)" || (echo "Set DECK, e.g. make deck DECK=M00/session-01/m00-session-01.tex"; exit 2)
	@test -f "$(DECK)" || (echo "Deck not found: $(DECK)"; exit 2)
	@dir=$$(dirname "$(DECK)"); file=$$(basename "$(DECK)"); \
	  echo "==> $(DECK)"; \
	  cd "$$dir" && TEXINPUTS="$(THEME_DIR):" $(LATEXMK) $(LATEXMK_FLAGS) "$$file" && $(LATEXMK) -c "$$file" && find . -maxdepth 1 -type f \( -name '*.nav' -o -name '*.snm' -o -name '*.vrb' -o -name '*.xdv' \) -delete

session:
	@test -n "$(SESSION)" || (echo "Set SESSION, e.g. make session SESSION=M00/session-01"; exit 2)
	@test -d "$(SESSION)" || (echo "Session directory not found: $(SESSION)"; exit 2)
	@source=$$(find "$(SESSION)" -maxdepth 1 -type f -name '*.tex' | head -n 1); \
	  test -n "$$source" || (echo "Session source not found in: $(SESSION)"; exit 2); \
	  $(MAKE) --no-print-directory deck DECK="$$source"

topic:
	@test -n "$(TOPIC)" || (echo "Set TOPIC, e.g. make topic TOPIC=M00/session-01/topics/topic-01-workspace.tex"; exit 2)
	@$(MAKE) --no-print-directory deck DECK="$(TOPIC)"

topics:
	@test -n "$(SESSION)" || (echo "Set SESSION, e.g. make topics SESSION=M00/session-01"; exit 2)
	@test -d "$(SESSION)/topics" || (echo "Topics directory not found: $(SESSION)/topics"; exit 2)
	@failed=0; \
	for source in $$(find "$(SESSION)/topics" -maxdepth 1 -type f -name '*.tex' | sort); do \
	  $(MAKE) --no-print-directory topic TOPIC="$$source" || failed=1; \
	done; \
	exit $$failed

topic-all:
	@failed=0; \
	for source in $(TOPIC_SOURCES); do \
	  $(MAKE) --no-print-directory topic TOPIC="$$source" || failed=1; \
	done; \
	exit $$failed

validate: all topic-all
	@failed=0; \
	for source in $(ALL_SOURCES); do \
	  pdf="$${source%.tex}.pdf"; pages=$$(pdfinfo "$$pdf" 2>/dev/null | awk '/^Pages:/ {print $$2}'); \
	  if test -z "$$pages" || test "$$pages" -lt 1; then echo "Invalid PDF: $$pdf"; failed=1; fi; \
	done; \
	exit $$failed

clean:
	@find . -type f \( -name '*.aux' -o -name '*.fdb_latexmk' -o -name '*.fls' -o -name '*.log' -o -name '*.nav' -o -name '*.out' -o -name '*.snm' -o -name '*.synctex.gz' -o -name '*.toc' -o -name '*.vrb' -o -name '*.xdv' \) -delete
