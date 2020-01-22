# This Makefile is for project packaging

default: mdoc

.PHONY: doc
doc: mdoc

# Builds the Matlab Toolbox help files
.PHONY: mdoc
mdoc:
	cd doc; bundle exec jekyll build --destination ../M-doc
