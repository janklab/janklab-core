
# Builds the Matlab Toolbox help files
.PHONY: mdoc
mdoc:
	jekyll build --source doc --destination M-doc