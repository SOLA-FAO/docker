-- 6 Feb 2014
-- Script to create the database - requires the dbName and 
-- dbTemplate parameters to be passed in to the psql command
-- using the -v option. 

-- Quote the dbName variable using the psql \set command so 
-- that it can be used as a query variable. 
\set quoted_dbName '\'' :dbName '\''

-- Attempt to terminate connections to the database on 
-- Postgresql 9.2+. This query will fail if the database
-- version is prior to 9.2. 
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM   pg_stat_activity
WHERE  pg_stat_activity.datname = :quoted_dbName
AND    pid <> pg_backend_pid(); 

-- Attempt to terminate connections to the database on 
-- Postgresql up to verion 9.1. This query will fail if 
-- the database version is 9.2 or later. 
--SELECT pg_terminate_backend(pg_stat_activity.procpid)
--FROM   pg_stat_activity
--WHERE  pg_stat_activity.datname = :quoted_dbName
--AND    procpid <> pg_backend_pid();

-- Drop and create the database 
DROP DATABASE IF EXISTS :dbName;    

CREATE DATABASE :dbName
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       CONNECTION LIMIT = -1;

ALTER DATABASE :dbName SET bytea_output = 'escape';
GRANT CONNECT, TEMPORARY ON DATABASE :dbName TO public;
GRANT ALL ON DATABASE :dbName TO postgres;

-- Connect to the new database and create the necessary extensions
-- Note that PostGIS must be manually installed on the PostgreSQL 
-- server first.   
\connect :dbName

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
