This will be a read me file

Prerequisites:
- Poetry
- Docker 

1. Add following .env in `config/local/.env`. The values are examles, you can change them to your liking
    ```
        POSTGRES_USER="potok"
        POSTGRES_PASSWORD="potok"
        POSTGRES_DB="fda"
        PGADMIN_DEFAULT_EMAIL="potokdes@gmail.com"
        PGADMIN_DEFAULT_PASSWORD="example"
        DB_HOST="localhost"
        DB_PORT=5432
    ```
2. Install the project `poetry install`
3. In windows add those wariables as your envirometal varaibles
4. In unix run 
    ```
        cd script
        source ./load_env.sh
    ```
5. In unix you can run make commands that avaliable for u in the makefile in windows just copy the one you need and paste it into the terminal
6. Set up database
   `docker-compose --env-file ./config/local/.env --project-directory ./containers/postgres/docker-compose.yml up -d` or `make db-up`
7. Load the data into the database
   1. Open pgAdmin -> it is a part of docker compose and should be avaliable in your browser: `http://localhost:5050`
   2. Connect to the fda database (create server connection, use the same parameters as in .env configuration file)
   3. Copy the sql from `fdadata/create_script.sql` and run the script in browser. (if in terminal: CREATE SCHEMA raw_fda AUTHORIZATION [POSTGRES_USER];)
   4. Download FDA data from: [Drug NDC](https://download.open.fda.gov/drug/ndc/drug-ndc-0001-of-0001.json.zip). More data from FDA API can be found [Here](https://api.fda.gov/download.json). Save file as: "./data/drug-ndc-0001-of-0001.json"
   5. Run python script `fdadata/ingestion/load.py`
8. Test if the dbt can connect to db
   `dbt debug --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/`
9. Install dbt deps
    `dbt deps --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/`
10. Build dbt project
    ``dbt build --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/``