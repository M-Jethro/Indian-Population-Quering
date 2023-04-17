-- hello, my name is Jethro M . The code below was written in MySql as part of a portfolio project I was doing. Using two datasets namely set1 and set2. 
-- I have commented some guides to help follow the guide. The analysis is for a census done in India.

-- in this analysis, I will be using basic queries

select * from set1;
select * from set2;

-- to find out the number of rows in the tables
select count(*) from set1;
select count(*) from set2;

-- getting data from only 2 states - Bihar and Uttar Pradesh
select * 
from set1
where state in ('Bihar', 'Uttar Pradesh');

-- using the dataset 2 to find the total population of India using the sum function
select sum(population) as 'Total Population'
 from set2;

-- growth percentage of India's population 
select avg (growth) as 'Growth Rate'
from set1;

-- avergae growth percentage by state
select state, 
round(avg(growth), 0) as average_growth_rate
from set1
group by state;

-- average sex ration by state arranged by the highest to lowest
select state,
round(avg(sex_ratio),0) as avg_sex_ratio
from set1
group by state
order by avg_sex_ratio desc;

-- average literacy rate across states
select state,
round(avg(literacy),0) as avg_literacy_rate
from set1
group by state
order by avg_literacy_rate desc;

-- states with the highest growth rates
select state, 
round(avg(growth), 0) as average_growth_rate
from set1
group by state
order by average_growth_rate desc
limit 5;

-- states with the lowest sex ratio
select state,
round(avg(sex_ratio),0) as avg_sex_ratio
from set1
group by state
order by avg_sex_ratio asc
limit 5;

-- creating a table showing the top and least states with the highest and least literacy rates 
create table top_table
(state nvarchar(255),
top_states float); 

insert into top_table
select state,
round(avg(literacy),0) as avg_literacy_rate
from set1
group by state
order by avg_literacy_rate desc
limit 5;

select * from top_table;

create table bottom_table
(state nvarchar(255),
bottom_states float); 

insert into bottom_table
select state,
round(avg(literacy),0) as avg_literacy_rate
from set1
group by state
order by avg_literacy_rate asc
limit 5;

-- we use the union feature to join both tables
select *
from (select * 
from top_table
limit 5) a
union
select *
from (select *
from bottom_table
limit 5) b;

-- states names starting 'a' or 'b' and those ending with 'd' or 'a'
select distinct state
from set1
where state like 'a%'
or state like 'b%';

select distinct state
from set1
where state like '%d'
or state like '%a';

-- joining both tables to get the population of each state
select a.district, a.state, a.sex_ratio/1000, b.population
from claver_projects.set1 a 
join claver_projects.set2  b 
on a.district = b.district;

-- ASSUMING
-- that number of females/number of males = sex ration
-- and that total population = no. of males + no. of females
-- we are going to perform a calculation to find the number of females per state
-- females = population/(sex_ratio +)

select 
      c.district,
      c.state,
      round(c.population/(c.sex_ratio+1), 0) as females,
      c.population - (round(c.population/(c.sex_ratio+1), 0))  as males
from 
     (select a.district, a.state, a.sex_ratio/1000 as sex_ratio, b.population
      from claver_projects.set1 a 
	  join claver_projects.set2  b
      on a.district = b.district) 

c;

-- then we group by the states that have the highest number of males and females respectively
select
      d.state,
      sum(d.females) as 'Total Females',
      sum(d.males) as 'Total Males'
from
     (select 
            c.district,
            c.state,
		    round(c.population/(c.sex_ratio+1), 0) as females,
            c.population - (round(c.population/(c.sex_ratio+1), 0))  as males
     from 
            (select a.district, a.state, a.sex_ratio/1000 as sex_ratio, b.population
            from claver_projects.set1 a 
	        join claver_projects.set2  b
            on a.district = b.district) 
c) d

group by d.state;

-- getting population from the previous census using the growth rate
select
      a.district,
      a.state,
      a.growth/100 growth,
      b.population
from set1 a 
join set2 b
where a.district = b.district;

-- then

select
     d.district, 
     d.state,
     round(d.population/(d.growth +1), 0) as 'previous census',
     d.population as 'current census'
from 
    (select
           a.district,
           a.state,
           a.growth/100 growth,
           b.population
     from set1 a 
     join set2 b
     where a.district = b.district) d
order by d.state;


















