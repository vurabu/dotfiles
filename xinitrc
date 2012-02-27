if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Disable DPMS turning off the screen
xset -dpms
xset s off

# Disable bell ??
#xset -b

# Set wallpaper FIXME
eval `cat ~/.fehbg`

# Setting gtk-home (for qtconfig)
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Setting browser ??
#export BROWSER="/usr/bin/chromium"

# Start urxvt daemon
urxvtd &

# Start wm
exec xmonad

# vim:set ft=sh:
