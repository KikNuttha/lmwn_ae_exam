# 🛵 Food Delivery Analytics Engineering Project

## 🎯 Project Overview
This project transforms raw delivery, marketing, and support data into an actionable Star Schema using **dbt** and **DuckDB**. The goal is to provide deep insights into Campaign Effectiveness, Customer Acquisition, and Retargeting performance.  
Raw_data store in data folder: `data/ae_exam_db.duckdb`

## 🏗 Data Architecture
The project follows a modular 4-layer architecture:
### **Staging (`model_sg_`)**:
Raw data ingestion, type casting, and initial cleaning. by `dbt list` for inspec table name, which will be staging table.  
In this phase, have create source.yml for tell dbt that raw data inside `ae_exam_db.duckdb` and `sg_schema.yml` for validated output table  
-   campaign_interactions --> `model_sg_log_camp_interac`  
-   customers_master --> `model_sg_mst_customers`  
-   campaign_master --> `model_sg_mst_campaign`  
-   drivers_master --> `model_sg_mst_drivers`  
-   order_log_incentive_sessions_order_status_logs --> `model_sg_log_order`  
-   order_log_incentive_sessions_driver_incentive_logs --> `model_sg_log_driver_incentive`  
-   order_log_incentive_sessions_customer_app_sessions --> `model_sg_log_cus_app_sessions`  
-   order_transactions --> `model_sg_trn_order`  
-   restaurants_master --> `model_sg_mst_restaurants`  
-   support_ticket_status_logs --> `model_sg_log_support_tickets`  
-   support_tickets --> `model_sg_trn_support_tickets`  

### **Intermediate (`model_int_`)**:   
Complex joins follow business logic  
| Table name | Detail |
| :--- | :--- |
| `model_int_complaint` | This model links campaign metadata with raw interaction logs to attribute user actions to specific campaigns |
| `model_int_customer_acquisition` | This model identifies new customers and prepares behavioral metrics by linking marketing conversions with order history |
| `model_int_delivery_zone` | This model consolidates the entire lifecycle of an order, from creation to completion, into a single granular table |
| `model_int_driver_complaint` | This model filters for driver-specific issues and joins them with driver metadata to create a comprehensive incident view |
| `model_int_driver_incentive` | This model enriches raw incentive logs with driver metadata and actual delivery performance to evaluate behavior during bonus periods |
| `model_int_driver_order` | This model consolidates the entire lifecycle of an order, from creation to completion, into a single granular table |
| `model_int_customer_acquisition` | This model identifies new customers and prepares behavioral metrics by linking marketing conversions with order history |
| `model_int_restaurant_complaint` | This model filters and prepares base ticket data specifically for issues associated with partner restaurants |
| `model_int_retargeting` | This model identifies returning users and calculates the duration of their inactivity prior to re-engagement |

---

### **Marts (`model_mrt_`)**:  
Data is aggregated and business logic is applied to provide final metrics for reporting and BI tools across all business teams.
| Table name | Detail |
| :--- | :--- |
| `model_mrt_campaign_effective` | Evaluates advertising performance by channel and campaign, calculating key ROI metrics like **ROAS**, **CAC**, and **Total Revenue**. |
| `model_mrt_customer_acquisition` | Tracks the success of acquiring new customers and their post-acquisition behavior, including **Average Order Value (AOV)** and **Retention Days**. |
| `model_mrt_delivery_zone_heatmap` | Analyzes spatial efficiency and supply-demand tension by zone and city, focusing on **delivery requests** and **driver-to-request ratios**. |
| `model_mrt_driver_complaint` | Assesses driver reliability by tracking complaint frequency, issue types, and **customer satisfaction scores** following resolution. |
| `model_mrt_driver_incentive` | Measures the impact of incentive programs on driver performance vs. cost, including **bonus payouts** and **delivery volume** changes. |
| `model_mrt_driver_performance` | Evaluates driver effectiveness using operational metrics such as **completion rates**, **acceptance speed**, and **late delivery frequency**. |
| `model_mrt_restaurant_quality` | Monitors food and service standards of partner restaurants, including **complaint-to-order ratios** and **customer recovery rates**. |
| `model_mrt_retargeting` | Evaluates strategies to re-engage inactive customers by measuring **return proportions** and the **time gap** between orders. |
| `model_mrt_total_complaint` | Summarizes platform-wide complaint trends, **resolution efficiency**, and the financial impact of total **compensation issued**. |

### **Report (`report_`)**: Provides BI-ready views designed to answer specific business questions
| Report name | Objective | Required Insight | report name(report_xx) |
| :--- | :--- | :--- | :--- |
| **Campaign Effectiveness Report** | Evaluate the performance of advertising campaigns across digital platforms and understand campaign performance in terms of user engagement, cost efficiency, and resulting transactions. | • Volume of exposure (ad impressions) over time<br>• Level of user interaction (clicks)<br>• Number of users who completed a purchase<br>• Costs associated with running the campaign<br>• Total revenue attributed to each campaign<br>• Marketing efficiency metrics (CAC and ROAS). | `report_campaign_effectiveness` |
| **Complaint Summary Dashboard** | Get a high-level overview of all customer complaints across the platform to prioritize problem areas and improve response processes. | • Total number of issues reported<br>• Most common categories of complaints<br>• Average time taken to resolve an issue<br>• Volume of unresolved or escalated tickets<br>• Compensation or refunds issued<br>• Trends over time in volume or resolution time. | `report_complaint_summary` |
| **Customer Acquisition Report** | Understand how successful each campaign is at acquiring new customers and how those customers behave post-acquisition. | • Number of first-time customers attributed to a campaign<br>• Spending behavior (average purchase value, repeat orders)<br>• Customer active duration post-first purchase<br>• Average time between first interaction and purchase<br>• Total marketing cost spent on acquisition<br>• Segmentation by channel/platform. | `report_customer_acquisition` |
| **Delivery Zone Heatmap Report** | Monitor delivery efficiency and driver supply-demand issues by geographical zones to assist with placement, promotions, or resource planning. | • Total volume of deliveries requested per zone<br>• Completion rates within each area<br>• Average delivery time in different areas or cities<br>• Areas with high job rejection or cancellation due to unavailable drivers<br>• Ratio of available drivers to delivery requests (Supply vs. Demand tension)<br>• Delivery speed vs. customer expectations per zone. | `report_delivery_zone_heatmap` |
| **Driver-Related Complaints Report** | Identify behavioral or performance issues related to drivers and determine if certain drivers require further training or intervention. | • Frequency of complaints tied to specific drivers<br>• Type of issues (lateness, unprofessional conduct)<br>• Time required to resolve driver-related cases<br>• Customer satisfaction scores following resolution<br>• Ratio of complaints to total orders handled<br>• Driver ratings before and after complaints. | `report_driver_complaints` |
| **Driver Incentive Impact Report** | Measure whether incentive programs for drivers (e.g., bonuses) lead to improved performance or just higher costs. | • Driver participation in each program<br>• Volume of completed deliveries during incentive periods<br>• Change in delivery times and acceptance rates while incentives are active<br>• Driver satisfaction and feedback (if collected)<br>• Bonus amount paid out to each driver<br>• Revenue generated or operational efficiency gains. | `report_driver_incentive_impact` |
| **Driver Performance Report** | Assess the effectiveness and reliability of delivery drivers to support workforce evaluation and operational optimization. | • Number of tasks assigned vs. completed<br>• Responsiveness in accepting jobs<br>• Average time taken to complete a delivery<br>• Frequency of late or delayed deliveries<br>• Feedback provided by customers for each driver<br>• Comparison across vehicle types or geographic zones. | `report_driver_performance` |
| **Restaurant Quality Complaint Report** | Monitor the quality of food and service provided by partner restaurants and ensure they align with platform standards. | • Volume of complaints linked to individual restaurants<br>• Nature of issues (food quality, wrong items, missing items)<br>• Time to resolve restaurant-related issues<br>• Total customer compensation linked to each restaurant<br>• Ratio of complaints to total orders from the restaurant<br>• Impact on repeat purchase behavior after issues. | `report_restaurant_quality` |
| **Retargeting Performance Report** | Evaluate retargeting campaigns that aim to bring back previous or inactive customers and see if the strategy effectively re-engages past users. | • Number of previously active customers targeted<br>• Proportion who returned and placed another order<br>• Total spend generated by retargeted customers<br>• Time gap between original and returning orders<br>• Retention behavior after retargeting<br>• Comparison across campaign types or targeting segments. | `report_retargeting_performance` |


## 📊 Entity Relationship Diagram (ERD)
You can view the full data model here: [[Link to my dbdiagram.io](https://dbdiagram.io/d/69b82958fb2db18e3b917d44)]

## 🛠 Setup Instructions
1. **Environment:** Create a Python 3.10+ environment (venv or conda).
2. **Installation:** Run `pip install -r requirements.txt`.
3. **Database:** Ensure `ae_exam_db.duckdb` is in the `/data` folder.
4. **Execution:** Run `dbt build` to run and test all models.
