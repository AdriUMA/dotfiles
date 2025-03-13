#!/bin/bash

# Weather icons
number_icons=("󰬺" "󰬻" "󰬼" "󰬽" "󰬾" "󰬿" "󰭀" "󰭁")

# Execute the command and capture the output
result=$(hyprctl monitors -j)

if [ $(hyprctl monitors -j | jq '. | length') -le 1 ]; then
    echo ""
    exit 0
fi

# Parse JSON and get the focused monitor
focused_monitor=$(echo "$result" | jq '.[] | select(.focused == true)')

# Extract ID and name
focused_monitor_id=$(echo "$focused_monitor" | jq -r '.id')
focused_monitor_name=$(echo "$focused_monitor" | jq -r '.name')

# Get the corresponding icon (subtracting 1 because arrays start at 0 in Bash)
icon=${number_icons[$((focused_monitor_id))]}

# Create JSON output
out_data="{\"id\": \"$focused_monitor_id\", \"icon\": \"$icon\", \"text\": \"$focused_monitor_name $icon\"}"

# Print JSON output
# printf "$out_data\n"
# echo "$focused_monitor_name $icon"
echo "$icon"

sleep 0.2
