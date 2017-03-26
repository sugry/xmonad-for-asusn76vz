#!/bin/sh

export JAVA_HOME=/usr/lib/jvm/java-default-runtime
export PATH=~/bin:$PATH
export PATH=~/bin:$PATH
export TERMINAL=lxterminal
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export _volume_pipe=/tmp/.volume-pipe
[[ -S $_volume_pipe ]] || mkfifo $_volume_pipe

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
fi

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

setxkbmap -layout "us,ru"
setxkbmap -option "grp:caps_toggle,grp_led:caps"
numlockx &
perWindowLayoutD & # A daemon that remembers the selected layout for each window http://archlinux.org.ru/forum/topic/3124/
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 3 --transparent true --alpha 0 --tint 0x2A373E --height 21 &
compton -b &
urxvtd -q -f -o &
# Disable the touchpad while typing from the keyboard
syndaemon -i 2 -d &
# Disconnect the touchpad completely
# You need to know the touchpad id with command xinput list
# xinput disable 15
# Battery status monitoring
/home/s-adm/.scripts/controlbatt_and_notify.sh &
# Checking for updates
mkfifo /tmp/.getpkg-pipe &
/home/s-adm/.scripts/get-pkg.sh &
# Weather
mkfifo /tmp/.weather-pipe &
cat /dev/null > /home/s-adm/.scripts/weatmp &
/home/s-adm/.scripts/get-weather.sh &

xrdb -merge ~/.Xresources &
parcellite &
nm-applet &
orage &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

#feh --bg-center /usr/share/backgrounds/003.jpg
#dropbox &
#qterminal -d &

exec xmonad

