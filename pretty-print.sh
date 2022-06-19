#!/usr/bin/env bash

DIRNAME="$(dirname "$0")"

docker-compose -f "$DIRNAME/docker-compose.yml" exec speedtest-monitor jq --raw-output '
( .timestamp | fromdate | strflocaltime("%F %X") ) as $localtime |
( (.download.bandwidth * 8 / 1000 | round) / 1000 ) as $download_Mbps |
(   (.upload.bandwidth * 8 / 1000 | round) / 1000 ) as $upload_Mbps |
"[\($localtime)]\tdownload: \($download_Mbps)Mbps\tupload: \($upload_Mbps)Mbps"
' /root/result.jsonl
