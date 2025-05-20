select *
from {{ ref('mart_labeler_summary') }}
where
    total_drugs <= 0
    or generic_drugs_count < 0
    or distinct_active_ingredients < 0
