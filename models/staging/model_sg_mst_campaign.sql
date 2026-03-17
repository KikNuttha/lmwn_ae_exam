with source as ( 
    select *
    from {{ source('raw_data', 'campaign_master')}}
),

sg_mst_campaign as (
    select
        trim(lower(campaign_id)) as campaign_id,
        trim(lower(campaign_name)) as campaign_name,
        "start_date"::date as start_dt,
        end_date::date as end_dt,
        trim(lower(campaign_type)) as campaign_type,
        trim(lower(objective)) as objective,
        trim(lower(channel)) as channel,
        COALESCE(CAST(budget AS DECIMAL(18, 2)), 0) as budget,
        trim(lower(cost_model)) as cost_model,
        trim(lower(targeting_strategy)) as targeting_strategy,
        is_active::boolean as is_active
    from source
)

select * from sg_mst_campaign