--SQl Retail SAles Analysis - P1
create database sql_project_p2;
--create table
drop table if exists ratail_sales;
create table retail_sales
		(
			transactions_id int primary key,
			sale_date date,
			sale_time time,
			customer_id int,
			gender varchar(15),
			age int,
			category varchar(15),
			quantiy int,
			price_per_unit float,
			cogs float,
			total_sale float
		);
		select 
		count(*) from retail_sales;

		select * from retail_sales
		where transactions_id is null;

		select * from retail_sales
		where sale_date is null;

		select * from retail_sales
		where 
			transactions_id is null
			or
			sale_date is null
			or
			sale_time is null
			or 
			gender is null
			or 
			category is null
			or 
			quantiy is null
			or
			Price_per_unit is null
			or
			cogs is null
			or
			total_sale is null;
	--delete null value
	delete from retail_sales
		where 
			transactions_id is null
			or
			sale_date is null
			or
			sale_time is null
			or 
			gender is null
			or 
			category is null
			or 
			quantiy is null
			or
			Price_per_unit is null
			or
			cogs is null
			or
			total_sale is null;
-- data exploration
-- how many sales we have?
select count(*) total_sale from retail_sales
--how many unique customers we have?
select count(distinct customer_id) as total_sale from retail_sales
-- how many unique category we have?
select distinct category  from retail_sales


--data analysis & business key problem and  answers
--Q1. write the sql query to retrieve all columns for sales made on '2022-11-05'
select * 
from retail_sales
where sale_date = '2022-11-05';
--Q2. write a sql query to retrieve all transaction where the category is 'clothing' and the quantity sold is more 
--than 4 in the  month of nov-2022
select 
	*
	from retail_sales
	where category = 'Clothing'
		and 
		to_char(sale_date,'yyyy-mm') = '2022-11'
		and 
		quantiy >= 4
	group by 1;

--Q3. write a sql query tp calculate the total sales (total_sale) for each category.

select category,
		sum(total_sale) as net_sale,
		count(*) as total_orders
from retail_sales
group by 1;

--Q4.write a sql query to find the avrage age of customers who purchase items from 'beauty' category.

select 
round(avg(age),2) 
from retail_sales
where category = 'Beauty';

--Q5. write a sql query to find all transaction where total_sale is greater than 1000.

select * from retail_sales
where total_sale >1000;
--Q.6 write a sql query to find the total number of transaction (transaction_id) made by each gender in each category.

select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group 
	by
	category,
	gender
order by 3;

--Q7. write a sql query to calculate the average sale for each month. find out best selling month in each year.
select 
	year,
	month,
	avg_sale
from
(	
select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over (partition by extract(year from sale_date) order by avg(total_sale)desc) as rank
from retail_sales
group by 1, 2
) as t1
where rank =1;the top 

--Q8. write a sql query to find out 5 cutomers based on the highest total sales.

select 
	customer_id,
	sum(total_sale)as total_sales
from retail_sales
group by 1
order by 2  desc
limit 5;

--Q9.write a SQL query to find the number of unique customers who purchased item  from each  category.

select 
	category,
	count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category

--Q10. write a sql query to create each shift and number of order (example morning <=12, afternoon between 12 & 17 evening >17)
with hourly_sale
as
(
select *,
		case 
			when extract (hour from sale_time) < 12 then 'Morning'
			when extract (hour from sale_time) between 12 and 17 then 'afternoon'
			else 'evening'
		end as shift
	from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;

--End of Project