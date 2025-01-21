select
    dm.labeler_name,
    count(distinct dm.product_id) as total_drugs,
    count(distinct gdi.product_id) as generic_drugs_count,
    count(distinct dai.name) as distinct_active_ingredients
from {{ ref('drug_labeler') }} as dm
left join {{ ref('generic_drug_ids') }} as gdi
    on dm.product_id = gdi.product_id
left join {{ ref('drug_active_ingredients') }} as dai
    on dm.product_id = dai.product_id
group by dm.labeler_name
