#!/bin/bash

MOUNT_POINT="${1:-/}"

# Get disk info: $2 is Total, $3 is Used, $5 is Percentage
INFO=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $2,$3,$5}')
read -r TOTAL USED PERC <<< "$INFO"

# Strip % for the numerical field
PERC_NUM=${PERC%\%}

if   [ "$PERC_NUM" -ge 90 ]; then CLASS="critical"
elif [ "$PERC_NUM" -ge 80 ]; then CLASS="warning"
else CLASS="normal"
fi

echo "{\"text\": \"$PERC\", \"percentage\": $PERC_NUM, \"class\": \"$CLASS\", \"tooltip\": \"$MOUNT_POINT\\nUsed: $USED / Total: $TOTAL\"}"
