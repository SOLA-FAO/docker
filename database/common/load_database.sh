#!/bin/bash

# 08 Feb 2019
# Customized version of the SOLA database build script to use as 
# part of the docker build to allow loading of the sola database 
# until after Postgres is accepting connections. 

# Default install location for psql on linux/Debian. This location
# may need to be modified if a different version of postgresql
# is being used and/or it is installed in a custom location.
psql="psql"
BUILD_LOG=$SOLA_HOME/load_db.log

# Default DB connection values. Source values from environment
# variables configured by the DockerFile. 
dbname=$SOLA_DB

# Wait 10 seconds for init process on Postgres to complete before 
# attempting to load the demo data. 
sleep 10

# Start the build
echo 
echo 
echo "Starting db load at $(date)"
echo "Starting db load at $(date)" > $BUILD_LOG 2>&1
echo "NOTE: Load of SOLA database can take up to  10 minutes"
echo "NOTE: Load of SOLA database can take up to  10 minutes" > $BUILD_LOG 2>&1

# Load data into the database.  
for sqlfile in $SOLA_HOME/data/*.sql
do
   echo "Running $sqlfile..."
   echo "### Running $sqlfile..." >> $BUILD_LOG 2>&1
   $psql --username="$POSTGRES_USER" --file="$sqlfile" $dbname > /dev/null 2>> $BUILD_LOG
done

# Report the finish time
echo "Finished load at $(date)"
echo "Finished load at $(date)" >> $BUILD_LOG 2>&1