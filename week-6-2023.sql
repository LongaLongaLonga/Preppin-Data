--https://preppindata.blogspot.com/2023/02/2023-week-6-dsb-customer-ratings.html

WITH PRE_PIVOT AS (
SELECT 
CUSTOMER_ID, 
SPLIT_PART(PIV_COL, '___', 1 ) AS DEVICE,
SPLIT_PART(PIV_COL, '___', 2 ) AS FACTOR,
VALUE
FROM 
(

SELECT * 
FROM PD2023_WK06_DSB_CUSTOMER_SURVEY
) AS SOURCE
UNPIVOT (
VALUE FOR PIV_COL IN (MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, ONLINE_INTERFACE___OVERALL_RATING)) AS PIVOTED_TABLE
) 

, POST_PIVOT AS (
SELECT * 
FROM PRE_PIVOT
PIVOT (SUM(VALUE) FOR DEVICE IN ('MOBILE_APP', 'ONLINE_INTERFACE'))
WHERE FACTOR != 'OVERALL_RATING'
)

, CAT_TABLE AS (
SELECT
CUSTOMER_ID,
AVG("'MOBILE_APP'") AS AVG_MOBILE,
AVG("'ONLINE_INTERFACE'") AS AVG_ONLINE,
AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") AS DIFF_IN_RATINGS,
CASE 
    WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= 2 THEN 'MOBILE APP SUPERFAN'
    WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= 1 THEN 'MOBILE APP FANS'
    WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") <= -2 THEN 'ONLINE INTERFACE SUPERFAN'
    WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") <= -1 THEN 'ONLINE INTERFACE FAN'
    ELSE 'NEUTRAL'
    END AS CATEGORY
FROM POST_PIVOT
GROUP BY CUSTOMER_ID
)

SELECT 
CATEGORY AS PREFERANCE,
ROUND(COUNT(CUSTOMER_ID) / (SELECT COUNT(CUSTOMER_ID) FROM CAT_TABLE)*100, 1) AS PERCENT_CUSTOMERS
FROM CAT_TABLE
GROUP BY CATEGORY
