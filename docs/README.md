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
| Executor | `fork()` + `execvp()` + `waitpid()` for external commands |
| Pipes | `pipe_new()` + `dup2()` for arbitrary-length pipelines |
| Redirects | `open_fd()` + `dup2()` for `>`, `>>`, `<` |
| History | Persistent history in `~/.nyx_history`, arrow key navigation |
| Line editor | Raw mode input with cursor movement, word delete, clear screen |
| Main loop | Prompt → read line → tokenize → parse → execute cycle |

## Process Builtins Used

These Nyx builtins power the shell's POSIX functionality:

- `fork()` — create child process
- `execvp(prog, args)` — replace child with external command
- `waitpid(pid, opts)` — wait for child to finish, get exit status
- `dup2(old_fd, new_fd)` — redirect file descriptors (pipes, redirects)
- `pipe_new()` — create pipe (returns array `[read_fd, write_fd]`)
- `open_fd(path, mode)` / `close_fd(fd)` — file descriptor operations
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
- `fork()` + GC constraint: child must call `execvp()` immediately
