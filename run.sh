#!/bin/sh

rm -rf /tmp/.X*-lock

export DISPLAY=:99

# Start xvfb
if pgrep -x "Xvfb" > /dev/null
then
    echo "Xvfb is already running"
else
    echo "Starting Xvfb screen $DISPLAY"
    /usr/bin/Xvfb $DISPLAY -ac -screen 0 1920x1280x24 &
    # Give time to dbus & Xvfb to boot
    sleep 1
fi

# Start application
cd /opt
npm run start
