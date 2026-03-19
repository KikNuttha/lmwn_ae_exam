
  
  create view "ae_exam_db"."main"."model_int_driver_complaint__dbt_tmp" as (
    with raw_tickets as (
    select * from "ae_exam_db"."main"."model_sg_trn_support_tickets"
),

drivers as (
    select * from "ae_exam_db"."main"."model_sg_mst_drivers"
)

select
    t.ticket_id,
    t.order_id,
    t.driver_id,
    d.vehicle_type,
    d.region,
    d.driver_rating as baseline_rating,
    t.issue_type,
    t.issue_sub_type,
    date_diff('minute', t.opened_datetime, t.resolved_datetime) as resolution_time_min,
    t.csat_score,
    t.current_status
from raw_tickets t
left join drivers d 
    on t.driver_id = d.driver_id
where t.issue_type not in ('payment','food')
  );
