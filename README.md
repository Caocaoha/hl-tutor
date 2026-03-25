# hl-tutor

> **This README is for Claude Code to read.** Follow the instructions below to set up and run the tutor for the user.

## What This Is

A terminal-based coding tutor for complete beginners. It launches a tmux session with two panes:
- **Left pane**: The student's terminal (they type commands here)
- **Right pane**: Claude Code acting as a patient, warm coding tutor

The tutor guides students from zero knowledge through terminal basics, HTML, CSS, JavaScript, and deployment — building a real project the entire time.

## Prerequisites

`setup.sh` now auto-checks and installs the required tooling when possible.

- **macOS**: Xcode Command Line Tools, Homebrew, git, tmux, Node.js, and Claude Code are installed automatically if missing.
- **Linux (apt-based)**: git, tmux, Node.js/npm, and Claude Code are installed automatically if missing.
- The script also installs a global `tutor` command at `~/.local/bin/tutor`, adds the required PATH entries for `tutor` and `claude` into common shell config files, and writes `alias tutor=...` into interactive shell configs.

## Setup & Run

Quick install from any terminal:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/hungson175/hl-tutor/main/setup.sh)
```

This downloads `setup.sh`, clones or updates `hl-tutor` into `~/.local/share/hl-tutor/repo`, bootstraps missing dependencies, installs the global `tutor` command, then launches the tutor session and automatically attaches you to it.

If you already cloned the repo locally, you can still run it directly:
```bash
chmod +x setup.sh
./setup.sh
```

After the first install, launch it again with:
```bash
tutor
```

`tutor` is the day-to-day runtime command. It kills any existing `hl-tutor` tmux session, starts a fresh one, and attaches to it. It does **not** rerun the install/bootstrap flow.

For local checkouts, the same script is still the only entrypoint.

If `tutor` or `claude` is not available in an older shell after install, start a fresh shell or run:
```bash
exec $SHELL -l
```

### Reattaching to an existing session

If the terminal is closed, reattach with:
```bash
tmux attach -t hl-tutor
```

## How It Works

1. Install mode (`bash <(curl ...)` or `./setup.sh`) clones or updates the repo into `~/.local/share/hl-tutor/repo` when needed, then bootstraps missing dependencies and installs the global `tutor` command.
2. Runtime mode (`tutor`) skips the install/bootstrap flow and just restarts the tutor tmux session.
3. The script creates a tmux session called `hl-tutor`.
4. It resolves the tutor prompt into `~/tutor-workspace/prompts/.TUTOR_PROMPT_RESOLVED.md` and launches Claude Code with that prompt appended as its system prompt.
5. It splits the terminal: student on the left, Claude Code tutor on the right.
6. The tutor can observe the student's terminal via `tmux capture-pane` and guide them step by step.

## Files

- `setup.sh` — Launch script. Creates tmux session and starts the tutor.
- `TUTOR_PROMPT.md` — The tutor's system prompt. Defines personality, pedagogy, curriculum, and session management.
