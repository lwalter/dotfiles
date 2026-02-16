#!/bin/bash

failed_system=$(systemctl list-units --state=failed --legend=no | awk '{print $2}')
failed_user=$(systemctl --user list-units --state=failed --legend=no | awk '{print $2}')
all_failed=$(printf "%s\n%s" "$failed_system" "$failed_user" | sed '/^$/d')

if [ -n "$all_failed" ]; then
    count=$(echo "$all_failed" | wc -l)
    tooltip="Failed Units:\n$all_failed"
    echo "{\"text\": \"$count ⚠\", \"tooltip\": \"$tooltip\", \"class\": \"failed\"}"
else
    echo "{\"text\": \"0 󰸞\", \"tooltip\": \"All systems nominal\", \"class\": \"healthy\"}"
fi
