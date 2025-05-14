#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/material"

## -m option to take in a number and save it to a variable, default is 3
while getopts ":m:" opt; do
  case $opt in
    m) monitor="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar

# if only one monitor connected, pult poly bar o that monitor, else if DP-3 and eDP-1 connected, put main polybar on DP-3 and secondary on eDP-1
if xrandr | grep "eDP-1-1"; then
    MONITOR=DP-$monitor polybar --reload main -c "$DIR"/config.ini &
    MONITOR=eDP-1-1 polybar --reload secondary -c "$DIR"/config.ini &
  elif xrandr | grep -E "DP-[0-9]+ connected"; then
    MONITOR=DP-$monitor polybar --reload main -c "$DIR"/config.ini &
    MONITOR=eDP-1 polybar --reload secondary -c "$DIR"/config.ini &
  else
    MONITOR=eDP-1 polybar --reload secondary -c "$DIR"/config.ini &
    polybar --reload main -c "$DIR"/config.ini &
fi
