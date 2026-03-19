with intermediate_data as (
    select * from "ae_exam_db"."main"."model_int_marketing_attribution"
),

campaign_metrics as (
    select
        campaign_id,
        campaign_name,
        channel,
        sum(case when event_type = 'impression' then 1 else 0 end) as total_impressions,
        sum(case when event_type = 'click' then 1 else 0 end) as total_clicks,
        sum(case when event_type = 'conversion' then 1 else 0 end) as total_conversions,
        sum(ad_cost) as total_spend,
        sum(revenue) as total_revenue,
        sum(revenue)-sum(ad_cost) as total_benefit,
        coalesce(count(distinct case 
            when event_type = 'conversion' and is_new_customer = TRUE 
            then customer_id 
        end)) as acquired_new_customers
    from intermediate_data
    group by 1, 2, 3
)

select
    *,
    case 
        when total_spend > 0 then round((total_revenue / total_spend),2) 
        else 0
    end as roas,
    case 
        when acquired_new_customers > 0 then round((total_spend / acquired_new_customers),2)
        else 0
    end as cac

from campaign_metrics
order by total_benefit DESC