-- Customer & Shipping Data Analysis using SQL

-- Creating a new database for the project
CREATE DATABASE ecommerce_analysis;
-- Selecting the database to use for all future queries
USE ecommerce_analysis;

-- Creating the shipping_ecommerce table
-- This table contains shipping-related data such as 
-- customer interactions, shipment mode, product importance, and delivery class.
-- 'id' is added as a primary key for uniqueness.
CREATE TABLE shipping_ecommerce (
    id INT AUTO_INCREMENT PRIMARY KEY,			-- Unique identifier for each row
    Customer_care_calls INT,					-- Number of customer care calls
    Customer_rating INT,						-- Rating given by the customer
    Prior_purchases INT,						-- Number of prior purchases
    Discount_offered INT,						-- Discount applied
    Weight_in_gms INT,						    -- Weight of the product
    Warehouse_block VARCHAR(5),					-- Warehouse block (A-F)
    Mode_of_Shipment VARCHAR(20),				-- Mode (Ship/Road/Flight)
    Product_importance VARCHAR(20),				-- Importance level (low/medium/high)
    Gender CHAR(1),								-- Customer gender (M/F)
    Class INT									-- Whether product reached on time (0/1)
);

-- Creating the customer_data table 
-- This table stores demographic and purchasing details of customers.
-- 'ID' is the primary key since each customer is unique.
CREATE TABLE customer_data (
    ID INT PRIMARY KEY,                     -- Unique customer ID
    Year_Birth INT,                         -- Birth year
    Education VARCHAR(50),                  -- Education level
    Marital_Status VARCHAR(50),             -- Marital status
    Income INT,                             -- Annual income
    Kidhome INT,                            -- Number of kids at home
    Teenhome INT,                           -- Number of teenagers at home
    Dt_Customer DATE,                       -- Date customer joined
    Recency INT,                            -- Days since last purchase
    MntWines INT,                           -- Amount spent on wine
    MntFruits INT,                          -- Amount spent on fruits
    MntMeatProducts INT,                    -- Amount spent on meat
    MntFishProducts INT,                    -- Amount spent on fish
    MntSweetProducts INT,                   -- Amount spent on sweets
    MntGoldProds INT,                       -- Amount spent on gold products
    NumDealsPurchases INT,                  -- Number of deal purchases
    NumWebPurchases INT,                    -- Number of web purchases
    NumCatalogPurchases INT,                -- Number of catalog purchases
    NumStorePurchases INT,                  -- Number of store purchases
    NumWebVisitsMonth INT,                  -- Number of website visits per month
    AcceptedCmp3 INT,                       -- Campaign acceptance flags
    AcceptedCmp4 INT,
    AcceptedCmp5 INT,
    AcceptedCmp1 INT,
    AcceptedCmp2 INT,
    Complain INT,                            -- Complaint flag
    Z_CostContact INT,                       -- Company cost metric
    Z_Revenue INT,                           -- Company revenue metric
    Response INT                             -- Campaign response indicator
);

-- Viewing the imported data
SELECT * FROM customer_data;
SELECT * FROM shipping_ecommerce;


-- CLEANING customer_data TABLE

-- 1. CHECKING FOR NULLs OR EMPTY VALUES IN IMPORTANT COLUMNS

-- This query counts how many rows have missing Income values.
-- Income might be NULL (not filled) or an empty string (''),
-- so we check for both cases.
SELECT COUNT(*) AS missing_income
FROM customer_data
WHERE Income IS NULL OR Income = '';

-- This query checks if any customer has a missing date.
-- Dt_Customer stores the date the customer joined.
-- If the date failed to load or was invalid, it becomes NULL.
SELECT COUNT(*) AS missing_dates
FROM customer_data
WHERE Dt_Customer IS NULL;


-- 2. Converting blank Income values to NULL
-- Some rows have Income = '' (empty string) from the CSV import.
-- MySQL cannot calculate averages on empty strings.
-- So we convert all empty Income values into proper NULL.
UPDATE customer_data
SET Income = NULL
WHERE Income = '';


-- 3. Fixing missing Income values by filling them with the average income
-- MySQL does not allow updating a table while selecting from the SAME table directly.
-- Therefore, we place the AVG() value inside a derived table (a temporary subquery),
-- which avoids the error problem.

UPDATE customer_data
SET Income = (
    -- This subquery selects the average income,
    -- but wraps it inside another SELECT to make it safe for MySQL.
    SELECT avg_val FROM (
        SELECT AVG(Income) AS avg_val 
        FROM customer_data
    ) AS temp
)
-- This ensures we only update the rows where Income is NULL.
WHERE Income IS NULL;


-- 4. Standardizing Education categories 
-- This cleans inconsistent spellings or formats in the Education column
-- and ensures all values follow one standard format.

UPDATE customer_data
SET Education = 'Graduation'
WHERE LOWER(Education) = 'graduation';

UPDATE customer_data
SET Education = 'Master'
WHERE LOWER(Education) = 'master';

UPDATE customer_data
SET Education = 'PhD'
WHERE LOWER(Education) = 'phd';

UPDATE customer_data
SET Education = 'Basic'
WHERE LOWER(Education) = 'basic';

-- Fixing inconsistent versions of "2nd Cycle" into one correct format
UPDATE customer_data
SET Education = '2nd Cycle'
WHERE Education IN ('2n Cycle', '2nd cycle', '2N cycle');


-- 5. Standardizing Marital_Status
-- Making all marital status values consistent and correcting spelling variations.

UPDATE customer_data
SET Marital_Status = 'Single'
WHERE LOWER(Marital_Status) IN ('single','singl');   -- Fixing typo “singl”

UPDATE customer_data
SET Marital_Status = 'Married'
WHERE LOWER(Marital_Status) = 'married';

UPDATE customer_data
SET Marital_Status = 'Divorced'
WHERE LOWER(Marital_Status) = 'divorced';

UPDATE customer_data
SET Marital_Status = 'Together'
WHERE LOWER(Marital_Status) = 'together';

UPDATE customer_data
SET Marital_Status = 'Widow'
WHERE LOWER(Marital_Status) IN ('widow','widowed');   -- Fixing variations


-- -- CLEANING shipping_ecommerce TABLE

-- 1. Checking missing values in important columns
-- This query counts how many rows have blank or NULL values 
-- in Warehouse_block, Mode_of_Shipment, Product_importance, and Gender.
SELECT 
    SUM(CASE WHEN Warehouse_block = '' OR Warehouse_block IS NULL THEN 1 ELSE 0 END) AS missing_warehouse,
    SUM(CASE WHEN Mode_of_Shipment = '' OR Mode_of_Shipment IS NULL THEN 1 ELSE 0 END) AS missing_mode,
    SUM(CASE WHEN Product_importance = '' OR Product_importance IS NULL THEN 1 ELSE 0 END) AS missing_importance,
    SUM(CASE WHEN Gender = '' OR Gender IS NULL THEN 1 ELSE 0 END) AS missing_gender
FROM shipping_ecommerce;


-- 2. Standardizing Product Importance values
-- Converts all importance values to lowercase so that categories 
-- such as High, HIGH, high are stored in one consistent format: "high".
UPDATE shipping_ecommerce
SET Product_importance = LOWER(Product_importance);


-- 3. Standardizing Mode_of_Shipment values
-- This ensures all shipment modes are stored in consistent format.
-- It converts variations like SHIP, ship, Ship into "Ship".
UPDATE shipping_ecommerce
SET Mode_of_Shipment = 
    CASE 
        WHEN LOWER(Mode_of_Shipment) = 'ship' THEN 'Ship'
        WHEN LOWER(Mode_of_Shipment) = 'road' THEN 'Road'
        WHEN LOWER(Mode_of_Shipment) = 'flight' THEN 'Flight'
        ELSE Mode_of_Shipment  -- If value is something unexpected, keep it as is
    END;


-- 4. Standardizing Warehouse Block values (A–F)
-- Ensures that all warehouse block codes are stored in uppercase format 
-- so there is consistency (A, B, C, D, E, F instead of a mix like 'a', 'B', 'c').
UPDATE shipping_ecommerce
SET Warehouse_block = UPPER(Warehouse_block);


-- 5. Standardize Gender (M, F)
-- Converts all gender values to uppercase to avoid mismatches like 'm', 'F', 'f'.
UPDATE shipping_ecommerce
SET Gender = UPPER(Gender);


-- 6. Remove suplicates from shipping_ecommerce
-- 1: Create a temporary table storing ONLY the IDs we want to KEEP.
-- We keep the MIN(id) for each duplicate group.
CREATE TEMPORARY TABLE keep_ids AS
SELECT MIN(id) AS keep_id
FROM shipping_ecommerce
GROUP BY 
    Customer_care_calls,
    Customer_rating,
    Prior_purchases,
    Discount_offered,
    Weight_in_gms;

-- 2: Delete all rows that are NOT in the keep list.
-- This removes duplicate rows safely.
DELETE FROM shipping_ecommerce
WHERE id NOT IN (SELECT keep_id FROM keep_ids);

-- 3. Check if duplicates are gone.
SELECT 
    Customer_care_calls,
    Customer_rating,
    Prior_purchases,
    Discount_offered,
    Weight_in_gms,
    COUNT(*) AS cnt
FROM shipping_ecommerce
GROUP BY 
    Customer_care_calls,
    Customer_rating,
    Prior_purchases,
    Discount_offered,
    Weight_in_gms
HAVING COUNT(*) > 1;

-- CREATING A CONNECTION COLUMN FOR JOINS 
-- Adding a customer_id column into shipping_ecommerce table 
-- so that the two tables can be joined.
ALTER TABLE shipping_ecommerce
ADD COLUMN customer_id INT;

-- Assigning random customer IDs from customer_data into shipping_ecommerce
-- This creates a fake mapping only for JOIN demonstrations.
UPDATE shipping_ecommerce 
SET customer_id = (
    SELECT ID 
    FROM customer_data 
    ORDER BY RAND() 
    LIMIT 1
);



-- Tasks: 
-- 1. SELECT, WHERE, ORDER BY, GROUP BY Queries


-- 1.1 example for 'SELECT'
-- This query selects specific columns (ID, Education, Income)
-- from the customer_data table and limits the output to the first 10 rows.
SELECT ID, Education, Income
FROM customer_data
LIMIT 10;


-- 1.2 example for 'WHERE'
-- This query filters customers by Income.
-- It only returns customers whose income is greater than 1,00,000.
SELECT ID, Income, Marital_Status
FROM customer_data
WHERE Income > 100000;


-- 1.3 example for 'ORDER BY'
-- This query sorts customers based on their wine spending.
-- It orders results from highest to lowest (DESC) and shows the top 10.
SELECT ID, MntWines
FROM customer_data
ORDER BY MntWines DESC
LIMIT 10;


-- 1.4 example for 'GROUP BY'
-- This query groups all customers by their Education level.
-- For each education group, it counts how many customers belong to that group.
SELECT Education, COUNT(*) AS total_customers
FROM customer_data
GROUP BY Education;


-- 2. JOINS (INNER, LEFT, RIGHT)


-- 2.1 example for 'INNER JOIN'
-- This returns only rows where a customer exists in both tables.
-- A match happens when customer_data.ID = shipping_ecommerce.customer_id.
-- If a shipment does not have a customer_id, it will not appear in the result.
SELECT c.ID, c.Income, s.Mode_of_Shipment
FROM customer_data c
INNER JOIN shipping_ecommerce s
ON c.ID = s.customer_id
LIMIT 20;


-- 2.2 example for 'LEFT JOIN'
-- Left join returns ALL customers from customer_data.
-- If a customer has no shipment, shipment columns (Mode_of_Shipment) will show NULL.
SELECT c.ID, c.Education, s.Mode_of_Shipment
FROM customer_data c
LEFT JOIN shipping_ecommerce s
ON c.ID = s.customer_id;


-- 2.3 example for 'RIGHT JOIN'
-- Right join returns ALL shipments from shipping_ecommerce.
-- If a shipment's customer_id does not match any customer, customer fields (Income) will be NULL.
SELECT s.id AS shipment_id, s.Mode_of_Shipment, c.Income
FROM shipping_ecommerce s
RIGHT JOIN customer_data c
ON s.customer_id = c.ID;


-- 3. Subqueries


-- 3.1 Customers earning above-average income
-- The inner query (subquery) calculates the average income of all customers.
-- The outer query selects only those customers whose income is higher than that average.
SELECT ID, Income
FROM customer_data
WHERE Income > (SELECT AVG(Income) FROM customer_data);


-- 3.2 Shipments with discounts above the average
-- The subquery finds the average discount across all shipments.
-- The main query returns shipments where the discount is higher than that average.
SELECT id, Discount_offered
FROM shipping_ecommerce
WHERE Discount_offered > (
    SELECT AVG(Discount_offered)
    FROM shipping_ecommerce
);


-- 3.3 Customer with maximum wine purchase 
-- The subquery retrieves the highest value of wine spending from all customers.
-- The outer query returns the customer who has that highest spending.
SELECT ID, MntWines
FROM customer_data
WHERE MntWines = (
    SELECT MAX(MntWines) 
    FROM customer_data
);


-- 4. Aggregate Functions (SUM, AVG, COUNT, MIN, MAX)


-- 4.1 Total Revenue Proxy (Wine + Meat + Gold)
-- This query calculates an estimated total spending value for each customer.
-- It adds wine spending, meat spending, and gold product spending.
-- The result is sorted from highest to lowest spenders.
SELECT 
    ID,
    (MntWines + MntMeatProducts + MntGoldProds) AS Total_Spending
FROM customer_data
ORDER BY Total_Spending DESC;


-- 4.2 Average shipment weight
-- This query uses AVG() to find the average weight of all shipments.
-- It returns a single number representing the average weight.
SELECT AVG(Weight_in_gms) AS avg_weight
FROM shipping_ecommerce;


-- 4.3 Number of shipments per mode
-- This query groups shipments by their Mode_of_Shipment.
-- COUNT(*) is used to count how many shipments belong to each mode.
SELECT Mode_of_Shipment, COUNT(*) AS total_shipments
FROM shipping_ecommerce
GROUP BY Mode_of_Shipment;


-- 5. Create Views for Analysis
-- Views help store pre-calculated or commonly used query results
-- so you can reuse them easily later without rewriting the queries.


-- 5.1 Customer Spending Summary View
-- This view creates a summary of customer spending.
-- It adds up all product-related spending fields for each customer.
-- The view can be used later for reporting or further analysis.
CREATE VIEW customer_spending_summary AS
SELECT 
    ID,
    Income,
    (MntWines + MntFruits + MntMeatProducts +
     MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Spending
FROM customer_data;


-- 5.2 Shipment Performance View
-- This view summarizes shipment performance by mode of shipment.
-- It calculates:
--   - average discount
--   - average weight
--   - total number of shipments
-- The results are grouped by shipment mode (Ship, Road, Flight).
CREATE VIEW shipment_performance AS
SELECT 
    Mode_of_Shipment,
    AVG(Discount_offered) AS avg_discount,
    AVG(Weight_in_gms) AS avg_weight,
    COUNT(*) AS total_shipments
FROM shipping_ecommerce
GROUP BY Mode_of_Shipment;


-- 5.3 Check the views
-- These queries display the first few rows from each view.
-- They help you confirm that the views were created correctly.
SELECT * FROM customer_spending_summary LIMIT 10;
SELECT * FROM shipment_performance;



-- 6. Optimize Queries with Indexes
-- Indexes improve query performance by helping MySQL quickly
-- locate rows without scanning the entire table.
-- Below we create three indexes and immediately verify each one.


-- 6.1 Index for JOIN operations
-- Creating an index on the customer_id column in shipping_ecommerce.
-- This helps speed up queries that JOIN customer_data and shipping_ecommerce
-- using ON customer_data.ID = shipping_ecommerce.customer_id.
CREATE INDEX idx_customer_id ON shipping_ecommerce(customer_id);

-- View the index details to confirm it was created successfully.
SHOW INDEXES FROM shipping_ecommerce
WHERE Key_name = 'idx_customer_id';


-- 6.2 Index for filtering by income

-- Creating an index on the Income column in customer_data.
-- This speeds up queries such as:
-- SELECT * FROM customer_data WHERE Income > 50000;
CREATE INDEX idx_income ON customer_data(Income);

-- Verify the index was created.
SHOW INDEXES FROM customer_data
WHERE Key_name = 'idx_income';

-- 6.3 Index for shipment mode-related filtering or grouping
-- Creating an index on Mode_of_Shipment in shipping_ecommerce.
-- This helps queries like:
-- SELECT COUNT(*) FROM shipping_ecommerce GROUP BY Mode_of_Shipment;
CREATE INDEX idx_mode ON shipping_ecommerce(Mode_of_Shipment);

-- Verify the index was created.
SHOW INDEXES FROM shipping_ecommerce
WHERE Key_name = 'idx_mode';

-- View all indexes in each table
-- Shows all indexes present in shipping_ecommerce table.
SHOW INDEXES FROM shipping_ecommerce;

-- Shows all indexes present in customer_data table.
SHOW INDEXES FROM customer_data;



