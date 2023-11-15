#!/bin/sh

export DISPLAY=':99.0'
Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &

# Give time to dbus & Xvfb to boot
sleep 1

# Start application
cd /opt
npm run start
