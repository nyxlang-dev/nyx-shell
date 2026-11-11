# Makefile — nyx-shell-stack
# El toolchain Nyx (compilador, runtime, std) vive fuera de este repo.
# Se apunta vía NYX_HOME (patrón nyx-kv-stack / nyx-edit-stack).

NYX_HOME ?= /home/admin/nyx/lang
export NYX_HOME

.PHONY: build test-shell clean install uninstall

build:
	nyx build

test-shell: build
	bash tests/smoke.sh
	bash tests/spawn.sh

# Deja el binario JUNTO AL TOOLCHAIN, no en el PATH del usuario: así
# `nyx shell` anda desde cualquier proyecto. El wrapper `nyx` lo busca primero
# en el PATH (una build de desarrollo gana) y después acá. Es lo que el propio
# wrapper le dice al usuario que corra cuando no encuentra nyx-shell; hasta el
# 2026-11-11 este Makefile no tenía el target.
NYX_BIN ?= $(HOME)/.nyx/bin

install: build
	@mkdir -p "$(NYX_BIN)"
	@cp nyx-shell "$(NYX_BIN)/nyx-shell"
	@echo "✓ nyx-shell instalado en $(NYX_BIN)"
	@echo "  Pruébalo desde cualquier proyecto:  nyx shell"

uninstall:
	@rm -f "$(NYX_BIN)/nyx-shell"
	@echo "✓ nyx-shell quitado de $(NYX_BIN)"

clean:
	rm -f nyx-shell script.nx script.ll nyx.lock
