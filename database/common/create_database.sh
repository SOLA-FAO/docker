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
createDb=y
loadData=$SOLA_LOAD_DATA

# Start the build
echo 
echo 
echo "Starting Build at $(date)"
echo "Starting Build at $(date)" > $BUILD_LOG 2>&1
echo "NOTE: Build of SOLA database will take approx. 5 minutes"
echo "NOTE: Build of SOLA database will take approx. 5 minutes" > $BUILD_LOG 2>&1

# Skip creating the database depending on the users choice 
if [ $createDb == "y" ]; then
   # Create database passing in dbName as a variable
   echo "Creating database..."
   echo "Creating database..." >> $BUILD_LOG 2>&1
   $psql --username="$POSTGRES_USER" --file=$SOLA_HOME/database.sql -v dbName=$dbname >>$BUILD_LOG 2>&1
fi

# Run the files to create the tables, functions and views, etc, of the database
# and load the configuration data from the config directory. 
for sqlfile in $SOLA_HOME/schema/*.sql $SOLA_HOME/config/*.sql
do
   echo "Running $sqlfile..."
   echo "### Running $sqlfile..." >> $BUILD_LOG 2>&1
   $psql --username="$POSTGRES_USER" --file="$sqlfile" $dbname > /dev/null 2>> $BUILD_LOG
done

# Load data into the database.  
if [ $loadData == "y" ]; then
	for sqlfile in $SOLA_HOME/data/*.sql
	do
	   echo "Running $sqlfile..."
	   echo "### Running $sqlfile..." >> $BUILD_LOG 2>&1
	   $psql --username="$POSTGRES_USER" --file="$sqlfile" $dbname > /dev/null 2>> $BUILD_LOG
	done
fi

# Run any override settings for docker deployment
echo "Running docker_config.sql..."
echo "### Running docker_config.sql..." >> $BUILD_LOG 2>&1
$psql --username="$POSTGRES_USER" --file=$SOLA_HOME/docker_config.sql $dbname > /dev/null 2>> $BUILD_LOG

# Report the finish time
echo "Finished at $(date) - Check build.log for errors!"
echo "Finished at $(date)" >> $BUILD_LOG 2>&1