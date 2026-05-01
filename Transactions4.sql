USE txn_lablast;

-- Shared Locks
-- Multiple txn can hold a shared lock on same row but cant do any DML on it unless the other releases their locks

START TRANSACTION;
SELECT * FROM bank_accounts WHERE account_id = 4 LOCK IN SHARE MODE;
COMMIT;

-- Exclusive Locks
-- Only one txn can hold an exclusive lock on a row at a time, other session can't read or modify it's data unless the X lock is released

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM bank_accounts WHERE account_id=3 FOR UPDATE; -- If other sesion even tries to read it cant as we are using repeatable reads
UPDATE bank_accounts SET balance = balance - 5000 WHERE account_id = 3;
SELECT * FROM bank_accounts;
COMMIT;

