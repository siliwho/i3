#!/bin/bash

TIMER_FILE="$HOME/tmp/timer.txt"

# if no args, just print file contents (for i3blocks)
if [ $# -eq 0 ]; then
    if [ -f "$TIMER_FILE" ]; then
        cat "$TIMER_FILE"
    fi
    exit 0
fi

secs="$1"
tot="$((secs / 60))"
frames=("" "" "")  # spinner frames
frame=0

while [ "$secs" -gt 0 ]; do
    icon="${frames[$frame]}"
    if [ "$secs" -ge 60 ]; then
        printf "%s %02d:%02d\n" "$icon" "$((secs / 60))" "$((secs % 60))" > "$TIMER_FILE"
    else
        printf "%s 00:%02d\n" "$icon" "$secs" > "$TIMER_FILE"
    fi

    sleep 1
    secs=$((secs - 1))
    frame=$(((frame + 1) % ${#frames[@]}))
done

# when done, remove file so block disappears
rm -f "$TIMER_FILE"

