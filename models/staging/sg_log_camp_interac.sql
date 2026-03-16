with source as (
    SELECT * 
    FROM {{ source('raw_data', 'campaign_interactions')}}
),

sg_log_camp_interac as (
select
    trim(lower(interaction_id)) as interaction_id,
    trim(lower(campaign_id)) as campaign_id,
    trim(lower(customer_id)) as customer_id,
    interaction_datetime::timestamp as interaction_dt,
    trim(lower(event_type)) as event_type,
    trim(lower(platform)) as platform,
    trim(lower(device_type)) as device_type,
    COALESCE(CAST(ad_cost AS DECIMAL(18, 2)), 0) as ad_cost,
    trim(lower(order_id)) as order_id,
    is_new_customer::boolean as is_new_customer,
    COALESCE(CAST(revenue AS DECIMAL(18, 2)), 0) as revenue,
    trim(lower(session_id)) as session_id
from source
)

select distinct device_type
from sg_log_camp_interac
