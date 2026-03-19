with complaints_metrics as (
    select * from {{ref('model_mrt_driver_complaint')}}
    ),

    driver_list as (
        select * from {{ref('model_sg_mst_drivers')}}
    ),

    driver_metadata as (
    -- ดึงข้อมูลมิติเพิ่มเติมจาก Driver Master เพื่อใช้ในการกรองข้อมูล
    select 
        driver_id,
        active_status,
        bonus_tier
    from driver_list
    )

select
    -- Dimensions --
    m.driver_id,
    m.vehicle_type,
    m.region,
    d.active_status,
    d.bonus_tier,

    -- Rating Metrics
    m.baseline_rating as rating_before_complaints,
    m.avg_post_complaint_csat as rating_after_complaints,

    -- Complaint Metrics --
    m.total_complaints,
    m.issue_rank,
    m.issue_sub_type as complaint_category,
    m.sub_type_count,
    
    --  Resolution & Efficiency --
    m.avg_resolution_time_min,
    m.complaint_to_order_ratio_pct

from complaints_metrics m
left join driver_metadata d on m.driver_id = d.driver_id
order by m.total_complaints DESC, m.issue_rank ASC