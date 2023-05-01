/*
 * QUESTION 1
 * ---------------------
 * ABC Foodmart wants to understand which store is more 
 * profitable. What are the gross profits of each store?
 *
 */

SELECT s.store_id, SUM(s.sale_quantity * s.sale_price) - SUM(t.transaction_quantity * t.transaction_price) AS gross_profit
FROM Sale s
JOIN Transaction t ON s.product_id = t.product_id
GROUP BY s.store_id;

/*
 * QUESTION 2
 * ---------------------
 * ABC Foodmart wants to understand to what extent their daily 
 * expenses are covered by sales. Compare the ratio of total expenses 
 * of each store to their sales.
 *
 */

WITH s1 (id, sum) AS (
	SELECT store_id, SUM (expense_amount)
	FROM expense
	GROUP BY store_id),
 s2 (id, sum) AS (
	SELECT store_id, SUM(sale_price)
	 FROM sale
	GROUP BY store_id)
SELECT s1.id, (s1.sum/s2.sum) AS ratio
FROM s1 LEFT JOIN s2 ON s1.id = s2.id;

/*
 * QUESTION 3
 * ---------------------
 * ABC Foodmart wants to ensure fair and equitable pay across 
 * all 5 boroughs. Are employees with similar years of experience
 * receiving similar salaries? 
 *
 */
 
SELECT e.year_of_experience, AVG(s.salary_amount) as avg_salary
FROM Employee e
JOIN Salary s ON e.employee_id = s.employee_id
GROUP BY e.year_of_experience
ORDER BY e.year_of_experience;
 
/*
 * QUESTION 4
 * ---------------------
 *  ABC Foodmart wants to know if their loyalty reward has promoted 
 * the sales. Do customers with loyalty rewards make more purchases 
 * on average than those who do not?
 *
 */

SELECT AVG(sale_num) AS avg_sale_num, AVG(sale_amount) AS avg_sale_amount
FROM (SELECT COUNT(sale_id) AS sale_num, SUM(sale_price) AS sale_amount
	 FROM sale LEFT JOIN loyalty_reward ON loyalty_reward.customer_id = sale.customer_id
	 WHERE loyalty_reward_id IS NULL
	 GROUP BY sale.customer_id) foo;
	 
SELECT AVG(sale_num) AS avg_sale_num, AVG(sale_amount) AS avg_sale_amount
FROM (SELECT COUNT(sale_id) AS sale_num, SUM(sale_price) AS sale_amount
	 FROM sale LEFT JOIN loyalty_reward ON loyalty_reward.customer_id = sale.customer_id
	 WHERE loyalty_reward_id IS NOT NULL
	 GROUP BY sale.customer_id) foo;

/*
 * QUSTION 5
 * ---------------------
 * In order to reduce spoilage or expiration, which product 
 * has the lowest turnover (i.e. which products sell the least 
 * amount as a percentage of inventory)?
 *
 */

SELECT p.product_name, (SUM(s.sale_quantity) / i.inventory_quantity) * 100 AS percentage_sold
FROM product p JOIN inventory i ON p.product_id = i.product_id
    JOIN sale s ON p.product_id = s.product_id AND i.store_id = s.store_id
GROUP BY p.product_id, i.inventory_quantity
ORDER BY percentage_sold ASC
	
/*
 * QUESTION 6
 * ---------------------
 * ABC Foodmart wants their yoghurt section to appeal 
 * to a wide variety of age groups. For each age group (>18, 
 * 18-30, 30-45, 45-65, 65+), what are the most popular brands 
 * of yoghurt?
 *
 */

-- Total
SELECT p.product_brand, SUM(s.sale_quantity) AS total_sales
FROM sale s JOIN product p ON s.product_id = p.product_id
WHERE p.product_group = 'Yoghurt'
GROUP BY p.product_brand
ORDER BY total_sales DESC
LIMIT 1;

-- By age group
WITH foo (brand, count, age) AS (
SELECT product_brand, COUNT(DISTINCT(sale_id)) AS sale_num, 
  CASE 
    WHEN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.date_of_birth) > 65 THEN '65+'
    WHEN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.date_of_birth)  BETWEEN 45 AND 64 THEN '45-64'
    WHEN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.date_of_birth)  BETWEEN 30 AND 44 THEN '30-44'
    WHEN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', c.date_of_birth)  BETWEEN 18 AND 29 THEN '18-29'
    ELSE '>18'
  END AS age_group
FROM customer c JOIN sale s ON c.customer_id = s.customer_id
  JOIN product p ON s.product_id = p.product_id AND p.product_group = 'Yoghurt'
GROUP BY age_group, p.product_brand
)
SELECT filter.brand, filter.count, filter.age, filter.rnk
FROM (
	SELECT brand, count, age, 
	DENSE_RANK() OVER(PARTITION BY foo.age ORDER BY foo.count DESC) AS rnk
	FROM foo
) filter
WHERE filter.rnk <= 3

/*
 * QUESTION 7
 * ---------------------
 * ABC Foodmart wants to save money on supplier delivery 
 * fees by consolidating as many products as they can from 
 * a single supplier. What suppliers supply the grocery 
 * store with the least amount of products? 
 *
 */
 
SELECT i.store_id, s.supplier_name, COUNT(*) AS num_products
FROM inventory i JOIN product p ON i.product_id = p.product_id
  JOIN supplier s ON p.supplier_id = s.supplier_id
GROUP BY i.store_id, s.supplier_id
HAVING COUNT(*) = (
    SELECT MIN(num_products)
    FROM (
      SELECT i1.store_id, p1.supplier_id, COUNT(*) AS num_products
      FROM inventory i1 JOIN product p1 ON i1.product_id = p1.product_id
      GROUP BY i1.store_id, p1.supplier_id
    ) AS subquery
    WHERE i.store_id = subquery.store_id
  )
ORDER BY i.store_id, num_products ASC;
 
/*
 * QUESTION 8
 * ---------------------
 * ABC Foodmart wants to uncover a reason as to why meat sales 
 * in 2 different locations are so different from each other. 
 * What is the relationship between each store’s butcher, the 
 * butcher’s experience, and the sales from each meat department?
 *
 */

SELECT e.first_name || ' ' || e.last_name AS butcher_name, 
	e.year_of_experience AS butcher_experience, SUM(s.sale_price) AS meat_sales
FROM Employee e
JOIN Sale s ON s.employee_id = e.employee_id
JOIN Product p ON s.product_id = p.product_id
JOIN Category c ON p.category_id = c.category_id
WHERE c.main_category LIKE 'Meat%'
GROUP BY e.first_name, e.last_name, e.year_of_experience;

/*
 * QUESTION 9
 * ---------------------
 * ABC Foodmart wants to mail a promotional coupon to select 
 * customers to promote a locally brewed beer. Find all the 
 * customers who purchased any brand of beer within the past 2 months.
 *
 */

SELECT DISTINCT c.first_name, c.last_name, c.email, c.date_of_birth, c.phone_number
FROM Customer c
JOIN Sale s ON c.customer_id = s.customer_id
JOIN Product p ON s.product_id = p.product_id
JOIN Transaction t ON p.product_id = t.product_id
WHERE t.transaction_date BETWEEN DATE_SUB(NOW(), INTERVAL '2 months') AND NOW()
  AND p.product_group = 'beer';
  
/*
 * QUESTION 10
 * ---------------------
 * ABC Foodmart wants to add more unique subcategories of products 
 * by trimming down selections of certain products that have too 
 * much variety. What 10 subcategories have the most variety of products?
 *
 */
 
SELECT c.sub_category, COUNT(DISTINCT p.product_name) AS variety_count
FROM product p
JOIN category c ON p.category_id = c.category_id
GROUP BY c.sub_category
ORDER BY variety_count DESC
LIMIT 10;