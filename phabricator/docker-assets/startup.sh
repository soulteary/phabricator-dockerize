#!/bin/bash

echo "Configuring DB options"
echo "HOST: $DB_HOST PORT: $DB_PORT"

./phabricator/bin/config set mysql.host $DB_HOST 
./phabricator/bin/config set mysql.port $DB_PORT 
./phabricator/bin/config set mysql.user $DB_USER 
./phabricator/bin/config set mysql.pass $DB_PASS 
