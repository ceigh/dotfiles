# restore bg
~/.fehbg &

# apply xresources
xrdb -merge .Xresources &

# normal pointer
xsetroot -cursor_name left_ptr &

# keyboard layout
setxkbmap -layout us,ru -option 'grp:alt_shift_toggle' &

# screen lock
xautolock -detectsleep -notify 10 -corners '----' -locker "xlock" &

# compositor
picom &

# notifications
dunst &

exec xmonad
