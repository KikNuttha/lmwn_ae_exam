with orders as (
        select * from "ae_exam_db"."main"."model_sg_trn_order"
    ),

    drivers as (
        select * from "ae_exam_db"."main"."model_sg_mst_drivers"
    ),

    driver_incentive as (
        select * from "ae_exam_db"."main"."model_sg_log_driver_incentive"
    ),

    daily_driver_performance as (
        select
            driver_id,
            cast(order_datetime as date) order_date,
            count(order_id) as orders_completed,
            round(avg(date_diff('minute', pickup_datetime, delivery_datetime)),2) as avg_delivery_duration_min
        from orders
        where order_status = 'completed'
        group by 1, 2
    )

select
    i.log_id,
    i.driver_id,
    d.vehicle_type,
    i.region,
    i.incentive_program,
    i.applied_date,
    i.bonus_amount,
    i.bonus_qualified,
    p.orders_completed as actual_deliveries_on_date,
    p.avg_delivery_duration_min
from driver_incentive i
inner join drivers d 
    on i.driver_id = d.driver_id
left join daily_driver_performance p 
    on i.driver_id = p.driver_id 
    and i.applied_date = p.order_date