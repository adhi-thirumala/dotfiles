if [ "$(tty)" = "/dev/tty1" ]; then
  paru -Syu --noconfirm
  startx
fi

