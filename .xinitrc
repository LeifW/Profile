#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
xsetroot -solid '#80a0af'
xsetroot -cursor_name left_ptr
exec xmonad
