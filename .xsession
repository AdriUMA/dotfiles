#!/bin/sh

userresources=$HOME/.Xresources

usermodmap=$HOME/.Xmodmap

sysresources=/etc/X11/xinit/.Xresources

sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f  $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then

    xmodmap $sysmodmap

fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then

    xmodmap "$usermodmap"

fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then

    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do

        [ -x "$f" ] && . "$f"

    done

    unset f

fi

# Notifications
/usr/lib/notification-daemon-1.0/notification-daemon &

# Transparency manager program
picom -b

# Keyboard layout 
setxkbmap es &

#Monitor
xrandr --output DP-1 --off --output DP-2 --off --output HDMI-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-D-1 --off &

#Wallpapaer
feh --bg-fill .config/Wallpapers/right.jpg --bg-fill .config/Wallpapers/left.jpg
