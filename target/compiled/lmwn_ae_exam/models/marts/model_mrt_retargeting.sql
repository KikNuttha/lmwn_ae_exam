with retargeting_data as (
    select * from "ae_exam_db"."main"."model_int_retargeting"
)

select
    campaign_id,
    any_value(customer_segment) as targeted_segment,
    count(distinct customer_id) as total_targeted_customers,
    count(distinct case when event_type = 'conversion' then customer_id end) as returned_customers_count,
    round(
        count(distinct case when event_type = 'conversion' then customer_id end) * 100.0 
        / nullif(count(distinct customer_id), 0), 2
    ) as return_proportion_pct,
    sum(case when event_type = 'conversion' then revenue else 0 end) as total_retargeted_revenue,
    round(avg(case when event_type = 'conversion' then days_since_last_order end), 1) as avg_reengagement_gap_days,
    round(sum(revenue) / nullif(sum(case when event_type = 'conversion' then 1 else 0 end), 0),2) as avg_revenue_per_return
from retargeting_data
group by 1
order by total_retargeted_revenue desc