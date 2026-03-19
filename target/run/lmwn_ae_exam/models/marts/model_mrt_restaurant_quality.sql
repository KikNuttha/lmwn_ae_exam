
  
    
    

    create  table
      "ae_exam_db"."main"."model_mrt_restaurant_quality__dbt_tmp"
  
    as (
      with restaurant_complaints as (
    select * from "ae_exam_db"."main"."model_int_restaurant_complaint"
    ),

    orders as (
    select * from "ae_exam_db"."main"."model_sg_trn_order"
    ),

    restaurant_order_stats as (
        select 
            restaurant_id,
            count(order_id) as total_orders
        from orders
        group by 1
    ),

    issue_summary as (
        select
            restaurant_id,
            issue_sub_type,
            count(ticket_id) as issue_count,
            row_number() over (
                partition by restaurant_id 
                order by count(ticket_id) desc
            ) as issue_rank
        from restaurant_complaints
        group by 1, 2
    ),

    post_complaint_behavior as (
        select
            c.restaurant_id,
            c.customer_id,
            c.ticket_id,
            max(case 
                when o.order_datetime > c.resolved_datetime 
                    and o.order_datetime <= date_add(cast(c.resolved_datetime as timestamp), interval 30 day)
                    and o.order_status = 'completed'
                then 1 else 0 
            end) as has_reordered_30d
        from restaurant_complaints c
        left join orders o 
            on c.customer_id = o.customer_id
        group by 1, 2, 3
    )

select
    c.restaurant_id,
    any_value(c.restaurant_name) as restaurant_name,
    any_value(c.restaurant_category) as category,
    count(distinct c.ticket_id) as volume_of_complaints,
    s.issue_sub_type,
    s.issue_rank,
    s.issue_count,
    round(avg(c.resolution_time_min), 2) as avg_resolution_time_min,
    sum(c.compensation_amount) as total_compensation_issued,
    round(count(distinct c.ticket_id) * 100.0 / nullif(any_value(ros.total_orders), 0), 2) as complaint_to_order_ratio_pct,
    round(count(distinct case when pcb.has_reordered_30d = 1 then c.customer_id end) * 100.0 / nullif(count(distinct c.customer_id), 0), 2) as customer_recovery_rate_30d_pct
from restaurant_complaints c
left join restaurant_order_stats ros on c.restaurant_id = ros.restaurant_id
left join issue_summary s on c.restaurant_id = s.restaurant_id
left join post_complaint_behavior pcb on c.ticket_id = pcb.ticket_id
group by c.restaurant_id, s.issue_sub_type, s.issue_count, s.issue_rank
order by volume_of_complaints desc, c.restaurant_id, s.issue_rank ASC
    );
  
  