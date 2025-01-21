db-up:
	docker-compose --env-file ./config/local/.env --project-directory ./containers/postgres/docker-compose.yml up -d
db-down:
	docker-compose --env-file ./config/local/.env --project-directory ./containers/postgres/docker-compose.yml down
dbt-debug:
	dbt debug --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/
dbt-run:
	dbt run --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/
dbt-build:
	dbt build --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/
dbt-clean:
	dbt clean --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/
sql-format:
	sqlfluff fix --dialect postgres fdadata/transformations/models