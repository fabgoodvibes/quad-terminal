#!/bin/bash
# quad.sh - Launch a maximized GNOME Terminal split into 4 tmux panes

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "tmux is not installed. Installing..."
    sudo apt-get install -y tmux
fi

SESSION="quad"

# Kill existing session if it exists
tmux kill-session -t $SESSION 2>/dev/null
sleep 0.5  # give tmux a moment to clean up

# Create new session
tmux new-session -d -s $SESSION

# Select top-left to start
tmux select-pane -t %0

# Split into 4 even panes:
# ┌─────────┬─────────┐
# │  0.0    │  0.1    │
# ├─────────┼─────────┤
# │  0.2    │  0.3    │
# └─────────┴─────────┘

# Split into 4 panes
tmux split-window -h     # → 0.0 | 0.1
tmux select-pane -t %0   # 0.0
tmux split-window -v     # → 0.0 / 0.2
tmux select-pane -t %1   # 0.1
tmux split-window -v     # → 0.1 / 0.3
tmux select-pane -t %0   # 0.0

# Preload commands in each pane (customize as needed)
#tmux send-keys -t %0 "echo 'Pane 1 - top left'"  Enter   # top-left
#tmux send-keys -t %2 "echo 'Pane 3 - bottom left'" Enter  # bottom-left
#tmux send-keys -t %1 "echo 'Pane 2 - top right'"  Enter   # top-right
tmux send-keys -t %1 "htop"  Enter   # top-right
#tmux send-keys -t %3 "echo 'Pane 4 - bottom right'" Enter # bottom-right

# Select top-left pane to start
tmux select-pane -t %0

# Launch GNOME Terminal maximized, attaching to the tmux session
gnome-terminal --maximize -- tmux attach-session -t $SESSION
