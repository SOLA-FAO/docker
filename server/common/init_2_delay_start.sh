#!/bin/bash

# 11 Feb 2019
# Delays the start up of the SOLA Server by up to the specified WAIT_TIME (Default 90s).
# Used to allow the SOLA database time to initialize and start accepting connections.
# This script is run on container initialization when it is copied into the $SCRIPT_DIR
# in the Payara image post version 5.183  
$PAYARA_PATH/wait_for_it.sh $DATABASE_HOST:$DATABASE_PORT -t $WAIT_TIME

