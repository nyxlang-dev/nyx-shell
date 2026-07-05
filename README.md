# nyx-shell

A POSIX-compatible interactive shell written entirely in Nyx (~1175 lines, single file). Demonstrates Nyx's process control builtins (fork, execvp, waitpid, dup2, pipe) with no FFI or C glue code.

Shell interactivo compatible con POSIX escrito completamente en Nyx (~1175 líneas, archivo único). Demuestra los builtins de control de procesos de Nyx (fork, execvp, waitpid, dup2, pipe) sin FFI ni código C adicional.

---

## Install

Install the Nyx toolchain:

```bash
curl -sSf https://nyxlang.com/install.sh | sh
```

## Quick start

```bash
git clone https://github.com/nyxlang-dev/nyx-shell
cd nyx-shell
nyx build
./nyx-shell
```

## Usage

```bash
./nyx-shell                        # interactive mode
./nyx-shell -c "ls -la"            # run a single command
echo "cmd1 | cmd2" | ./nyx-shell   # pipe mode (non-interactive)
nyx shell                          # via Nyx wrapper
```

## Features

- **External commands**: PATH lookup + fork + execvp + waitpid
- **Pipes**: `cmd1 | cmd2 | cmd3` — arbitrary pipeline length
- **Redirects**: `>`, `>>`, `<`
- **Conditionals**: `&&` (run on success), `||` (run on failure)
- **Variable expansion**: `$VAR`, `${VAR}`, `$?` (last exit code), `$$` (PID)
- **Tilde expansion**: `~/path` → `$HOME/path`
- **Quoted strings**: `"interpolated"` and `'literal $no-expand'`
- **Persistent history**: saved across sessions to `~/.nyx_history`
- **Raw mode line editor**: inline editing with arrow keys and cursor movement

## Builtins

| Command | Description |
|---------|-------------|
| `cd [dir]` | Change directory (`cd` alone goes to `$HOME`) |
| `pwd` | Print working directory |
| `echo [args...]` | Print arguments to stdout |
| `export VAR=value` | Set environment variable |
| `unset VAR` | Remove environment variable |
| `type cmd` | Show whether command is builtin or external (with path) |
| `history` | Show command history |
| `exit [code]` | Exit shell (default code: 0) |

## Keybindings

| Key | Action |
|-----|--------|
| `Up` / `Down` | Navigate history |
| `Left` / `Right` | Move cursor in line |
| `Home` / `Ctrl+A` | Move to start of line |
| `End` / `Ctrl+E` | Move to end of line |
| `Ctrl+K` | Delete from cursor to end of line |
| `Ctrl+U` | Delete from start of line to cursor |
| `Ctrl+W` | Delete previous word |
| `Ctrl+L` | Clear screen |
| `Ctrl+C` | Cancel current line |
| `Ctrl+D` | Exit shell (on empty line) |
| `Backspace` | Delete previous character |
| `Delete` | Delete character at cursor |

## Documentation

Internal architecture and implementation notes: [`docs/README.md`](./docs/README.md)

## Limitations

- No job control (`bg`, `fg`, `Ctrl+Z`)
- No filename globbing (`*.txt`)
- No heredocs (`<<EOF`)
- No command substitution (`$()` or backticks)
- No arithmetic expansion (`$((...))`)

## License

Apache 2.0 — see [LICENSE](../../LICENSE)
