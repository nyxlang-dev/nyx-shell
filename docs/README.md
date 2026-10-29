# nyx-shell — Documentation

## Overview

nyx-shell is a POSIX-compatible interactive shell written entirely in Nyx (~1175 lines, single file). It demonstrates process control capabilities using only Nyx builtins — no imports, no FFI, no C glue code.

## Architecture

The shell is implemented in `src/main.nx` as a single file with these logical sections:

| Section | Description |
|---------|-------------|
| Constants | History limit, key codes |
| String utilities | `starts_with`, `char_at`, `is_whitespace`, `trim`, etc. |
| Tokenizer | Splits input into tokens respecting quotes and special chars |
| Parser | Builds command structures from tokens (pipes, redirects, conditionals) |
| Variable expansion | `$VAR`, `${VAR}`, `$?` (last exit), `$$` (PID), tilde expansion |
| Builtins | `cd`, `pwd`, `echo`, `export`, `unset`, `type`, `history`, `exit` |
| Executor | `try_spawn()` + `try_child_wait()` (`std/process`) for external commands |
| Pipes | `try_spawn_pipeline()` for arbitrary-length pipelines |
| Redirects | `Stdio.File(path, "r"/"w"/"a")` for `<`, `>`, `>>` |
| History | Persistent history in `~/.nyx_history`, arrow key navigation |
| Line editor | Raw mode input with cursor movement, word delete, clear screen |
| Main loop | Prompt → read line → tokenize → parse → execute cycle |

## Process Builtins Used

These Nyx builtins power the shell's POSIX functionality:

- `std/process`: `spawn_opts()`, `try_spawn`, `try_spawn_pipeline`, `try_child_wait`, `Stdio`
- `getcwd()` / `chdir(path)` — working directory
- `getenv(name)` / `setenv(name, val)` — environment variables
- `getpid()` — process ID for `$$` expansion
- `isatty(fd)` — detect interactive vs pipe mode
- `stat(path)` — check file existence for PATH lookup

## Limitations

- No job control (`bg`, `fg`, `Ctrl+Z`)
- No globbing (`*.txt`, `?` wildcards)
- No heredocs (`<<EOF`)
- No command substitution (`$(cmd)` or backticks)
- No arithmetic expansion (`$((1+2))`)
