
  
    
    

    create  table
      "ae_exam_db"."main"."model_mrt_total_complaint__dbt_tmp"
  
    as (
      with complaint_metrics as (
    select * from "ae_exam_db"."main"."model_int_complaint"
)

select
    opened_date,
    opened_date_mm,
    opened_date_yyyy,
    issue_type,
    issue_sub_type,
    count(ticket_id) as total_tickets,
    sum(is_unresolved) as total_unresolved,
    round(avg(case when is_resolved = 1 then resolution_time_min end), 2) as avg_resolution_time_min,
    sum(compensation_amount) as total_compensation_issued,
    round(sum(compensation_amount) / nullif(count(ticket_id), 0), 2) as avg_compensation_per_ticket
from complaint_metrics
group by 1, 2, 3, 4, 5
order by cast(opened_date as date) desc, total_tickets desc
    );
  
  