with source as (
    SELECT * 
    FROM "ae_exam_db"."main"."order_transactions"
),

sg_trn_order as (
select
    trim(lower(order_id)) as order_id,
    trim(lower(customer_id)) as customer_id,
    trim(lower(restaurant_id)) as restaurant_id,
    trim(lower(driver_id)) as driver_id,
    order_datetime::timestamp as order_datetime,
    pickup_datetime::timestamp as pickup_datetime,
    delivery_datetime::timestamp as delivery_datetime,
    trim(lower(order_status)) as order_status,
    trim(lower(delivery_zone)) as delivery_zone,
    COALESCE(CAST(total_amount AS DECIMAL(18, 2)), 0) as total_amount,
    trim(lower(payment_method)) as payment_method,
    is_late_delivery::boolean as is_late_delivery,
    COALESCE(CAST(delivery_distance_km AS DECIMAL(18, 2)), 0) as delivery_distance_km
from source
)
 select *
 from sg_trn_order