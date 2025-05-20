select
    labeler_code,
    count(distinct labeler_name) as name_count
from {{ ref('int_ndc_labelers_deduplicated') }}
group by labeler_code
having count(distinct labeler_name) > 1
