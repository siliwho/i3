#!/bin/sh
#
# An updated custom script for i3blocks to display and control PulseAudio volume.

# Icons for different volume states (requires a Nerd Font)
ICON_VOL_HIGH="" # Volume > 66%
ICON_VOL_MED=""  # Volume > 33%
ICON_VOL_LOW=""   # Volume > 0%
ICON_VOL_MUTED="" # Muted

# Handle clicks passed by i3blocks
case $BLOCK_BUTTON in
    1) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;  # Left click: Toggle mute
    3) pavucontrol ;;                               # Right click: Open pavucontrol
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;  # Scroll up: Increase volume
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;  # Scroll down: Decrease volume
esac

# Get current mute status
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '/Mute/ {print $2}')

# If muted, display the muted icon and exit immediately.
if [ "$MUTED" = "yes" ]; then
    echo "$ICON_VOL_MUTED Muted"
    exit 0
fi

# Get current volume percentage
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -n 1)
VOLUME_NUM=${VOLUME%\%} # Get just the number for comparison

#
# --- New Display Logic with Multiple Volume Levels ---
#
if [ "$VOLUME_NUM" -gt 66 ]; then
    # 1. High Volume
    ICON=$ICON_VOL_HIGH
elif [ "$VOLUME_NUM" -gt 33 ]; then
    # 2. Medium Volume
    ICON=$ICON_VOL_MED
else
    # 3. Low Volume (but not muted)
    ICON=$ICON_VOL_LOW
fi

# Cap volume display at 100%
if [ "$VOLUME_NUM" -gt 100 ]; then
    VOLUME="100%"
fi

echo "$ICON $VOLUME"


