#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/material"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar

# if only one monitor connected, pult poly bar o that monitor, else if DP-3 and eDP-1 connected, put main polybar on DP-3 and secondary on eDP-1
if xrandr | grep "eDP-1-1"; then
    MONITOR=DP-0 polybar --reload main -c "$DIR"/config.ini &
    MONITOR=eDP-1-1 polybar --reload secondary -c "$DIR"/config.ini &
  elif xrandr | grep "DP-3 connected"; then
    MONITOR=DP-3 polybar --reload main -c "$DIR"/config.ini &
    MONITOR=eDP-1 polybar --reload secondary -c "$DIR"/config.ini &
  else
    polybar --reload main -c "$DIR"/config.ini &
fi
