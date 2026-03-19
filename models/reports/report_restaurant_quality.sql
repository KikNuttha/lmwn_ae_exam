with restaurant_metrics as (
    select * from {{ref('model_mrt_restaurant_quality')}}
    ),

    mst_restaurants as (
        select * from {{ref('model_sg_mst_restaurants')}}
    ),

    restaurant_master as (
        select 
            restaurant_id,
            city,
            active_status,
            average_rating as lifetime_avg_rating
        from mst_restaurants
    )

select
    -- Dimensions --
    m.restaurant_id,
    m.restaurant_name,
    m.category,
    r.city,
    r.active_status,
    r.lifetime_avg_rating,


    -- Complaint Volume & Nature --
    m.volume_of_complaints,
    m.issue_sub_type as complaint_category,
    m.issue_count as category_frequency,
    
    -- Operational & Financial Impact --
    m.avg_resolution_time_min,
    m.total_compensation_issued,
    
    -- Quality Ratios & Behavior --
    m.complaint_to_order_ratio_pct,
    m.customer_recovery_rate_30d_pct

from restaurant_metrics m
left join restaurant_master r on m.restaurant_id = r.restaurant_id
order by m.volume_of_complaints desc, m.restaurant_id, m.issue_rank ASC