![image alt](https://github.com/sunnyswork2005-jpg/THE-ONE-STOP----R_F_M-REPORT/blob/b07d3db6612fcbd0b19642deae76e5522115fcbb/Brand%20Logo%201.png)
# THE-ONE-STOP----R_F_M-REPORT


CLIENT DETAILS

## The One Stop — Phoenix Branch

### Customer Performance Report | 2025

---

> 

---

### About the Phoenix Branch

The One Stop is a leading US-based offline retail chain operating across **47 states** through **54 outlets** nationwide. The Phoenix branch was established in **2024**, and we are proud to present the performance highlights as we close out our **second year of operations** — a critical milestone in any retail establishment's growth journey.

---

### Year 2025 — Phoenix at a Glance

| Metric | Value |
| --- | --- |
| 💰 **Total Revenue Generated** | $66,640 |
| 🧾 **Total Transactions** | 1,656 |
| 👥 **Unique Customers Served** | 484 |
| 🔁 **Avg. Transactions per Customer** | 3.42 |
| 💵 **Avg. Revenue per Customer** | $137.69 |
| 🧾 **Avg. Transaction Value** | $40.24 |

---


In just its **second year of existence**, the Phoenix branch has demonstrated a healthy and growing customer base. With **484 unique customers** driving over **1,600 transactions**, the outlet is showing strong repeat visit behavior — averaging over **3 visits per customer**, which is an encouraging sign of early loyalty formation for a relatively new retail location.

A total revenue of **$66.64K** in year two positions Phoenix on a solid upward trajectory, and with the right customer retention strategies — informed by our RFM segmentation — there is a clear opportunity to **convert occasional visitors into loyal, high-value customers** in the years ahead.

---

### Repert View

![image alt](https://github.com/sunnyswork2005-jpg/THE-ONE-STOP----R_F_M-REPORT/blob/956892b069b366b488dabfd0bcc0520af8e552fb/The%20One%20Stop%20--%20rfm--dashboard.png)

--- 
### Report's Methodolodgy

 `Customer Data  recorded in store. holds information of 'customer's transaction' which they are informed before any executive note them in 'company's portal' .`  

The RFM report analyzes customer behavior based on three key factors: **Recency** (how recently a customer made a purchase), **Frequency** (how often they purchase), and **Monetary value** (how much they spend).

 These factors drive our analysis of customer behavior, helping us understand customer needs and deliver the best possible service through more personalized, effective strategies.
 
Structure of collected Data is as described in  ***Sample Data***

#### Sample Data.

|OrderID  | CustomerID|	OrderDate	| ProductType |	OrderValue |
|-|-|-|-|-|
|ORDER00511 |CUST0074	| 04-28-2025|	Notebook  |	33.73| 
|ORDER00571	|CUST0065	|04-03-2025	|Poster	| 65.6 |
|ORDER06002	|CUST0186	|04-13-2025	|Notebook	|11.13|
|ORDER02514	|CUST0348	|04-15-2025	|Brochure|	46.04|
|ORDER01260	|CUST0294	|04-05-2025	|T-Shirt|	35.25|
|ORDER05151 |	CUST0333|	04-09-2025|	Poster |	77.4|


- **THE ONE STOP’S - PHOENIX BRANCH’S RFM  ANALYSES  CONTAIN 6 STEPS**
    
    **1. Appending all monthly data tables into one data table ‘sales_2025’ .**
    
    ```sql
    CREATE TABLE
    sales_2025
    AS
    SELECT * FROM jan2025
    UNION ALL
    SELECT * FROM feb2025
    UNION ALL
    SELECT * FROM mar2025
    UNION ALL
    SELECT * FROM apr2025
    UNION ALL
    SELECT * FROM may2025
    UNION ALL
    SELECT * FROM jun2025
    UNION ALL
    SELECT * FROM jul2025
    UNION ALL
    SELECT * FROM aug2025
    UNION ALL
    SELECT * FROM sep2025
    UNION ALL
    SELECT * FROM oct2025
    UNION ALL
    SELECT * FROM nov2025
    UNION ALL
    SELECT * FROM dec2025;
    ```
    
    **2. Finding major components (Recency, Frequency, Monetary).**
    
    ```sql
    CREATE VIEW
    r_f_m_metrics
    AS
     SELECT
    customerid,
    MAX(STR_TO_DATE(orderdate ,'%m-%d-%Y')) AS last_order_date,
    DATEDIFF(
    '2026-01-01',
    MAX(STR_TO_DATE(orderdate ,'%m-%d-%Y'))
    )AS recency,
    COUNT(DISTINCT orderid) AS frequency,
    ROUND(SUM(ordervalue)) AS monetary
    FROM sales_2025
    GROUP BY customerid;
    ```
    
    **3. Allotting  scores  according to the performances. Where** 
    
    - in r_score - Lowest Recency  is Good  and Highest Recency is bad .
    - in f_score - Highest Frequency is Good  and Lowest Frequency is bad .
    - in m_score - Highest Monetary is Good  and Lowest Monetary is bad .
    
    ```sql
    CREATE VIEW
    r_f_m_score
    AS
    SELECT
    *,
    NTILE(10) OVER(ORDER BY recency DESC) AS r_score,
    NTILE(10) OVER(ORDER BY frequency ASC) AS f_score,
    NTILE(10) OVER(ORDER BY monetary ASC) AS m_score
    FROM r_f_m_metrics;
    ```
    
    **4. Calculating Total R-F-M score Per-customer by (r_score + f_score + m_score).**
    
    ```sql
    CREATE VIEW
    total_score
    AS
    SELECT
    customerid,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS total_rfm_score
    FROM r_f_m_score;
    ```
    
    **5. Creating final table of Customer Segment  by their Total R-F-M score. Where**
    
    ```sql
    CREATE TABLE customer_segment
    AS
    SELECT
    customerid,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    total_rfm_score,
    ```
    
    ```sql
    - SEGMENTATION
    CASE
    WHEN total_rfm_score >= 24 THEN 'Champions'
    WHEN total_rfm_score BETWEEN 20 AND 23 THEN 'Loyal Customers'
    WHEN total_rfm_score BETWEEN 15 AND 19 THEN 'Potential Loyalists'
    WHEN total_rfm_score BETWEEN 10 AND 14 THEN 'Need Attention'
    WHEN total_rfm_score BETWEEN 6 AND 9 THEN 'At Risk'
    ELSE 'Lost Customers'
    END AS customer_segment
    FROM total_score;
    ```
    
    6.Creating Visualization at  the basis of our final **Customer Segment  table.**  

    ![image alt](https://github.com/sunnyswork2005-jpg/THE-ONE-STOP----R_F_M-REPORT/blob/956892b069b366b488dabfd0bcc0520af8e552fb/The%20One%20Stop%20--%20rfm--dashboard.png)

---

# **Insight : 1**

Most customers fall into the **Potential Loyalists (22.52%)** and **Need Attention (21.49%)** segments. **Champions (19.21%)** and **Loyal Customers (17.77%)** make up the middle, while smaller shares are **At Risk (12.19%)** and **Lost Customers (6.82%)**.


![image alt](https://github.com/sunnyswork2005-jpg/THE-ONE-STOP----R_F_M-REPORT/blob/281035f77b4d246c2b10eccc4bea7582c1acaa16/Pictures/customer%20share.png)


**Growth opportunity** — Potential Loyalists (22.52%) and Need Attention (21.49%) together make up nearly 44% of customers. These are your most actionable segments — targeted retention efforts here could convert them into Champions or Loyal Customers.



**Loyal base is solid** — Champions + Loyal Customers combine for ~37%, a strong foundation of engaged customers. which indicates that 1/3 of our customer base is loyal to us.

**Risk signals** — At Risk (12.19%) + Lost Customers (6.82%) = ~19% of your base needs recovery or win-back campaigns before they're gone permanently.

---
# **Insight : 2**

![image alt]()
- Champions and Loyal Customers are ~37% of the customer base, but they generate $38.97K out of $66.64K (~58.5%) of total revenue. which indicates that 37% of **Top customers** generate more  revenue than other 63% of customers.
- Potential Loyalists and Need Attention customers make up ~44% of the customer base, yet they contribute only ~$23.25K out of $66.64K (~35%) in total revenue.
- At Risk and Lost Customers make up ~19% of the customer base, but they generate only ~$4.52K out of $66.64K (~6.8%) of total revenue.

---


