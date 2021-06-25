ALTER VIEW getAllCars
AS
SELECT M.Name AS Manufactured, P.Name,  PM.ModelID, PC.Name AS Category,
PM.Weight, PM.Color, PM.Generation, PM.Power, PM.VolumeOfMotor, PM.TypeOfDrive, DATEPART(YY, pm.YearOfManufacture) AS Year,
PM.Acceleration, PM.ExpenditureOfFuel, PM.MaximumSpeed, PM.Transmission, PM.ListPrice, PM.Count 
FROM DBO.Manufactured AS M
JOIN DBO.Product AS P
ON M.ManufacturedID = P.ManufacturedID
JOIN DBO.ProductModel AS PM
ON P.ProductID = PM.ProductID
JOIN DBO.ProductCategory AS PC
ON PM.CategoryID = PC.CategoryID
WHERE PC.ParentCategoryID = 1;
GO
SELECT * FROM dbo.getAllCars
GO
CREATE VIEW getAllParts
AS
SELECT M.Name AS Manufactured, P.Name,  PM.ModelID, PC.Name AS Category,
PM.Size, PM.Color, PM.Power, PM.ListPrice, PM.Count
FROM DBO.Manufactured AS M
JOIN DBO.Product AS P
ON M.ManufacturedID = P.ManufacturedID
JOIN DBO.ProductModel AS PM
ON P.ProductID = PM.ProductID
JOIN DBO.ProductCategory AS PC
ON PM.CategoryID = PC.CategoryID
WHERE PC.ParentCategoryID = 2;
GO
SELECT * FROM DBO.getAllParts
GO
ALTER VIEW getAllSels
AS
SELECT distinct C.CustomerID, ISNULL(C.FirstName + ' ' + C.MiddleName + ' ' + C.LastName, C.FirstName + ' ' + C.LastName) AS Name, 
c.Phone, M.Name AS Manufactured, p.Name AS Product, pm.ModelID, sod.Count, sod.LineTotal
FROM DBO.Customer AS C
JOIN DBO.SalesOrderHeader AS SOH
ON C.CustomerID = SOH.CustomerID
JOIN DBO.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN DBO.ProductModel AS PM 
ON SOD.ModelID = PM.ModelID
JOIN DBO.Product AS P
ON PM.ProductID = P.ProductID
JOIN DBO.Manufactured AS M
ON P.ManufacturedID = M.ManufacturedID;
GO
SELECT * FROM DBO.getAllSels
--ТЕСТИРОВАНИЕ ПРЕДСТАВЛЕНИЕ
SELECT * FROM dbo.getAllCars
SELECT * FROM DBO.getAllParts
SELECT * FROM DBO.getAllSels
----------------------------
