with driver_list as (
        select * from "ae_exam_db"."main"."model_sg_mst_drivers"
    ),

    driver_order as (
        select * from "ae_exam_db"."main"."model_int_driver_order"
    ),
 
    driver_perf as (
    select
        driver_id,
        count(order_id) as total_assigned_tasks,
        count(case when order_status = 'completed' then 1 end) as total_completed_tasks,
        avg(acceptance_time_min) as avg_acceptance_time_min,
        avg(delivery_duration_min) as avg_delivery_time_min,
        count(case when is_late_delivery = 'TRUE' then 1 end) as total_late_deliveries,
        avg(csat_score) as avg_customer_csat
    from driver_order
    group by driver_id
    )

select
    d.driver_id,
    d.vehicle_type,
    d.region,
    d.driver_rating as lifetime_rating,
    m.total_assigned_tasks,
    m.total_completed_tasks,
    round(m.total_completed_tasks * 100.0 / nullif(m.total_assigned_tasks,0), 2) as completion_rate_pct,
    round(m.avg_acceptance_time_min, 2) as avg_acceptance_time_min,
    round(m.avg_delivery_time_min, 2) as avg_delivery_time_min,
    m.total_late_deliveries,
    round(m.total_late_deliveries * 100.0 / nullif(m.total_completed_tasks, 0), 2) as late_delivery_rate_pct,
    round(m.avg_customer_csat, 2) as avg_recent_csat
from driver_list d
left join driver_perf m 
    on d.driver_id = m.driver_id