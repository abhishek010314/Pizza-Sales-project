# 🍕 Pizza Sales SQL Project

This repository contains a full SQL-based data analysis project on pizza sales. It includes database creation, table setup, data import instructions, relational constraints, and a wide range of queries — from basic to advanced — to derive insights from the sales data.

## 📁 Project Structure

- **`pizza_sales_analysis.sql`**: Full SQL script to create the database, tables, add constraints, and perform analysis.
- **CSV Files** (to be imported manually):
  - `orders.csv`
  - `order_details.csv`
  - `pizzas.csv`
  - `pizza_types.csv`

## 🛠️ Requirements

- MySQL or compatible SQL database engine
- MySQL Workbench (recommended for importing CSVs using the Table Data Import Wizard)

## 📌 Instructions

1. Clone this repository.
2. Open `pizza_sales_analysis.sql` in your SQL editor (e.g., MySQL Workbench).
3. Run the script section-by-section:
   - Create database and tables
   - Add foreign key constraints
   - Use MySQL Workbench to import CSV files into respective tables
   - Execute analysis queries

## 🔍 Key Analyses Performed

### Basic Analysis:
- Total number of orders
- Total revenue generated
- Highest-priced pizza
- Most common pizza size
- Top 5 most ordered pizza types

### Intermediate Analysis:
- Pizza category-wise quantity
- Order distribution by hour and weekday
- Daily pizza averages
- Category-wise pizza counts

### Advanced Analysis:
- Percentage revenue contribution by pizza type
- Cumulative revenue over time
- Top 3 revenue-generating pizzas by category

## 🧾 Conclusion

This analysis of pizza sales data revealed several actionable insights:
- **Large pizzas (L)** were the most ordered size (**18,526** orders), followed by **medium (M)** with **15,385** orders.
- The most ordered pizza types were **Classic Deluxe**, **Barbecue Chicken**, and **Hawaiian**, with **Classic Deluxe** leading at **2,453** orders.
- Sales peaked at **12 PM (2,520 orders)** and remained high during **1 PM (2,455)** and **6–8 PM**, especially **6 PM (2,399 orders)**.
- **Fridays** saw the highest average daily orders (**294.83**), followed by **Thursdays** and **Saturdays**.
- Top revenue-generating pizzas were:
  - **Thai Chicken Pizza**: ₹43,434.25 (5.31%)
  - **Barbecue Chicken Pizza**: ₹42,768.00 (5.23%)
  - **California Chicken Pizza**: ₹41,409.50 (5.06%)
- A small subset of pizzas accounted for a significant share of total revenue, aligning with the **Pareto Principle (80/20 rule)**.

These findings can help optimize menu offerings, pricing strategies, inventory planning, and staffing schedules for a pizza restaurant business.

## 📌 Author

Project by Abhishek Kunbhare.

Feel free to fork this repo or use the queries to build your own sales insights project!

