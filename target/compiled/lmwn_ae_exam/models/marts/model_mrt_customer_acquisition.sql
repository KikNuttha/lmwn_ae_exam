with acquisition as (
    select * from "ae_exam_db"."main"."model_int_customer_acquisition"
    ),

    campaign as (
        select * from "ae_exam_db"."main"."model_sg_mst_campaign"
    ),

    customer_acquisition as (
        select
            c.campaign_id,
            c.campaign_name,
            c.channel,
            a.platform,
            count(distinct a.customer_id) as total_new_customers,
            round(sum(a.total_spend) / sum(a.total_orders), 2) as avg_order_value,
            count(distinct case when a.total_orders > 1 then a.customer_id end) * 100.0 / count(distinct a.customer_id) as repeat_order_rate_pct,
            round(avg(a.retention_days),2) as avg_retention_days,
            round(avg(a.minutes_to_convert),2) as avg_minutes_to_convert,
            round(sum(a.acquisition_cost),2) as total_acquisition_spend
    from acquisition a
    left join campaign c on a.campaign_id = c.campaign_id
    group by 1, 2, 3, 4
)

select *
from customer_acquisition