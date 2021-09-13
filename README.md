# Superset

## Supersetup

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

5. Exit the container and go to `localhost:8088` and login with username and password
   `admin`.

Connect to database with URI string:

        postgresql+psycopg2://superset:superset@db:5432/superset
