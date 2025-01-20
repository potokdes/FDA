select
    labeler_name,
    product_id
from {{ ref("stg_drug_ndc") }}
