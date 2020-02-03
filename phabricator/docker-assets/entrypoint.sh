#!/usr/bin/env bash

chmod 777 /data/stor

./phabricator/bin/storage upgrade --force && \
./phabricator/bin/phd start

apachectl -D FOREGROUND
