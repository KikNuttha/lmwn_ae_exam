-- SELECT table_name 
-- FROM information_schema.tables 
-- WHERE table_schema = 'main'

with source as (
    SELECT * 
    FROM {{ source('raw_data', 'order_log_incentive_sessions_order_status_logs')}}
),

sg_log_order as (
select
    trim(lower(order_id)) as order_id,
    trim(lower("status")) as order_status,
    status_datetime::timestamp as status_datetime,
    trim(lower(updated_by)) as updated_by
from source
)

select *
from sg_log_order