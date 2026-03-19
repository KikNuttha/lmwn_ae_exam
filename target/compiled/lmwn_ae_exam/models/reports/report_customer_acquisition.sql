with acquisition as (
    select * from "ae_exam_db"."main"."model_mrt_customer_acquisition"
    ),

    campaign as (
        select * from "ae_exam_db"."main"."model_sg_mst_campaign"
    ),

    campaign_metadata as (
        -- Dimensions --
        select 
            campaign_id,
            campaign_name,
            campaign_type,
            objective,
            channel,
            budget,
            targeting_strategy,
            is_active
        from campaign
    )

select
    -- 1. Campaign Dimensions --
    m.campaign_name,
    m.channel,
    m.platform,
    c.campaign_type,
    c.targeting_strategy,
    c.objective,
    c.budget,
    c.is_active,

    -- 2. Acquisition Metrics (Direct mapping from your Mart logic)
    m.total_new_customers,
    m.total_acquisition_spend,
    
    -- Calculated Cost Per Acquisition (CAC)
    round(m.total_acquisition_spend / nullif(m.total_new_customers, 0), 2) as cac,

    -- 3. Behavioral Insights (Post-acquisition performance)
    m.avg_order_value,
    m.repeat_order_rate_pct,
    m.avg_retention_days,
    m.avg_minutes_to_convert

from acquisition m
left join campaign_metadata c on m.campaign_id = c.campaign_id