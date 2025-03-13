#!/bin/bash

# Get the list of monitors sorted by name
MONITORS=($(hyprctl monitors -j | jq -r '.[].name' | sort))

# Get the currently active monitor
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Find the index of the active monitor
for i in "${!MONITORS[@]}"; do
    if [[ "${MONITORS[$i]}" == "$ACTIVE_MONITOR" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Check the provided argument (--next or --previous)
if [[ "$1" == "--previous" ]]; then
    # Calculate the index of the previous monitor (circular)
    PREV_INDEX=$(( (CURRENT_INDEX - 1 + ${#MONITORS[@]}) % ${#MONITORS[@]} ))
    TARGET_INDEX=$PREV_INDEX
else
    # Default to --next if no argument is provided
    # Calculate the index of the next monitor (circular)
    NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#MONITORS[@]} ))
    TARGET_INDEX=$NEXT_INDEX
fi

# Switch focus to the target monitor
hyprctl dispatch focusmonitor "${MONITORS[$TARGET_INDEX]}"

