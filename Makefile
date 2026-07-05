# nyx-shell — Portable Makefile
# Prerequisites: Nyx toolchain installed
#   curl -sSf https://nyxlang.com/install.sh | sh
BINARY = nyx-shell
.PHONY: build clean
build:
	nyx build
clean:
	rm -f $(BINARY)
