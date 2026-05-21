#!/usr/bin/env bash
exec zscroll -l 40 -d 0.25 -u true -U 1 -e true \
    "niri msg --json focused-window 2>/dev/null | jq -r 'if . then \"\(.app_id) | \(.title)\" else \" \" end'"
