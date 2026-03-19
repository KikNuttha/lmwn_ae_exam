with campaign as (
        select * from "ae_exam_db"."main"."model_sg_mst_campaign"
    ),

    orders as (
        select * from "ae_exam_db"."main"."model_sg_trn_order"
    ),

    customer as (
        select * from "ae_exam_db"."main"."model_sg_mst_customers"
    ),

    interactions as (
        select * from "ae_exam_db"."main"."model_sg_log_camp_interac"
    ),

    retargeting_campaigns as (
        select * 
        from campaign
        where campaign_type = 'retargeting'
    ),

    customer_previous_orders as (
        select 
            customer_id,
            max(order_datetime) as last_order_before_interaction
        from orders
        group by 1
    ),

    retargeting_interactions as (
        select
            inter.interaction_id,
            inter.customer_id,
            inter.campaign_id,
            inter.interaction_dt,
            inter.event_type,
            inter.revenue,
            inter.is_new_customer,
            cust.customer_segment,
            -- calculate the time gap between a customer's previous purchase and their current re-engagement with a marketing campaign
            date_diff('day', inter.interaction_dt,prev.last_order_before_interaction) as days_since_last_order
        from interactions inter
        left join customer cust on inter.customer_id = cust.customer_id
        left join customer_previous_orders prev on inter.customer_id = prev.customer_id
        where inter.is_new_customer = FALSE
    )

select * from retargeting_interactions