#!/bin/sh

# restore wallpaper
~/.fehbg &

# normal pointer
xsetroot -cursor_name left_ptr &

# keyboard layout
kb-layout &

# true tone
# redshift &

# screen lock
# slock &
# xautolock -detectsleep -notify 10 -corners '----' -cornersize 50 \
  # -locker "slock" -killtime 120 -killer "systemctl suspend" &

# wait for network
# nm-online --timeout 20

# recompile for sure
# xmonad --recompile
# run wm
exec xmonad
