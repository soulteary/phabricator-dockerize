#!/usr/bin/env bash

docker build -t $(cat phabricator/IMAGE_NAME.txt) .