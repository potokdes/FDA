with labeler_names_cleaned as (
    select
        product_ndc,
        product_id,
        trim(
            regexp_replace(
                regexp_replace(
                    replace(
                        replace(lower(labeler_name), '&', ' and '),
                        '`',
                        ''''
                    ),

                    '[,\.]? ?(llc|ltd|inc|s\.?l|s\.?a|company)[\. ]?', ' ', 'g'
                ),
                ' +', ' ', 'g'
            )
        ) as labeler_name
    from {{ ref('stg_fda__ndc') }}
),

labeler_code_extracted as (
    select
        labeler_name,
        product_id,
        substring(product_ndc, 0, position('-' in product_ndc)) as labeler_code
    from labeler_names_cleaned
),

count_of_names_grouped_by_the_labeler_code as (
    select
        labeler_code,
        labeler_name,
        count(*) as number_of_occurences
    from labeler_code_extracted
    group by labeler_code, labeler_name
),

laber_name_ranked_by_number_of_occurences as (
    select
        labeler_code,
        labeler_name,
        number_of_occurences,
        row_number() over (
            partition by labeler_code
            order by number_of_occurences desc, length(labeler_name) asc
        ) as rnk
    from count_of_names_grouped_by_the_labeler_code
    order by labeler_code asc, rnk asc
),

assing_each_labeler_its_cleaned_name as (
    select
        labeler_code,
        labeler_name
    from laber_name_ranked_by_number_of_occurences
    where rnk = 1
)

select
    labeler_code_extracted.product_id,
    names_cleaned.labeler_name,
    names_cleaned.labeler_code
from assing_each_labeler_its_cleaned_name as names_cleaned
inner join labeler_code_extracted
    on names_cleaned.labeler_code = labeler_code_extracted.labeler_code
