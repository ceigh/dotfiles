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

# normal pointer
xsetroot -cursor_name left_ptr &
# add ru keyboard and alt+shift toggle
setxkbmap -layout us,ru -option 'grp:alt_shift_toggle' &
# enable numlock
numlockx &
# enable natural scrolling
xinput set-prop 12 285 1 &

# change freq
xrandr --output DVI-I-2 --mode 1440x900 --rate 74.98

# wait for network
nm-online --timeout 15

# autorun
st -e sh -c 'newsboat --refresh-on-start' &

# run wm
exec xmonad
