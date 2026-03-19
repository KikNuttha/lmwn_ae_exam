with driver_metrics as (
    select * from "ae_exam_db"."main"."model_mrt_driver_performance"
    ),

    mst_driver as (
        select * from "ae_exam_db"."main"."model_sg_mst_drivers"
    ),

    driver_metadata as (
        -- Dimensions --
        select 
            driver_id,
            vehicle_type,
            region,
            driver_rating,
            active_status,
            bonus_tier
        from mst_driver
    )

select
    -- Descriptive Metadata--
    d.driver_id,
    d.vehicle_type,
    d.region,
    d.driver_rating as lifetime_rating,
    d.active_status,
    d.bonus_tier,

    -- Metrics--
    m.total_assigned_tasks,
    m.total_completed_tasks,
    m.completion_rate_pct,
    m.avg_acceptance_time_min,
    m.avg_delivery_time_min,
    m.total_late_deliveries,
    late_delivery_rate_pct,
    avg_recent_csat

from driver_metadata d
left join driver_metrics m on d.driver_id = m.driver_id