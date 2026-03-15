with source as (
    select *
    from {{ source('raw_data', 'drivers_master')}}
),

sg_mst_drivers as (
    select
         trim(lower(driver_id)) as driver_id,
         join_date::date as join_date,
         trim(lower(vehicle_type)) as vehicle_type,
         trim(lower(region)) as region,
         trim(lower(active_status)) as active_status,
         driver_rating,
         trim(lower(bonus_tier)) as bonus_tier
    from source
)

select * from sg_mst_drivers