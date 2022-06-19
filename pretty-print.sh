#!/usr/bin/env bash

DIRNAME="$(dirname "$0")"

docker-compose -f "$DIRNAME/docker-compose.yml" exec speedtest-monitor jq --slurp --raw-output '
def down_avg: ( map(.download.bandwidth) | add ) / length;
def up_avg: ( map(.upload.bandwidth) | add ) / length;
def to_fixed(n): tostring | capture("(?<int>\\d+)?(?<frac>[.]\\d+)?") | "\(.int).\(((.frac // "0") + "0" * n)[1:n+1])";
def to_mbps: "\(. * 8 / 1000000 | to_fixed(2)) Mbps";
def to_localtime: fromdate | strflocaltime("%F %X");

map("[\(.timestamp | to_localtime)]\tdown:\t\(.download.bandwidth | to_mbps)\tup:\t\(.upload.bandwidth | to_mbps)")[],
"\t\t\t\( "=" * 44 )",
"\t\t\tavg:\t\(down_avg | to_mbps)\tavg:\t\(up_avg | to_mbps)"
' /root/result.jsonl
