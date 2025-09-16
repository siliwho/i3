#!/bin/bash

TIMER_FILE="$HOME/tmp/timer.txt"
PID_FILE="$HOME/tmp/timer.pid"

frames=("" "" "")  # spinner frames
frame=0

print_status() {
    if [ -f "$TIMER_FILE" ]; then
        cat "$TIMER_FILE"
    fi
}

start_timer() {
    secs="$1"
    tot="$((secs / 60))"
    echo $$ > "$PID_FILE"

    while [ "$secs" -gt 0 ]; do
        # check pause flag
        if [ -f "$HOME/tmp/timer.pause" ]; then
            sleep 1
            continue
        fi

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

    rm -f "$TIMER_FILE" "$PID_FILE" "$HOME/tmp/timer.pause"
    notify-send "⏰ Timer finished ($tot min)"
}

pause_timer() {
    touch "$HOME/tmp/timer.pause"
}

resume_timer() {
    rm -f "$HOME/tmp/timer.pause"
}

cancel_timer() {
    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$TIMER_FILE" "$PID_FILE" "$HOME/tmp/timer.pause"
    fi
}

case "$1" in
    "")
        print_status
        ;;
    start)
        shift
        if [ -n "$1" ]; then
            (start_timer "$1" &)
        fi
        ;;
    pause)
        pause_timer
        ;;
    resume)
        resume_timer
        ;;
    cancel|stop|delete)
        cancel_timer
        ;;
    *)
        echo "Usage: $0 [start SECONDS|pause|resume|cancel]"
        ;;
esac

