
  
  create view "ae_exam_db"."main"."model_int_delivery_zone__dbt_tmp" as (
    with log_order as (
        select * from "ae_exam_db"."main"."model_sg_log_order"
    ),

    orders as (
        select * from "ae_exam_db"."main"."model_sg_trn_order"
    ),

    restaurants as (
        select * from "ae_exam_db"."main"."model_sg_mst_restaurants"
    ),

    order_logs as (
        select 
            order_id,
            count(case when order_status = 'accepted' then 1 end) > 0 as was_accepted
        from log_order
        group by 1
    )

select
    o.order_id,
    o.delivery_zone,
    r.city,
    o.order_status,
    o.is_late_delivery,
    o.driver_id,
    o.order_datetime,
    o.delivery_datetime,
    date_diff('minute', o.order_datetime, o.delivery_datetime) as total_delivery_time_min,
    case when o.order_status = 'canceled' and l.was_accepted = false then 1 else 0 end as is_canceled_no_driver --cancel order before driver accepted
from orders o
left join restaurants r on o.restaurant_id = r.restaurant_id
left join order_logs l on o.order_id = l.order_id
  );
