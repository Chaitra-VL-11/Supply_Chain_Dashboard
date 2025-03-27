SELECT * FROM supply_chain.`supply chain`;

SELECT count(*) as Total_Records
FROM supply_chain.`supply chain`;

-- Exploratory Data Analysis --

1) Employee Count Per Warehouse.

select Warehouse_ID, Location, Employee_Count
from supply_chain.`supply chain`
order by Employee_Count DESC;

2) Warehouse with High Storage and Transportation Costs.

select Warehouse_ID, Location, Storage_Cost, Transportation_Cost
from supply_chain.`supply chain`
order by (Storage_Cost+Transportation_Cost) DESC;

3) Return Rate by Category.

select Product_Category, 
round(avg(Return_Rate),2) as avg_return_rate
from supply_chain.`supply chain`
group by Product_Category
order by avg_return_rate DESC;

4) Summary Statistics.

SELECT 
    MIN(Current_Stock) AS min_stock, MAX(Current_Stock) AS max_stock, AVG(Current_Stock) AS avg_stock,
    MIN(Demand_Forecast) AS min_demand, MAX(Demand_Forecast) AS max_demand, AVG(Demand_Forecast) AS avg_demand,
    MIN(Shipping_Time_Days) AS min_shipping_time, MAX(Shipping_Time_Days) AS max_shipping_time, AVG(Shipping_Time_Days) AS avg_shipping_time,
    MIN(Order_Processing_Time) AS min_order_processing_time, MAX(Order_Processing_Time) AS max_order_processing_time, AVG(Order_Processing_Time) AS avg_order_processing_time
FROM supply_chain.`supply chain`;

5) Average Order Processing Time per Warehpouse.

SELECT Warehouse_ID, AVG(Order_Processing_Time) AS avg_processing_time
FROM supply_chain.`supply chain`
GROUP BY Warehouse_ID
ORDER BY avg_processing_time ASC;

6) Top-Selling Categories.

SELECT Product_Category, SUM(Monthly_Sales) AS total_sales
FROM supply_chain.`supply chain`
GROUP BY Product_Category
ORDER BY total_sales DESC;

-- Shipping Performance Analysis--

1) Average Shipping Time by Warehouse

select warehouse_ID, Location,
AVG(Shipping_Time_Days) AS avg_shipping_time
from supply_chain.`supply chain`
group by Warehouse_ID, Location
order by avg_shipping_time ASC;

2) On-Time Delivery performance

select Warehouse_ID, count(*) as total_orders,
sum(case when Shipping_Time_Days<=Lead_Time_Days then 1 else 0 end)as On_time_deliveries,
round((sum(case when Shipping_Time_Days<=Lead_Time_Days then 1 else 0 end)*100.0)/count(*),2)as on_time_delivery_percentage
from supply_chain.`supply chain`
group by Warehouse_ID
order by on_time_delivery_percentage DESC;

3) Warehouse With High Stock-out Risk Affecting Shipping.

select Warehouse_ID, Location, Current_Stock, Demand_Forecast, Stockout_Risk,Shipping_Time_Days,Lead_Time_Days
from supply_chain.`supply chain`
where Stockout_Risk < 10
order by Stockout_Risk DESC,Shipping_Time_Days ASC;

4) Impact of Employee Count on Shipping Performance.

select Warehouse_ID, Location, Employee_Count,
round(AVG(Shipping_Time_days),2) as avg_shipping_time
from supply_chain.`supply chain`
group by Warehouse_ID, Location, Employee_Count
order by Warehouse_ID, Location, Employee_Count DESC, avg_shipping_time DESC;

-- Inventory Level Analysis --

1) Stock Utilization Percentage by Warehouse.

select Warehouse_ID, Location, Current_Stock, Warehouse_Capacity,
round((Current_Stock*100.0)/Warehouse_Capacity,2) as stock_utilization_percentage
from supply_chain.`supply chain`
order by stock_utilization_percentage DESC;

2) Inventory Turnover Rate by Category

select Product_Category, sum(Monthly_Sales)as Total_Sales, 
sum(Current_Stock) as Total_Stocks,
round(sum(Monthly_Sales)*1.0/nullif(sum(Current_Stock),0),2) as inventory_turnover_rate
from supply_chain.`supply chain`
group by Product_Category
order by inventory_turnover_rate DESC;

3) Backorder and Damaged Goods Impact on Inventory.

select Warehouse_ID, Location, sum(Backorder_Quantity) as Total_backorder,
sum(Damaged_Goods) as Total_damaged_goods,
sum(Current_Stock) as Total_Stock,
round((sum(Damaged_Goods)*100.0)/nullif(sum(Current_Stock),0),2) as damaged_percentage
from supply_chain.`supply chain`
group by Warehouse_ID, Location
order by damaged_percentage DESC;

5) Storage Cost and Operational Cost Analysis

select Warehouse_ID, Location, Storage_Cost, Operational_Cost,
(Storage_Cost+Operational_Cost) as Total_Cost
from supply_chain.`supply chain`
order by Total_Cost DESC;

-- Demand Fluctuation --

1) Demand-Supply Gap Analysis.

select Warehouse_ID, Location, Current_Stock, Demand_Forecast,
(Demand_Forecast-Current_Stock) as demand_supply_gap
from supply_chain.`supply chain`
order by demand_supply_gap DESC;

2) Monthly Sales Trend Per Category.

select Product_Category,sum(Monthly_Sales) as Total_Sales
from supply_chain.`supply chain`
group by Product_Category
order by Total_Sales DESC;

3) Lead Time Impact on Demand Fullfillment.

select Warehouse_ID, Location, Lead_Time_Days, Demand_Forecast, Current_Stock,
(Demand_Forecast-Current_Stock) as Demand_gap
from supply_chain.`supply chain`
order by Lead_Time_Days DESC, Demand_gap DESC;

4) Customer Rating VS Demand Fulfillment.

select Warehouse_ID, Location, Customer_Rating, Demand_Forecast,Current_Stock,
(Demand_Forecast-Current_Stock) as unmet_demand
from supply_chain.`supply chain`
order by Customer_Rating ASC, unmet_demand DESC;









