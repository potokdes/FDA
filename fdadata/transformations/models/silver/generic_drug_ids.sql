select
    product_id,
    generic_name
from {{ ref("stg_drug_ndc") }}
where generic_name is not null