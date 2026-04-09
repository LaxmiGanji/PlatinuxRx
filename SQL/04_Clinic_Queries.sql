-- 1. Find the revenue we got from each sales channel in a given year
-- (Assuming the year is 2021 as a parameter)
SELECT 
    sales_channel, 
    SUM(amount) AS revenue 
FROM clinic_sales 
WHERE EXTRACT(YEAR FROM datetime) = 2021 
GROUP BY sales_channel;

-- 2. Find top 10 the most valuable customers for a given year
SELECT 
    c.uid, 
    c.name,
    SUM(cs.amount) AS total_spent 
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE EXTRACT(YEAR FROM cs.datetime) = 2021 
GROUP BY c.uid, c.name
ORDER BY total_spent DESC 
LIMIT 10;

-- 3. Find month wise revenue, expense, profit, status (profitable / not-profitable) for a given year
WITH monthly_revenue AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS mnt, 
        SUM(amount) AS revenue 
    FROM clinic_sales 
    WHERE EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY EXTRACT(MONTH FROM datetime)
), 
monthly_expense AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS mnt, 
        SUM(amount) AS expense 
    FROM expenses 
    WHERE EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY EXTRACT(MONTH FROM datetime)
),
all_months AS (
    SELECT mnt FROM monthly_revenue
    UNION
    SELECT mnt FROM monthly_expense
)
SELECT 
    am.mnt AS month_num, 
    COALESCE(r.revenue, 0) AS revenue, 
    COALESCE(e.expense, 0) AS expense, 
    (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) AS profit, 
    CASE 
        WHEN (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) > 0 THEN 'Profitable' 
        ELSE 'Not-Profitable' 
    END AS status 
FROM all_months am
LEFT JOIN monthly_revenue r ON am.mnt = r.mnt
LEFT JOIN monthly_expense e ON am.mnt = e.mnt
ORDER BY am.mnt;

-- 4. For each city find the most profitable clinic for a given month
-- (Assuming the given month is September 2021, i.e., month 9 and year 2021)
WITH clinic_revenue AS (
    SELECT 
        cid, 
        SUM(amount) AS revenue 
    FROM clinic_sales 
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY cid
), 
clinic_expense AS (
    SELECT 
        cid, 
        SUM(amount) AS expense 
    FROM expenses 
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY cid
), 
clinic_profit AS (
    SELECT 
        c.city, 
        c.cid, 
        c.clinic_name,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit 
    FROM clinics c 
    LEFT JOIN clinic_revenue r ON c.cid = r.cid 
    LEFT JOIN clinic_expense e ON c.cid = e.cid
), 
ranked_profit AS (
    SELECT 
        city, 
        cid, 
        clinic_name,
        profit, 
        RANK() OVER(PARTITION BY city ORDER BY profit DESC) as rn 
    FROM clinic_profit
) 
SELECT 
    city, 
    cid, 
    clinic_name,
    profit 
FROM ranked_profit 
WHERE rn = 1;

-- 5. For each state find the second least profitable clinic for a given month
WITH clinic_revenue AS (
    SELECT 
        cid, 
        SUM(amount) AS revenue 
    FROM clinic_sales 
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY cid
), 
clinic_expense AS (
    SELECT 
        cid, 
        SUM(amount) AS expense 
    FROM expenses 
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021 
    GROUP BY cid
), 
clinic_profit AS (
    SELECT 
        c.state, 
        c.cid, 
        c.clinic_name,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit 
    FROM clinics c 
    LEFT JOIN clinic_revenue r ON c.cid = r.cid 
    LEFT JOIN clinic_expense e ON c.cid = e.cid
), 
ranked_profit AS (
    SELECT 
        state, 
        cid, 
        clinic_name,
        profit, 
        DENSE_RANK() OVER(PARTITION BY state ORDER BY profit ASC) as rn 
    FROM clinic_profit
) 
SELECT 
    state, 
    cid, 
    clinic_name,
    profit 
FROM ranked_profit 
WHERE rn = 2;
