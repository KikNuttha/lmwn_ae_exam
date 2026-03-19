
  
    
    

    create  table
      "ae_exam_db"."main"."report_campaign_effectiveness__dbt_tmp"
  
    as (
      with campaign_marts as (
    select * from "ae_exam_db"."main"."model_mrt_campaign_effective"
    ),

    mst_campaign as (
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
            targeting_strategy,
            is_active
        from mst_campaign
    )

select
    -- Descriptive Metadata--
    c.campaign_name,
    c.campaign_type,
    c.objective,
    c.channel,
    c.targeting_strategy,
    c.is_active,

    -- Metrics--
    m.total_impressions,
    m.total_clicks,
    m.total_conversions,
    m.total_spend,
    m.total_revenue,
    m.total_benefit,
    m.roas,
    m.cac

from campaign_marts m
left join campaign_metadata c on m.campaign_id = c.campaign_id
    );
  
  