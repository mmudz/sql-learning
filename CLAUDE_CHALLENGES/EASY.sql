-- ============================================
-- Warunki umieszczenia w portfolio:
-- Zadanie wykonane samodzielnie, bez podpowiedzi
-- ============================================


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

-- Zadanie: Produkty kupione przez każdego klienta
-- Koncepty: JOIN x3, łańcuch 4 tabel
-- Poziom: podstawowy-średni

SELECT
    customers.name,
    products.name,
    order_items.quantity
FROM customers
JOIN orders
    ON orders.customer_id = customers.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
JOIN products
    ON products.product_id = order_items.product_id;

-- Zadanie: Miesiące z przychodem powyżej 500
-- Koncepty: DATEPART, GROUP BY, HAVING, COUNT, SUM
-- Poziom: podstawowy-średni

SELECT
    DATEPART(month, order_date) AS month,
    COUNT(customer_id) AS order_number,
    SUM(total_amount) AS sum
FROM orders
GROUP BY DATEPART(month, order_date)
HAVING SUM(total_amount) > 500
ORDER BY month;
