
  
  create view "ae_exam_db"."main"."model_int_restaurant_complaint__dbt_tmp" as (
    with raw_tickets as (
    select * from "ae_exam_db"."main"."model_sg_trn_support_tickets"
),

restaurants as (
    select * from "ae_exam_db"."main"."model_sg_mst_restaurants"
)

select
    t.ticket_id,
    t.order_id,
    t.customer_id,
    t.restaurant_id,
    r.restaurant_name,
    r.category as restaurant_category,
    t.issue_type,
    t.issue_sub_type,
    t.opened_datetime,
    t.resolved_datetime,
    date_diff('minute', t.opened_datetime, t.resolved_datetime) as resolution_time_min,
    t.compensation_amount,
    t.current_status
from raw_tickets t
join restaurants r on t.restaurant_id = r.restaurant_id
where t.issue_type = 'food'
  );
