
  
    
    

    create  table
      "ae_exam_db"."main"."report_delivery_zone_heatmap__dbt_tmp"
  
    as (
      with delivery_zone_heatmap as (
    select * from "ae_exam_db"."main"."model_mrt_delivery_zone_heatmap"
    )

select
    delivery_zone,
    city,
    total_delivery_requests,
    completion_rate_pct,
    avg_delivery_time_min,
    late_delivery_rate_pct,
    no_driver_cancel_rate_pct,
    driver_to_request_ratio
from delivery_zone_heatmap
    );
  
  