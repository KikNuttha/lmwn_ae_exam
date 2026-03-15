with source as (
    select * 
    from {{ source('raw_data', 'customers_master')}}
),

sg_mst_customers as (
    select
        trim(lower(customer_id)) as customer_id,
        signup_date::date as signup_date,
        trim(lower(customer_segment)) as customer_segment,
        trim(lower("status")) as current_status,
        trim(lower(referral_source)) as referral_source,
        birth_year::integer as birth_year,
        trim(lower(gender)) as gender,
        trim(lower(preferred_device)) as preferred_device
    from source
)

select * from sg_mst_customers
