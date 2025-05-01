-- ====================================================
-- 🍕 Pizza Sales SQL Project
-- ====================================================
-- This script creates the pizza sales database, imports structure, sets up constraints, and performs basic to advanced analysis.
-- ====================================================

-- this script performs an analysis of pizza sales data.  it assumes the data is in a mysql database, and the database and 
-- tables are created as part of this script.  the script is designed to be clear, well-commented, and easy to understand.

-- -----------------------------------------------------------------------------
-- Database Setup
-- -----------------------------------------------------------------------------

-- Drop the database if it already exists.  this is useful for development and testing, to ensure a clean slate.  in a production 
-- environment, you would typically not drop the database.
drop database if exists pizzasales;

-- Create the Database.
create database pizzasales;

-- Select the database to use.  all subsequent commands will apply to this database.
use pizzasales;

-- -----------------------------------------------------------------------------
-- Table Creation
-- -----------------------------------------------------------------------------

-- Create the 'orders' table.  this table stores information about each order, including the order id, date, and time.
create table orders (
    order_id int primary key,
    date     date,
    time     time
);

-- Create the 'order_details' table.  this table stores information about the specific pizzas included in each order, 
-- including the quantity of each pizza.
create table order_details (
    order_details_id int primary key,
    order_id         int,
    pizza_id         varchar(50),
    quantity         int
);

-- Create the 'pizza_types' table.  this table stores information about the different types of pizzas, such as their name and category.
create table pizza_types (
    pizza_type_id varchar(50) primary key,
    name          varchar(255),
    category      varchar(255),
    ingredients   varchar(255)
);

-- Create the 'pizzas' table.  this table stores information about each type of pizza, including its size, price, and pizza type.
create table pizzas (
    pizza_id      varchar(50) primary key,
    pizza_type_id varchar(50),
    size          varchar(20),
    price         decimal(10, 2)
);


-- -----------------------------------------------------------------------------
-- Data loading
-- -----------------------------------------------------------------------------

-- Instructions for loading data using the table data import wizard are in the original code.
-- Load data infile '/path/to/orders.csv'
-- Into perticular table

-- -----------------------------------------------------------------------------
-- Data Integrity Constraints (added for robustness)
-- -----------------------------------------------------------------------------

-- Add foreign key constraint for order_id in order_details.
alter table order_details
add constraint fk_order_details_orders
foreign key (order_id) references orders(order_id);

-- Add foreign key constraint for pizza_id in order_details.
alter table order_details
add constraint fk_order_details_pizzas
foreign key (pizza_id) references pizzas(pizza_id);

-- Add foreign key constraint for pizza_type_id in pizzas.
alter table pizzas
add constraint fk_pizzas_pizza_types
foreign key (pizza_type_id) references pizza_types(pizza_type_id);



-- -----------------------------------------------------------------------------
-- Basic Queries
-- -----------------------------------------------------------------------------

-- Total number of orders placed.
select count(*) as total_orders
from orders;

-- Total revenue generated from pizza sales.
select round(sum(OD.quantity * P.price), 2) as total_revenue
from order_details as OD
join pizzas as P on OD.pizza_id = P.pizza_id;

-- Highest-priced pizza.
select pt.name, p.size, p.price
from pizzas as p
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
order by p.price desc
limit 1;

-- Most common pizza size ordered.
select p.size, count(p.size) as size_count
from order_details as od
join pizzas as p on od.pizza_id = p.pizza_id
group by p.size
order by size_count desc
limit 3;

-- Top 5 most ordered pizza types.
select pt.name, sum(od.quantity) as total_quantity
from order_details as od
join pizzas as p on od.pizza_id = p.pizza_id
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_quantity desc
limit 5;

-- -----------------------------------------------------------------------------
-- intermediate queries
-- -----------------------------------------------------------------------------

-- Total quantity by pizza category.
select pt.category, sum(od.quantity) as total_quantity
from order_details as od
join pizzas as p on od.pizza_id = p.pizza_id
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category
order by total_quantity desc;

-- Distribution of orders by hour.
select hour(time) as hour_of_day, count(order_id) as order_count
from orders
group by hour_of_day
order by order_count desc;

-- Average number of orders by weekday.
select
    case
        when weekday = 6 then 'sunday'
        when weekday = 0 then 'monday'
        when weekday = 1 then 'tuesday'
        when weekday = 2 then 'wednesday'
        when weekday = 3 then 'thursday'
        when weekday = 4 then 'friday'
        when weekday = 5 then 'saturday'
    end as weekdays,
    round(avg(order_count), 2) as average_orders
from (
    select
        month(date) as month,
        weekday(date) as weekday,
        count(order_id) as order_count
    from orders
    group by month(date), weekday(date)
) as sub
group by weekdays
order by average_orders desc;

-- Category-wise pizza count.
select pt.category, count(distinct p.pizza_id) as total_pizzas
from pizzas as p
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category;

-- Average number of pizzas ordered per day.
select round(avg(daily_pizzas), 0) as average_pizzas_per_day
from (
    select o.date, sum(od.quantity) as daily_pizzas
    from orders as o
    join order_details as od on o.order_id = od.order_id
    group by o.date
) as daily_pizza_counts;

-- Top 3 most ordered pizza types based on revenue.
select pt.name, sum(od.quantity * p.price) as total_revenue
from order_details as od
join pizzas as p on od.pizza_id = p.pizza_id
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_revenue desc
limit 3;

-- -----------------------------------------------------------------------------
-- Advanced Queries
-- -----------------------------------------------------------------------------

-- Revenue contribution % by pizza type.
select
    pt.name,
    round(sum(od.quantity * p.price), 2) as total_revenue,
    round(
        (sum(od.quantity * p.price) / sum(sum(od.quantity * p.price)) over () ) * 100,
        2
    ) as percentage_of_revenue
from order_details as od
join pizzas as p on od.pizza_id = p.pizza_id
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by percentage_of_revenue desc;

-- Cumulative revenue over time.
with daily_revenue as (
    select
        o.date,
        round(sum(od.quantity * p.price), 2) as daily_revenue_sum
    from order_details as od
    join pizzas as p on od.pizza_id = p.pizza_id
    join orders as o on od.order_id = o.order_id
    group by o.date
)
select
    dr.date,
    dr.daily_revenue_sum,
    round(sum(dr.daily_revenue_sum) over (order by dr.date), 2) as cumulative_revenue_sum
from daily_revenue as dr
order by dr.date;

-- Top 3 revenue-generating pizzas by category.
with pizza_revenue_by_category as (
    select
        pt.category,
        pt.name,
        sum(od.quantity * p.price) as revenue,
        rank() over (partition by pt.category order by sum(od.quantity * p.price) desc) as rank_within_category
    from order_details as od
    join pizzas as p on od.pizza_id = p.pizza_id
    join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
    group by pt.category, pt.name
)
select
    category,
    name,
    revenue
from pizza_revenue_by_category
where rank_within_category <= 3
order by category, revenue desc;
