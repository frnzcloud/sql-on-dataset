
– How many *unique* companies are in this dataset?

SELECT 
  COUNT(DISTINCT name) AS total_unique_companies
  FROM tutorial.crunchbase_companies;


--There are 27,326 unique companies in this dataset. 

– Which 10 countries have the most companies?

SELECT 
  country_code,
  COUNT(name) AS Companies
FROM tutorial.crunchbase_companies
GROUP BY country_code
ORDER BY Companies DESC
LIMIT 11;

–Due to our 2nd spot being null, assuming this means ~1800 companies in this dataset have a null country_code, the top 10 countries with the most companies are:

–United States of America
–United Kingdom
–Canada
–Germany
–France
–India
–Israel
–Spain
–China
–Sweden


– What are the top 5 most common company categories (category_code)?


SELECT
  category_code AS Common,
  COUNT(category_code) AS total
FROM tutorial.crunchbase_companies
GROUP BY category_code 
ORDER BY total DESC
LIMIT 5;



–software
–biotech
–web
–mobile
–enterprise

–What is the total funding (funding_total_usd) for all companies in the 'software' category?

SELECT
  SUM(funding_total_usd) AS total_funds
FROM 
  tutorial.crunchbase_companies
WHERE 
  category_code = 'software' AND funding_total_usd IS NOT NULL;



–33412610834




–What is the average funding amount for companies that are now 'acquired' versus those that –are 'operating'?



SELECT
    status,
    AVG(funding_total_usd) AS average_funding
FROM
    tutorial.crunchbase_companies
WHERE
    status IN ('acquired', 'operating')  
    AND funding_total_usd IS NOT NULL    
GROUP BY 
    status;




–ac - 23147704.2296
–op - 12830518.1645







–Which companies received the highest amount of funding? List the top 5.


SELECT 
  name as Companies,
  funding_total_usd as Funding
FROM 
  tutorial.crunchbase_companies
WHERE funding_total_usd IS NOT NULL
ORDER BY Funding DESC
LIMIT 5;






–Clearwire
–Verizon Communications, Inc.
–sigmacare
–Facebook
–Carestream


–Who are the top 5 investors (by number of investments) in companies that eventually get
–acquired?

SELECT 
  i.investor_name,
  COUNT(funded_month) as Number_of_Investments
FROM 
  tutorial.crunchbase_investments as i
INNER JOIN 
  tutorial.crunchbase_companies as c
ON 
  i.company_permalink = c.permalink
WHERE 
  c.status = 'acquired'
GROUP BY 
  i.investor_name
ORDER BY Number_of_Investments DESC 
LIMIT 5;







–Categorize companies from the crunchbase_companies table into funding tiers


SELECT 
  CASE 
    WHEN funding_total_usd <= 5000000 THEN 'Seed'
    WHEN funding_total_usd <= 100000000 THEN 'Venture'
    ELSE 'Growth Stage'
  END AS Funding_Tier, 
  COUNT(*) AS Total_Companies
FROM 
  tutorial.crunchbase_companies
WHERE funding_total_usd IS NOT NULL
GROUP BY Funding_Tier
ORDER BY Total_Companies DESC
LIMIT 10;



–For the 5 companies that had the highest total funding (funding_total_usd), how many unique –investors did each of them have?


WITH top_companies AS (
  SELECT 
    permalink, 
    name
  FROM 
    tutorial.crunchbase_companies
  WHERE 
    funding_total_usd  IS NOT NULL
  ORDER BY funding_total_usd DESC 
  LIMIT 6
)

SELECT 
  t1.name, 
  COUNT(DISTINCT t2.investor_name) AS unique_investors
FROM 
  tutorial.crunchbase_investments as t2
LEFT JOIN 
  top_companies as t1
ON 
  t2.company_permalink = t1.permalink
WHERE 
  t1.name IS NOT NULL
GROUP BY 
  t1.name 
ORDER BY 
  unique_investors DESC;

