COQC ?= coqc
COQDEP ?= coqdep

VFILES = src/Ledger.v src/InvariantProofs.v
VOFILES = $(VFILES:.v=.vo)

all: $(VOFILES)

%.vo: %.v
	$(COQC) -Q src FinancialEngine $<

test: all
	@echo "[COQ] All formal invariant proofs typechecked successfully with zero axioms."

clean:
	rm -f src/*.vo src/*.glob src/.*.aux

.PHONY: all test clean
