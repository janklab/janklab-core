.PHONY: fetch

VERSION=1.0.1
TARBALL=matlab-jarext-inspector-$(VERSION).tgz

fetch:
	rm -rf matlab-jarext-inspector-*
	wget https://github.com/apjanke/matlab-jarext-inspector/releases/download/v$(VERSION)/$(TARBALL)
	tar xzf $(TARBALL)
	rm $(TARBALL)