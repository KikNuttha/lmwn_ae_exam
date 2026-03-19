
  
  create view "ae_exam_db"."main"."model_sg_log_driver_incentive__dbt_tmp" as (
    with source as (
    SELECT * 
    FROM "ae_exam_db"."main"."order_log_incentive_sessions_driver_incentive_logs"
),

sg_log_driver_incentive as (
select
    COALESCE(CAST(log_id AS INT), 0) as log_id,
    trim(lower(driver_id)) as driver_id,
    trim(lower(incentive_program)) as incentive_program,
    COALESCE(CAST(bonus_amount AS DECIMAL(18, 2)), 0) as bonus_amount,
    applied_date::date as applied_date,
    COALESCE(CAST(delivery_target AS INT), 0) as delivery_target,
    COALESCE(CAST(actual_deliveries AS INT), 0) as actual_deliveries,
    bonus_qualified::boolean as bonus_qualified,
    trim(lower(region)) as region,
from source
)

select *
from sg_log_driver_incentive
  );
