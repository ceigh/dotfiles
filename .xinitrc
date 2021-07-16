#!/bin/sh

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
# slock &
# xautolock -detectsleep -notify 10 -corners '----' -cornersize 50 \
  # -locker "slock" -killtime 120 -killer "systemctl suspend" &

# compositor
picom &

# notifications
dunst &

# wait for network
nm-online --timeout 20

# recompile for sure
xmonad --recompile
# run wm
exec xmonad
