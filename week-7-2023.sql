-- Challenge can be found: https://preppindata.blogspot.com/2023/02/2023-week-7-flagging-fraudulent.html

WITH ACC_INFO AS (
SELECT 
ACCOUNT_NUMBER,
ACCOUNT_TYPE,
VALUE AS ACCOUNT_HOLDER_ID,
BALANCE_DATE,
BALANCE
FROM PD2023_WK07_ACCOUNT_INFORMATION, LATERAL SPLIT_TO_TABLE(ACCOUNT_HOLDER_ID, ',')  
WHERE ACCOUNT_HOLDER_ID != 'NULL'
) 

, ACC_HOL AS (
SELECT 
AI.ACCOUNT_HOLDER_ID,
NAME, 
DATE_OF_BIRTH,
CONCAT('0', CONTACT_NUMBER) AS CONTACT_NUMBER,
FIRST_LINE_OF_ADDRESS,
ACCOUNT_NUMBER,
ACCOUNT_TYPE,
BALANCE_DATE,
BALANCE
FROM PD2023_WK07_ACCOUNT_HOLDERS AS AH
JOIN ACC_INFO AS AI ON AI.ACCOUNT_HOLDER_ID = AH.ACCOUNT_HOLDER_ID
)

, TRANS AS (
SELECT
TD.TRANSACTION_ID,
ACCOUNT_TO,
ACCOUNT_FROM,
TRANSACTION_DATE,
VALUE,
CANCELLED_ AS CANCELLED 
FROM PD2023_WK07_TRANSACTION_DETAIL AS TD
INNER JOIN PD2023_WK07_TRANSACTION_PATH AS PT ON PT.TRANSACTION_ID = TD.TRANSACTION_ID
WHERE CANCELLED_ != 'Y'
AND VALUE > 1000
)

SELECT 
TRANS.TRANSACTION_ID,
ACCOUNT_TO,
TRANSACTION_DATE,
VALUE,
ACCOUNT_NUMBER,
ACCOUNT_TYPE,
BALANCE_DATE,
BALANCE,
NAME,
DATE_OF_BIRTH,
CONTACT_NUMBER,
FIRST_LINE_OF_ADDRESS
FROM ACC_HOL AS AC
JOIN TRANS ON TRANS.ACCOUNT_FROM =  AC.ACCOUNT_NUMBER
WHERE ACCOUNT_TYPE != 'Platinum'