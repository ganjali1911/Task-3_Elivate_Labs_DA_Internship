# Task 3 – SQL for Data Analysis
## Data Analyst Internship – Elivate Labs
**Created by: Anjali Gupta**

## Project Overview

This project is part of Task 3 of the Data Analyst Internship at Elivate Labs.
The goal of this task was to use SQL to clean, analyze, and manipulate structured data. Two datasets were used in this project:

- customer_data.csv
- shipping_ecommerce.csv

Both datasets were imported into a MySQL database and analyzed using SQL queries.

## Task Objective

The main objectives of the task were:

- Import and clean real-world datasets inside MySQL
- Use SQL commands such as SELECT, WHERE, ORDER BY, GROUP BY
- Perform JOIN operations (INNER, LEFT, RIGHT)
- Write and execute subqueries
- Apply aggregate functions such as SUM, AVG, COUNT, MIN, and MAX
- Create reusable database views for analysis
- Optimize queries using indexes
- Capture outputs and prepare documentation

## What I Did in This Task

1. Imported Both Datasets into MySQL
- Created a new database called ecommerce_analysis.
- Created two tables: customer_data and shipping_ecommerce.
- Used MySQL Workbench Table Data Import Wizard to upload the CSV files.

2. Cleaned the Data Using SQL
   
Customer Data Cleaning
- Checked for missing or invalid values.
- Converted blank Income values into NULL.
- Replaced missing Income values using average income.
- Standardized inconsistent text values for fields such as Education and Marital Status.
- Confirmed valid date format for Dt_Customer.
- Removed duplicate rows safely.

Shipping Data Cleaning
- Checked for missing and inconsistent entries.
- Standardized fields such as Product Importance, Mode of Shipment, Warehouse Block, and Gender.
- Removed duplicate rows.
- Added a customer_id field to enable joins between the two tables.
- Assigned customer IDs to the shipping dataset for demonstration joins.

3. Performed SQL Query Operations

Completed all required SQL concepts listed in the task.

Select, Where, Order By, Group By
- Retrieved specific columns.
- Applied filters to find customers based on income and spending.
- Sorted data in ascending and descending order.
- Grouped data to count customers by education or shipments by mode.

Joins
- Created INNER JOIN, LEFT JOIN, and RIGHT JOIN queries to link customer and shipping data.
- Demonstrated how each type of join works and when it is used.

Subqueries
- Found customers earning above the average income.
- Identified shipments with above-average discount.
- Retrieved the customer with maximum wine spending.

Aggregate Functions
- Calculated total and average spending.
- Counted shipments per mode.
- Calculated minimum, maximum, and average values for various numeric fields.

4. Created Views for Reusable Analysis

Two SQL views were created:
- customer_spending_summary: Shows each customer’s total spending across multiple categories.
- shipment_performance: Stores average discount, average weight, and total shipments for each shipment mode.

These views help simplify future analysis without rewriting long SQL queries.

5. Query Optimization Using Indexes

Created indexes to improve performance:
- Index on shipping_ecommerce.customer_id for faster joins
- Index on customer_data.Income for faster filtering
- Index on shipping_ecommerce.Mode_of_Shipment for faster grouping and filtering

Verified all indexes using SHOW INDEXES.

## Files Included
- SQL Script: Task-3_Elivate_Labs_DA_Internship.sql
- Dataset: customer_data.csv
- Dataset: shipping_ecommerce.csv
- Output screenshots: TASK 3_DA_INTERNSHIP_ELIVATE LABS_Screenshots.pdf
- Documentation: README.md

## Summary

In this task, I performed complete data cleaning, analysis, and optimization using SQL.
I used practical SQL concepts such as joins, filtering, aggregation, views, and indexing to build a full analysis workflow.
This task strengthened my understanding of how databases are used in real-world data analyst roles and how SQL plays an essential role in cleaning and analyzing structured data.

## Author
**Anjali Gupta**  
Data Analyst Intern

