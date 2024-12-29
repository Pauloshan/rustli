SELECT * FROM sales;

----- Updating order date column from String to date
SET SQL_SAFE_UPDATES = 0;
-- Add a new DATE column
ALTER TABLE sales ADD COLUMN new_order_date DATE;
-- Update the new_order_date column
UPDATE sales
SET new_order_date = STR_TO_DATE(Order_date, '%m/%d/%Y');
-- Drop Order_date column
ALTER TABLE sales DROP COLUMN Order_date;
-- Rename order_date column
ALTER TABLE sales CHANGE COLUMN new_order_date order_date DATE;
SET SQL_SAFE_UPDATES = 1;

----- Updating ship date column from String to date
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE sales ADD COLUMN new_order_date DATE;
UPDATE sales
SET new_order_date = STR_TO_DATE(Ship_Date, '%m/%d/%Y');
ALTER TABLE sales DROP COLUMN Ship_Date;
ALTER TABLE sales CHANGE COLUMN new_order_date ship_date DATE;
SET SQL_SAFE_UPDATES = 1;

-- Primary Analysis-------------------------------------------------------------------------------------------------------------------
-- Total Revenue
SELECT CONCAT(CAST(ROUND(SUM(amount)/1000000, 2) AS CHAR(5)), "M") 
AS revenue_in_millions  FROM sales;

-- Total Profit MArgin
SELECT (SUM(Profit) / SUM(amount))*100 AS profit_margin
FROM sales;

-- Best selling product
SELECT Product_Name,SUM(amount) as revenue  
FROM sales GROUP BY Product_Name 
ORDER BY revenue DESC
LIMIT 1;

-- Top category
SELECT Category,SUM(amount) as revenue  
FROM sales GROUP BY Category 
ORDER BY revenue DESC
LIMIT 1;

-- Top ship mode
SELECT Ship_Mode,SUM(amount) as revenue  
FROM sales GROUP BY Ship_Mode 
ORDER BY revenue DESC
LIMIT 1;

-- Top customer 
SELECT Customer_Name,SUM(amount) as revenue  
FROM sales GROUP BY Customer_Name 
ORDER BY revenue DESC
LIMIT 1;


-- Secondary Analysis-------------------------------------------------------------------------------------------------------------------
-- Total Sales by region
SELECT Region, 
CONCAT(CAST(ROUND(SUM(amount)/1000000, 2) AS CHAR(5)), "M") AS revenue_in_millions  
FROM sales GROUP BY Region; 

-- Top 5 Products by Profit
SELECT Product_Name, 
ROUND(SUM(Profit),2) as Total_Profit
FROM sales GROUP BY Product_Name
ORDER BY Total_Profit DESC LIMIT 5; 

-- Monthly Sales Trend
SELECT MONTH(order_date) AS month, 
CONCAT(CAST(ROUND(SUM(amount)/1000000, 2) AS CHAR(5)), "M") AS revenue_in_millions  
FROM sales
GROUP BY month ORDER BY month ASC;

-- Customer Segmentation Analysis
SELECT Segment, 
CONCAT(CAST(ROUND(SUM(amount)/1000000, 2) AS CHAR(5)), "M") AS revenue_in_millions  
FROM sales
GROUP BY Segment ORDER BY revenue_in_millions DESC;

-- Impact of Discount on Profit
SELECT Discount, 
CONCAT(CAST(ROUND(SUM(amount)/1000000, 2) AS CHAR(5)), "M") AS revenue_in_millions ,
CONCAT(CAST(ROUND(SUM(Profit)/1000,2) AS CHAR(5)), "K") AS profit_in_thousands
FROM sales
GROUP BY Discount
ORDER BY Discount;

-- Sales and Profit by Category
SELECT Category, 
CONCAT(CAST(ROUND(SUM(amount)/1000000, 2) AS CHAR(5)), "M") AS revenue_in_millions, 
CONCAT(CAST(ROUND(SUM(Profit)/1000,2) AS CHAR(5)), "K") AS profit_in_thousands FROM sales
GROUP BY Category ORDER BY revenue_in_millions DESC;

-- Top 10 Cities by Sales
SELECT City, SUM(amount) AS revenue
FROM sales
GROUP BY City ORDER BY revenue DESC 
LIMIT 10;

-- Product by Order Quantity
SELECT Product_Name, SUM(Quantity) as Total_Quantity
FROM sales GROUP BY Product_Name
ORDER BY Total_Quantity DESC; 

-- Profit Margin by Product
SELECT Product_Name, ROUND((SUM(Profit)/SUM(amount))*100,2) as Profit_Margin_Pct
FROM sales GROUP BY Product_Name
ORDER BY Profit_Margin_Pct DESC LIMIT 10; 

-- Sales by Shipping Mode
SELECT Ship_Mode, 
CONCAT(CAST(ROUND(SUM(amount)/1000000, 2) AS CHAR(5)), "M") AS revenue_in_millions
FROM sales
GROUP BY Ship_Mode ORDER BY revenue_in_millions DESC;

-- Revenue by customer
SELECT Customer_Name, SUM(amount) as revenue FROM sales GROUP BY Customer_Name
ORDER BY revenue DESC LIMIT 10;

-- Purchase frequency
SELECT Customer_Name, COUNT(Order_ID) as purchase 
FROM sales WHERE YEAR(order_date)="2017" 
GROUP BY Customer_Name
ORDER BY purchase DESC LIMIT 10;

-- Average Purchase Value
SELECT Customer_Name, ROUND(SUM(amount)/COUNT(Order_ID),2) as avg_purchase_value FROM sales 
GROUP BY Customer_Name
ORDER BY avg_purchase_value DESC LIMIT 10;

-- Customer Lifetime Value
SELECT Customer_Name, 
SUM(Quantity)*(SUM(amount)/COUNT(Order_ID)) as clv 
FROM sales 
GROUP BY Customer_Name
ORDER BY clv DESC LIMIT 10;

-- Top 10 customer in each segment by amount
WITH cte1 AS (SELECT Segment,Customer_Name,SUM(amount) AS total_amount, 
RANK() OVER(PARTITION BY Segment ORDER BY SUM(amount) DESC) as customer_rank 
FROM sales GROUP BY Customer_Name,Segment)
SELECT Segment,Customer_Name,total_amount,customer_rank
FROM cte1 WHERE customer_rank<=10;

-- Top 10 customer in each segment by order frequency
WITH cte2 AS(SELECT  Customer_Name, MONTH(order_date) AS month, COUNT(Customer_ID) AS FREQUENCY,
RANK() OVER(PARTITION BY MONTH(order_date) ORDER BY COUNT(Customer_ID) DESC) as customer_rank
FROM sales
GROUP BY Customer_Name,month
ORDER BY month ASC,FREQUENCY DESC)
SELECT * FROM cte2 WHERE customer_rank<=10;
