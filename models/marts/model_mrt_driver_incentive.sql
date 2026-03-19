with driver_incentive_performance as (
        select * from {{ref('model_int_driver_incentive')}}
    )

select
    incentive_program,
    region,
    count(distinct driver_id) as total_drivers_participating,
    sum(case when bonus_qualified = TRUE then bonus_amount else 0 end) as total_bonus_payout,
    sum(actual_deliveries_on_date) as total_delivery_volume,
    round(avg(avg_delivery_duration_min), 2) as avg_delivery_time_min,
    round(
        sum(case when bonus_qualified = TRUE then 1 else 0 end) * 100.0 / count(*), 
        2
    ) as qualification_rate_pct

from driver_incentive_performance
group by 1, 2
order by total_bonus_payout desc