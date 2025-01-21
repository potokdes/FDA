-- Every labeler should have a at lest one drug assositated
-- It this test fails it meens that logic we are loosing some durg info
-- in labeler_summary aggregations or in drug_labeler. Satrt digging there.
select
    labeler_name
from {{ ref('manufacturer_summary') }}
where total_drugs = 0