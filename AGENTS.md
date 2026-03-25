# PROJECT KNOWLEDGE BASE

## OVERVIEW
`hl-tutor` boots a local terminal-based coding tutor. `setup.sh` is the single entrypoint.

## STRUCTURE
```text
setup.sh                # bootstrap, launcher, tmux session creation
tutor/                  # tutor runtime memory copied into ~/tutor-workspace
tutor-hooks/            # Claude Code hook config copied into isolated workspace
TUTOR_PROMPT.md         # tutor behavior, pacing, session rules
CURRICULUM.md           # lesson progression and teaching sequence
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Bootstrap/setup behavior | `setup.sh` | Installs prerequisites, symlinks `~/.local/bin/tutor`, attaches to `hl-tutor` |
| Tutor behavior | `TUTOR_PROMPT.md` | Role, pacing, terminal rules, memory usage |
| Curriculum changes | `CURRICULUM.md` | Lesson order and feature introduction |
| Session-start hook behavior | `tutor-hooks/session_start_tutor.py` | Re-injects resolved prompt only inside `hl-tutor` tmux session |

## CONVENTIONS
- `setup.sh` owns dependency bootstrapping for macOS and apt-based Linux.
- Bootstrap order matters: macOS installs Xcode Command Line Tools before Homebrew, then git/tmux, then Node/npm, then Claude Code, then the `tutor` symlink.
- macOS bootstrap covers Xcode Command Line Tools, Homebrew, git, tmux, Node.js, and Claude Code.
- Linux bootstrap covers git, tmux, Node.js/npm, and Claude Code.
- `setup.sh` creates `~/.local/bin/tutor` as a symlink to itself.
- Successful setup ends with automatic `tmux attach-session -t hl-tutor`.
- Tutor workspace is provisioned under `~/tutor-workspace`; prompts and hooks are copied there.
- `tutor-hooks/session_start_tutor.py` is session-scoped; it must stay inert outside the `hl-tutor` tmux session.

## COMMANDS
```bash
chmod +x setup.sh
./setup.sh
tutor
tmux attach -t hl-tutor
```

## NOTES
- `README.md` is user-facing; treat `setup.sh` as source of truth for startup flow.
