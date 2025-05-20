# Docker Commands
db-up:
	docker-compose --env-file ./config/local/.env --project-directory ./containers/postgres/docker-compose.yml up -d

db-down:
	docker-compose --env-file ./config/local/.env --project-directory ./containers/postgres/docker-compose.yml down

# DBT Commands
dbt-debug:
	poetry run dbt debug --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/

dbt-run: ensure-logs
	poetry run dbt run --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/ --full-refresh

dbt-run-incremental: ensure-logs
	poetry run dbt run --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/

dbt-build: ensure-logs
	poetry run dbt build --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/

dbt-clean:
	poetry run dbt clean --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/

dbt-deps:
	poetry run dbt deps --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/

dbt-test: ensure-logs
	poetry run dbt test --profiles-dir ./config/base/ --project-dir ./fdadata/transformations --log-path ./logs/dbt/

# SQL Formatting
sql-format:
	poetry run sqlfluff fix --dialect postgres fdadata/transformations/models fdadata/transformations/tests

# Ensure logs directory exists
ensure-logs:
	mkdir -p logs/dbt

# Help Section
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Docker Targets:"
	@echo "  db-up             Start the PostgreSQL container"
	@echo "  db-down           Stop the PostgreSQL container"
	@echo ""
	@echo "DBT Targets:"
	@echo "  dbt-debug         Check DBT connection"
	@echo "  dbt-run           Run DBT models (FULL REFRESH by default)"
	@echo "  dbt-run-incremental Run DBT models without full refresh"
	@echo "  dbt-build         Run DBT models with tests"
	@echo "  dbt-clean         Clean DBT project"
	@echo "  dbt-deps          Install DBT dependencies"
	@echo "  dbt-test          Run DBT tests"
	@echo ""
	@echo "SQL Formatting:"
	@echo "  sql-format        Format SQL files using SQLFluff"
