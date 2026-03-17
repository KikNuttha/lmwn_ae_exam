-- For Campaign Effectiveness Report --
with campaign as (
    select * from {{ ref('model_sg_mst_campaign') }}
),

interactions as (
    select * from {{ ref('model_sg_log_camp_interac') }}
),

attribution as (
    select
        c.campaign_id,
        c.campaign_name,
        c.campaign_type,
        c.objective,
        c.channel,
        c.budget,
        c.targeting_strategy,
        i.customer_id,
        cast(i.interaction_dt as date) as interaction_date,
        i.event_type,
        i.platform,
        i.ad_cost,
        i.is_new_customer,
        i.revenue
    from campaign c
    left join interactions i    
        on c.campaign_id = i.campaign_id 
    where cast(i.interaction_dt as date) between c.start_dt and c.end_dt
)

select *
from attribution