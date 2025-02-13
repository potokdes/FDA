with active_ingreditens as (
    select
        product_id,
        (
            jsonb_array_elements(active_ingredients) ->> 'name'
        ) as ingredient_name,
        (jsonb_array_elements(active_ingredients) ->> 'strength') as strength
    from {{ ref("stg_fda__ndc") }}
)
,
colese_missing_strength as (
    select
        product_id,
        ingredient_name,
        coalesce(strength, '1/1') as strength
    from active_ingreditens
)

select *
from colese_missing_strength
