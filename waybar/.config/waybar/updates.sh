#!/bin/bash
# Count pending repo + AUR updates and print Waybar JSON.
#
# Waybar runs this once per bar (i.e. per monitor) at the same time.
# checkupdates locks a shared temp db, so concurrent runs fail. Serialize with
# flock and let later runs reuse the first run's cached result.

cache="${XDG_RUNTIME_DIR:-/tmp}/waybar-updates.json"
max_age=60

exec 9>"$cache.lock"
flock 9

if [ -f "$cache" ] && [ $(( $(date +%s) - $(stat -c %Y "$cache") )) -lt "$max_age" ]; then
    cat "$cache"
    exit 0
fi

repo=$(checkupdates 2>/dev/null)
repo_status=$?   # 0 = updates, 2 = none, anything else = failure
aur=$(yay -Qua 2>/dev/null)

repo_count=$(grep -c . <<< "$repo")
aur_count=$(grep -c . <<< "$aur")
total=$((repo_count + aur_count))

if [ "$repo_status" -ne 0 ] && [ "$repo_status" -ne 2 ]; then
    class="error"
    total="?"
    tooltip="checkupdates failed (exit $repo_status)"
elif [ "$total" -gt 0 ]; then
    class="has-updates"
    tooltip=""
    [ "$repo_count" -gt 0 ] && tooltip+="Repo ($repo_count):"$'\n'"$repo"
    [ "$repo_count" -gt 0 ] && [ "$aur_count" -gt 0 ] && tooltip+=$'\n\n'
    [ "$aur_count" -gt 0 ] && tooltip+="AUR ($aur_count):"$'\n'"$aur"
else
    class="updated"
    tooltip="System up to date"
fi

jq -cn --arg text "$total" --arg tooltip "$tooltip" --arg class "$class" \
    '{text: $text, tooltip: $tooltip, class: $class, alt: $class}' | tee "$cache"
