create schema bronze
create table bronze.drug_ndc
(
    id uuid,
    result jsonb
)