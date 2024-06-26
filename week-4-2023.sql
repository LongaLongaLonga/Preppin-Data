ALTER SESSION SET DATE_INPUT_FORMAT = 'DD/MM/YYYY';

-- UNION ALL THE 12 TABLES WITH ADDITIONAL MONTH COLUMN

WITH FULL_DATA AS (

SELECT * ,
'01' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JANUARY
UNION ALL 

SELECT *,
'02' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_FEBRUARY
UNION ALL 

SELECT *,
'03' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_MARCH
UNION ALL 

SELECT *,
'04' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_APRIL
UNION ALL 


SELECT *,
'05' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_MAY
UNION ALL 

SELECT *,
'06' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JUNE
UNION ALL 

SELECT *,
'07' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JULY
UNION ALL 

SELECT *,
'08' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_AUGUST
UNION ALL 

SELECT *,
'09' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_SEPTEMBER
UNION ALL 

SELECT *,
'10' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_OCTOBER
UNION ALL 

SELECT *,
'11' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_NOVEMBER
UNION ALL 

SELECT *,
'12' as MONTH
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_DECEMBER
)

  -- CREATE A TEMP TABLE WITH NEEDED FIELDS
, STR_TABLE AS (
SELECT
ID,
TO_DATE(CONCAT(JOINING_DAY, '/', MONTH, '/2023')) AS JOINING_DATE,
DEMOGRAPHIC,
VALUE
FROM FULL_DATA 
)

  -- PIVOT THE TABLE
, PIVOTED_TABLE AS (
SELECT 
ID,
JOINING_DATE,
ETHNICITY, 
ACCOUNT_TYPE, 
DATE_OF_BIRTH
FROM STR_TABLE 
PIVOT(MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity','Account Type', 'Date of Birth')) AS P
(ID,
JOINING_DATE,
ETHNICITY, 
ACCOUNT_TYPE, 
DATE_OF_BIRTH) 
)

  -- REMOVE DUPLICATES
SELECT 
ID, 
ETHNICITY, 
ACCOUNT_TYPE, 
DATE_OF_BIRTH, 
JOINING_DATE,
ROW_NUMBER() OVER (PARTITION BY  ID, ETHNICITY, ACCOUNT_TYPE, DATE_OF_BIRTH ORDER BY JOINING_DATE) AS RN
FROM PIVOTED_TABLE
QUALIFY RN = 1

