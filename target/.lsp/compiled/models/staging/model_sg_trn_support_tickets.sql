with source as (
    SELECT * 
    FROM "ae_exam_db"."main"."support_tickets"
),

sg_trn_support_tickets as (
select
    trim(lower(ticket_id)) as ticket_id,
    trim(lower(order_id)) as order_id,
    trim(lower(customer_id)) as customer_id,
    trim(lower(driver_id)) as driver_id,
    trim(lower(restaurant_id)) as restaurant_id,
    trim(lower(issue_type)) as issue_type,
    trim(lower(issue_sub_type)) as issue_sub_type,
    trim(lower(channel)) as channel,
    opened_datetime::timestamp as opened_datetime,
    resolved_datetime::timestamp as resolved_datetime,
    trim(lower("status")) as current_status,
    COALESCE(CAST(csat_score AS DECIMAL(18, 2)), 0) as csat_score,
    COALESCE(CAST(compensation_amount AS DECIMAL(18, 2)), 0) as compensation_amount,
    trim(lower(resolved_by_agent_id)) as resolved_by_agent_id
from source
)
 select * from sg_trn_support_tickets