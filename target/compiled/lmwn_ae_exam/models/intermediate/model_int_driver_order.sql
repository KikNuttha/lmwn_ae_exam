with log_order as (
        select * from "ae_exam_db"."main"."model_sg_log_order"
    ),

    orders as (
        select * from "ae_exam_db"."main"."model_sg_trn_order"
    ),

    feedback as (
        select * from "ae_exam_db"."main"."model_sg_trn_support_tickets"
    ),

    order_status as (
    select 
        order_id,
        min(case when order_status = 'created' then cast(status_datetime as timestamp) end) as created_dt,
        min(case when order_status = 'accepted' then cast(status_datetime as timestamp) end) as accepted_dt,
        min(case when order_status = 'canceled' then cast(status_datetime as timestamp) end) as canceled_dt
    from log_order
    group by 1
    ),

    order_details as (
        select
            order_id,
            driver_id,
            order_status,
            is_late_delivery,
            cast(pickup_datetime as timestamp) as pickup_dt,
            cast(delivery_datetime as timestamp) as delivery_dt
        from orders
    ),

    driver_feedback as (
        select 
            order_id,
            csat_score
        from feedback
        where driver_id is not null
    )

select
    o.order_id,
    o.driver_id,
    o.order_status,
    o.is_late_delivery,
    t.created_dt,
    t.accepted_dt,
    date_diff('minute', t.created_dt, t.accepted_dt) as acceptance_time_min, 
    t.canceled_dt,
    date_diff('minute', t.created_dt, t.canceled_dt) as customer_wait_time_to_cancel_min,
    date_diff('minute', t.accepted_dt, t.canceled_dt) as driver_held_to_cancel_min,
    o.pickup_dt,
    o.delivery_dt,
    date_diff('minute', o.pickup_dt, o.delivery_dt) as delivery_duration_min,
    f.csat_score
from order_details o
left join order_status t on o.order_id = t.order_id
left join driver_feedback f on o.order_id = f.order_id