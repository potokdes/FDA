select
    (result ->> 'product_id') as product_id,
    (result ->> 'product_ndc') as product_ndc,
    (result ->> 'brand_name') as brand_name,
    (result -> 'pharm_class') as pharm_class,
    ((result -> 'openfda') -> 'manufacturer_name') as manufacturer_name,
    (result -> 'openfda') -> 'is_original_packager' as is_original_packager,
    (result ->> 'generic_name') as generic_name,
    (result ->> 'dosage_form') as dosage_form,
    (result ->> 'route') as route,
    (result ->> 'marketing_category') as marketing_category,
    (result ->> 'dea_schedule') as dea_schedule,
    (result -> 'active_ingredients') as active_ingredients,
    (result ->> 'product_type') as product_type,
    (result) ->> 'labeler_name' as labeler_name
from {{ source('fda', 'ndc') }}
