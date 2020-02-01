#!/usr/bin/env bash

./phabricator/bin/storage upgrade --force && \
./phabricator/bin/phd start

apachectl -D FOREGROUND
