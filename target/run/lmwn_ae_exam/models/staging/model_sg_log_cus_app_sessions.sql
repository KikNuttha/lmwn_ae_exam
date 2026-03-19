
  
  create view "ae_exam_db"."main"."model_sg_log_cus_app_sessions__dbt_tmp" as (
    with source as (
    SELECT * 
    FROM "ae_exam_db"."main"."order_log_incentive_sessions_customer_app_sessions"
),

sg_log_cus_app_sessions as (
select
    trim(lower(session_id)) as session_id,
    trim(lower(customer_id)) as customer_id,
    session_start::timestamp as session_start,
    session_end::timestamp as session_end,
    trim(lower(device_type)) as device_type,
    COALESCE(CAST(os_version AS DECIMAL(18, 2)), 0) as os_version,
    trim(lower(app_version)) as app_version,
    trim(lower("location")) as city
from source
)

select *
from sg_log_cus_app_sessions
  );
