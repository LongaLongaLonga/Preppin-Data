--Filter the transactions to just look at DSB
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
--Change the date to be the quarter 
--Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) 
--Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter
--Remove the 'Q' from the quarter field and make the data type numeric 
--Join the two datasets together 
--Calculate the Variance to Target 

WITH TRANS_TABLE AS (
SELECT
SPLIT_PART(TRANSACTION_CODE,'-', 1) AS BANK_CODE,
IFF(ONLINE_OR_IN_PERSON = 1, 'Online', 'In-Person') AS ATTENDANCE,
QUARTER(TO_DATE(TRANSACTION_DATE, 'dd/MM/yyyy HH24:MI:SS')) AS QUARTER_Q,
SUM(VALUE) AS TOTAL_VALUE,
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK01
WHERE BANK_CODE = 'DSB'
GROUP BY BANK_CODE, ATTENDANCE, QUARTER_Q
ORDER BY ATTENDANCE ASC, QUARTER_Q ASC
)


SELECT 
ONLINE_OR_IN_PERSON,
TO_CHAR(REPLACE(TARGETS_TABLE.QUARTER, 'Q', '')) AS QUARTER,
TARGET,
TRANS_TABLE.TOTAL_VALUE,
TRANS_TABLE.TOTAL_VALUE - TARGET AS VARIANCE_FROM_TARGET
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK03_TARGETS AS TARGETS_TABLE
UNPIVOT(TARGET FOR QUARTER IN (Q1, Q2, Q3, Q4))
INNER JOIN TRANS_TABLE ON TRANS_TABLE.ATTENDANCE = TARGETS_TABLE.ONLINE_OR_IN_PERSON 
AND TRANS_TABLE.QUARTER_Q = TO_CHAR(REPLACE(TARGETS_TABLE.QUARTER,'Q',''))
