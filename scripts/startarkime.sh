#!/bin/bash

# start cron daemon for logrotate
service cron start

# Start capture
# exec /opt/arkime/bin/arkime_config_interfaces.sh -c /opt/arkime/etc/config.ini -n default
exec /opt/arkime/bin/capture -c /opt/arkime/etc/config.ini >> /opt/arkime/logs/capture.log 2>&1 &

# Start Viewer
pushd /opt/arkime/viewer
exec /opt/arkime/bin/node viewer.js -c /opt/arkime/etc/config.ini >> /opt/arkime/logs/viewer.log 2>&1
popd
