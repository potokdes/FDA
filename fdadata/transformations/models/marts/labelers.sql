select
    dm.labeler_name,
    count(distinct dm.product_id) as total_drugs,
    count(distinct gdi.product_id) as generic_drugs_count,
    count(distinct dai.ingredient_name) as distinct_active_ingredients
from {{ ref('int_ndc_labelers_deduplicated') }} as dm
left join {{ ref('int_generic_drug_identificated') }} as gdi
    on dm.product_id = gdi.product_id
left join {{ ref('int_drug_active_ingredients_unnested') }} as dai
    on dm.product_id = dai.product_id
group by dm.labeler_name
