#!/bin/bash

# 08 Feb 2019
# Delays the start up of the SOLA Server by the specified WAIT_TIME. Used to allow
# the SOLA database time to initialize and start accepting connections. 

if [ $WAIT_TIME -eq 0 ]; then
    exit 0
fi

echo "Delaying start of server by $WAIT_TIME seconds"
sleep $WAIT_TIME

