
#if more than one monitor
if [ $(hyprctl monitors -j | jq '. | length') -gt 1 ]; then
    # Set mouse on middle
    hyprctl dispatch movecursor 2924 572
    # Set focus on monitor 1
    hyprctl dispatch focusmonitor 1
fi