sql
	
| -- CREATING DATABASE .|
	|-|
|CREATE DATABASE R_F_M_Analytics;|


```sql
-- USING DATABSE.
USE R_F_M_Analytics;
```

```sql
-- CHECKING TABLES WITHIN THE DATABASE.
SHOW TABLES;
```

```sql
-- APPENDING ALL MONTHLY SALES TABLE DATA TO CREATE SINGLE YEAR SALES TABLE(sales_2025).
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

```sql
-- NO OF TRANSACTIONS.
SELECT COUNT(*) AS Total_Transaction
FROM sales_2025;
```

```sql
-- NO OF CUSTOMERS.
SELECT COUNT(DISTINCT CustomerID)
AS Total_Customers
FROM sales_2025;
```

```sql
-- AVG TRANSACTION PER CUSTOMER.
SELECT COUNT(*) / COUNT(DISTINCT customerid)
FROM sales_2025;
```

```sql
-- AVERAGE REVENUE PER CUSTOMER.
SELECT ROUND(SUM(ordervalue) / COUNT(DISTINCT Customerid),2)
FROM sales_2025;
```

```sql
-- AVERAGE TRANSACTION VALUE.
SELECT ROUND(SUM(ordervalue) / COUNT(Customerid),2)
FROM sales_2025;
```

```sql
-- FINDING MAJOR COMPONENTS(RECENCY,FREQUENCY AND MONETARY) BY CREATING VIEW(r_f_m metrics).
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

```sql
-- ALLOTING SCORES ACCORDING TO THE PERFORMANCE [(LOWEST recency = 10,HIGHEST recency = 1),(HIGHEST frequency OR monetary = 10, LOWEST frequency OR monetary = 1)]
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

```sql
-- FINDING TOTAL R_F_M SCORES BY (r_score + f_score + m_score).
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

```sql
-- CREATING FINAL TABLE 'customer_segment' BY ,SEGMENTING CUSTOMERS BASE ON THEIR 'total_rfm_score'.

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
-- SEGMENTATION
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
