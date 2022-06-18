# speedtest-monitor

## Requirement

- docker
- docker-compose

## Setup

Execute `init.sh` at the first time and type `YES` manually.

```shell
$ ./init.sh
==============================================================================

You may only use this Speedtest software and information generated
from it for personal, non-commercial use, through a command line
interface on a personal computer. Your use of this software is subject
to the End User License Agreement, Terms of Use and Privacy Policy at
these URLs:

        https://www.speedtest.net/about/eula
        https://www.speedtest.net/about/terms
        https://www.speedtest.net/about/privacy

==============================================================================

Do you accept the license? [type YES to accept]:
```

## Speedtest Hourly

You can modified [tasks.cron](tasks.cron) for control the schedule and choose the speedtest server.

```txt
# do daily/weekly/monthly maintenance
# min   hour    day     month   weekday command
03      *       *       *       *       speedtest -s 14604 -f jsonl | grep result | tee -a /root/result.jsonl
#                                                 ^^^^^^^^
#                                                 change this if need, use `speedtest -L` to show server list
```

You may get some help by [crontab.guru](https://crontab.guru).

Change the `TZ` environment variable to your timezone in [docker-compose.yml](docker-compose.yml) will make [Pretty Print Result](#pretty-print-result) works better

Finally, up the service!

```shell
$ docker-compose up -d
```

## Pretty Print Result

```shell
$ ./pretty-print.sh
[2022-06-18 15:03:31]   download: 603.952Mbps   upload: 53.873Mbps
[2022-06-18 16:03:32]   download: 598.62Mbps    upload: 34.031Mbps
[2022-06-18 17:03:24]   download: 610.626Mbps   upload: 53.728Mbps
```
