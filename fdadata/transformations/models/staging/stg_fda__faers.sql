select distinct
    (result ->> 'safetyreportid') as safety_report_id,
    (result ->> 'safetyreportversion') as safety_report_version,
    (result ->> 'companynumb') as company_number,
    source_file as _source_file
from {{ source('fda', 'faers') }}
