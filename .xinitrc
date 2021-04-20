#!/bin/sh

# keep list of installed packages
pacman-installed > ~/documents/installed.list.txt &

# normal pointer
xsetroot -cursor_name left_ptr &

# keyboard layout
kb-layout &

# enable natural scrolling
natural-scrolling &

# enable numlock
numlockx &

# set resolution and rate to max
top-display &

# true tone
# redshift &

# screen lock
slock &
xautolock -locker slock &

# compositor
picom &

# notifications
dunst &

# wait for network
nm-online --timeout 10

# recompile for sure
xmonad --recompile
# run wm
exec xmonad
