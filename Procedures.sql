CREATE DATABASE IF NOT EXISTS shop_db;
USE shop_db;

-- Products catalog
CREATE TABLE products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(100) NOT NULL,
    category      VARCHAR(50),
    price         DECIMAL(10,2) NOT NULL,
    stock_qty     INT NOT NULL DEFAULT 0
);

-- Customers
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    loyalty_points INT DEFAULT 0
);

-- Orders header
CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    order_date    DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount  DECIMAL(10,2) DEFAULT 0.00,
    status        ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order line items
CREATE TABLE order_items (
    item_id       INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Audit log (triggers will write here automatically)
CREATE TABLE audit_log (
    log_id        INT PRIMARY KEY AUTO_INCREMENT,
    action_type   VARCHAR(50),
    table_name    VARCHAR(50),
    description   TEXT,
    happened_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO products (product_name, category, price, stock_qty) VALUES
('iPhone 15',        'Electronics',  80000.00, 10),
('Samsung TV 55"',   'Electronics',  55000.00,  5),
('Nike Air Max',     'Footwear',      9000.00, 20),
('Levi Jeans',       'Clothing',      3500.00, 15),
('Whirlpool Fridge', 'Appliances',   35000.00,  3);

INSERT INTO customers (customer_name, email, loyalty_points) VALUES
('Sumit Sharma',  'sumit@email.com',  120),
('Priya Mehta',   'priya@email.com',   50),
('Ravi Kumar',    'ravi@email.com',   200),
('Anjali Singh',  'anjali@email.com',   0);

-- Verify
SELECT * FROM products;
SELECT * FROM customers;



-- Procedure 1
DELIMITER $$
CREATE PROCEDURE get_products_by_category(
	IN cat_name VARCHAR(50)
)

BEGIN 
	SELECT 
		product_id,
        product_name,
        stock_qty,
        price
	FROM products
    WHERE category = cat_name;
END $$

DELIMITER ;

CALL get_products_by_category('Electronics');
CALL get_products_by_category('Appliances');


-- Procedure 2
DELIMITER $$
CREATE PROCEDURE get_loyalty_point(
	IN cust_id INT,
    OUT points INT
)
    
BEGIN 
	SELECT loyalty_points
    INTO points
    FROM customers 
    WHERE customer_id = cust_id;
    END $$
    
DELIMITER ;

CALL get_loyalty_point(1, @pts); -- @pts is a session variable 
SELECT @pts AS loyalty_points;
    
    
-- Procedure 3
DELIMITER $$
CREATE PROCEDURE get_discount_tier(
	IN cust_id INT,
    OUT tier_name VARCHAR(20),
    OUT discount_pct DECIMAL(5,2)
)

BEGIN 
	DECLARE pts INT;
    
    SELECT loyalty_points INTO pts
    FROM customers
    WHERE customer_id = cust_id;
    
    IF pts>=200 THEN
    SET tier_name = 'Gold';
    SET discount_pct = 15.00;
    
    ELSEIF pts>=100 THEN
    SET tier_name = 'Silver';
    SET discount_pct = 10.00;
    
	ELSEIF pts<100 THEN
    SET tier_name = 'Bronze';
    SET discount_pct = 5.00;
    
    
	END IF;
END $$
DELIMITER ;

SELECT * FROM customers;
CALL get_discount_tier(1,@tier,@disc);
SELECT @tier AS tier, @disc AS discount_percent;

CALL get_discount_tier(3,@tier,@disc);
SELECT @tier, @disc;



    
    