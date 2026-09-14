.PHONY: decks deck session topic topics sample-deck clean-decks validate-decks

sample-deck:
	$(MAKE) -C lecture-decks sample-deck

decks:
	$(MAKE) -C lecture-decks all

# Example: make deck DECK=M00/session-01/m00-session-01.tex
deck:
	$(MAKE) -C lecture-decks deck DECK="$(DECK)"

# Example: make session SESSION=M00/session-01
session:
	$(MAKE) -C lecture-decks session SESSION="$(SESSION)"

# Example: make topic TOPIC=M00/session-01/topics/topic-01-workspace.tex
topic:
	$(MAKE) -C lecture-decks topic TOPIC="$(TOPIC)"

# Example: make topics SESSION=M00/session-01
topics:
	$(MAKE) -C lecture-decks topics SESSION="$(SESSION)"

clean-decks:
	$(MAKE) -C lecture-decks clean

validate-decks:
	$(MAKE) -C lecture-decks validate
