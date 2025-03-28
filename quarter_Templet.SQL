CREATE VIEW weekly_amounts AS
SELECT 
    category,
    amount_per_week AS W1,
    amount_per_week AS W2,
    amount_per_week AS W3,
    amount_per_week AS W4,
    amount_per_week AS W5,
    amount_per_week AS W6,
    amount_per_week AS W7,
    amount_per_week AS W8,
    amount_per_week AS W9,
    amount_per_week AS W10,
    amount_per_week AS W11,
    amount_per_week AS W12,
    amount_per_week AS W13
FROM customers_Target_data;
