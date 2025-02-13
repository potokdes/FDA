select
    product_id,
    generic_name
from {{ ref("stg_fda__ndc") }}
where generic_name is not null
