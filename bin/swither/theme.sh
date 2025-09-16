#!/usr/bin/env bash
# Unified theme + wallpaper switcher for i3 + i3blocks

I3_CONFIG="$HOME/.config/i3/config"
I3BLOCKS_CONFIG="$HOME/.config/i3blocks/config"
WALLPAPER_DIR="$HOME/Pictures/wallpapers/theme"

apply_theme() {
    local theme=$1
    local bg=$2
    local fg=$3
    local black=$4
    local gray=$5
    local red=$6
    local green=$7
    local yellow=$8
    local blue=$9
    local magenta=${10}
    local cyan=${11}
    local white=${12}
    local orange=${13}

    # --- Update set $vars at top of config ---
    sed -i -E \
        -e "s|^set \$bg .*|set \$bg $bg|" \
        -e "s|^set \$fg .*|set \$fg $fg|" \
        -e "s|^set \$black .*|set \$black $black|" \
        -e "s|^set \$gray .*|set \$gray $gray|" \
        -e "s|^set \$red .*|set \$red $red|" \
        -e "s|^set \$green .*|set \$green $green|" \
        -e "s|^set \$yellow .*|set \$yellow $yellow|" \
        -e "s|^set \$blue .*|set \$blue $blue|" \
        -e "s|^set \$magenta .*|set \$magenta $magenta|" \
        -e "s|^set \$cyan .*|set \$cyan $cyan|" \
        -e "s|^set \$white .*|set \$white $white|" \
        -e "s|^set \$orange .*|set \$orange $orange|" \
        "$I3_CONFIG"

    # --- Replace bar colors block (hardcoded hex, no vars) ---
    sed -i '/colors {/,/}/c\    colors {\n        background '"$bg"'\n        statusline '"$fg"'\n        separator '"$gray"'\n\n        # workspace id, border, background, text\n        focused_workspace  '"$blue $blue $bg"'\n        active_workspace   '"$blue $gray $fg"'\n        inactive_workspace '"$bg $bg $white"'\n        urgent_workspace   '"$red $red $fg"'\n    }' "$I3_CONFIG"

    # --- Update client.* borders ---
    sed -i -E \
        -e "s|^client.focused .*|client.focused          $blue $blue $fg $blue $blue|" \
        -e "s|^client.focused_inactive .*|client.focused_inactive $gray $gray $fg $gray $gray|" \
        -e "s|^client.unfocused .*|client.unfocused        $gray $gray $fg $gray $gray|" \
        "$I3_CONFIG"

    # --- Update i3blocks colors ---
    sed -i -E \
        -e "/^\[pomo\]/,/^color=/ s|^color=.*|color=$red|" \
        -e "/^\[ip\]/,/^color=/ s|^color=.*|color=$blue|" \
        -e "/^\[battery\]/,/^color=/ s|^color=.*|color=$green|" \
        -e "/^\[cpu_usage\]/,/^color=/ s|^color=.*|color=$yellow|" \
        -e "/^\[ram\]/,/^color=/ s|^color=.*|color=$magenta|" \
        -e "/^\[disk-home\]/,/^color=/ s|^color=.*|color=$cyan|" \
        -e "/^\[volume-pulseaudio\]/,/^color=/ s|^color=.*|color=$orange|" \
        -e "/^\[date\]/,/^color=/ s|^color=.*|color=$blue|" \
        -e "/^\[time\]/,/^color=/ s|^color=.*|color=$green|" \
        "$I3BLOCKS_CONFIG"

    # --- Change wallpaper with feh ---
    
    # --- Change wallpaper with nitrogen ---
    if [ -f "$WALLPAPER_DIR/${theme}.jpg" ]; then
        nitrogen --set-zoom-fill "$WALLPAPER_DIR/${theme}.jpg" --save
    elif [ -f "$WALLPAPER_DIR/${theme}.png" ]; then
        nitrogen --set-zoom-fill "$WALLPAPER_DIR/${theme}.png" --save
    else
        nitrogen --restore
    fi
  
    # --- Restart i3 ---
    i3-msg reload >/dev/null
    i3-msg restart >/dev/null
    notify-send "Theme switched 🎨 ($theme)"
}

case "$1" in
  tokyo)
    apply_theme tokyo "#1a1b26" "#c0caf5" "#15161e" "#414868" "#f7768e" "#9ece6a" "#e0af68" "#7aa2f7" "#bb9af7" "#7dcfff" "#a9b1d6" "#ff9e64"
    ;;
  gruvbox)
    apply_theme gruvbox "#282828" "#ebdbb2" "#1d2021" "#928374" "#fb4934" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c" "#ebdbb2" "#fe8019"
    ;;
  nord)
    apply_theme nord "#2e3440" "#eceff4" "#3b4252" "#4c566a" "#bf616a" "#a3be8c" "#ebcb8b" "#81a1c1" "#b48ead" "#88c0d0" "#e5e9f0" "#d08770"
    ;;
  everforest)
    # apply_theme everforest "#2b3339" "#d3c6aa" "#232a2e" "#7a8478" "#e67e80" "#a7c080" "#dbbc7f" "#7fbbb3" "#d699b6" "#83c092" "#d3c6aa" "#e69875"
     # apply_theme everforest "#1a2a1a" "#ebf0c9" "#1a2a1a" "#4a6150" "#ff6c6b" "#98d486" "#f0c674" "#51afef" "#c678dd" "#56b6c2" "#ebf0c9" "#ff9e64" 
     apply_theme everforest "#1e252a" "#ece3d1" "#1a2025" "#3c464c" "#e86668" "#b5cc89" "#e9c36e" "#83c9be" "#de95bb" "#8bd49c" "#ece3d1" "#f0a279"
    ;;
  blackwhite)
    apply_theme blackwhite "#000000" "#ffffff" "#000000" "#eeeeee" "#dddddd" "#cccccc" "#bbbbbb" "#aaaaaa" "#999999" "#888888" "#ffffff" "#dddddd"
    ;;
  *)
    echo "Usage: $0 {tokyo|gruvbox|nord|everforest|blackwhite}"
    exit 1
    ;;
esac

