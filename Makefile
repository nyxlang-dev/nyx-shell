# Makefile — nyx-shell-stack
# El toolchain Nyx (compilador, runtime, std) vive fuera de este repo.
# Se apunta vía NYX_HOME (patrón nyx-kv-stack / nyx-edit-stack).

NYX_HOME ?= /home/admin/nyx/lang
export NYX_HOME

.PHONY: build test-shell clean

build:
	nyx build

test-shell: build
	bash tests/smoke.sh

clean:
	rm -f nyx-shell script.nx script.ll nyx.lock
