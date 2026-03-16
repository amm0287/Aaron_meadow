s/* ============================================================
   ESG Financial Data Analysis
   Author: Aaron Meadow
   Purpose: Analyze ESG performance, financial metrics, and 
   environmental impact across industries using SQL.
   Dataset: company_esg_financial_dataset
   ============================================================ */


/* ============================================================
   SECTION 1: High ESG Performing Companies
   Objective:
   Identify companies with ESG scores above 95.
   ============================================================ */

SELECT "CompanyName",
MAX("ESG_Overall") AS "Highest ESG Score"
FROM "company_esg_financial_dataset"
WHERE "ESG_Overall" > 95
GROUP BY "CompanyName"
ORDER BY "CompanyName";


/* ============================================================
   SECTION 2: Median Growth Rate by Region
   Objective:
   Calculate the median company growth rate across regions
   using percentile calculations.
   ============================================================ */

SELECT "Region",
PERCENTILE_CONT(.50) 
WITHIN GROUP (ORDER BY "GrowthRate") AS "Median Growth Rate"
FROM "company_esg_financial_dataset"
WHERE "GrowthRate" IS NOT NULL
GROUP BY "Region";


/* ============================================================
   SECTION 3: Median Profit Margin by Industry
   Objective:
   Identify industries with the highest median profitability.
   ============================================================ */

SELECT "Industry",
PERCENTILE_CONT(.50)
WITHIN GROUP (ORDER BY "ProfitMargin") AS "Median Profit"
FROM "company_esg_financial_dataset"
WHERE "ProfitMargin" > 38
GROUP BY "Industry"
ORDER BY "Median Profit" DESC;


/* ============================================================
   SECTION 4: Companies With Target Revenue Range
   Objective:
   Identify companies with average revenue between
   3900 and 4000.
   ============================================================ */

SELECT "CompanyName",
AVG("Revenue") AS "Average Revenue"
FROM "company_esg_financial_dataset"
GROUP BY "CompanyName"
HAVING AVG("Revenue") BETWEEN 3900 AND 4000;


/* ============================================================
   SECTION 5: Environmental Impact by Industry (2025)
   Objective:
   Compare carbon emissions, water usage, and energy
   consumption across industries.
   ============================================================ */

SELECT "Industry",
"Year",
AVG("CarbonEmissions") AS "Average Carbon",
AVG("WaterUsage") AS "Average Water Use",
AVG("EnergyConsumption") AS "Average Energy Consumption"
FROM "company_esg_financial_dataset"
WHERE "Year" = 2025
AND "CarbonEmissions" >= 230000
AND "WaterUsage" >= 230000
AND "EnergyConsumption" >= 230000
GROUP BY "Industry", "Year"
ORDER BY "Industry" DESC;


/* ============================================================
   SECTION 6: ESG Score Analysis by Industry
   Objective:
   Evaluate average environmental, social, and governance
   scores across industries.
   ============================================================ */

SELECT "Industry",
AVG(COALESCE("ESG_Social",0)) AS "Average Social Score",
AVG(COALESCE("ESG_Environmental",0)) AS "Average Environmental Score",
AVG(COALESCE("ESG_Governance",0)) AS "Average Governance Score"
FROM "company_esg_financial_dataset"
WHERE "ESG_Environmental" > 90
AND "ESG_Social" > 90
AND "ESG_Governance" > 90
GROUP BY "Industry"
ORDER BY "Industry" DESC;


/* ============================================================
   SECTION 7: Industry ESG Comparison Using CTE
   Objective:
   Compare individual company ESG scores to the
   average ESG score within their industry.
   ============================================================ */

WITH Industry_ESG AS (
SELECT "Industry",
AVG("ESG_Overall") AS avg_esg
FROM "company_esg_financial_dataset"
GROUP BY "Industry"
)
SELECT
c."CompanyName",
c."Industry",
c."ESG_Overall",
i.avg_esg,
c."ESG_Overall" - i.avg_esg AS "ESG_vs_Industry"
FROM "company_esg_financial_dataset" c
JOIN Industry_ESG i
ON c."Industry" = i."Industry"
ORDER BY "ESG_vs_Industry" DESC;