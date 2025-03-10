#!/bin/bash

logger "Waybar/scripts/ShitfWorkspace: Call"

# If no argument is passed, exit
if [ -z "$1" ]; then
    logger "Waybar/scripts/ShitfWorkspace: Usage: $0 < --forward or --back or Id > $0 < --by-focus (default) / --by-mouse > $0 < --move-cursor (default) / --no-move-cursor > "
    exit 1
fi

# Initialize variables
WS_ACTION=""
MOVE_CURSOR=""
SELECT_MONITOR_BY=""

# Validate first argument (action)
case "$1" in
    --forward)
        WS_ACTION="forward"
        ;;
    --back)
        WS_ACTION="back"
        ;;
    *)
        # If the argument is neither --forward nor --back, assume it's a monitor ID
        WS_ACTION="$1"
        ;;
esac

# Validate second argument (focus or mouse)
if [ -n "$2" ]; then
    case "$2" in
        --by-focus)
            SELECT_MONITOR_BY="focus"
            ;;
        --by-mouse)
            SELECT_MONITOR_BY="mouse"
            ;;
        *)
            logger "Waybar/scripts/ShitfWorkspace: Invalid second argument: $2. Use --by-focus or --by-mouse."
            exit 1
            ;;
    esac
else
    # Default to focus if no second argument is provided
    SELECT_MONITOR_BY="focus"
fi

# Validate third argument (move-cursor or no-move-cursor)
if [ -n "$3" ]; then
    case "$3" in
        --move-cursor)
            MOVE_CURSOR="move"
            ;;
        --no-move-cursor)
            MOVE_CURSOR="no-move"
            ;;
        *)
            logger "Waybar/scripts/ShitfWorkspace: Invalid third argument: $3. Use --move-cursor or --no-move-cursor."
            exit 1
            ;;
    esac
else
    # Default to no-move-cursor if no third argument is provided
    MOVE_CURSOR="move"
fi

# Output the validated variables (optional for debugging)
logger "Waybar/scripts/ShitfWorkspace: WS_ACTION: $WS_ACTION"
logger "Waybar/scripts/ShitfWorkspace: SELECT_MONITOR_BY: $SELECT_MONITOR_BY"
logger "Waybar/scripts/ShitfWorkspace: MOVE_CURSOR: $MOVE_CURSOR"

# Define the total number of workspaces
FIRST_WS_ID=$(hyprctl workspaces -j | jq -r 'map(.id) | sort | .[0]')
LAST_WS_ID=$(hyprctl workspaces -j | jq -r 'map(.id) | sort | .[-1]')

# Get the index of the current workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Calculate the new workspace
if [ "$1" = "--forward" ]; then
    # If +1, go to the next workspace (if it's the last, go to the first)
    if [ "$CURRENT_WS" = "$LAST_WS_ID" ]; then
        TARGET_WS="$FIRST_WS_ID"
    else
        TARGET_WS=$(hyprctl workspaces -j | jq -r 'map(.id) | sort | .[]' | awk -v id="$CURRENT_WS" '$0 == id {getline; print}')
    fi
elif [ "$1" = "--back" ]; then
    # If -1, go to the previous workspace (if it's the first, go to the last)
    if [ "$CURRENT_WS" = "$FIRST_WS_ID" ]; then
        TARGET_WS="$LAST_WS_ID"
    else
        TARGET_WS=$(hyprctl workspaces -j | jq -r 'map(.id) | sort | .[]' | awk -v id="$CURRENT_WS" '{if ($0 == id) {print prev; exit} prev=$0}')
    fi
else
    TARGET_WS="$1"
fi

logger "Waybar/scripts/ShitfWorkspace: Arg parsed from $1 to $TARGET_WS"

# Nothing to do if the workspace is already in this screen
if [ "$TARGET_WS" = "$CURRENT_WS" ]; then
    logger "Waybar/scripts/ShitfWorkspace: Same workspace $1 and $TARGET_WS, thing to do."
    exit 0
fi

# Determine the monitor where the cursor is located
MOUSE_MONITOR=""

# Detect screen by focus
if [ "$SELECT_MONITOR_BY" = "focus" ]; then
    MOUSE_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
# Detect in witch screen is the cursor. Only one monitor can skips this.
elif [ "$(hyprctl monitors -j | jq -r '.[].id' | wc -l)" -eq 1 ]; then
    MOUSE_MONITOR="0"
else
    # Extract the X coordinate from the cursor position
    CURSOR_X=$(hyprctl cursorpos | cut -d',' -f1)
    
    if [ "$CURSOR_X" -le 1920 ]; then
        MOUSE_MONITOR="0"
    elif [ "$CURSOR_X" -gt 1920 ] && [ "$CURSOR_X" -le 3840 ]; then
        MOUSE_MONITOR="1"
    elif [ "$CURSOR_X" -gt 3840 ]; then
        MOUSE_MONITOR="2"
    else
        logger "Unable to determine the monitor based on the cursor position"
        exit 1
    fi
fi

logger "Cursor is on monitor: $MOUSE_MONITOR by $SELECT_MONITOR_BY"

# Get all the visible workspaces on the monitors before the change
VISIBLE_WORKSPACES=$(hyprctl monitors -j | jq -r '.[].activeWorkspace.id')
MONITOR_ID=$(hyprctl monitors -j | jq -r '.[].id')

# Save mouse position
CURSOR_POS=$(hyprctl cursorpos)

# Make the change
hyprctl dispatch moveworkspacetomonitor "$TARGET_WS" "$MOUSE_MONITOR"
logger "Waybar/scripts/ShitfWorkspace: Relocation $TARGET_WS on $MOUSE_MONITOR"

# Check if the moved workspace was already visible on any monitor
if echo "$VISIBLE_WORKSPACES" | grep -wq "$TARGET_WS"; then
    # If the workspace was visible, behaves like a swap with the hidden one
    INDEX=$(echo "$VISIBLE_WORKSPACES" | grep -nw "$TARGET_WS" | cut -d':' -f1)
    OLD_MONITOR=$(echo "$MONITOR_ID" | sed -n "$(($INDEX))p")
    
    hyprctl dispatch moveworkspacetomonitor "$CURRENT_WS" "$OLD_MONITOR"
    logger "Waybar/scripts/ShitfWorkspace: Relocation $CURRENT_WS on $OLD_MONITOR"
fi

logger "Waybar/scripts/ShitfWorkspace: Focus $TARGET_WS on $MOUSE_MONITOR"
hyprctl dispatch workspace "$TARGET_WS" | logger

if [ "$MOVE_CURSOR" = "no-move" ]; then
    logger "Waybar/scripts/ShitfWorkspace: Restoring cursor position to $(echo "$CURSOR_POS" | sed 's/,//g')"
    hyprctl dispatch movecursor "$(echo "$CURSOR_POS" | sed 's/,//g')"  | logger
fi

logger "Waybar/scripts/ShitfWorkspace: Done"
