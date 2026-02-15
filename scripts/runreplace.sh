#!/usr/bin/env bash

set -u
function replace() {
    flavors=("_retail_" "_classic_")
    for flavor in "${flavors[@]}"; do
        PROXY="/home/lucas/Faugus/battlenet/drive_c/Program Files (x86)/World of Warcraft/$flavor/Utils/WowVoiceProxy.exe"
        cat <<'EOF' >"$PROXY"
#!/bin/sh
exit 0
EOF
    done
    chmod +x "$PROXY"
}

replace
DIGEST=$(md5sum "$PROXY")
echo "$DIGEST"

while sleep 0.1; do
    NEW_DIGEST=$(md5sum "$PROXY")
    RC=$?
    if [[ $RC != 0 || $NEW_DIGEST != "$DIGEST" ]]; then
        echo "File changed, reloading"
        replace
    fi
done
