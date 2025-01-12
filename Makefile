db-up:
	docker-compose --env-file ./config/local/.env --project-directory ./containers/postgres/docker-compose.yml up -d
db-down:
	docker-compose --env-file ./config/local/.env --project-directory ./containers/postgres/docker-compose.yml down
dbt-debug:
	dbt debug --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/