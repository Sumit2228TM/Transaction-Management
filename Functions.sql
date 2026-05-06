-- Function 1

DELIMITER $$

CREATE FUNCTION apply_discount(
	original_price DECIMAL(10,2),
    discount_pct DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
	RETURN original_price - (original_price * discount_pct/100);
END $$

DELIMITER ;

SELECT
	product_id,
    price AS orginal_price,
    apply_discount(price,10) AS discount_after_10pct,
    apply_discount(price,20) AS discount_after_20pct
FROM products;

