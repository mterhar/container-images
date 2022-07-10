#!/usr/bin/env bash

version=$(curl -sX GET https://api.github.com/repos/actualbudget/actual-server/tags | jq --raw-output '.[0].name')
version="${version#*v}"
version="${version#*release-}"
version="${version:0:7}"
printf "%s" "${version}"
