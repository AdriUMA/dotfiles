#!/bin/bash

logger "Waybar/scripts/ShitfWorkspace: $1"

# If no argument is passed, exit
if [ -z "$1" ]; then
    echo "Usage: $0 <+1 or -1 or N>"
    exit 1
fi

# Define the total number of workspaces (adjust this according to your configuration)
TOTAL_WS=6

# Get the index of the current workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Calculate the new workspace
if [ "$1" -eq "+1" ]; then
    # If +1, go to the next workspace (if it's the last, go to the first)
    if [ "$CURRENT_WS" -ge "$TOTAL_WS" ]; then
        TARGET_WS=1
    else
        TARGET_WS=$((CURRENT_WS + 1))
    fi
elif [ "$1" -eq "-1" ]; then
    # If -1, go to the previous workspace (if it's the first, go to the last)
    if [ "$CURRENT_WS" -le 1 ]; then
        TARGET_WS=$TOTAL_WS
    else
        TARGET_WS=$((CURRENT_WS - 1))
    fi
else
    TARGET_WS="$1"
fi

# Get the cursor's position (X and Y coordinates)
CURSOR_POS=$(hyprctl cursorpos)

# Extract the X and Y coordinates from the cursor position
CURSOR_X=$(hyprctl cursorpos | cut -d',' -f1)

# Define monitor boundaries
# Monitor 1 (HDMI-A-1): x=0 to 1920, y=0 to 1080
# Monitor 2 (DP-2): x=0 to 1920, y=0 to 3970
# Monitor 3 (DP-3): x=1921 to 3840, y=0 to 1080

# Determine the monitor where the cursor is located
MOUSE_MONITOR=""

if [ "$CURSOR_X" -le 1920 ]; then
    MOUSE_MONITOR="HDMI-A-1"
elif [ "$CURSOR_X" -gt 1920 ] && [ "$CURSOR_X" -le 3840 ]; then
    MOUSE_MONITOR="DP-2"
elif [ "$CURSOR_X" -gt 3840 ]; then
    MOUSE_MONITOR="DP-3"
else
    echo "Unable to determine the monitor based on the cursor position"
    exit 1
fi

echo "Cursor is on monitor: $MOUSE_MONITOR"

# Get all the visible workspaces on the monitors
VISIBLE_WORKSPACES=$(hyprctl monitors -j | jq -r '.[].activeWorkspace.id')
MONITOR_NAMES=$(hyprctl monitors -j | jq -r '.[].name')

hyprctl dispatch moveworkspacetomonitor "$TARGET_WS" "$MOUSE_MONITOR"

logger "Waybar/scripts/ShitfWorkspace: Focus $TARGET_WS on $MOUSE_MONITOR"

# Check if the workspace was already visible on any monitor
if echo "$VISIBLE_WORKSPACES" | grep -wq "$TARGET_WS"; then
    # If the workspace was visible, behaves like a swap
    INDEX=$(echo "$VISIBLE_WORKSPACES" | grep -nw "$TARGET_WS" | cut -d':' -f1)
    OLD_MONITOR=$(echo "$MONITOR_NAMES" | sed -n "$(($INDEX))p")
    
    hyprctl dispatch moveworkspacetomonitor "$CURRENT_WS" "$OLD_MONITOR"
    logger "Waybar/scripts/ShitfWorkspace: Silent relocation $CURRENT_WS on $OLD_MONITOR"
fi

hyprctl dispatch workspace "$TARGET_WS"
