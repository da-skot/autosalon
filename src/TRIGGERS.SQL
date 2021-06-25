CREATE TRIGGER NewPurchaseOrder ON DBO.ProductModel
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS 
	(
		SELECT * FROM INSERTED 
		WHERE Count < 5
	)
	BEGIN
		DECLARE @ModelID INT = (SELECT ModelID FROM DBO.ProductModel 
		WHERE ModelID = (SELECT ModelID FROM INSERTED
		WHERE Count < 5))
		EXECUTE DBO.MakePurchaseOrder @ModelID, 5
	END
END
GO
BEGIN TRANSACTION
UPDATE DBO.ProductModel
SET Count = 4
WHERE ModelID = 115
SELECT * FROM DBO.Shipment
ROLLBACK TRANSACTION
GO
ALTER TRIGGER CheckCount ON DBO.SALESORDERDETAIL
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS 
	(
		SELECT * FROM INSERTED AS INS
		WHERE Count > (
			SELECT Count FROM ProductModel AS PM
			WHERE  (INS.ModelID = PM.ModelID))
	)
	BEGIN
		ROLLBACK;
		THROW 50001, 'Количество товаров в заказе больше, чем на складе', 0;
	END
END
BEGIN TRANSACTION
	EXECUTE AddNewOrder 6121, 15, 1000, 4
	SELECT * FROM SalesOrderHeader
	SELECT * FROM SalesOrderDetail
ROLLBACK TRANSACTION
ALTER TRIGGER PurchaseClose ON DBO.SHIPMENT
AFTER INSERT, UPDATE 
AS
BEGIN
	DECLARE @MINID INT = (SELECT MIN(PurchaseOrderID) FROM Shipment)
	DECLARE @MAXID INT = (SELECT MAX(PurchaseOrderID) FROM Shipment)
	WHILE @MINID <= @MAXID
	BEGIN
	IF @MINID IN (SELECT PurchaseOrderID FROM inserted)
	BEGIN
		DECLARE @COUNT INT = (SELECT Count FROM Shipment WHERE (PurchaseOrderID = @MINID) AND (ShipDate IS NOT NULL))
		DECLARE @MODEL INT = (SELECT ModelID FROM Shipment WHERE (PurchaseOrderID = @MINID) AND (ShipDate IS NOT NULL))
		UPDATE DBO.ProductModel
		SET Count = Count + @COUNT
		WHERE (ModelID IN (SELECT ModelID FROM inserted)) AND (ModelID = @MODEL);
	END
	SET @MINID = @MINID + 1;
	END
	
END
BEGIN TRANSACTION
	EXECUTE MakePurchaseOrder 15, 100
	EXECUTE MakePurchaseOrder 30, 100
	UPDATE DBO.Shipment
	SET ShipDate = GETDATE()
	WHERE ShipDate IS NULL
	SELECT * FROM Shipment
	SELECT * FROM ProductModel
ROLLBACK TRANSACTION

INSERT INTO DBO.Shipment
VALUES 
( 1, 16, 15, 36800000, GETDATE(), GETDATE()),
( 1, 10, 30, 13000000, GETDATE(), GETDATE())
	SELECT * FROM Shipment
	SELECT ModelID, Count FROM ProductModel


--ТЕСТИРОВАНИЕ ТРИГГЕРОВ 

UPDATE DBO.ProductModel
SET Count = 4
WHERE ModelID = 115
--ТРИГГЕР NewPurchaseOrder СРАБОТАЛ

EXECUTE AddNewOrder 6121, 15, 1000, 4
--ТРИГГЕР CheckCount СРАБОТАЛ

EXECUTE MakePurchaseOrder 15, 100
EXECUTE MakePurchaseOrder 30, 100
UPDATE DBO.Shipment
SET ShipDate = GETDATE()
WHERE ShipDate IS NULL
--ТРИГГЕР PurchaseClose СРАБОТАЛ

INSERT INTO DBO.Shipment
VALUES 
( 1, 16, 15, 36800000, GETDATE(), GETDATE()),
( 1, 10, 30, 13000000, GETDATE(), GETDATE())
--ТРИГГЕР PurchaseClose СРАБОТАЛ
