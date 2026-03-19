with mrt_driver_incentive as (
    select * from {{ref('model_mrt_driver_incentive')}}
    ),

    drivers as (
        select * from {{ref('model_sg_mst_drivers')}}
    )

select
    -- Metrics--
    i.incentive_program,
    i.region,
    i.total_drivers_participating,
    i.total_bonus_payout,
    i.total_delivery_volume,
    i.avg_delivery_time_min,
    i.qualification_rate_pct
from mrt_driver_incentive i
order by total_bonus_payout desc