# This Dockerflle can be used to build and configure an image for the SOLA database
# based on a Postgres PostGIS image. Before building an image, you must manually unzip 
# the database build files in the appropriate Solution/Version folder. Note that  
# pre-built docker images for the SOLA solutions are available from DockerHub at 
# https://hub.docker.com/u/mcdowella 

FROM mdillon/postgis:11

ENV SOLA_HOME /home/sola

# Used by create_database.sh to set the name of the SOLA database 
ENV SOLA_DB sola

# Used by create_database.sh to determine if the SOLA DB should be created
ENV CREATE_SOLA_DB y

# Used by create_database.sh to control if data is loaded into the 
# new database
ENV SOLA_LOAD_DATA y

# Change this to modify which SOLA solution database and version is built. 
# Can also specify solution at build time from build command line. See --build-arg option. 
ARG SOLA_SOLUTION=registry/1503a
#ARG SOLA_SOLUTION=stateland/1503a
#ARG SOLA_SOLUTION=systemreg/1503a

RUN mkdir -p ${SOLA_HOME}

# Copies the database build files from source directories into the image
COPY common/ ${SOLA_SOLUTION}/ ${SOLA_HOME}/

# See postgres docker image documentation. Files in docker-entrypoint-initdb.d
# will be run as part of the postgres init process. 
# The commands below remove any files in the init directory and add the 
# create_database.sh to ensure the sola database is created on the first run
# of the docker image. Also sets permissions to allow the build.log to be written
# to SOLA_HOME.  
RUN mv /docker-entrypoint-initdb.d/*.sh ${SOLA_HOME}/. && \
    cp ${SOLA_HOME}/create_database.sh /docker-entrypoint-initdb.d/.  && \
    chmod 755 /docker-entrypoint-initdb.d/create_database.sh && \
	chmod 777 ${SOLA_HOME}


