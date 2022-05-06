#!/usr/bin/env bash

set -e

#shellcheck disable=SC1091
source "/shim/umask.sh"
source "/shim/vpn.sh"

downloadsPath="/downloads"

if [[ -z "$USE_PROFILE" ]]; then
    qbtConfigFile="/config/qBittorrent/qBittorrent.conf"
    qbtLogFile="/config/qBittorrent/logs/qbittorrent.log"
    PROFILE_ARGS=""
else
    profilePath="/config"
    qbtConfigFile="$profilePath/qBittorrent/config/qBittorrent.conf"
    qbtLogFile="$profilePath/qBittorrent/data/logs/qbittorrent.log"
    PROFILE_ARGS="--profile=\"$profilePath\""
fi

if [[ ! -f "$qbtConfigFile" ]]; then
    mkdir -p "$(dirname $qbtConfigFile)"
    cat << EOF > "$qbtConfigFile"
[BitTorrent]
Session\DefaultSavePath=$downloadsPath
Session\Port=$BITTORRENT_PORT
Session\TempPath=$downloadsPath/temp
[Preferences]
WebUI\HostHeaderValidation=false
WebUI\UseUPnP=false
WebUI\LocalHostAuth=false
[LegalNotice]
Accepted=true
EOF
fi

python3 /shim/config.py --output "$qbtConfigFile"

if [[ ! -f "$qbtLogFile" ]]; then
    mkdir -p "$(dirname $qbtLogFile)"
    ln -sf /proc/self/fd/1 "$qbtLogFile"
fi

exec /app/qbittorrent-nox \
    ${PROFILE_ARGS} \
    --webui-port="${WEBUI_PORT}" \
    ${EXTRA_ARGS}
fi
