#!/usr/bin/env bash
exec zscroll -l 40 -d 0.25 -u true -U 1 -e true \
    "playerctl metadata --format 'Now {{status}} - {{title}} - {{artist}}' 2>/dev/null || echo ' '"
