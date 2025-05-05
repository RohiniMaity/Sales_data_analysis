SELECT * FROM walmart;

DROP TABLE walmart;

SELECT COUNT(*) FROM walmart;

SELECT COUNT(DISTINCT branch) FROM walmart; -- internally the column name is processed in lower letters

-- 1. Analyze Payment Methods and Sales
-- ● Question: What are the different payment methods, and how many transactions and items were sold with each method?

SELECT DISTINCT payment_method FROM walmart;
SELECT payment_method, COUNT(*) FROM walmart GROUP BY payment_method;

-- 2. Identify the Highest-Rated Category in Each Branch
-- ● Question: Which category received the highest average rating in each branch?

SELECT * 
FROM(
	SELECT 
		branch, 
		category, 
		AVG(rating) as avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
	FROM walmart 
	GROUP BY branch, category 
	ORDER BY 1, 3 DESC
)
WHERE rank=1;

-- 3. Determine the Busiest Day for Each Branch
-- ● Question: What is the busiest day of the week for each branch based on transaction volume?

SELECT 
	date,
	TO_DATE(date, 'DD/MM/YY') as formated_date
FROM walmart;

SELECT 
	date,
	TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name
FROM walmart;

SELECT * 
FROM (
	SELECT 
		branch,
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
		COUNT(*) as no_transactions,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1, 2
)
WHERE rank=1;

--  4. Calculate Total Quantity Sold by Payment Method
-- ● Question: How many items were sold through each payment method?

SELECT DISTINCT payment_method, SUM(quantity) as no_items
FROM walmart
GROUP BY payment_method;

-- 5. Analyze Category Ratings by City
-- ● Question: What are the average, minimum, and maximum ratings for each category in each city?

SELECT 
	city,
	category,	
	AVG(rating) as avg_rating, 
	MIN(rating) as min_rating, 
	MAX(rating) as max_rarting
FROM walmart
GROUP BY city, category
ORDER BY city, category;

-- 6. Calculate Total Profit by Category
-- ● Question: What is the total profit for each category, ranked from highest to lowest?

SELECT 
	category, 
	SUM(total) as total_revenue,
	SUM(total*profit_margin) as profit_sum
FROM walmart
GROUP BY category
ORDER BY profit_sum DESC;

-- 7. Determine the Most Common Payment Method per Branch
-- ● Question: What is the most frequently used payment method in each branch?

SELECT *
FROM(
	SELECT
		branch,
		payment_method,
		COUNT(payment_method),
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(payment_method) DESC) as rank
	FROM walmart
	GROUP BY branch, payment_method
)
WHERE rank=1;

WITH cte
AS(
	SELECT
		branch,
		payment_method,
		COUNT(payment_method),
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(payment_method) DESC) as rank
	FROM walmart
	GROUP BY branch, payment_method
)
SELECT *
FROM cte
WHERE rank=1;

-- 8. Analyze Sales Shifts Throughout the Day
-- ● Question: How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?

SELECT
	branch,
	CASE
		WHEN EXTRACT (HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- 9. Identify Branches with Highest Revenue Decline Year-Over-Year
-- ● Question: Which branches experienced the largest decrease in revenue compared to the previous year?

-- rdr == last_rev - cr_rev / ls_rev * 100

SELECT *, EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YYYY')) as formated_date
FROM walmart;

WITH revenue_2022
AS(
	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
	GROUP BY 1
),
revenue_2023
AS(
	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
	GROUP BY 1
)
SELECT 
	ls.branch,
	ls.revenue as last_year_revenue,
	cs.revenue as current_year_revenue,
	ROUND((ls.revenue - cs.revenue)::numeric / ls.revenue::numeric * 100, 2) as rev_dec_ratio
FROM revenue_2022 as ls
JOIN revenue_2023 as cs
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5;

