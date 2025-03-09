#!/bin/bash

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="Adri Quick Cheat Sheet" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "close this app" "" " = " "SUPER KEY (Windows Key Button)" "(SUPER KEY)" \
" SHIFT H" "Searchable Keybinds" "(Search all Keybinds via rofi)" \
"" "" "" \
" Enter" "Terminal" "(kitty)" \
" B" "Launch Browser" "(Default browser)" \
" A" "Desktop Overview" "(AGS - if opted to install)" \
" R" "Application Launcher" "(rofi-wayland)" \
" E" "Open File Manager" "(Thunar)" \
" Q" "close active window" "(not kill)" \
" Shift Q " "kills an active window" "(kill)" \
" Z" "Desktop Zoom" "" \
" Shift W" "Choose wallpaper" "(Wallpaper Menu)" \
" ALT Shift W" "Random wallpaper" "(via swww)" \
" CTRL W" "Choose wallpaper effects" "(imagemagick + swww)" \
" B" "Hide/UnHide Waybar" "waybar" \
" CTRL B" "Choose waybar styles" "(waybar styles)" \
" ALT B" "Choose waybar layout" "(waybar layout)" \
" F5" "Reload Waybar swaync Rofi" "CHECK NOTIFICATION FIRST!!!" \
" CTRL Shift R" "Reload Waybar swaync Rofi" "CHECK NOTIFICATION FIRST!!!" \
" N" "Launch Notification Panel" "swaync Notification Center" \
" Shift S" "screenshot region" "(swappy)" \
" ESC" "power-menu" "(wlogout)" \
" L" "screen lock" "(hyprlock)" \
" SHIFT Q" "Hyprland Exit" "(NOTE: Hyprland Will exit immediately)" \
" F" "Fake Fullscreen" "Toggles to fake full screen" \
" SHIFT F" "Fullscreen" "Toggles to full screen" \
" CTRL F" "Toggle float" "single window" \
" ALT O" "Toggle Blur" "normal or less blur" \
" O" "Toggle Opaque ON or OFF" "on active window only" \
" Shift A" "Animations Menu" "Choose Animations via rofi" \
" CTRL R" "Rofi Themes Menu" "Choose Rofi Themes via rofi" \
" CTRL Shift R" "Rofi Themes Menu v2" "Choose Rofi Themes via Theme Selector (modified)" \
" SHIFT G" "Gamemode! All animations OFF or ON" "toggle" \
" ." "Rofi Emoticons" "Emoticon" \
" SPACE" "Change keyboard layout" "By default layouts are es and us (intl)" \
" H" "Launch this Quick Cheat Sheet" "" \