-- Zadanie: Klienci z więcej niż 2 zamówieniami
-- Koncepty: JOIN, GROUP BY, HAVING, COUNT
-- Poziom: podstawowy

SELECT
    customers.name,
    COUNT(orders.customer_id) AS orders
FROM customers
JOIN orders
    ON orders.customer_id = customers.customer_id
GROUP BY customers.name
HAVING COUNT(orders.customer_id) > 2
ORDER BY COUNT(orders.customer_id) DESC;
