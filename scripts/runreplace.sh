#!/usr/bin/env bash

set -u
function replace() {
    flavors=("_retail_" "_classic_")
    for flavor in "${flavors[@]}"; do
        local PROXY="/home/lucas/Faugus/battlenet/drive_c/Program Files (x86)/World of Warcraft/$flavor/Utils/WowVoiceProxy.exe"
        cat <<'EOF' >"$PROXY"
#!/bin/sh
exit 0
EOF
        chmod +x "$PROXY"
    done
}

replace
PROXY="/home/lucas/Faugus/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/Utils/WowVoiceProxy.exe"
DIGEST=$(md5sum "$PROXY" | awk '{print $1}')
echo "$DIGEST"

while sleep 0.1; do
    flavors=("_retail_" "_classic_")
    for flavor in "${flavors[@]}"; do
        LOCALPROXY="/home/lucas/Faugus/battlenet/drive_c/Program Files (x86)/World of Warcraft/$flavor/Utils/WowVoiceProxy.exe"
        NEW_DIGEST=$(md5sum "$LOCALPROXY" | awk '{print $1}')
        RC=$?
        if [[ $RC != 0 || $NEW_DIGEST != "$DIGEST" ]]; then
            echo "File changed, reloading"
            replace
        fi
    done
done
