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

# Create a new tmux session (detached)
tmux new-session -d -s $SESSION

# Split into 4 even panes:
# ┌─────────┬─────────┐
# │  0.0    │  0.1    │
# ├─────────┼─────────┤
# │  0.2    │  0.3    │
# └─────────┴─────────┘
tmux split-window -h -t $SESSION        # Split right  → Panes 0.0 | 0.1
tmux split-window -v -t $SESSION:0.0    # Split bottom → Panes 0.0 / 0.2
tmux split-window -v -t $SESSION:0.2    # Split bottom → Panes 0.1 / 0.3

# Preload commands in each pane (customize as needed)
# tmux send-keys -t $SESSION:0.0 "echo 'top-left'"     Enter
tmux send-keys -t $SESSION:0.1 "htop" Enter

# Select top-left pane to start
tmux select-pane -t $SESSION:0.0

# Launch GNOME Terminal maximized, attaching to the tmux session
gnome-terminal --maximize -- tmux attach-session -t $SESSION
