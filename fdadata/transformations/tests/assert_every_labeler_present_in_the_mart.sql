select dm.product_id
from {{ ref('int_ndc_labelers_deduplicated') }} as dm
left join {{ ref('mart_labeler_summary') }} as ms
    on dm.labeler_name = ms.labeler_name
where ms.labeler_name is null
