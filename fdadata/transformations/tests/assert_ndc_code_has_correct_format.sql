select product_ndc
from {{ ref("stg_fda__ndc") }}
where
    position('-' in product_ndc) = 0   -- no hyphen
    -- left part 4–5 digits
    or length(split_part(product_ndc, '-', 1)) not in (4, 5)
    -- right part 3–5 digits
    or length(split_part(product_ndc, '-', 2)) not in (3, 4, 5)
    -- total length check
    or length(product_ndc) not in (9, 10, 11)
