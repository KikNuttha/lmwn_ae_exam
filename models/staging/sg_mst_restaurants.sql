with source as ( 
    select *
    from {{ source('raw_data', 'restaurants_master')}}
),

sg_mst_restaurants as (
    select
        trim(lower(restaurant_id)) as restaurant_id,
        lower("name") as restaurant_name,
        trim(lower(category)) as category,
        trim(lower(city)) as city,
        average_rating,
        trim(lower(active_status)) as active_status,
        prep_time_min
    from source
)

select * from sg_mst_restaurants