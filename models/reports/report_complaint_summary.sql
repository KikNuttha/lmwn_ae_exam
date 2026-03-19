with complaint_metrics as (
    select * from {{ ref('model_mrt_total_complaint') }}
)

select
    opened_date,
    opened_date_mm,
    opened_date_yyyy,
    issue_type,
    issue_sub_type,
    total_tickets,
    total_unresolved,
    avg_resolution_time_min,
    total_compensation_issued,
    avg_compensation_per_ticket
from complaint_metrics