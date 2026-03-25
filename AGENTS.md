# PROJECT KNOWLEDGE BASE

## OVERVIEW
`hl-tutor` boots a local terminal-based coding tutor. `setup.sh` is the single file entrypoint, but it has two invocation modes: install (`setup.sh`) and runtime (`tutor`).

## STRUCTURE
```text
setup.sh                # bootstrap, launcher, remote self-reexec, tmux session creation
tutor/                  # tutor runtime memory copied into ~/tutor-workspace
tutor-hooks/            # Claude Code hook config copied into isolated workspace
TUTOR_PROMPT.md         # tutor behavior, pacing, session rules
CURRICULUM.md           # lesson progression and teaching sequence
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Bootstrap/setup behavior | `setup.sh` | Install mode syncs repo checkout, installs prerequisites, and creates `~/.local/bin/tutor` |
| Runtime behavior | `setup.sh` | `tutor` mode kills the old `hl-tutor` session, starts a new one, and attaches |
| Tutor behavior | `TUTOR_PROMPT.md` | Role, pacing, terminal rules, memory usage |
| Curriculum changes | `CURRICULUM.md` | Lesson order and feature introduction |
| Session-start hook behavior | `tutor-hooks/session_start_tutor.py` | Re-injects resolved prompt only inside `hl-tutor` tmux session |

## CONVENTIONS
- `setup.sh` owns dependency bootstrapping for macOS and apt-based Linux.
- `setup.sh` may be launched remotely; install mode clones or updates the repo into `~/.local/share/hl-tutor/repo` when companion files are missing, then re-execs that checkout before continuing.
- Bootstrap order matters: macOS installs Xcode Command Line Tools before Homebrew, then git/tmux, then Node/npm, then Claude Code, then the `tutor` symlink.
- macOS bootstrap covers Xcode Command Line Tools, Homebrew, git, tmux, Node.js, and Claude Code.
- Linux bootstrap covers git, tmux, Node.js/npm, and Claude Code.
- `setup.sh` creates `~/.local/bin/tutor` as a symlink to itself.
- The quick-install one-liner is a durable entrypoint; keep it alongside `./setup.sh` and `tutor`.
- `tutor` is runtime-only: it must NOT rerun install/bootstrap; it should only verify runtime prerequisites, restart the tmux session, and attach.
- Successful setup ends with automatic `tmux attach-session -t hl-tutor`.
- Tutor workspace is provisioned under `~/tutor-workspace`; prompts and hooks are copied there.
- `tutor-hooks/session_start_tutor.py` is session-scoped; it must stay inert outside the `hl-tutor` tmux session.

## COMMANDS
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/hungson175/hl-tutor/main/setup.sh)
chmod +x setup.sh
./setup.sh
tutor
tmux attach -t hl-tutor
```

## NOTES
- `README.md` is user-facing; treat `setup.sh` as source of truth for startup flow.
