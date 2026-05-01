CREATE DATABASE IF NOT EXISTS txn_lablast;
USE txn_lablast;

-- Create the table
CREATE TABLE bank_accounts (
    account_id    INT PRIMARY KEY AUTO_INCREMENT,
    account_name  VARCHAR(50) NOT NULL,
    account_type  ENUM('savings', 'current') DEFAULT 'savings',
    balance       DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Read Uncommitted 
-- Session A uncommitted data Workbench B is CLI which will do dirty read
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM bank_accounts;
START TRANSACTION;
UPDATE bank_accounts SET balance=balance-10000 WHERE account_id=1;	
ROLLBACK;


-- Read Committed 
-- Session A uncommitted data Workbench B is CLI which will not read the updated values unless committed


SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM bank_accounts;
START TRANSACTION;
UPDATE bank_accounts SET balance = balance + 10000 WHERE account_id=4;
COMMIT;

-- Repeatable Reads
-- We get the same result, even if others commit changes i.e we same the same snapshot of data from the start of transaction & when u access it from outside you get new updated values

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM bank_accounts;
UPDATE bank_accounts SET balance= balance + 500 WHERE account_id =3;
COMMIT;

-- Serializable - Phantom Reads
-- A new row can't appear in a repeated query inside a same transaction until one is reading it once it releases its locks the DML passes 

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

INSERT INTO bank_accounts (account_name, account_type, balance)
VALUES ('Another User', 'savings', 2000.00);

SELECT * FROM bank_accounts; -- No addition done of another user as CLI is reading it







