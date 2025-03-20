-- Create a table called ads_data_new

CREATE TABLE ads_data_new (
    ID SERIAL PRIMARY KEY,
    bulkmail_ad BOOLEAN,
    twitter_ad BOOLEAN,
    instagram_ad BOOLEAN,
    facebook_ad BOOLEAN,
    brochure_ad BOOLEAN
);


-- Create another table called marketing

CREATE TABLE marketing_data (
    ID SERIAL PRIMARY KEY,
    birth_year NUMERIC(4),
    education VARCHAR(20),
    marital_status VARCHAR(20),
    age NUMERIC(5),
    income VARCHAR(10),
    kid_home NUMERIC(5),
    teen_home NUMERIC(5),
    reg_date DATE,
    recency NUMERIC(5),
    liquor_sale NUMERIC(10),
    veg_sale NUMERIC(10),
    nonveg_sale NUMERIC(10),
    fish_sale NUMERIC(10),
    choc_sale NUMERIC(10),
    comm_sale NUMERIC(10),
    num_disc_sale NUMERIC(10),
    num_web_buy NUMERIC(10),
    num_store_purchase NUMERIC(10),
    num_web_visits NUMERIC(10),
    response BOOLEAN,
    complain BOOLEAN,
    country VARCHAR(50),
    count_success VARCHAR(10),
    age_2 NUMERIC(5),
    total_sales NUMERIC(10)
);


-- import data from the csv file for ads_data_new table

COPY ads_data_new 
FROM 'D:\\Course 1 - Data Analytics for Business\\Assignment Excel File\\LSE_DA101_Assignment_data\\ads_data_new.csv' 
DELIMITER ',' 
CSV HEADER;


-- import data from csv file for marketing_data table

COPY marketing_data 
FROM 'D:\\Course 1 - Data Analytics for Business\\Assignment Excel File\\LSE_DA101_Assignment_data\\2market_data.csv' 
DELIMITER ',' 
CSV HEADER;




-- Query # 1: Display both tables' data.

SELECT * FROM public.marketing_data
SELECT * FROM public.ads_data_new

-- Query # 2: The total spend per country

SELECT SUM (m."liquor_sale" + m."choc_sale"+ m."veg_sale" + m."comm_sale" + m."nonveg_sale" + m."fish_sale") AS "total_spend", "country"
FROM public.marketing_data m
GROUP BY  ("country")
ORDER BY "total_spend" DESC;


-- Query # 3: The total spend per product per country

SELECT "country", 
SUM(m."liquor_sale") AS total_liqour_sales, 
SUM(m."fish_sale") AS total_fish_sales, 
SUM(m."veg_sale") AS total_veg_sales, 
SUM(m."nonveg_sale") AS total_non_veg_sales,
SUM(m."choc_sale") AS total_chocolate_sales, 
SUM(m."comm_sale") AS total_commodities_sales
FROM public.marketing_data m
GROUP BY "country"
ORDER BY "country" DESC;



WITH CTE AS(
SELECT "country", 

-- Query # 4: Which products are the most popular in each country

WITH CTE AS (
    SELECT 
        "country", 
        SUM(COALESCE(m."liquor_sale", 0)) AS total_liquor_sales, 
        SUM(COALESCE(m."fish_sale", 0)) AS total_fish_sales, 
        SUM(COALESCE(m."veg_sale", 0)) AS total_veg_sales, 
        SUM(COALESCE(m."nonveg_sale", 0)) AS total_non_veg_sales,
        SUM(COALESCE(m."choc_sale", 0)) AS total_chocolate_sales, 
        SUM(COALESCE(m."comm_sale", 0)) AS total_commodities_sales
    FROM public.marketing_data m
    GROUP BY "country"
)

SELECT 
    "country", 
    "total_liquor_sales", 
    "total_fish_sales",
    "total_veg_sales",
    "total_non_veg_sales", 
    "total_chocolate_sales", 
    "total_commodities_sales",
    
    -- Ranking each product category independently
    RANK() OVER (ORDER BY "total_liquor_sales" DESC) AS rank_liquor,
    RANK() OVER (ORDER BY "total_fish_sales" DESC) AS rank_fish,
    RANK() OVER (ORDER BY "total_veg_sales" DESC) AS rank_veg,
    RANK() OVER (ORDER BY "total_non_veg_sales" DESC) AS rank_non_veg,
    RANK() OVER (ORDER BY "total_chocolate_sales" DESC) AS rank_chocolate,
    RANK() OVER (ORDER BY "total_commodities_sales" DESC) AS rank_commodities

FROM CTE;

	
-- Query # 5: Which products are the most popular based on marital status
	
SELECT "marital_status", 
SUM(m."liquor_sale") AS total_liqour_sales, 
SUM(m."fish_sale") AS total_fish_sales, 
SUM(m."veg_sale") AS total_veg_sales, 
SUM(m."nonveg_sale") AS total_non_veg_sales,
SUM(m."choc_sale") AS total_chocolate_sales, 
SUM(m."comm_sale") AS total_commodities_sales
FROM public.marketing_data m
	
GROUP BY ("marital_status");
	
	
