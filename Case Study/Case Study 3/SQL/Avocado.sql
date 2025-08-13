/*
This guide provides SQL queries to perform the analysis phase of the avocado case study.
SQL is used for data processing and aggregation. The results of these queries would then
be exported to a tool like Excel or Tableau for visualization (the 'Share' phase).

Prerequisites: You have already imported the `avocado.csv` file into a database table
named `avocados`. The steps to import a CSV vary by database system (e.g., PostgreSQL,
MySQL, SQL Server), but the queries below are standard SQL.
*/


-- --- Phase 3: Process (Data Check) ---

-- First, let's check the structure and a few rows of our table.
SELECT * FROM avocados LIMIT 10;

-- Let's check the total row count to ensure data was loaded correctly.
SELECT COUNT(*) FROM avocados; -- Should be 18249

-- Check for NULLs in critical columns.
SELECT
    COUNT(CASE WHEN "Date" IS NULL THEN 1 END) AS null_dates,
    COUNT(CASE WHEN "AveragePrice" IS NULL THEN 1 END) AS null_prices,
    COUNT(CASE WHEN "Total Volume" IS NULL THEN 1 END) AS null_volumes
FROM avocados;
-- For this dataset, all counts should be 0.


-- --- Phase 4: Analyze ---

-- We will write a query to answer each of our key business questions.

-- Question 1: How have avocado prices and sales volume changed over the years?
-- We group by the year extracted from the date.
SELECT
    EXTRACT(YEAR FROM "Date") AS sale_year,
    AVG("AveragePrice") AS average_price,
    SUM("Total Volume") AS total_volume
FROM
    avocados
GROUP BY
    sale_year
ORDER BY
    sale_year;


-- Question 2: Which regions have the highest and lowest prices? Which sell the most?
-- We group by region and order the results to find the top/bottom performers.
-- Top 10 regions by total sales volume
SELECT
    region,
    SUM("Total Volume") AS total_sales
FROM
    avocados
GROUP BY
    region
ORDER BY
    total_sales DESC
LIMIT 10;

-- Top 10 regions by average price
SELECT
    region,
    AVG("AveragePrice") AS avg_price
FROM
    avocados
GROUP BY
    region
ORDER BY
    avg_price DESC
LIMIT 10;


-- Question 3: What is the price and volume difference between conventional and organic avocados?
-- We group by the 'type' column.
SELECT
    type,
    AVG("AveragePrice") AS avg_price,
    SUM("Total Volume") AS total_sales,
    COUNT(*) AS number_of_entries
FROM
    avocados
GROUP BY
    type;


-- Question 4: Are there clear seasonal patterns in avocado prices and demand?
-- We group by the month extracted from the date to see monthly trends.
SELECT
    EXTRACT(MONTH FROM "Date") AS sale_month,
    AVG("Total Volume") AS average_monthly_volume,
    AVG("AveragePrice") AS average_monthly_price
FROM
    avocados
GROUP BY
    sale_month
ORDER BY
    sale_month;
-- The results of this query will show higher volume in months 1, 2, and 5.


-- --- Phase 5 & 6: Share & Act ---

/*
The 'Share' and 'Act' phases happen outside of SQL.

1.  **Export Results**: You would export the results of each of the queries above as a CSV file.
2.  **Visualize**: Import these smaller, aggregated CSVs into a tool like Tableau or Excel to create the final charts (line charts, bar charts, etc.).
3.  **Report**: Combine the visualizations with your written recommendations.

**Example Recommendations based on SQL results:**

* **Based on Query 4 (Seasonality):** "The data shows a clear spike in sales volume in February (Month 2) and May (Month 5). We recommend launching targeted marketing campaigns in the weeks leading up to the Super Bowl and Cinco de Mayo."

* **Based on Query 3 (Type Comparison):** "Organic avocados have a ~55% higher average price but account for a much smaller portion of total volume. This indicates a strong, premium niche. We recommend ensuring organic avocados are always in stock and marketed for their quality, not on price."
*/