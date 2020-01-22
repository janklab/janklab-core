# This Makefile is for project packaging

default: all

.PHONY: all
all: mdoc dist

.PHONY: dist
dist:
	bash package_janklab.sh

.PHONY: doc
doc: mdoc

# Builds the Matlab Toolbox help files
.PHONY: mdoc
mdoc:
	(cd doc; bundle exec jekyll build --destination ../M-doc)
