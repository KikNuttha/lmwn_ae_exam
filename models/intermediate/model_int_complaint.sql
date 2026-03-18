with raw_tickets as (
    select * from {{ ref('model_sg_trn_support_tickets') }}
)

select
    ticket_id,
    order_id,
    customer_id,
    driver_id,
    restaurant_id,
    issue_type,
    issue_sub_type,
    current_status,
    opened_datetime,
    resolved_datetime,
    date_diff('minute', opened_datetime, resolved_datetime) as resolution_time_min,
    case 
        when current_status != 'resolved' then 1 
        else 0 
    end as is_unresolved,
    case 
        when current_status = 'resolved' then 1 
        else 0 
    end as is_resolved,
    compensation_amount,
    cast(opened_datetime as date) as opened_date
from raw_tickets