CASK        ?= cask
EMACS       ?= emacs
EMACSFLAGS   = --batch -Q
EMACSBATCH   = $(EMACS) $(EMACSFLAGS)

EMACS_D      = ~/.emacs.d

SRCS         = unify-opening.el

.PHONY: all clean-elc clean check lint
all : check

clean :
	rm -f *.elc

check : lint

lint : $(SRCS) clean
	# Byte compile all and stop on any warning or error
	${CASK} emacs $(EMACSFLAGS) \
	--eval "(setq byte-compile-error-on-warn t)" \
	-L . -f batch-byte-compile ${SRCS}

	# Run package-lint to check for packaging mistakes
	${CASK} emacs $(EMACSFLAGS) \
	-l package-lint.el \
	-f package-lint-batch-and-exit ${SRCS}
