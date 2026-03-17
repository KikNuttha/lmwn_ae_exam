# Performance Marketing Team

This folder contains the models responsible for transforming raw campaign data into actionable insights for the **Performance Marketing Team**.

## Campaign Effectiveness Report
### 1. Intermediate Layer: `model_int_marketing_attribution`
**Description:** 
This model acts as the central enrichment layer for all marketing activities. It links campaign metadata with raw interaction logs to attribute user actions to specific campaigns.
- **Primary Logic:** Joins `model_sg_mst_campaign` with `model_sg_log_camp_interac`.
- **Filtering:** Only includes interactions where the `interaction_dt` falls between the campaign's `start_dt` and `end_dt`.

### 2. Mart Layer: `model_mrt_campaign_effectiveness` 

### 📊 Metric Definitions & Requirement Mapping

| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_impressions** | `SUM` of events where `event_type = 'impression'` | **Volume of exposure** for each campaign over time. |
| **total_clicks** | `SUM` of events where `event_type = 'click'` | **Level of user interaction** (engagement). |
| **total_conversions** | `SUM` of events where `event_type = 'conversion'` | **Number of users who completed a purchase**. |
| **total_spend** | `SUM(ad_cost)` | **Cost associated** with running the campaign. |
| **total_revenue** | `SUM(revenue)` | **Total revenue** attributed to each campaign. |
| **total_benefit** | `total_revenue - total_spend` | General **Marketing efficiency** and profitability. |
| **acquired_new_customers** |  `event_type = 'conversion' and is_new_customer = TRUE ` | Number of first-time customers. |
| **roas** | `ROUND(total_revenue / total_spend, 2)` | **Return on advertising spend** metric. |
| **cac** | `total_spend / count(distinct new_customers)` | **Cost per acquired customer** (using `is_new_customer = TRUE`). |

---

## Customer Acquisition Report
### 1. Intermediate Layer: `model_int_customer_acquisition`
**Description:** 
Identifies new customers and prepares behavioral metrics by linking marketing conversions with order history.
- **Primary Logic:** Joins `model_sg_log_camp_interac` with `model_sg_trn_order`.
- **Filtering:** Only interaction logs specifically for rows where is_new_customer = TRUE and event_type = 'conversion'

### 2. Mart Layer: `model_mrt_customer_acquisition`
### 📊 Metric Definitions & Requirement Mapping
| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_new_customers** | `COUNT(DISTINCT customer_id)` | Number of first-time customers. |
| **avg_order_value** | `SUM(total_revenue) / SUM(total_orders)` | Spending behavior (average order value). |
| **repeat_order_rate_pct**| % of users with `total_orders > 1` | Number of repeat orders and behavior. |
| **avg_retention_days** | `AVG(retention_days)` | How long customers remain active. |
| **avg_minutes_to_convert**| `AVG(minutes_to_convert)` | Time between interaction and purchase. |
| **total_acquisition_spend**| `SUM(acquisition_cost)` | Total marketing cost to acquire customers. |

---

## Driver Performance Report
### 1. Intermediate Layer: `model_int_driver_order`
**Description:** 
This model serves as the granular enrichment layer for driver activities. It consolidates the lifecycle of an order—from creation to completion or cancellation—into a single table at the order grain.
- **Primary Logic:** 
    - Combines Order Transactions (`model_sg_trn_order`) with Order Status Logs ('model_sg_log_order`) to determine exact timestamps for each stage of delivery.
    - Integrates Customer Feedback from Support Tickets (`model_sg_trn_support_tickets`) to attribute CSAT scores to specific drivers and orders.

### 2. Mart Layer: `model_mrt_driver_performance`
### 📊 Metric Definitions & Requirement Mapping
| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_assigned_tasks** | COUNT(order_id) assigned to the driver. | Tasks assigned |
| **total_completed_tasks** | COUNT(order_id) assigned to the driver where order_status = 'completed'. | Tasks completed. |
| **completion_rate_pct** | % of assigned tasks with completed status. | Reliability and task completion success. |
| **avg_acceptance_time_min** | AVG(acceptance_time_min) | **Responsiveness** in accepting jobs. |
| **avg_delivery_duration** | AVG(delivery_duration_min) | **Average time taken** to complete a delivery. |
| **total_late_deliveries** | COUNT(is_late_delivery = 'TRUE') |  Complete a delivery. |
| **late_delivery_rate_pct** | % of orders where is_late_delivery = TRUE. | **Frequency of late** or delayed deliveries. |
| **avg_recent_csat** | AVG(csat_score) attributed to the driver. | **Feedback provided by customers**. |

---