# Superset and Metabase Evaluations

## Supersetup

Recommended to run on Linux OS with Docker and `docker-compose`.

1. Clone the Apache Superset repo on GitHub

        git clone https://github.com/apache/superset.git; cd superset

2. (optional) If you have data and SQL scripts for loading data, change the `db`
   component in the `docker-compose-non-dev.yml` file to the following:

        db:
            env_file: docker/.env-non-dev
            image: postgres:latest
            container_name: superset_db
            restart: unless-stopped
            volumes:
              - db_home:/var/lib/postgresql/data
              - ../source-data:/source-data
              - ../database-setup/sourcedb.sql:/docker-entrypoint-initdb.d/sourcedb.sql
            ports:
              - "5433:5432" 

    The default settings also has no port mapping for the database, which prevents
    external connections to the database (e.g. from a VSCode extension). Specify the
    port mapping as above to make external connections possible. Other environment
    variables are in the `.env-non-dev` file.

    Modify the `docker/.env-non-dev` file not to load examples because it takes
    way too long to load them.

        SUPERSET_LOAD_EXAMPLES=no

3. Run this production version of the `docker-compose` file

        docker-compose -f docker-compose-non-dev.yml up -d

    **NOTE:** Although the official instructions at this stage say that you can
    login with username and password `admin` at `localhost:8088`, I could not. This was a
    [past issue](https://github.com/apache/superset/issues/10149) as well.

4. To fix this, go inside the `superset_app` container and run the `docker-init.sh` Bash script:

        docker exec -it superset_app bash
        cd /app/docker
        bash docker-init.sh

    This will create the Superset Admin user, with username and password `admin`.
    If `SUPERSET_LOAD_EXAMPLES` is set to `no`, running the Bash script will not
    load them. Otherwise, it will take ~30 min to load the examples.

    Another way of fixing this is to directly run the Bash script without going inside the container:

        docker exec -i superset_app bash /app/docker/docker-init.sh

    Yet another way is by fixing it permanently. Modify the `superset-init` container in the
    `docker-compose-non-dev.yml` file as follows:

    ![picture](picture)

5. Exit the container and go to `localhost:8088` and login with username and password
   `admin`.

Connect to database with URI string:

        postgresql+psycopg2://superset:superset@db:5432/superset

## Metabase Setup

[One-liner](https://www.metabase.com/start/oss/) for Docker (not recommended):

        docker run -d -p 3000:3000 --name metabase metabase/metabase

[Custom setup](https://www.metabase.com/docs/latest/operations-guide/running-metabase-on-docker.html) (modified)
with a `docker-compose` file, including database container and secret files:

        docker-compose up -d

Connect to database from Metabase setup page with `hostname:port` = `postgres-metabase:5432`.
Connect from external applications using `localhost:5434`.

**NOTE:** Docker secrets don't work with `docker-compose`, they only work with Docker Swarm.
Use an environment file `.env` instead.

If containers keep exiting unexpectedly (usually when database connection credentials are invalid),
check their logs with

        docker logs [CONTAINER_NAME | CONTAINER_ID]

## CSV, Excel, and Parquet Uploads

### Superset

