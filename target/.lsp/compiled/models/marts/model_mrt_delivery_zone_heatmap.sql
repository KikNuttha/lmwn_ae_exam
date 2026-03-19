with del_zone AS (
    select * from "ae_exam_db"."main"."model_int_delivery_zone"
    ),

    delivery_zone as (
        select
            delivery_zone,
            city,
            count(order_id) as total_delivery_requests,
            count(case when order_status = 'completed' then 1 end) as completed_orders,
            count(case when is_canceled_no_driver = 1 then 1 end) as no_driver_cancellations,
            avg(total_delivery_time_min) as avg_delivery_time_min,
            count(case when is_late_delivery = 'TRUE' then 1 end) as total_late_deliveries,
            count(distinct driver_id) as active_driver_count
        from del_zone
        group by 1, 2
)

select
    delivery_zone,
    city,
    total_delivery_requests,
    round(completed_orders * 100.0 / nullif(total_delivery_requests, 0), 2) as completion_rate_pct,
    round(avg_delivery_time_min, 2) as avg_delivery_time_min,
    round(no_driver_cancellations * 100.0 / nullif(total_delivery_requests, 0), 2) as no_driver_cancel_rate_pct,
    round(active_driver_count * 1.0 / nullif(total_delivery_requests, 0), 4) as driver_to_request_ratio,
    round(total_late_deliveries * 100.0 / nullif(completed_orders, 0), 2) as late_delivery_rate_pct
from delivery_zone
order by 1,2,3 DESC