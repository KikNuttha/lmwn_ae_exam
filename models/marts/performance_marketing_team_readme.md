# 1️⃣ Campaign Effectiveness Report
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

# 2️⃣ Customer Acquisition Report
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

# 3️⃣ Driver Performance Report
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

# 4️⃣ Delivery Zone Heatmap Report
### 1. Intermediate Layer: `model_int_delivery_zone_metrics`
**Description:** This model prepares order-level geographic metrics by joining transaction data with restaurant locations and status logs to identify operational bottlenecks.
*   **Primary Logic:** Joins `model_sg_trn_order` with `model_sg_mst_restaurants` (to attribute orders to a `city`) and `model_sg_log_order` (to determine the lifecycle of canceled orders).

### 2. Mart Layer: `model_mrt_delivery_zone_heatmap`
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

# 5️⃣ Complaint Summary Dashboard
### 1. Intermediate Layer: `model_int_complaint`
**Description:**  
This model serves as the granular enrichment layer for customer support requests. It calculates operational metrics at the individual ticket level, specifically focusing on resolution speed and categorization.

*   **Primary Logic:**
    *   **Resolution Time Calculation:** Uses the `date_diff` function to calculate the duration in minutes between `opened_datetime` and `resolved_datetime`.
    *   **Status Identification:** Identifies "unresolved" tickets where the `current_status` is not marked as 'resolved'.

### 2. Mart Layer: `model_mrt_complaint_summary`
#### 📊 Metric Definitions & Requirement Mapping
| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_tickets** | `COUNT(ticket_id)` | **Total number of issues** reported. |
| **total_unresolved** | `SUM(is_unresolved)` | **Volume of unresolved** or escalated tickets. |
| **avg_resolution_time_min** | `AVG(resolution_time_min)` | **Time taken on average** to resolve an issue. |
| **total_compensation_issued** | `SUM(compensation_amount)` | **Compensation or refunds** issued. |
| **avg_compensation_per_ticket** | (Resolved Tickets / Total Tickets) * 100 | Effectiveness of the response process. |

---  
# 6️⃣ Driver-Related Complaints Report
### 1. Intermediate Layer: `model_int_driver_complaint`
**Description:**  
This model enriches raw support ticket data by filtering for driver-specific issues and joining them with driver metadata to create a comprehensive view of each incident.

*   **Primary Logic:**
    *   Filters **`sg_trn_support_tickets`** to include only `issue_type` related to 'rider' or 'delivery'.
    *   Joins with **`sg_mst_drivers`** to retrieve the `driver_rating` (baseline rating before complaints) and vehicle metadata.
    *   **Post-Complaint Feedback:** Captures the **`csat_score`** from the support ticket as the primary "after" metric.
    *   **Resolution Speed:** Calculates the duration in minutes between `opened_datetime` and `resolved_datetime` using the **`date_diff`** function.

### 2. Mart Layer: `model_mrt_driver_complaint`
#### 📊 Metric Definitions & Requirement Mapping
| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **baseline_rating** | Value from `sg_mst_drivers.driver_rating` | **Driver ratings before complaints**. |
| **total_complaints** | `COUNT(ticket_id)` | **Frequency of complaints** tied to specific drivers. |
| **avg_resolution_time_min**| `AVG(resolution_time_min)` | **Time required to resolve** driver-related cases. |
| **issue_rank**| `ROW_NUMBER() partitioned by driver, ordered by frequency (DESC) and CSAT (ASC)` | Identification of behavioral issues for **prioritized training**|
| **sub_type_count**| The number of occurrences for a specific issue category for that driver. | Granular tracking of recurring performance issues|
| **avg_post_complaint_csat**| `AVG(csat_score)` | **Customer satisfaction scores** following resolution. |
| **complaint_to_order_ratio**| (Total Complaints / Total Orders) * 100 | **Ratio of complaints** to total orders handled. |

---

# 7️⃣ Restaurant Quality Complaint Report
### **1. Intermediate Layer: `model_int_restaurant_complaint`**
**Description:** This model filters and prepares base data specifically for complaints associated with restaurants.

*   **Primary Logic:** Filters data from **`sg_trn_support_tickets`** by selecting only `issue_type = 'food'`.

### **2. Mart Layer: `model_mrt_restaurant_quality`**
#### **📊 Metric Definitions & Requirement Mapping**
| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **volume_of_complaints** | `COUNT(DISTINCT ticket_id)` | **Volume of complaints** linked to individual restaurants. |
| **avg_resolution_time_min**| `AVG(resolution_time_min)` | **Time to resolve** restaurant-related issues. |
| **total_compensation_issued** | `SUM(compensation_amount)` | **Total customer compensation** linked to each restaurant. |
| **complaint_to_order_ratio_pct**| (Total Complaints / Total Orders) * 100 | **Ratio of complaints** to total orders from the restaurant. |
| **customer_recovery_rate_30d_pct** | % of customers reordering within 30 days post-resolution | **Impact on repeat purchase behavior** from customers after issues. |


# 8️⃣ Driver Incentive Impact Report
### 1. Intermediate Layer: `model_int_driver_incentive_performance`
**Description:**  
This model enriches raw incentive logs with driver metadata and actual delivery performance data to evaluate behavior during active bonus periods.

*   **Primary Logic:**  
    *   Aggregates daily performance from **`sg_trn_order`** to calculate the actual workload on the days incentives were applied [20, Conversation History].

### 2. Mart Layer: `model_mrt_driver_incentive_impact`
**Description:**  
#### 📊 Metric Definitions & Requirement Mapping

| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_drivers_participating** | `COUNT(DISTINCT driver_id)` | **Driver participation** in each incentive program. |
| **total_bonus_payout** | `SUM(bonus_amount)` where `bonus_qualified = TRUE` | **Bonus amount paid out** to the fleet. |
| **total_delivery_volume** | `SUM(orders_completed)` during active dates | **Volume of completed deliveries** during incentive periods. |
| **avg_delivery_time_min** | `AVG(avg_delivery_duration_min)` | **Operational efficiency gains** (changes in delivery speed). |
| **qualification_rate_pct** | (Qualified Bonuses / Total Logs) * 100 | Effectiveness of the program in helping drivers **meet targets**. |

---

# 9️⃣ Retargeting Performance Report
### **1. Intermediate Layer: `model_int_retargeting_attribution`**
**Description:** This model acts as the core enrichment layer for retargeting activities. It identifies returning users and calculates the duration of their inactivity prior to re-engagement.

*   **Primary Logic:** 
    *   Filters the campaign master (**`sg_mst_campaign`**) for `campaign_type = 'retargeting'`.
    *   Filters interaction logs (**`sg_log_camp_interac`**) for **`is_new_customer = FALSE`** to isolate existing users [8, Conversation History].

### **2. Mart Layer: `model_mrt_retargeting_performance`**
#### **📊 Metric Definitions & Requirement Mapping**
| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_targeted_customers** | `COUNT(DISTINCT customer_id)` | **Number of previously active customers targeted** in each campaign. |
| **returned_customers_count** | Count of distinct customers with a 'conversion' event | Number of users who successfully returned. |
| **return_proportion_pct** | (Returned Customers / Total Targeted) * 100 | **Proportion who returned** and placed another order. |
| **total_retargeted_revenue** | `SUM(revenue)` from conversion events | **Total spend generated** by retargeted customers. |
| **avg_reengagement_gap_days**| `AVG(days_since_last_order)` | **Time gap between original and returning orders.** |
| **avg_revenue_per_return** | Total Revenue / Returned Customers | Efficiency of spend per re-engaged user. |

---