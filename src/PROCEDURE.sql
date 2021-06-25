ALTER PROCEDURE DBO.MakePurchaseOrder
(
	@ModelID INT,
	@Count INT
)
AS
BEGIN
BEGIN TRY
	DECLARE @TotalPrice INT = @Count * (SELECT StandartCost FROM DBO.ProductModel WHERE ModelID = @ModelID)
	DECLARE @ProviderID INT = (SELECT PC.ParentCategoryID FROM DBO.ProductModel AS PM
	JOIN DBO.ProductCategory AS PC
	ON PM.CategoryID = PC.CategoryID
	WHERE PM.ModelID = @ModelID)
	INSERT INTO DBO.Shipment (ProviderID, Count, ModelID, TotalPrice, OrderDate)
	VALUES ( @ProviderID, @Count, @ModelID, @TotalPrice, GETDATE())
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH
END
GO
BEGIN TRANSACTION
EXECUTE DBO.MakePurchaseOrder 15, 3
ROLLBACK TRANSACTION
GO
CREATE PROCEDURE DBO.AddNewCustomer
(
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@Phone NVARCHAR(50)
)
AS
BEGIN
	INSERT INTO DBO.Customer (FirstName, LastName, Phone)
	VALUES (@FirstName, @LastName, @Phone)
END
GO
BEGIN TRANSACTION 
	EXECUTE DBO.AddNewCustomer 'KIKA', 'SUPRUK', '89641257634';
	SELECT * FROM Customer
ROLLBACK TRANSACTION
GO
ALTER PROCEDURE DBO.AddNewOrder
(
	@CustomerID INT,
	@ModelID INT,
	@Count INT,
	@EmploeyyID INT
)
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @OrderDate DATETIME = GETDATE()
	DECLARE @ListPrice MONEY = (SELECT ListPrice FROM DBO.ProductModel WHERE ModelID = @ModelID);
	DECLARE @PD DECIMAL(8,2) = ISNULL((SELECT PersonalDiscount FROM DBO.Customer WHERE CustomerID = @CustomerID)/100.00, 0);
	DECLARE @UnitPrice MONEY = @ListPrice * @Count;
	DECLARE @UnitPriceDiscount MONEY = @UnitPrice * @PD;
	DECLARE @LineTotal MONEY = @UnitPrice - @UnitPriceDiscount;
	DECLARE @SubTotal MONEY = @LineTotal;
	INSERT INTO DBO.SalesOrderHeader (OrderDate, SubTotal, CustomerID, EmployeeID)
	VALUES (@OrderDate, @SubTotal, @CustomerID, @EmploeyyID);
	DECLARE @SalesOrderID INT = (SELECT MAX(SalesOrderID) FROM DBO.SalesOrderHeader)
	INSERT INTO DBO.SalesOrderDetail (SalesOrderID, ModelID, Count, UnitPrice, UnitPriceDiscount, LineTotal)
	VALUES (@SalesOrderID, @ModelID, @Count, @UnitPrice, @UnitPriceDiscount, @LineTotal)
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	THROW;
END CATCH
END
GO
BEGIN TRANSACTION
	--UPDATE DBO.Customer
	--SET PersonalDiscount = 5 
	--WHERE CustomerID = 6121
	EXECUTE AddNewOrder 6121, 15, 3, 4
	SELECT * FROM SalesOrderHeader
	SELECT * FROM SalesOrderDetail
ROLLBACK TRANSACTION
GO
ALTER PROCEDURE DBO.AddModelToOrder
(
	@ModelID INT,
	@SalesOrderID INT,
	@Count INT
)
AS
BEGIN
BEGIN TRY
	DECLARE @ListPrice MONEY = (SELECT ListPrice FROM DBO.ProductModel WHERE ModelID = @ModelID);
	DECLARE @PD DECIMAL(8,2) = ISNULL((
	SELECT DISTINCT PersonalDiscount FROM DBO.Customer AS C
	JOIN DBO.SalesOrderHeader AS SOH
	ON C.CustomerID = SOH.CustomerID
	JOIN DBO.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
	WHERE SOD.SalesOrderID = @SalesOrderID
	)/100.00, 0);
	DECLARE @UnitPrice MONEY = @ListPrice * @Count;
	DECLARE @UnitPriceDiscount MONEY = @UnitPrice * @PD;
	DECLARE @LineTotal MONEY = @UnitPrice - @UnitPriceDiscount;
	INSERT INTO DBO.SalesOrderDetail (SalesOrderID, ModelID, Count, UnitPrice, UnitPriceDiscount, LineTotal)
	VALUES (@SalesOrderID, @ModelID, @Count, @UnitPrice, @UnitPriceDiscount, @LineTotal)
	UPDATE DBO.SalesOrderHeader
	SET SubTotal = (SELECT SUM(LineTotal) FROM SalesOrderDetail WHERE SalesOrderID = @SalesOrderID
	GROUP BY SalesOrderID)
	WHERE SalesOrderID = @SalesOrderID
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH
END
BEGIN TRANSACTION
 EXECUTE DBO.AddModelToOrder 50, 2001, 1
 SELECT * FROM SalesOrderHeader
 SELECT * FROM SalesOrderDetail
ROLLBACK TRANSACTION
CREATE PROCEDURE DBO.GetProductsFromCategory
(
	@CategoryID INT
)
AS
BEGIN
	DECLARE @NAME NVARCHAR(15) = (SELECT Name FROM DBO.ProductCategory WHERE CategoryID = @CategoryID);
	DECLARE @PCID INT = (SELECT ParentCategoryID FROM DBO.ProductCategory WHERE CategoryID = @CategoryID);
	IF @PCID = 1
	BEGIN
	SELECT * FROM getAllCars
	WHERE Category = @NAME
	END
	ELSE BEGIN
	SELECT * FROM getAllParts
	WHERE Category = @NAME
	END
END
EXECUTE GetProductsFromCategory 4

ALTER PROCEDURE DBO.uspFindStringInTable
(
	@schema SYSNAME,
	@table SYSNAME,
	@stringToFind NVARCHAR(2000)
)
AS
BEGIN
	DECLARE @Column AS VARCHAR(50)
	DECLARE @SQL AS VARCHAR(400)
	DECLARE SearchingCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
	WHERE (DATA_TYPE IN ('CHAR', 'NCHAR', 'VARCHAR', 'NVARCHAR', 'TEXT', 'NTEXT')) AND (TABLE_NAME = @table);

	OPEN SearchingCursor 
	FETCH SearchingCursor INTO @Column
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @SQL = 'SELECT * FROM [' + @schema + '].['+ @table+ '] 
		WHERE [' + @Column + '] LIKE ' + '''%' + @stringToFind + '%'''
		EXECUTE (@SQL)
		FETCH SearchingCursor INTO @Column
	END
	CLOSE SearchingCursor
	DEALLOCATE SearchingCursor
END

EXECUTE uspFindStringInTable 'dbo', 'ProductModel', '4WD'

--ТЕСТИРОВАНИЕ ПРОЦЕДУР
EXECUTE DBO.MakePurchaseOrder 15, 3

EXECUTE DBO.AddNewCustomer 'KIKA', 'SUPRUK', '89641257634'

EXECUTE AddNewOrder 6121, 15, 3, 4

EXECUTE DBO.AddModelToOrder 50, 2001, 1

EXECUTE GetProductsFromCategory 4

EXECUTE uspFindStringInTable 'dbo', 'ProductModel', '4WD'
---------------------------
