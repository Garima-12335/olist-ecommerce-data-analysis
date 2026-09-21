 --   LEVEL 1

--Q1. What is the total number of orders?

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

--Q2. Total number of customers kya hain?

SELECT COUNT( CUSTOMER_ID)FROM OLIST_CUSTOMERS_DATASET;

--  Q3. Total number of sellers kya hain?

SELECT COUNT(SELLER_ID )FROM OLIST_SELLERS_DATASET;

--Q4. Total number of products kya hain?

SELECT COUNT(PRODUCT_ID) FROM OLIST_PRODUCTS_DATASET;

--  Q5. Orders mein kaun-kaun se order_status available hain?

SELECT DISTINCT order_status FROM orders;

--Q6. Har order_status mein kitne orders hain?

SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY order_status;

--Q7. Customers kis-kis state mein hain?

SELECT customer_state, COUNT(*) AS customer_count
FROM OLIST_CUSTOMERS_DATASET
GROUP BY customer_state;

--Q8. Har state mein kitne customers hain?

SELECT customer_state, COUNT(*) AS customer_count
FROM OLIST_CUSTOMERS_DATASET
GROUP BY customer_state;





--LEVEL 2 — Basic Aggregation

--Orders

--Q9. Delivered orders ki total count nikalo.

     SELECT COUNT(*) AS TOTAL_DELIVERED_ORDERS
FROM OLIST_ORDERS_DATASET
WHERE ORDER_STATUS = 'DELIVERED';

--Q10. Cancelled orders ki total count nikalo.

SELECT COUNT(*) AS TOTAL_CANCELLED_ORDERS
FROM OLIST_ORDERS_DATASET
WHERE ORDER_STATUS = 'CANCELLED';

--Q11. Har month mein kitne orders aaye?

    SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
       COUNT(*) AS total_orders
FROM OLIST_ORDERS_DATASET
GROUP BY order_year, order_month;

--Q12. Har year mein kitne orders aaye?

        SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
        COUNT(*) AS total_orders
    FROM OLIST_ORDERS_DATASET
    GROUP BY order_year;

--Q13. Sabse zyada orders kis month mein aaye?


 SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
       COUNT(*) AS total_orders
FROM OLIST_ORDERS_DATASET
GROUP BY order_year, order_month
ORDER BY total_orders DESC
LIMIT 1;


--Order Items


--Q14. Total quantity/products sold kitne hain?

SELECT SUM(order_item_id) AS total_products_sold
FROM OLIST_ORDER_ITEMS_DATASET;

--Q15. Total product sales/revenue kitni hai?

   SELECT SUM(price) AS total_revenue
FROM OLIST_ORDER_ITEMS_DATASET;

--Q16. Average product price kya hai?

 SELECT AVG(price) AS average_price
FROM OLIST_ORDER_ITEMS_DATASET;

--Q17. Highest product price kya hai?

SELECT MAX(price) AS highest_price
FROM OLIST_ORDER_ITEMS_DATASET;

--Q18. Lowest product price kya hai?

SELECT MIN(price) AS lowest_price
FROM OLIST_ORDER_ITEMS_DATASET;


--LEVEL 3 — JOIN Analysis


--Customer + Orders(TABLES)


--Q19. Har customer ne kitne orders kiye?

--Output:

--customer_id | total_orders

SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM OLIST_CUSTOMERS_DATASET c JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--Q20. Aise customers find karo jinhone kabhi order nahi kiya.

        SELECT c.customer_id
        FROM OLIST_CUSTOMERS_DATASET c
        LEFT JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
        WHERE o.customer_id IS NULL;

--Q21. Top 10 customers find karo based on number of orders.
 SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM OLIST_CUSTOMERS_DATASET c JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC
LIMIT 10;

--Q22. Top 10 customers find karo based on total spending.

SELECT c.customer_id, SUM(oi.price) AS total_spending
FROM OLIST_CUSTOMERS_DATASET c
 JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spending DESC
LIMIT 10;





--Orders + Order Items(TABLES)

--Q23. Har order ka total amount .

   SELECT o.order_id, SUM(oi.price) AS total_amount
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY o.order_id;


--order_id | total_amount


--Q24. Har customer ka total spending .
 SELECT c.customer_id, SUM(oi.price) AS total_spending
FROM OLIST_CUSTOMERS_DATASET c
 JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY c.customer_id;

--Q25. Har month ki total revenue .

     SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       SUM(oi.price) AS total_revenue
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month;


--Q26. Har year ki total revenue .

    SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       SUM(oi.price) AS total_revenue
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year;



--LEVEL 4 — Product Analysis


--Q27. Total products sold by quantity.
  SELECT p.product_id, SUM(oi.order_item_id) AS total_quantity_sold
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_id;

--Q28. Top 10 products by quantity sold.
  SELECT p.product_id, SUM(oi.order_item_id) AS total_quantity_sold
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_quantity_sold DESC
LIMIT 10 --(FETCH FIRST 10 ROWS ONLY)ORACLE SQL;

--Q29. Top 10 products by revenue.
   SELECT p.product_id, SUM(oi.price) AS total_revenue
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC
FETCH FIRST 10 ROWS ONLY;

--Q30. Har product category ki total revenue.
     SELECT p.product_category_name, SUM(oi.price) AS total_revenue
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name;

--Q31. Har product category mein kitne products sell hue?

    SELECT p.product_category_name, SUM(oi.order_item_id) AS total_quantity_sold
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name;

--Q32. Highest revenue generating category find karo.
   SELECT p.product_category_name, SUM(oi.price) AS total_revenue
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 1;

--Q33. Highest quantity sold wali category find karo.

   SELECT p.product_category_name, SUM(oi.order_item_id) AS total_quantity_sold
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

--Q34. Aise products find karo jo products table mein exist karte hain but kabhi purchase nahi hue.
SELECT p.product_id
FROM OLIST_PRODUCTS_DATASET p
LEFT JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


--LEVEL 5 — Seller Analysis

--Q35. Har seller ne kitne orders/items sell kiye?
      SELECT s.seller_id, COUNT(oi.order_item_id) AS total_items_sold
FROM OLIST_SELLERS_DATASET s
JOIN OLIST_ORDER_ITEMS_DATASET oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id;

--Q36. Top 10 sellers by revenue.

   SELECT s.seller_id, SUM(oi.price) AS total_revenue
FROM OLIST_SELLERS_DATASET s
JOIN OLIST_ORDER_ITEMS_DATASET oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

--Q37. Top 10 sellers by quantity sold.
   SELECT s.seller_id, SUM(oi.order_item_id) AS total_quantity_sold
FROM OLIST_SELLERS_DATASET s
JOIN OLIST_ORDER_ITEMS_DATASET oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_quantity_sold DESC
LIMIT 10;

--Q38. Har seller ka average product price.
  SELECT s.seller_id, AVG(oi.price) AS average_product_price
FROM OLIST_SELLERS_DATASET s
JOIN OLIST_ORDER_ITEMS_DATASET oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id;

--Q39. Kaunse sellers ne sabse zyada products sell kiye?

   SELECT s.seller_id, COUNT(oi.order_item_id) AS total_items_sold
FROM OLIST_SELLERS_DATASET s
JOIN OLIST_ORDER_ITEMS_DATASET oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_items_sold DESC
LIMIT 10;

--Q40. Aise sellers find karo jinhone bahut kam products sell kiye.

   SELECT s.seller_id, COUNT(oi.order_item_id) AS total_items_sold
FROM OLIST_SELLERS_DATASET s
LEFT JOIN OLIST_ORDER_ITEMS_DATASET oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_items_sold ASC
LIMIT 10;





--LEVEL 6 — Date & Trend Analysis 📈


--Q41. First order date kya hai?
   SELECT MIN(order_purchase_timestamp) AS first_order_date
FROM OLIST_ORDERS_DATASET;

--Q42. Latest order date kya hai?
  SELECT MAX(order_purchase_timestamp) AS latest_order_date
FROM OLIST_ORDERS_DATASET;

--Q43. Monthly order count .
SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
       COUNT(*) AS total_orders
FROM OLIST_ORDERS_DATASET
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

--Q44. Monthly revenue.
SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       SUM(oi.price) AS total_revenue
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

--Q45. Monthly average order value .
SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       AVG(oi.price) AS average_order_value
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


--Q46. Month-wise delivered orders .
SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       COUNT(*) AS delivered_orders
FROM OLIST_ORDERS_DATASET o
WHERE o.order_status = 'delivered'
GROUP BY order_year, order_month
ORDER BY order_year, order_month;



--Q47. Har month ka highest revenue identify karo.
  SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       SUM(oi.price) AS total_revenue
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month
ORDER BY total_revenue DESC
LIMIT 1;


--Q48. Har year ka revenue comparition.
SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       SUM(oi.price) AS total_revenue
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year
ORDER BY order_year;


--Q49. Month-over-month revenue change calculation.

--Q50. Month-over-month revenue growth percentage calculation .






--LEVEL 7 — Customer Lifetime Analysis

--Q51. Har customer ka first order date find karo.
SELECT c.customer_id, MIN(o.order_purchase_timestamp) AS first_order_date
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;


--Q52. Har customer ka latest order date find karo.
SELECT c.customer_id, MAX(o.order_purchase_timestamp) AS latest_order_date
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--Q53. Har customer ne lifetime mein kitne orders kiye?
SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;


--Q54. Har customer ne lifetime mein kitna spend kiya?
SELECT c.customer_id, SUM(oi.price) AS total_spending
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY c.customer_id;

--Q55. Customer ka average order value nikalo.
SELECT c.customer_id, AVG(oi.price) AS avg_order_value
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY c.customer_id;

--Q56. Top 10 customers by lifetime spending.
SELECT c.customer_id, SUM(oi.price) AS total_spending
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spending DESC
LIMIT 10;

--Q57. Aise customers find karo jinka sirf 1 order hai.
   SELECT c.customer_id
   FROM OLIST_CUSTOMERS_DATASET c
   JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
   GROUP BY c.customer_id
   HAVING COUNT(o.order_id) = 1;

   --SECOND QUERY:(RECOMMENDED METHOD) /(BEST METHOD)
     SELECT c.customer_id,COUNT(O.ORDER_ID)AS TOTAL_ORDER
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING TOTAL_ORDER= 1;


--Q58. Repeat customers find karo.
SELECT CUSTOMER_ID, COUNT(ORDER_ID) AS TOTAL_ORDERS
FROM OLIST_ORDERS_DATASET
GROUP BY CUSTOMER_ID
HAVING COUNT(ORDER_ID) > 1;

--SECOND QUERY:(RECOMMENDED METHOD)
SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING total_orders > 1;

--Q59. Repeat customers ka total percentage calculate karo.
SELECT COUNT(*) AS REPEAT_CUSTOMERS
FROM (
    SELECT
        C.CUSTOMER_ID
    FROM OLIST_CUSTOMERS_DATASET C
    JOIN OLIST_ORDERS_DATASET O
        ON C.CUSTOMER_ID = O.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID
    HAVING COUNT(O.ORDER_ID) >= 1);


--Q60. Customer ke first aur latest order ke beech kitne days hain?
SELECT c.customer_id,
       MIN(o.order_purchase_timestamp) AS first_order_date,
       MAX(o.order_purchase_timestamp) AS latest_order_date,
       DATEDIFF(MAX(o.order_purchase_timestamp), MIN(o.order_purchase_timestamp)) AS days_between_orders
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--SECOND QUERY:(ORACLE SQL)USE(DATE1-DATE2)*24*60 TO GET DAYS BETWEEN TWO DATES
SELECT c.customer_id,
       MIN(o.order_purchase_timestamp) AS first_order_date,
       MAX(o.order_purchase_timestamp) AS latest_order_date,
       (MAX(o.order_purchase_timestamp)- MIN(o.order_purchase_timestamp))*24*60 AS days_between_orders
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;



--LEVEL 8 — Window Functions

--Q61. Rank products within each product category based on total revenue.

select p.product_category_name, p.product_id, SUM(oi.price) AS total_revenue,
       RANK() OVER (PARTITION BY p.product_category_name ORDER BY SUM(oi.price) DESC) AS revenue_rank
from OLIST_PRODUCTS_DATASET p
join OLIST_ORDER_ITEMS_DATASET oi on p.product_id = oi.product_id
group by p.product_category_name, p.product_id
order by p.product_category_name, revenue_rank;

     --Har category ke Top 3 products find karo.
     select p.product_category_name, p.product_id, SUM(oi.price) AS total_revenue,
       RANK() OVER (PARTITION BY p.product_category_name ORDER BY SUM(oi.price) DESC) AS revenue_rank
from OLIST_PRODUCTS_DATASET p
join OLIST_ORDER_ITEMS_DATASET oi on p.product_id = oi.product_id
group by p.product_category_name, p.product_id
having revenue_rank <= 3
order by p.product_category_name, revenue_rank;

--Q62. Find the top 3 products by revenue within each product category.
select p.product_category_name, p.product_id, SUM(oi.price) AS total_revenue,
      DENSE RANK() OVER (PARTITION BY p.product_category_name ORDER BY SUM(oi.price) DESC) AS revenue_rank
from OLIST_PRODUCTS_DATASET p
join OLIST_ORDER_ITEMS_DATASET oi on p.product_id = oi.product_id
group by p.product_category_name, p.product_id
having revenue_rank <= 3
order by p.product_category_name, revenue_rank;

--Q63. Rank sellers based on their total revenue.
SELECT s.seller_id, SUM(oi.price) AS total_revenue,
       RANK() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank
FROM OLIST_SELLERS_DATASET s
JOIN OLIST_ORDER_ITEMS_DATASET oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id;

--Q64. Assign a sequential order number to each customer's orders based on the order date.
SELECT c.customer_id, o.order_id, o.order_purchase_timestamp,
       ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp) AS order_sequence
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_purchase_timestamp;

--Q65. Find the previous order date for each customer.
select c.customer_id, o.order_id, o.order_purchase_timestamp,
       LAG(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp) AS previous_order_date
       FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_purchase_timestamp;

--Q66 har customer ka previous order date find karo aur agar previous order nahi hai toh NULL show karo.
SELECT c.customer_id, o.order_id, o.order_purchase_timestamp,
       LAG(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp) AS previous_order_date
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_purchase_timestamp;


--Q67 Har customer ka first order identify karo using ROW_NUMBER().
SELECT c.customer_id, o.order_id, o.order_purchase_timestamp,
       ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp) AS order_sequence
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
WHERE order_sequence = 1;

--Q68. Identify each customer's latest order using a window function.
SELECT c.customer_id, o.order_id, o.order_purchase_timestamp,
       ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp DESC) AS order_sequence
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
WHERE order_sequence = 1;

--Q69.Customer ke current order aur previous order ke beech days calculate karo.
SELECT c.customer_id, o.order_id, o.order_purchase_timestamp,
MAX(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp) AS current_order_date,
       LAG(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp) AS previous_order_date,
         DATEDIFF(MAX(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp),
                  LAG(o.order_purchase_timestamp) OVER (PARTITION BY c.customer_id ORDER BY o.order_purchase_timestamp)) AS days_between_orders
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_purchase_timestamp;

 --Q70. Display each month's revenue along with the previous month's revenue.
SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       SUM(oi.price) AS current_month_revenue,
       LAG(SUM(oi.price)) OVER (ORDER BY EXTRACT(YEAR FROM o.order_purchase_timestamp), EXTRACT(MONTH FROM o.order_purchase_timestamp)) AS previous_month_revenue
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

--Q71. Calculate the cumulative (running) revenue over time.
SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
         EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
         SUM(oi.price) AS monthly_revenue,
         SUM(SUM(oi.price)) OVER (ORDER BY EXTRACT(YEAR FROM o.order_purchase_timestamp), EXTRACT(MONTH FROM o.order_purchase_timestamp)) AS cumulative_revenue
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


--LEVEL 9 — Order & Customer Date Logic

--Q71. Har customer ka first order date aur latest order date ek saath dikhao.
SELECT c.customer_id,
       MIN(o.order_purchase_timestamp) AS first_order_date,
       MAX(o.order_purchase_timestamp) AS latest_order_date
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--Q72. Aise customers find karo jinka latest order company ke overall first order ke baad hai.
SELECT c.customer_id, MAX(o.order_purchase_timestamp) AS latest_order_date
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
WHERE o.order_purchase_timestamp > (SELECT MIN(order_purchase_timestamp) FROM OLIST_ORDERS_DATASET)
GROUP BY c.customer_id;

--Q73. Aise customers find karo jinhone consecutive/close periods mein multiple orders kiye.
SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 1
AND MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp) <= INTERVAL '30'day;

--Q74. Customers find karo jinhone ek se zyada orders kiye aur unke orders ke beech average gap nikalo.


--Q75. Last order ke basis par customers ko categorize karo:
SELECT c.customer_id,
       CASE
           WHEN MAX(o.order_purchase_timestamp) >= CURRENT_DATE - INTERVAL '30' DAY THEN 'Active'
           WHEN MAX(o.order_purchase_timestamp) >= CURRENT_DATE - INTERVAL '90' DAY THEN 'Inactive'
           ELSE 'Dormant'
       END AS customer_status
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;




--LEVEL 12 — Payment Analysis

--Q91. Total payment value.
SELECT SUM(payment_value) AS total_payment_value
FROM OLIST_PAYMENTS_DATASET;

--Q92. Different payment types kaunse hain?
SELECT DISTINCT payment_type FROM OLIST_PAYMENTS_DATASET;

--Q93. Har payment type se kitni transactions hui?
 SELECT payment_type, COUNT(*) AS transaction_count
FROM OLIST_PAYMENTS_DATASET
GROUP BY payment_type;

--Q94. Har payment type ka total payment value.
SELECT payment_type, SUM(payment_value) AS total_payment_value
FROM OLIST_PAYMENTS_DATASET
GROUP BY payment_type;

--Q95. Average payment value by payment type.
SELECT payment_type, AVG(payment_value) AS average_payment_value
FROM OLIST_PAYMENTS_DATASET
GROUP BY payment_type;

--Q96. Installment count ka distribution analyse karo.
SELECT payment_installments, COUNT(*) AS installment_count
FROM OLIST_PAYMENTS_DATASET
GROUP BY payment_installments
ORDER BY payment_installments;

--Q97. Highest revenue/payment generating payment method identify karo.
SELECT payment_type, SUM(payment_value) AS total_payment_value
FROM OLIST_PAYMENTS_DATASET
GROUP BY payment_type
ORDER BY total_payment_value DESC
LIMIT 1;// FOR ORACLE SQL USE FETCH FIRST 1 ROWS ONLY;


--LEVEL 13 — Advanced Business Questions

--Q98. Kaunsi category highest revenue generate karti hai?

SELECT p.product_category_name, SUM(oi.price) AS total_revenue
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
 FETCH FIRST 1 ROWS ONLY ;


--Q99. Kaunsi category highest quantity sell karti hai?
SELECT p.product_category_name, SUM(oi.order_item_id) AS total_quantity_sold
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_quantity_sold DESC
FETCH FIRST 1 ROWS ONLY ;

--Q100. Kya highest quantity selling category aur highest revenue category same hai?
SELECT p.product_category_name, SUM(oi.order_item_id) AS total_quantity_sold, SUM(oi.price) AS total_revenue
FROM OLIST_PRODUCTS_DATASET p
JOIN OLIST_ORDER_ITEMS_DATASET oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_quantity_sold DESC, total_revenue DESC
FETCH FIRST 1 ROWS ONLY ;


--Q101. Top 10% customers total revenue ka kitna percentage generate karte hain?



--Q102. Customers ko spending ke basis par segments mein divide karo:
--Low Value
--Medium Value
--High Value

SELECT c.customer_id, SUM(oi.price) AS total_spending,
       CASE
           WHEN SUM(oi.price) < 100 THEN 'Low Value'
           WHEN SUM(oi.price) BETWEEN 100 AND 500 THEN 'Medium Value'
           ELSE 'High Value'
       END AS customer_segment

FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spending DESC;

--Q103.Kaunse states highest revenue generate karte hain?
select c.customer_state, SUM(oi.price) AS total_revenue
from OLIST_CUSTOMERS_DATASET c
join OLIST_ORDERS_DATASET o on c.customer_id = o.customer_id
join OLIST_ORDER_ITEMS_DATASET oi on o.order_id = oi.order_id
group by c.customer_state
order by total_revenue desc
fetch first 1 rows only;


--Q104.Kaunse states mein delivery problems zyada hain? (the delivery table is not available in the dataset, so we can use order_status to identify delivery problems)
SELECT c.customer_state, COUNT(*) AS delivery_problems
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o ON c.customer_id = o.customer_id
WHERE o.order_status = 'canceled' OR o.order_status = 'unavailable'
GROUP BY c.customer_state
ORDER BY delivery_problems DESC;

--second query:
SELECT c.customer_state,
       COUNT(*) AS delivery_problems
FROM OLIST_CUSTOMERS_DATASET c
JOIN OLIST_ORDERS_DATASET o
    ON c.customer_id = o.customer_id
WHERE o.order_status IN ('canceled', 'unavailable')
GROUP BY c.customer_state
ORDER BY delivery_problems DESC;

--Q105.Kaunse sellers high revenue generate karte hain but poor reviews receive karte hain?

--Q106.Kaunse categories high revenue + high rating dono generate karti hain?

--Q107.Kaunse categories high revenue but low rating wali hain?

--Q108.Kaunse months mein revenue growth sabse zyada hui?
select EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       SUM(oi.price) AS total_revenue,
LAG(SUM(oi.price)) OVER (ORDER BY EXTRACT(YEAR FROM o.order_purchase_timestamp), EXTRACT(MONTH FROM o.order_purchase_timestamp)) AS previous_month_revenue,
(SUM(oi.price) - LAG(SUM(oi.price)) OVER (ORDER BY EXTRACT(YEAR FROM o.order_purchase_timestamp), EXTRACT(MONTH FROM o.order_purchase_timestamp))) AS revenue_growth
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month
ORDER BY revenue_growth DESC;

--Q109.Kaunse months mein revenue decline hua?
select EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
       SUM(oi.price) AS total_revenue,
LAG(SUM(oi.price)) OVER (ORDER BY EXTRACT(YEAR FROM o.order_purchase_timestamp), EXTRACT(MONTH FROM o.order_purchase_timestamp)) AS previous_month_revenue,
(SUM(oi.price) - LAG(SUM(oi.price)) OVER (ORDER BY EXTRACT(YEAR FROM o.order_purchase_timestamp), EXTRACT(MONTH FROM o.order_purchase_timestamp))) AS revenue_growth
FROM OLIST_ORDERS_DATASET o
JOIN OLIST_ORDER_ITEMS_DATASET oi ON o.order_id = oi.order_id
GROUP BY order_year, order_month
ORDER BY revenue_growth ASC;

--Q110.Repeat customers business revenue mein kitna contribute karte hain?
 SELECT ROUND(SUM(
             CASE
                WHEN customer_order_count > 1 THEN customer_revenue
                ELSE 0
            END) * 100.0 / SUM(customer_revenue), 2
    ) AS repeat_customer_revenue_percentage
FROM (

 SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS customer_order_count,
        SUM(oi.price) AS customer_revenue
    FROM OLIST_ORDERS_DATASET o
    JOIN OLIST_ORDER_ITEMS_DATASET oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
    );

    --Final 5 Questions -


--Q111 — Customer Ranking
--Har state ke andar top 3 customers by spending.
--Concept: PARTITION BY + DENSE_RANK()

SELECT C.CUSTOMER_ID, C.CUSTOMER_STATE ,SUM(OI.PRICE)AS TOTAL_REVENUE,
DENSE_RANK()OVER( PARTITION BY C.CUSTOMER_STATE ORDER BY SUM(OI.PRICE))AS SPENDING_RANK
FROM OLIST_CUSTOMERS_DATASET C JOIN OLIST_ORDERS_DATASET O
 ON C.CUSTOMER_ID=O.CUSTOMER_ID
 JOIN OLIST_ORDER_ITEMS_DATASET OI ON OI.ORDER_ID=O.ORDER_ID
 GROUP BY C.CUSTOMER_ID,C.CUSTOMER_STATE
ORDER BY C.CUSTOMER_STATE, SPENDING_RANK;




--Q112 — Product Ranking
--Har category ke andar top 3 products by revenue.
--Concept: CTE + DENSE_RANK()

SELECT *FROM
(
    SELECT P.PRODUCT_ID,P.PRODUCT_CATEGORY_NAME,SUM(OI.PRICE)AS TOTAL_REVENUE,
DENSE_RANK()OVER(PARTITION BY P.PRODUCT_CATEGORY_NAME ORDER BY SUM(OI.PRICE))AS RN
FROM OLIST_ORDER_ITEMS_DATASET OI JOIN OLIST_PRODUCTS_DATASET P ON OI.PRODUCT_ID= P.PRODUCT_ID
GROUP BY P.PRODUCT_ID,P.PRODUCT_CATEGORY_NAME
)
WHERE RN <=3
ORDER BY PRODUCT_CATEGORY_NAME ,RN;


--Q113 — Previous Order
--Har customer ka:
--Current Order
--Previous Order
--Days Between Orders.
--Concept: LAG()
SELECT C.CUSTOMER_ID,O.ORDER_ID,O.ORDER_PURCHASE_TIMESTAMP,
MAX(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP)AS CURRENT_ORDER_DATE,
LAG(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP)AS PREVIOUS_ORDER_DATE,
DATEDIFF(MAX(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP), LAG(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP)) AS DAYS_BETWEEN_ORDERS
FROM OLIST_CUSTOMERS_DATASET C
JOIN OLIST_ORDERS_DATASET O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN OLIST_ORDER_ITEMS_DATASET OI ON O.ORDER_ID = OI.ORDER_ID
GROUP BY C.CUSTOMER_ID, O.ORDER_ID, O.ORDER_PURCHASE_TIMESTAMP
ORDER BY C.CUSTOMER_ID, O.ORDER_PURCHASE_TIMESTAMP;


--SECOND QUERY:(ORACLE SQL)USE(DATE1-DATE2)*24*60 TO GET DAYS BETWEEN TWO DATES
SELECT C.CUSTOMER_ID,O.ORDER_ID,O.ORDER_PURCHASE_TIMESTAMP,
MAX(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP)AS CURRENT_ORDER_DATE,
MAX(O.ORDER_ID)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP)AS CURRENT_ORDER_ID,
LAG(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP)AS PREVIOUS_ORDER_DATE,
LAG(O.ORDER_ID)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP)AS PREVIOUS_ORDER_ID,
(MAX(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP) - LAG(O.ORDER_PURCHASE_TIMESTAMP)OVER(PARTITION BY C.CUSTOMER_ID ORDER BY O.ORDER_PURCHASE_TIMESTAMP))*24*60 AS DAYS_BETWEEN_ORDERS
FROM OLIST_CUSTOMERS_DATASET C
JOIN OLIST_ORDERS_DATASET O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN OLIST_ORDER_ITEMS_DATASET OI ON O.ORDER_ID = OI.ORDER_ID
GROUP BY C.CUSTOMER_ID, O.ORDER_ID, O.ORDER_PURCHASE_TIMESTAMP
ORDER BY C.CUSTOMER_ID, O.ORDER_PURCHASE_TIMESTAMP;

--Q114 — Monthly Growth

--Output:
--Month
--Revenue
--Previous Month Revenue
--Growth
--Growth %

--Concept: LAG() + date logic


SELECT EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP) AS ORDER_YEAR,
       EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP) AS ORDER_MONTH,
       SUM(OI.PRICE) AS REVENUE,
 LAG(SUM(OI.PRICE)) OVER (ORDER BY EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP), EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP)) AS PREVIOUS_MONTH_REVENUE,
(SUM(OI.PRICE) - LAG(SUM(OI.PRICE)) OVER (ORDER BY EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP), EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP))) AS GROWTH,

((SUM(OI.PRICE) - LAG(SUM(OI.PRICE)) OVER (ORDER BY EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP), EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP))) / LAG(SUM(OI.PRICE)) OVER (ORDER BY EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP), EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP))) * 100 AS GROWTH_PERCENTAGE

FROM OLIST_ORDERS_DATASET O
JOIN OLIST_ORDER_ITEMS_DATASET OI ON O.ORDER_ID = OI.ORDER_ID
GROUP BY ORDER_YEAR,ORDER_MONTH
ORDER BY GROWTH DESC;



--Q115 — Customer Lifetime Summary
-- CREATE a final customer-level table :

--customer_id
--first_order_date
--latest_order_date
--total_orders
--total_spending
--average_order_value
--days_between_first_and_last_order
--customer_rank

SELECT  C.CUSTOMER_ID,
 MIN(O.ORDER_PURCHASE_TIMESTAMP) AS FIRST_ORDER_DATE,
MAX(O.ORDER_PURCHASE_TIMESTAMP) AS LATEST_ORDER_DATE,
COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS,
SUM(OI.PRICE) AS TOTAL_SPENDING,
COUNT(DISTINCT O.ORDER_ID) AS AVERAGE_ORDER_VALUE,
(MAX(O.ORDER_PURCHASE_TIMESTAMP)-MIN(O.ORDER_PURCHASE_TIMESTAMP))*24*60 AS DAYS_BETWEEN_FIRST_AND_LAST_ORDER,
RANK() OVER (ORDER BY SUM(OI.PRICE) DESC) AS CUSTOMER_RANK
FROM OLIST_CUSTOMERS_DATASET C
JOIN OLIST_ORDERS_DATASET O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN OLIST_ORDER_ITEMS_DATASET OI ON O.ORDER_ID = OI.ORDER_ID
GROUP BY  C.CUSTOMER_ID;
