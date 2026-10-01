#!/usr/bin/env bash

print_status() {
    local window media

    window=$(niri msg --json focused-window 2>/dev/null |
        jq -r 'if . then "\(.app_id) | \(.title)" else empty end')
    media=$(playerctl metadata --format 'Now {{status}} - {{title}} - {{artist}}' 2>/dev/null)

    if [[ -n $window && -n $media ]]; then
        printf '%s | %s\n' "$window" "$media"
    elif [[ -n $window ]]; then
        printf '%s\n' "$window"
    elif [[ -n $media ]]; then
        printf '%s\n' "$media"
    else
        printf '%s\n' "__WAYBAR_LEFT_STATUS_EMPTY__"
    fi
}

format_status() {
    local text class

    while IFS= read -r text; do
        if [[ $text == "__WAYBAR_LEFT_STATUS_EMPTY__" ]]; then
            text=
            class=inactive
        else
            class=active
        fi
        jq --compact-output --null-input \
            --arg text "$text" --arg class "$class" \
            '{text: $text, class: $class}'
    done
}

case ${1-} in
    --print)
        print_status
        exit
        ;;
    --format)
        format_status
        exit
        ;;
esac

script_path=$(readlink -f -- "$0")
printf -v status_command '%q --print' "$script_path"

zscroll -l 80 -d 0.25 -u true -U 0.2 -e true "$status_command" |
    "$script_path" --format
