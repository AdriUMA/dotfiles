#!/usr/bin/env python3

import subprocess
import json

# weather icons
number_icons = [
    "󰬺",
    "󰬻",
    "󰬼",
    "󰬽",
    "󰬾",
    "󰬿",
    "󰭀",
    "󰭁",
]

# Execute the command
cmd = ["hyprctl", "monitors", "-j"]
result = subprocess.run(cmd, capture_output=True, text=True, check=True)

# Parse the JSON output and filter the focused monitor
monitors = json.loads(result.stdout)
focused_monitor = next((m for m in monitors if m.get("focused")), None)

focused_monitor_id = focused_monitor.get("id")
# status icon
icon = number_icons[focused_monitor_id - 1]

# print waybar module data
out_data = {
    "id": f"{focused_monitor_id}",
    "icon": f"{icon}",
    "text": f"{focused_monitor.get("name")}",
}

# sleep 0.25
subprocess.run(["sleep", "0.25"])

print(json.dumps(out_data))