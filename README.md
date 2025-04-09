# SQL Marketing Analysis Project

This README documents the SQL queries and analysis completed as part of a marketing and advertisement dataset project. The focus was on identifying spending patterns, product popularity, and the effectiveness of ad platforms based on customer attributes.

## 1. Two Tables were created

### 1.1 `ads_data_new`

```sql
CREATE TABLE ads_data_new (
    ID SERIAL PRIMARY KEY,
    bulkmail_ad BOOLEAN,
    twitter_ad BOOLEAN,
    instagram_ad BOOLEAN,
    facebook_ad BOOLEAN,
    brochure_ad BOOLEAN
);
```

### 1.2 `marketing_data`

```sql
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
```

## 2. Data was imported from csv files

```sql
COPY ads_data_new
FROM 'D:\\...\\ads_data_new.csv'
DELIMITER ','
CSV HEADER;

COPY marketing_data
FROM 'D:\\...\\2market_data.csv'
DELIMITER ','
CSV HEADER;
```

## 3. Ran SQL Queries & produced Insights

### Query 1: Display both tables

```sql
SELECT * FROM public.marketing_data;
SELECT * FROM public.ads_data_new;
```

### Query 2: Total spend per country

```sql
SELECT SUM(m."liquor_sale" + m."choc_sale" + m."veg_sale" + m."comm_sale" + m."nonveg_sale" + m."fish_sale") AS "total_spend", "country"
FROM public.marketing_data m
GROUP BY "country"
ORDER BY "total_spend" DESC;
```
![Chart 1](https://github.com/abbass97/2Market-SQL-Queries/blob/main/total_spend_per_country.png)

### Query 3: Total spend per product per country

```sql
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
```
![Chart 1](https://github.com/abbass97/2Market-SQL-Queries/blob/main/total_spend_pp_country.png)

### Query 4: Most popular products in each country (using ranking)

```sql
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
    *,
    RANK() OVER (ORDER BY total_liquor_sales DESC) AS rank_liquor,
    RANK() OVER (ORDER BY total_fish_sales DESC) AS rank_fish,
    RANK() OVER (ORDER BY total_veg_sales DESC) AS rank_veg,
    RANK() OVER (ORDER BY total_non_veg_sales DESC) AS rank_non_veg,
    RANK() OVER (ORDER BY total_chocolate_sales DESC) AS rank_chocolate,
    RANK() OVER (ORDER BY total_commodities_sales DESC) AS rank_commodities
FROM CTE;
```
![Chart 1](https://github.com/abbass97/2Market-SQL-Queries/blob/main/popular_product_country.png)


### Query 5: Most popular products by marital status

```sql
SELECT "marital_status",
SUM(m."liquor_sale") AS total_liqour_sales,
SUM(m."fish_sale") AS total_fish_sales,
SUM(m."veg_sale") AS total_veg_sales,
SUM(m."nonveg_sale") AS total_non_veg_sales,
SUM(m."choc_sale") AS total_chocolate_sales,
SUM(m."comm_sale") AS total_commodities_sales
FROM public.marketing_data m
GROUP BY "marital_status";
```
![Chart 1](https://github.com/abbass97/2Market-SQL-Queries/blob/main/popular_product_marital_status.png)

##  Interpretation

Results and visual analysis are included in the attached image files. Key findings include:

- Liquor was found to be the best-selling item across all countries and by marital status. The second most popular item across all the countries was non-vegetable items.

- The result of the query showed that the highest number of 2Market sales and successful leads are from Spain (\$659,557).&#x20;

- Spending trends vary significantly by marital status and presence of children/teens at home. The households with less kids and teens spend more on groceries than the ones the ones with 2 or more children. It was also observed that households with kids spend less on liquor.





## Next Steps

- Join with ad performance data to explore marketing effectiveness (done in Tableau)
- Visualise findings for deeper insights into customer behaviour

---

**Author:** Saima Abbas\
**Tools used:** PostgreSQL, SQL, Excel, Tableau

