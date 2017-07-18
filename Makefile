# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXAUTOBUILD   = sphinx-autobuild
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) help "phasor" "build" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

apidoc: Makefile
	sphinx-apidoc ~/projects/phasor/phasor -o "phasor/apidoc/" 
	sphinx-apidoc ~/projects/declarative/declarative -o "phasor/apidoc_decl/" 

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
auto%: Makefile
	@$(SPHINXAUTOBUILD) -b $* "phasor" "build" $(SPHINXOPTS) $(O)

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -b $@ "phasor/" "build" $(SPHINXOPTS) $(O)
