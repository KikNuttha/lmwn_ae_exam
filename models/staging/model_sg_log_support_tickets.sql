with source as (
    SELECT * 
    FROM {{ source('raw_data', 'support_ticket_status_logs')}}
),

sg_log_support_tickets as (
select
    trim(lower(ticket_id)) as ticket_id,
    trim(lower("status")) as action_status,
    status_datetime::timestamp as status_datetime,
    trim(lower("agent_id")) as agent_id
from source
)
 select * from sg_log_support_tickets