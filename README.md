# quad-terminal

Launch a maximized GNOME Terminal split into 4 tmux panes with a single command.

```
┌─────────┬─────────┐
│  0.0    │  0.1    │
│         │  htop   │
├─────────┼─────────┤
│  0.2    │  0.3    │
│         │         │
└─────────┴─────────┘
```

## One-liner install

```bash
git clone https://github.com/fabgoodvibes/quad-terminal.git && cd quad-terminal && bash install.sh
```

## What it does

- Installs `tmux` if not already present
- Copies `quad.sh` to `~/bin/quad.sh` and makes it executable
- Installs `~/.tmux.conf` with `Ctrl+Arrow` pane navigation (backs up any existing config)
- Adds `~/bin` to your `PATH` in `~/.bashrc`

## Usage

```bash
quad.sh
```

## Keyboard shortcuts (inside tmux)

| Action                    | Keys                      |
|---------------------------|---------------------------|
| Switch panes              | `Ctrl + Arrow`            |
| Zoom/unzoom a pane        | `Ctrl+B` then `Z`         |
| Resize a pane             | `Ctrl+B` then `Alt+Arrow` |
| Detach from session       | `Ctrl+B` then `D`         |
| Re-attach to session      | `tmux attach -t quad`     |

## Customizing preloaded commands

Edit `quad.sh` and add `tmux send-keys` lines to preload commands in any pane:

```bash
tmux send-keys -t $SESSION:0.0 "your-command" Enter   # top-left
tmux send-keys -t $SESSION:0.1 "htop"          Enter   # top-right
tmux send-keys -t $SESSION:0.2 "your-command" Enter   # bottom-left
tmux send-keys -t $SESSION:0.3 "your-command" Enter   # bottom-right
```
