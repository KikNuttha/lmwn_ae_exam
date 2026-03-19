
  
  create view "ae_exam_db"."main"."model_sg_mst_customers__dbt_tmp" as (
    with source as (
    select * 
    from "ae_exam_db"."main"."customers_master"
),

sg_mst_customers as (
    select
        trim(lower(customer_id)) as customer_id,
        signup_date::date as signup_date,
        trim(lower(customer_segment)) as customer_segment,
        trim(lower("status")) as current_status,
        trim(lower(referral_source)) as referral_source,
        COALESCE(CAST(birth_year AS INT), 0) as birth_year,
        trim(lower(gender)) as gender,
        trim(lower(preferred_device)) as preferred_device
    from source
)

select * from sg_mst_customers
  );
