#!/bin/sh
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

# users path
export PATH="$HOME/.bin:$PATH"

# clean some garbage
housekeeping &

# normal pointer
xsetroot -cursor_name left_ptr &
# add ru keyboard and alt+shift toggle
setxkbmap -layout us,ru -option 'grp:alt_shift_toggle' &
# enable numlock
numlockx &
# enable natural scrolling
xinput set-prop 12 285 1 &

# screensaver
xscreensaver -no-splash &

# change freq
OUTPUT=$(xrandr | grep -E " connected (primary )?[1-9]+" |
  sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
MODE=1440x900
RATE=74.98
xrandr --output $OUTPUT --mode $MODE --rate $RATE &

# wait for network
nm-online --timeout 10

# run wm
exec xmonad
