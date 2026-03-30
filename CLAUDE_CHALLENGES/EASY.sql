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

-- Zadanie: Klienci bez żadnego zamówienia
-- Koncepty: LEFT JOIN, IS NULL
-- Poziom: podstawowy-średni

SELECT customers.*
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE orders.order_id IS NULL;

-- Zadanie: Produkty z przychodem powyżej 500
-- Koncepty: JOIN, GROUP BY, HAVING, SUM
-- Poziom: podstawowy-średni

SELECT
    products.name,
    SUM(order_items.unit_price * order_items.quantity) AS total
FROM products
JOIN order_items
    ON products.product_id = order_items.product_id
GROUP BY products.name
HAVING SUM(order_items.unit_price * order_items.quantity) > 500
ORDER BY total DESC;

-- Zadanie: Liczba różnych kategorii produktów per klient
-- Koncepty: JOIN x3, GROUP BY, COUNT DISTINCT
-- Poziom: średni

SELECT
    customers.name,
    COUNT(DISTINCT category) AS cat_count
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN order_items
    ON orders.order_id = order_items.order_id
JOIN products
    ON order_items.product_id = products.product_id
GROUP BY customers.name
ORDER BY cat_count DESC;

-- Zadanie: Pierwszy, ostatni order i liczba dni między nimi per klient
-- Koncepty: JOIN, GROUP BY, MIN, MAX, DATEDIFF
-- Poziom: średni

SELECT
    customers.name,
    MIN(order_date) AS earliest,
    MAX(order_date) AS latest,
    DATEDIFF(day, MIN(order_date), MAX(order_date)) AS days_between
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY customers.name
ORDER BY customers.name;

-- Zadanie: Cena produktu jako procent najdroższego produktu
-- Koncepty: CTE, CROSS JOIN, ROUND
-- Poziom: średni

WITH max_price AS (
    SELECT MAX(price) AS max
    FROM products
)
SELECT
    products.name,
    ROUND((price / max_price.max) * 100, 2) AS percentage
FROM products
CROSS JOIN max_price;

-- Zadanie: Ranking klientów według łącznej kwoty zamówień
-- Koncepty: JOIN, GROUP BY, SUM, RANK(), OVER
-- Poziom: średni

SELECT
    customers.name,
    SUM(total_amount) AS total,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY customers.name;

-- Zadanie: Ranking produktów według ceny w obrębie kategorii
-- Koncepty: RANK(), OVER, PARTITION BY
-- Poziom: średni

SELECT
    products.name,
    products.price,
    products.category,
    RANK() OVER (PARTITION BY products.category ORDER BY products.price DESC) AS cat_rank
FROM products
ORDER BY cat_rank ASC;

-- Zadanie: Najtańszy produkt z każdej kategorii
-- Koncepty: CTE, JOIN, MIN, GROUP BY
-- Poziom: średni

WITH lowest_price AS (
    SELECT
        MIN(price) AS min,
        category
    FROM products
    GROUP BY category
)
SELECT
    products.name,
    lowest_price.category,
    products.price
FROM products
JOIN lowest_price
    ON products.price = lowest_price.min
    AND products.category = lowest_price.category;

-- Zadanie: Przychód per produkt i jego udział procentowy w całości
-- Koncepty: CTE x2, CROSS JOIN, JOIN, SUM, ROUND
-- Poziom: średni-trudny

WITH overall_revenue AS (
    SELECT SUM(quantity * unit_price) AS revenue
    FROM order_items
),
product_revenue AS (
    SELECT
        product_id,
        SUM(unit_price * quantity) AS prod_revenue
    FROM order_items
    GROUP BY product_id
)
SELECT
    products.name,
    product_revenue.prod_revenue,
    ROUND(product_revenue.prod_revenue * 100 / overall_revenue.revenue, 2) AS perc
FROM product_revenue
CROSS JOIN overall_revenue
JOIN products
    ON products.product_id = product_revenue.product_id;

-- Zadanie: Numerowanie zamówień każdego klienta chronologicznie
-- Koncepty: JOIN, ROW_NUMBER(), OVER, PARTITION BY
-- Poziom: średni

SELECT
    customers.name,
    orders.order_date,
    ROW_NUMBER() OVER (PARTITION BY customers.name ORDER BY orders.order_date ASC) AS numb
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
ORDER BY customers.name, orders.order_date;

-- Zadanie: Pierwsze zamówienie każdego klienta
-- Koncepty: CTE, ROW_NUMBER(), OVER, PARTITION BY, WHERE
-- Poziom: średni

WITH first_orders AS (
    SELECT
        customers.name,
        orders.order_date,
        orders.total_amount,
        ROW_NUMBER() OVER (PARTITION BY customers.name ORDER BY orders.order_date ASC) AS numb
    FROM customers
    JOIN orders
        ON customers.customer_id = orders.customer_id
)
SELECT name, order_date, total_amount
FROM first_orders
WHERE numb = 1;

-- Zadanie: Kwota poprzedniego zamówienia klienta (LAG)
-- Koncepty: CTE, ROW_NUMBER(), LAG(), OVER, PARTITION BY
-- Poziom: średni-trudny

WITH orders_numbered AS (
    SELECT
        customers.name,
        orders.order_date,
        orders.total_amount,
        ROW_NUMBER() OVER (PARTITION BY customers.name ORDER BY orders.order_date ASC) AS numb
    FROM customers
    JOIN orders
        ON customers.customer_id = orders.customer_id
)
SELECT
    name,
    order_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY name ORDER BY order_date ASC) AS prev_order_amount
FROM orders_numbered;

-- Zadanie: Skumulowany przychód per kategoria (rosnąco)
-- Koncepty: CTE, SUM() OVER, PARTITION BY, Window Functions
-- Poziom: średni-trudny

WITH product_revenue AS (
    SELECT
        product_id,
        SUM(quantity * unit_price) AS revenue
    FROM order_items
    GROUP BY product_id
)
SELECT
    products.name,
    products.category,
    products.price,
    product_revenue.revenue,
    SUM(product_revenue.revenue) OVER (PARTITION BY products.category ORDER BY product_revenue.revenue ASC) AS cumulative
FROM product_revenue
JOIN products
    ON product_revenue.product_id = products.product_id
ORDER BY products.category, cumulative ASC;
