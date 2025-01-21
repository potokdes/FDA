with deduplicate_labeler_name as (

    select
        product_id,
        trim(
            regexp_replace(lower(labeler_name), '([.,]|(inc)|llc)', '', 'g')
        ) as labeler_name
    from {{ ref("stg_drug_ndc") }}
)

select * from deduplicate_labeler_name
