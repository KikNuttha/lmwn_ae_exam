# 🛵 Food Delivery Analytics Engineering Project

## 🎯 Project Overview
This project transforms raw delivery, marketing, and support data into an actionable Star Schema using **dbt** and **DuckDB**. The goal is to provide deep insights into Campaign Effectiveness, Customer Acquisition, and Retargeting performance.

## 🏗 Data Architecture
The project follows a modular 3-layer architecture:
- **Staging (`stg_`)**: Raw data ingestion, type casting, and initial cleaning.
    -   customers_master --> sg_mst_customers
    -   drivers_master --> sg_mst_drivers
    -   restaurants_master --> sg_mst_restaurants
    -   campaign_master --> sg_mst_campaign
    -   order_transactions --> sg_trn_order
    -   support_tickets --> sg_trn_support_tickets
    -   support_ticket_status_logs --> sg_log_support_tickets
    -   campaign_interactions --> sg_log_camp_interac
    -   order_status_logs --> sg_log_order
    -   driver_incentive_logs --> sg_log_driver_incentive
    -   customer_app_sessions --> sg_log_cus_app_sessions
- **Intermediate (`int_`)**: Complex business logic, including **Marketing Attribution** (Last-Click) and**Customer Cohorting**.
- **Marts (`mt_`)**: Final reporting tables optimized for BI tools.
- **Marts (`rp_`)**

### 📊 Entity Relationship Diagram (ERD)
You can view the full data model here: [[Link to my dbdiagram.io](https://dbdiagram.io/d/69b82958fb2db18e3b917d44)]

## 🛠 Setup Instructions
1. **Environment:** Create a Python 3.10+ environment (venv or conda).
2. **Installation:** Run `pip install -r requirements.txt`.
3. **Database:** Ensure `ae_exam_db.duckdb` is in the `/data` folder.
4. **Execution:** Run `dbt build` to run and test all models.