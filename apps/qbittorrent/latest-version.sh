#!/usr/bin/env bash

version=$(curl -sX GET "https://api.github.com/repos/userdocs/qbittorrent-nox-static/releases" | jq -r '[.[] | select(.prerelease==false)][0] | .tag_name')
version="${version#*release-}"
version="${version%%_*}"
printf "%s" "${version}"
