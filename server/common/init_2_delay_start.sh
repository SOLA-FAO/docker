#!/bin/bash

# 11 Feb 2019
# Delays the start up of the SOLA Server by the specified WAIT_TIME. Used to allow
# the SOLA database time to initialize and start accepting connections.
# This script is run on container initialization when it is copied into the $SCRIPT_DIR
# in the Payara image post version 5.183  

if [ $WAIT_TIME -eq 0 ]; then
    echo "Start with no delay"
    exit 0
fi

echo "Delaying start of server by $WAIT_TIME seconds..."
sleep $WAIT_TIME

