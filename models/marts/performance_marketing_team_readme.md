# Performance Marketing Team

This folder contains the models responsible for transforming raw campaign data into actionable insights for the **Performance Marketing Team**.

## Campaign Effectiveness Report
### 1. Intermediate Layer: `int_marketing_attribution`
**Description:** 
This model acts as the central enrichment layer for all marketing activities. It links campaign metadata with raw interaction logs to attribute user actions to specific campaigns.

- **Primary Logic:** Joins `sg_mst_campaign` with `sg_log_camp_interac`.
- **Filtering:** Only includes interactions where the `interaction_dt` falls between the campaign's `start_dt` and `end_dt`.

### 2. Mart Layer: `mrt_campaign_effectiveness` 

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
### 1. Intermediate Layer: `int_customer_acquisition`
**Description:** 
Identifies new customers and prepares behavioral metrics by linking marketing conversions with order history.

- **Primary Logic:** Joins `sg_log_camp_interac` with `sg_trn_order`.
- **Filtering:** Only interaction logs specifically for rows where is_new_customer = TRUE and event_type = 'conversion'

### 2. Mart Layer: `mrt_customer_acquisition`
### 📊 Metric Definitions & Requirement Mapping
| Metric Name | Logic / Description | Required Insight Met [3] |
| :--- | :--- | :--- |
| **total_new_customers** | `COUNT(DISTINCT customer_id)` | Number of first-time customers. |
| **avg_order_value** | `SUM(total_revenue) / SUM(total_orders)` | Spending behavior (average order value). |
| **repeat_order_rate_pct**| % of users with `total_orders > 1` | Number of repeat orders and behavior. |
| **avg_retention_days** | `AVG(retention_days)` | How long customers remain active. |
| **avg_minutes_to_convert**| `AVG(minutes_to_convert)` | Time between interaction and purchase. |
| **total_acquisition_spend**| `SUM(acquisition_cost)` | Total marketing cost to acquire customers. |

---

