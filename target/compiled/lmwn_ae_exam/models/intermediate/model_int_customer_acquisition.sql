with interactions as (
    select * from "ae_exam_db"."main"."model_sg_log_camp_interac"
    ),

    orders as (
    select * from "ae_exam_db"."main"."model_sg_trn_order"
    ),

    acquisition as (
        select
            campaign_id,
            customer_id,
            interaction_dt,
            ad_cost as acquisition_cost,
            platform,
            order_id
        from interactions
        where TRUE
            and is_new_customer = true
            and event_type = 'conversion' 
    ),

    customer_order as (
        select
            customer_id,
            count(order_id) as total_orders,
            sum(total_amount) as total_spend,
            min(order_datetime) as first_order_dt,
            max(order_datetime) as last_order_dt
        from orders
        where order_status = 'completed'
        group by customer_id
    )

select
    a.campaign_id,
    a.customer_id,
    a.platform,
    a.order_id,
    a.interaction_dt as first_interaction_dt,
    c.first_order_dt,
    date_diff('minute', c.first_order_dt, a.interaction_dt) as minutes_to_convert,
    --Repeat Behavior--
    c.total_orders,
    c.total_spend,
    c.last_order_dt,
    date_diff('day', c.first_order_dt, c.last_order_dt) as retention_days,
    a.acquisition_cost
from acquisition a
left join customer_order c
    on a.customer_id = c.customer_id