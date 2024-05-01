//REMOVE '-' IN SORT_CODE, JOIN SWIFT AND TRANSACTION TABLES, ADD A FIELD FOR COUNTRY CODE, CREATING IBAN COLUMN

SELECT 
TRANSACTIONS_TABLE.TRANSACTION_ID, 
TRANSACTIONS_TABLE.BANK, 
REPLACE(SORT_CODE,'-','') AS SORT_C, 
TO_CHAR(TRANSACTIONS_TABLE.ACCOUNT_NUMBER) AS ACCOUNT_NUMBER, 
SWIFT_CODE_TABLE.SWIFT_CODE, 
SWIFT_CODE_TABLE.CHECK_DIGITS,     
'GB' AS COUNTRY_CODE, 
CONCAT(COUNTRY_CODE, CHECK_DIGITS, SWIFT_CODE, SORT_C, ACCOUNT_NUMBER) AS IBAN,
FROM TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK02_TRANSACTIONS AS TRANSACTIONS_TABLE
JOIN TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK02_SWIFT_CODES AS SWIFT_CODE_TABLE ON SWIFT_CODE_TABLE.BANK = TRANSACTIONS_TABLE.BANK;