with driver_complaints as (
    select * from {{ ref('model_int_driver_complaint') }}
    ),

    orders as (
    select * from {{ ref('model_sg_trn_order') }}
    ),

    issue_frequency as (
        select 
            driver_id,
            issue_sub_type,
            ROW_NUMBER() OVER (
                PARTITION BY driver_id 
                ORDER BY count(ticket_id) DESC,avg(csat_score)  ASC
            ) AS issue_rank,
            count(*) as sub_type_count,
            round(avg(csat_score),2) as avg_csat_score
        from driver_complaints
        group by 1, 2
    ),

    driver_orders as (
        select 
            driver_id, 
            count(order_id) as total_orders_handled
        from orders
        group by 1
    )

select
    c.driver_id,
    c.vehicle_type,
    c.region,
    c.baseline_rating, -- Driver ratings before complaints

    --Complaint section--
    count(c.ticket_id) as total_complaints,
    round(avg(c.resolution_time_min), 2) as avg_resolution_time_min,
    s.issue_rank,
    s.issue_sub_type,
    s.sub_type_count,
    s.avg_csat_score as avg_post_complaint_csat,
    round(count(c.ticket_id) * 100.0 / nullif(o.total_orders_handled, 0), 2) as complaint_to_order_ratio_pct
from driver_complaints c
left join driver_orders o on c.driver_id = o.driver_id
left join issue_frequency s on c.driver_id = s.driver_id
group by 1, 2, 3, 4, o.total_orders_handled,s.issue_rank,s.issue_sub_type,s.sub_type_count,s.avg_csat_score
order by count(c.ticket_id) DESC, s.issue_rank asc