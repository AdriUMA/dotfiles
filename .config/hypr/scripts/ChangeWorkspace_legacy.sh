#!/bin/bash

# Target workspace (passed as argument)
WORKSPACE=$1

# If no workspace is passed, exit
if [ -z "$WORKSPACE" ]; then
    echo "Usage: $0 <workspace>"
    exit 1
fi

# Get the active monitor
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Get all the visible workspaces on the monitors
VISIBLE_WORKSPACES=$(hyprctl monitors -j | jq -r '.[].activeWorkspace.id')

# Check if the workspace is already visible on any monitor
if echo "$VISIBLE_WORKSPACES" | grep -wq "$WORKSPACE"; then
    # If the workspace is visible, just switch focus to it
    hyprctl dispatch workspace "$WORKSPACE"
else
    # If it's not visible, move it to the active monitor and switch to it
    hyprctl dispatch moveworkspacetomonitor "$WORKSPACE" "$ACTIVE_MONITOR"
    hyprctl dispatch workspace "$WORKSPACE"
fi
