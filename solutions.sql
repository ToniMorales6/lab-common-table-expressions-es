use NorthWind;

-- 1. Escribe una CTE que liste los nombres y cantidades de los productos con un precio unitario mayor a $50.
SELECT 
    ProductName,
    Unit
FROM 
    Products
WHERE 
    Price > 50;

-- 2. ¿Cuáles son los 5 productos más rentables?
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity * p.Price) AS TotalRevenue
FROM 
    Products p
JOIN 
    OrderDetails od ON p.ProductID = od.ProductID
GROUP BY 
    p.ProductID, p.ProductName
ORDER BY 
    TotalRevenue DESC
LIMIT 
    6;
    
-- 3. Escribe una CTE que liste las 5 categorías principales según el número de productos que tienen.

WITH CategoryProductCount AS (
    SELECT 
        c.CategoryName,
        COUNT(p.ProductID) AS ProductCount
    FROM 
        Categories c
    LEFT JOIN 
        Products p ON c.CategoryID = p.CategoryID
    GROUP BY 
        c.CategoryName
)
SELECT 
    CategoryName,
    ProductCount
FROM 
    CategoryProductCount
ORDER BY 
    ProductCount DESC
LIMIT 
    5;
    
-- 4. Escribe una CTE que muestre la cantidad promedio de pedidos para cada categoría de producto.

WITH AvgOrderQuantityByCategory AS (
    SELECT 
        c.CategoryName,
        AVG(od.Quantity) AS AvgOrderQuantity
    FROM 
        Categories c
    JOIN 
        Products p ON c.CategoryID = p.CategoryID
    JOIN 
        OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY 
        c.CategoryName
)
SELECT 
    CategoryName,
    ROUND(AvgOrderQuantity, 4) AS AvgOrderQuantity
FROM 
    AvgOrderQuantityByCategory;

-- 5. Crea una CTE para calcular el importe medio de los pedidos para cada cliente.

WITH AvgOrderAmountByCustomer AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        AVG(od.Quantity * p.Price) AS AvgOrderAmount
    FROM 
        Customers c
    JOIN 
        Orders o ON c.CustomerID = o.CustomerID
    JOIN 
        OrderDetails od ON o.OrderID = od.OrderID
    JOIN 
        Products p ON od.ProductID = p.ProductID
    GROUP BY 
        c.CustomerID, c.CustomerName
)
SELECT 
    CustomerID,
    CustomerName,
    ROUND(AvgOrderAmount, 4) AS AvgOrderAmount
FROM 
    AvgOrderAmountByCustomer
ORDER BY AvgOrderAmount DESC;

-- 6. Análisis de Ventas con CTEs. Suponiendo que tenemos la base de datos Northwind que contiene tablas como Orders, OrderDetails y Products. Crea una CTE que calcule las ventas totales para cada producto en el año 1997.

WITH SalesByProduct AS (
    SELECT 
        p.ProductName,
        SUM(od.Quantity) AS TotalSales
    FROM 
        OrderDetails od
    JOIN 
        Orders o ON od.OrderID = o.OrderID
    JOIN 
        Products p ON od.ProductID = p.ProductID
    WHERE 
        YEAR(o.OrderDate) = 1997
    GROUP BY 
        p.ProductName
)
SELECT 
    ProductName,
    TotalSales
FROM 
    SalesByProduct
ORDER BY 
    TotalSales DESC;