-- Zadanie: Top artysta per gatunek według revenue per member
-- Źródło: DataLemur (Medium)
-- Koncepty: CTE, JOIN, GROUP BY, MAX
-- Poziom: średni

WITH revenue_pm_cte AS (
    SELECT
    artist_name,
    genre,
    number_of_members,
    concert_revenue,
    (concert_revenue / number_of_members) AS revenue_per_member
    FROM concerts
),
top_artist_cte AS (
    SELECT
    genre,
    MAX(revenue_per_member) AS top
    FROM revenue_pm_cte
    GROUP BY genre
)
SELECT
artist_name,
revenue_pm_cte.concert_revenue,
top_artist_cte.genre,
revenue_pm_cte.number_of_members,
revenue_per_member
FROM revenue_pm_cte
INNER JOIN top_artist_cte
    ON top_artist_cte.genre = revenue_pm_cte.genre
    AND revenue_pm_cte.revenue_per_member = top_artist_cte.top
ORDER BY revenue_per_member DESC, artist_name ASC;
