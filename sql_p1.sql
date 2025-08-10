-- SQL Retail Sales Analysis
CREATE DATABASE sql_project01;
USE sql_project01;



-- Create Table
CREATE TABLE retail_sales 
   (
       transactions_id INT PRIMARY KEY ,
       sale_date DATE,
       sale_time TIME,
       customer_id INT,
       gender VARCHAR(15),
       age INT,
       category VARCHAR(15),
       quantiy INT,
       price_per_unit FLOAT,
       cogs  FLOAT,
       total_sale FLOAT
	);
SELECT * FROM retail_sales;    
-- Checking for null values
SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL OR
     sale_date IS NULL OR
     sale_time IS NULL OR
     customer_id IS NULL OR
      gender IS NULL OR
      category IS NULL OR
      quantiy IS NULL OR
      price_per_unit IS NULL OR
      cogs IS NULL OR
       total_sale IS NULL;
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;    

-- How many customers we have?
SELECT  COUNT( DISTINCT customer_id) AS total_sale FROM retail_sales;  

-- Data Analysis
-- Retrieve all columns for sales on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Retrieve all columns where the category is clothing and the quantity sold is more than or equal to 4 in the month of nov-2022 
SELECT * FROM retail_sales
WHERE category = 'clothing' AND  
                 MONTH(sale_date) = '11' AND
                 YEAR(sale_date) = '2022' AND
				  quantiy >= 4;
-- Calculate the total sales for each category
SELECT category, SUM(total_sale) AS net_sale FROM retail_sales
GROUP BY category;

-- find the avg age of customer who purchased items from the beauty category
SELECT ROUND(AVG(age)) AS avg_age FROM retail_sales
WHERE category = 'Beauty';

-- find all transactions where the total sale is greater than 1000
SELECT transactions_id FROM retail_sales
WHERE total_sale > 1000;

-- find the total number of transactions made by each gender in each category
SELECT category, gender ,COUNT(*) AS total_transaction FROM retail_sales
GROUP BY category, gender;

-- calculate the avg sale of each month. find out best selling month in each year
SELECT month, year, avg_sale FROM
           (SELECT MONTH(sale_date) AS month, YEAR(sale_date) AS year, ROUND(AVG(total_sale), 2) AS avg_sale ,
            RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) AS rank_no
			FROM retail_sales
			GROUP BY  YEAR(sale_date), MONTH(sale_date)) t1
            WHERE rank_no = 1;
        
 --   find the top 5 customers based on the highest total sale
 SELECT   customer_id, SUM(total_sale) AS total_sale  FROM retail_sales
 GROUP BY customer_id
 ORDER BY total_sale DESC LIMIT 5;
 
 -- find the number of unique customer who parchased items from each category
 SELECT category, COUNT(DISTINCT customer_id) AS unique_cs FROM retail_sales
 GROUP BY category;
 
 -- Create each shift and numbers of orders(example moring<=12, afternoon between 12 & 17, evening > 17)
 WITH hourly_sale AS(
    SELECT *, 
   CASE 
     WHEN HOUR(sale_time) < 12 THEN 'moring'
     WHEN HOUR(sale_time) BETWEEN 12 AND 17  THEN 'afternoon'
     ELSE 'evening'
     END AS shift
     FROM retail_sales)
 SELECT shift, COUNT(*) AS total_orders FROM hourly_sale
 GROUP BY shift;
 
 -- End of project
 
 
 
 







