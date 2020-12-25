#!/bin/sh
# boilerplate section

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap

[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# my init section

# users path
export PATH="$HOME/.bin:$PATH"

# clean some garbage
housekeeping &

# keep list of installed packages
installed > ~/documents/installed.list.txt &

# normal pointer
xsetroot -cursor_name left_ptr &
# add ru keyboard and alt+shift toggle
setxkbmap -layout us,ru -option 'grp:alt_shift_toggle' &
# enable numlock
numlockx &
# enable natural scrolling
xinput set-prop 12 287 1 &

# screensaver
# xscreensaver -no-splash &
# lightson -d 4 &

# true tone
redshift &

# change display freq
xrandr --rate 75 &

# wait for network
nm-online --timeout 10

# run wm
xmonad --recompile
exec xmonad
