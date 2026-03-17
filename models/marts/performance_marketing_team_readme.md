# 📈 Campaign Performance Report: Data Documentation

This folder contains the models responsible for transforming raw campaign data into actionable insights for the **Performance Marketing Team**.

## 1. Intermediate Layer: `int_marketing_attribution`
**Description:** 
This model acts as the central enrichment layer for all marketing activities. It links campaign metadata with raw interaction logs to attribute user actions to specific campaigns.

- **Primary Logic:** Joins `sg_mst_campaign` with `sg_log_camp_interac`.
- **Filtering:** Only includes interactions where the `interaction_dt` falls between the campaign's `start_dt` and `end_dt`.
- **Key Columns:** 
    - `campaign_id`, `campaign_name`, `channel`.
    - `event_type` (impression, click, conversion).
    - `is_new_customer` (used for acquisition analysis).
    - `ad_cost` and `revenue`.


## 2. Mart Layer: `mrt_campaign_effectiveness` 
**Description:** 
A reporting-ready table aggregated by Campaign and Channel. It provides the final metrics used in the **Campaign Effectiveness Report** to evaluate engagement and efficiency.

- **Objective:** To evaluate advertising performance in terms of engagement, cost efficiency, and ROI.

### 📊 Metric Definitions & Requirement Mapping

| Metric Name | Logic / Description | Required Insight Met |
| :--- | :--- | :--- |
| **total_impressions** | `SUM` of events where `event_type = 'impression'` | **Volume of exposure** for each campaign over time. |
| **total_clicks** | `SUM` of events where `event_type = 'click'` | **Level of user interaction** (engagement). |
| **total_conversions** | `SUM` of events where `event_type = 'conversion'` | **Number of users who completed a purchase**. |
| **total_spend** | `SUM(ad_cost)` | **Cost associated** with running the campaign. |
| **total_revenue** | `SUM(revenue)` | **Total revenue** attributed to each campaign. |
| **total_benefit** | `total_revenue - total_spend` | General **Marketing efficiency** and profitability. |
| **roas** | `ROUND(total_revenue / total_spend, 2)` | **Return on advertising spend** metric. |
| **cac** | `total_spend / count(distinct new_customers)` | **Cost per acquired customer** (using `is_new_customer = TRUE`). |
