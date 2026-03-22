USE atm_network_analysis;

WITH atm_totals AS (
    SELECT
        l.region,
        l.atm_id,
        l.location_name,
        SUM(s.withdrawals) AS total_withdrawals
    FROM atm_daily_status s
    JOIN atm_locations l
        ON s.atm_id = l.atm_id
    GROUP BY l.region, l.atm_id, l.location_name
),

ranked AS (
    SELECT
        region,
        atm_id,
        location_name,
        total_withdrawals,
        RANK() OVER (
            PARTITION BY region
            ORDER BY total_withdrawals DESC
        ) AS atm_rank
    FROM atm_totals
)

SELECT *
FROM ranked
WHERE atm_rank = 1
ORDER BY total_withdrawals DESC;