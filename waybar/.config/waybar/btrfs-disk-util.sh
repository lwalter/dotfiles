#!/bin/bash

MOUNT_POINT="${1:-/}"

# Get disk info: $2 is Total, $3 is Used, $5 is Percentage
INFO=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $2,$3,$5}')
read -r TOTAL USED PERC <<< "$INFO"

# Strip % for the numerical field
PERC_NUM=${PERC%\%}

# We put the "Path" and "Used" info into the 'text' field 
# so Waybar doesn't have to look for custom arguments.
echo "{\"text\": \"$PERC $MOUNT_POINT\", \"percentage\": $PERC_NUM, \"tooltip\": \"Used: $USED / Total: $TOTAL\"}"
