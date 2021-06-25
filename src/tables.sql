INSERT INTO dbo.ProductCategory
VALUES (21, 1, 'Bus')
INSERT INTO dbo.ProductCategory
VALUES (22, 2, 'Audio System')
SELECT * FROM DBO.ProductCategory
-------------------------------------
INSERT INTO DBO.Manufactured
VALUES (18, 'Porshe', 'Germany')
SELECT * FROM DBO.Manufactured
----------------------------------------
INSERT INTO DBO.Product
VALUES (10, '911', 18)
SELECT * FROM DBO.Product
---------------------------------------
INSERT INTO DBO.ProductModel (ModelID, CategoryID, Weight, Color, Generation, Power, VolumeOfMotor, TypeOfDrive, 
YearOfManufacture, Acceleration, ExpenditureOfFuel, MaximumSpeed, Transmission, StandartCost, ListPrice, Count, ProductID)
VALUES 
(997, 5, 1600, 'Orange', 6, 385, 3.8, '4WD', '01.01.2008', 4.5, 14, 320, 5, 3500000, 4500000, 6, 10),
(991, 6, 1650, 'Grey', 7, 450, 3, '4WD', '01.01.2017', 4, 14.5, 360, 7, 7500000, 9500000, 12, 10)
INSERT INTO DBO.ProductModel (ModelID, CategoryID, Size, StandartCost, ListPrice, Count, ProductID)
VALUES (215, 12, 15, 5, 12, 400, 6),
(216, 12, 16, 6, 13, 400, 6)
SELECT * FROM DBO.ProductModel
-------------------------------------------------
INSERT INTO DBO.Provider
VALUES (1, 'AUTOMOTIVE SUPPLIER', 'auto_sup@email.com', '89145627899'),
(2, 'SPARE PARTS SUPPLIER', 'spare_sup@email.com', '89145631899')
SELECT * FROM DBO.Provider
---------------------------------------------------
INSERT INTO DBO.Shipment
VALUES 
(14263, 1, 16, 15, 36800000, '01.01.2013', '07.01.2013'),
(14264, 1, 10, 30, 13000000, '01.01.2013', '07.01.2013'),
(14265, 1, 12, 50, 18000000, '01.01.2013', '07.01.2013'),
(14266, 2, 60, 115, 240000, '01.01.2013', '07.01.2013'),
(14267, 2, 21, 116, 105000, '01.01.2013', '07.01.2013'),
(14268, 2, 500, 215, 2500, '01.01.2013', '07.01.2013'),
(14269, 1, 500, 216, 3000, '01.01.2013', '07.01.2013'),
(14270, 1, 22, 520, 66000000, '01.01.2020', '07.01.2020'),
(14271, 1, 9, 528, 24300000, '01.01.2016', '07.01.2016'),
(14272, 1, 12, 991, 90000000, '01.01.2017', '07.01.2017'),
(14273, 1, 8, 997, 28000000, '01.01.2013', '07.01.2013'),
(14274, 2, 10, 5877, 80000, '01.01.2013', '07.01.2013')
SELECT * FROM DBO.Shipment
----------------------------------------------------------
INSERT INTO DBO.Employee (EmployeeID, FirstName, LastName, MiddleName, Post, Phone, Email, DateOfEmployment)
VALUES
(1, 'Ivan', 'Ivanov', 'Ivanovich', 'Director', '89254631859', 'ivai_iv@email.com', '01.01.2013'),
(2, 'Mihail', 'Mihailov', 'Mihailovich', 'Administrator', '89254781859', 'mich_mi@email.com', '01.01.2013'),
(3, 'Volodya', 'Tranov', 'Ivanovich', 'Seccurity', '89254635459', 'tranovVI@email.com', '01.01.2013'),
(4, 'Egor', 'Tihonovetskiy', 'Petrovich', 'Consultant', '8921111859', 'tihtih@email.com', '01.01.2013'),
(5, 'Artem', 'Kapustin', 'Mihaylovich', 'Consultant', '8924588859', 'kapustinAM@email.com', '01.01.2013'),
(6, 'Dmitriy', 'Vaselkov', 'Egorovich', 'Chief accountant', '89254631444', 'vaselkovD@email.com', '01.01.2013'),
(7, 'Katerina', 'Ivanova', 'Mametovna', 'Accountant', '89784231859', 'ivan_kat@email.com', '01.01.2013')
SELECT * FROM DBO.Employee
------------------------------------------
INSERT INTO DBO.Customer 
VALUES
(6121, 'Daniil', 'Skotselyas', 'Vladimirovich', 'lyas.daniil@email.com', '89103058612'),
(6122, 'Eugeniy', 'Korolkov', 'Vladimirovich', 'korolok@email.com', '89103058999'),
(6123, 'Egor', 'Abramov', 'Mihaylovich', 'abram@email.com', '89103058612'),
(6124, 'Igor', 'Osipov', 'Valerevich', 'osip@email.com', '89111058612'),
(6125, 'Vladimir', 'Astakhov', 'Vladimirovich', 'astah@email.com', '89106452612'),
(6126, 'Azat', 'Hayrutdinov', 'Muratovich', 'azatik@email.com', '89103456912'),
(6127, 'Eugeniy', 'Androsov', 'Vladimirovich', 'dros@email.com', '89103784212'),
(6128, 'Nikita', 'Chuykov', 'Sergeevich', 'nikchuk@email.com', '89103788655')
SELECT * FROM DBO.Customer
---------------------------------------------
SELECT ModelID, ListPrice FROM DBO.ProductModel
INSERT INTO DBO.SalesOrderHeader
VALUES
(2001, GETDATE(), 3025000 , 6121, 4),
(2002, GETDATE(), 1525000 , 6122, 4),
(2003, GETDATE(), 3325000 , 6123, 4),
(2004, GETDATE(), 2700000 , 6124, 4),
(2005, GETDATE(), 4500000 , 6125, 4),
(2006, GETDATE(), 4500000 , 6126, 4),
(2007, GETDATE(), 2500 , 6127, 4),
(2008, GETDATE(), 30000 , 6128, 4)
SELECT * FROM DBO.SalesOrderHeader
---------------------------------------------
INSERT INTO DBO.SalesOrderDetail
VALUES 
(2001, 15, 1, 3000000, 0, 3000000),
(2001, 115, 5, 25000, 0, 25000),
(2002, 30, 1, 1500000, 0, 1500000),
(2002, 115, 5, 25000, 0, 25000),
(2003, 520, 1, 3300000, 0, 3300000),
(2003, 115, 5, 25000, 0, 25000),
(2004, 528, 1, 2700000, 0, 2700000),
(2005, 997, 1, 4500000, 0, 4500000),
(2006, 997, 1, 4500000, 0, 4500000),
(2007, 215, 100, 1200, 0, 1200),
(2007, 216, 100, 1300, 0, 1300),
(2008, 5877, 3, 30000, 0, 30000)
SELECT * FROM DBO.SalesOrderDetail
