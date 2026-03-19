with mrt_retargeting as (
        select * from {{ref('model_mrt_retargeting')}}
    ),

    campaign as (
        select * from {{ ref('model_sg_mst_campaign') }}
    ),


    retargeting_marts as (
        -- Pulling the core metrics --
        select 
            campaign_id,
            targeted_segment,
            total_targeted_customers,
            returned_customers_count,
            return_proportion_pct,
            total_retargeted_revenue,
            avg_reengagement_gap_days,
            avg_revenue_per_return
        from mrt_retargeting
    ),

    campaign_metadata as (
        -- Dimensions --
        select 
            campaign_id,
            campaign_name,
            channel,
            campaign_type,
            targeting_strategy,
            objective
        from campaign
    )

select
    -- Descriptive Metadata--
    c.campaign_name,
    c.channel,
    c.campaign_type,
    c.targeting_strategy,
    c.objective,
    
    -- Metrics--
    m.targeted_segment,
    m.total_targeted_customers,
    m.returned_customers_count,
    m.return_proportion_pct,
    m.total_retargeted_revenue,
    m.avg_reengagement_gap_days,
    m.avg_revenue_per_return

from retargeting_marts m
left join campaign_metadata c on m.campaign_id = c.campaign_id