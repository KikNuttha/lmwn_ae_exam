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

## Delivery Zone Heatmap Report
### 1. Intermediate Layer: `model_int_delivery_zone_metrics`
**Description:** This model prepares order-level geographic metrics by joining transaction data with restaurant locations and status logs to identify operational bottlenecks.
*   **Primary Logic:** Joins `model_sg_trn_order` with `model_sg_mst_restaurants` (to attribute orders to a `city`) and `model_sg_log_order` (to determine the lifecycle of canceled orders).

### 2. Mart Layer: `model_mrt_delivery_zone_heatmap`
**Description:** A summarized table aggregated by **Zone** and **City**, designed for BI Heatmap visualizations to identify high-demand or low-efficiency areas.
*   **Grain:** `delivery_zone` + `city`.
*   **Objective:** To monitor spatial efficiency and driver availability ratios.

### 📊 Metric Definitions & Requirement Mapping
| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_delivery_requests** | `COUNT(order_id)` | **Total volume** of deliveries requested per zone. |
| **completion_rate_pct** | % of orders with `order_status = 'completed'` | **Completion rates** within each area. |
| **avg_delivery_time_min** | `AVG(total_delivery_time_min)` | **Average delivery time** in different areas. |
| **no_driver_cancel_rate_pct** | % of orders where `is_canceled_no_driver = 1` | **Areas with high job rejection** due to unavailable drivers. |
| **driver_to_request_ratio** | `COUNT(DISTINCT driver_id) / COUNT(order_id)` | **Ratio of drivers available** to delivery requests (Supply vs. Demand). |
| **late_delivery_rate_pct**| % of orders where `is_late_delivery = 'TRUE'` | **Delivery speed vs expectations** per zone. |

---

## Complaint Summary Dashboard
### 1. Intermediate Layer: `model_int_complaint`
**Description:**  
This model serves as the granular enrichment layer for customer support requests. It calculates operational metrics at the individual ticket level, specifically focusing on resolution speed and categorization.

*   **Primary Logic:**
    *   **Resolution Time Calculation:** Uses the `date_diff` function to calculate the duration in minutes between `opened_datetime` and `resolved_datetime`.
    *   **Status Identification:** Identifies "unresolved" tickets where the `current_status` is not marked as 'resolved'.

### 2. Mart Layer: `model_mrt_complaint_summary`
**Description:**  
A reporting-ready table aggregated by **Date** and **Issue Category**. This table is optimized for BI tools to visualize complaint trends and financial remediation costs.

*   **Grain:** `opened_date` + `issue_type` + `issue_sub_type`.
*   **Objective:** To summarize support performance and identify recurring service quality issues.

#### 📊 Metric Definitions & Requirement Mapping

| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_tickets** | `COUNT(ticket_id)` | **Total number of issues** reported. |
| **total_unresolved** | `SUM(is_unresolved)` | **Volume of unresolved** or escalated tickets. |
| **avg_resolution_time_min** | `AVG(resolution_time_min)` | **Time taken on average** to resolve an issue. |
| **total_compensation_issued** | `SUM(compensation_amount)` | **Compensation or refunds** issued. |
| **avg_compensation_per_ticket** | (Resolved Tickets / Total Tickets) * 100 | Effectiveness of the response process. |

---
