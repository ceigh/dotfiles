#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
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

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# add personal path
export PATH="$HOME/.bin:$PATH"

# normal pointer
xsetroot -cursor_name left_ptr &
# add ru keyboard and alt+shift toggle
setxkbmap -layout us,ru -option 'grp:alt_shift_toggle' &
# enable numlock
numlockx &
# enable natural scrolling
xinput set-prop 12 285 1 &

# change freq
xrandr --output DVI-I-2 --mode 1440x900 --rate 74.98 &

# wait for network
readonly WIRELESS_DEV=$(ip link show | rg --only-matching wl[^:]*)
tries=0
while true; do
  [ "$tries" -eq 10 ] && break # timeout
  [ $(ip add sh dev $WIRELESS_DEV | rg inet | wc -l) -ne 0 ] && break
  sleep 1
  ((tries++))
done

# set bg
sh wallpaper-unsplash &

# autorun
firefox &

# run wm
exec xmonad
