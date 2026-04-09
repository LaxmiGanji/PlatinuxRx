-- 1. For every user in the system, get the user_id and last booked room_no
WITH RankedRooms AS (
    SELECT 
        user_id, 
        room_no,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY booking_date DESC) as rn
    FROM bookings
)
SELECT u.user_id, r.room_no
FROM users u
LEFT JOIN RankedRooms r ON u.user_id = r.user_id AND r.rn = 1;

-- 2. Get booking_id and total billing amount of every booking created in November, 2021
SELECT 
    b.booking_id, 
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01' AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;

-- 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount > 1000
SELECT 
    bc.bill_id, 
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01' AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- 4. Determine the most ordered and least ordered item of each month of year 2021
WITH MonthlyQuantities AS (
    SELECT 
        EXTRACT(MONTH FROM bill_date) AS month_num,
        item_id,
        SUM(item_quantity) AS total_ordered
    FROM booking_commercials
    WHERE EXTRACT(YEAR FROM bill_date) = 2021
    GROUP BY EXTRACT(MONTH FROM bill_date), item_id
),
RankedItems AS (
    SELECT 
        month_num,
        item_id,
        RANK() OVER(PARTITION BY month_num ORDER BY total_ordered DESC) as desc_rank,
        RANK() OVER(PARTITION BY month_num ORDER BY total_ordered ASC) as asc_rank
    FROM MonthlyQuantities
)
SELECT 
    r.month_num,
    i.item_name,
    CASE 
        WHEN r.desc_rank = 1 THEN 'Most Ordered'
        WHEN r.asc_rank = 1 THEN 'Least Ordered'
    END AS order_status
FROM RankedItems r
JOIN items i ON r.item_id = i.item_id
WHERE r.desc_rank = 1 OR r.asc_rank = 1
ORDER BY r.month_num;

-- 5. Find the customers with the second highest bill value of each month of year 2021
WITH MonthlyBills AS (
    SELECT 
        EXTRACT(MONTH FROM bc.bill_date) AS month_num,
        bc.bill_id,
        b.user_id,
        SUM(bc.item_quantity * i.item_rate) AS total_bill_value
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bc.bill_date) = 2021
    GROUP BY EXTRACT(MONTH FROM bc.bill_date), bc.bill_id, b.user_id
),
RankedBills AS (
    SELECT 
        month_num,
        user_id,
        total_bill_value,
        DENSE_RANK() OVER(PARTITION BY month_num ORDER BY total_bill_value DESC) as rnk
    FROM MonthlyBills
)
SELECT 
    r.month_num,
    u.name,
    r.total_bill_value
FROM RankedBills r
JOIN users u ON r.user_id = u.user_id
WHERE r.rnk = 2;
