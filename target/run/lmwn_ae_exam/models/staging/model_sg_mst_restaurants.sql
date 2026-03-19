
  
  create view "ae_exam_db"."main"."model_sg_mst_restaurants__dbt_tmp" as (
    with source as ( 
    select *
    from "ae_exam_db"."main"."restaurants_master"
),

sg_mst_restaurants as (
    select
        trim(lower(restaurant_id)) as restaurant_id,
        trim(lower("name")) as restaurant_name,
        trim(lower(category)) as category,
        trim(lower(city)) as city,
        COALESCE(CAST(average_rating AS DECIMAL(18, 2)), 0) as average_rating,
        trim(lower(active_status)) as active_status,
        COALESCE(CAST(prep_time_min AS INT), 0) as  prep_time_min
    from source
)

select * from sg_mst_restaurants
  );
