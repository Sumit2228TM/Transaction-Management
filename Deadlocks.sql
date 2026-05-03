USE txn_lablast;

START TRANSACTION;
UPDATE bank_accounts SET balance = balance + 1000 WHERE account_id = 1;

UPDATE bank_accounts SET balance = balance + 100 WHERE account_id = 2;

COMMIT;

UPDATE bank_accounts SET balance = 50000 WHERE account_id = 1;
UPDATE bank_accounts SET balance = 30000 WHERE account_id = 2;

