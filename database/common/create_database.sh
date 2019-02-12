#!/bin/bash

# 04 Feb 2019
# Customized version of the SOLA database build script to use as 
# part of the docker build. 

# Default install location for psql on linux/Debian. This location
# may need to be modified if a different version of postgresql
# is being used and/or it is installed in a custom location.
psql="psql"
BUILD_LOG=$SOLA_HOME/build.log

# Default DB connection values. Source values from environment
# variables configured by the DockerFile. 
dbname=$SOLA_DB
createDb=$CREATE_SOLA_DB
loadData=$SOLA_LOAD_DATA

if [ $createDb == "n" ]; then
    echo "Skipping SOLA database build"
    echo "Skipping SOLA database build $(date)" > $BUILD_LOG 2>&1
    exit 0
fi


# Start the build
echo 
echo 
echo "Starting Build at $(date)"
echo "Starting Build at $(date)" > $BUILD_LOG 2>&1
echo "NOTE: Build of SOLA database will take approx. 1 minute"
echo "NOTE: Build of SOLA database will take approx. 1 minute" > $BUILD_LOG 2>&1

# Create database passing in dbName as a variable
echo "Creating database..."
echo "Creating database..." >> $BUILD_LOG 2>&1
$psql --username="$POSTGRES_USER" --file=$SOLA_HOME/database.sql -v dbName=$dbname >>$BUILD_LOG 2>&1

# Run the files to create the tables, functions and views, etc, of the database
# and load the configuration data from the config directory. 
for sqlfile in $SOLA_HOME/schema/*.sql $SOLA_HOME/config/*.sql
do
   echo "Running $sqlfile..."
   echo "### Running $sqlfile..." >> $BUILD_LOG 2>&1
   $psql --username="$POSTGRES_USER" --file="$sqlfile" $dbname > /dev/null 2>> $BUILD_LOG
done

# Load data into the database by creating a background thread. Using a 
# background thread allows Postgres to complete its init processing so
# that it can accept connections quickly.
if [ $loadData == "y" ]; then
	$SOLA_HOME/load_database.sh &
fi

# Run any override settings for docker deployment
echo "Running docker_config.sql..."
echo "### Running docker_config.sql..." >> $BUILD_LOG 2>&1
$psql --username="$POSTGRES_USER" --file=$SOLA_HOME/docker_config.sql $dbname > /dev/null 2>> $BUILD_LOG

# Report the finish time
echo "Finished at $(date) - Check build.log for errors!"
echo "Finished at $(date)" >> $BUILD_LOG 2>&1