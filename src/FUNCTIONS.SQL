CREATE FUNCTION fn_getAllInformationCar
(@ModelID int)
RETURNS TABLE
AS
RETURN
	SELECT * FROM DBO.getAllCars
	WHERE ModelID = @ModelID
GO
SELECT * FROM fn_getAllInformationCar (15)
GO
ALTER FUNCTION fn_getAllEquipmentCar
(@NAME NVARCHAR(15))
RETURNS TABLE
AS
RETURN
	SELECT * FROM DBO.getAllCars
	WHERE Name = @NAME
GO
SELECT * FROM fn_getAllEquipmentCar('X5')
GO
CREATE FUNCTION fn_getTotalSumCustomer
(@customerID INT)
RETURNS MONEY
AS
BEGIN
DECLARE @SUBTOTAL MONEY
SET @SUBTOTAL = (SELECT SUM(LineTotal) FROM DBO.getAllSels
	WHERE CustomerID = @customerID
	GROUP BY CustomerID)
RETURN @SUBTOTAL
END
GO
PRINT DBO.fn_getTotalSumCustomer(6121)
CREATE FUNCTION fn_FindToPower
( @power INT)
RETURNS TABLE
AS
RETURN
	(SELECT * FROM DBO.getAllCars
	WHERE Power = @power)
SELECT * FROM fn_FindToPower(450)

--ТЕСТИРОВАНИЕ ФУНКЦИЯ
SELECT * FROM fn_getAllInformationCar (15)
SELECT * FROM fn_getAllEquipmentCar('X5')
PRINT DBO.fn_getTotalSumCustomer(6121)
SELECT * FROM fn_FindToPower(450)
----------------------------------
