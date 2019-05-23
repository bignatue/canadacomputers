-- CREATE DATABASE --
CREATE DATABASE CanadaComputers;
GO


USE CanadaComputers;
GO


-- CREATE SCHEMA --
IF SCHEMA_ID('product') IS NULL
EXEC ('CREATE SCHEMA product');
GO

IF SCHEMA_ID('sales') IS NULL
EXEC ('CREATE SCHEMA sales');
GO


-- CREATE TABLE ACCOUNT TYPE --
CREATE TABLE accountType(
  accountTypeID INT NOT NULL PRIMARY KEY IDENTITY,
  accountTypeName VARCHAR(40) NOT NULL
);
GO


-- CREATE TABLE ACCOUNT STATUS --
CREATE TABLE accountStatus(
  accountStatusID INT NOT NULL PRIMARY KEY IDENTITY,
  label VARCHAR(12) NOT NULL
);
GO


-- CREATE TABLE ACCOUNT --
CREATE TABLE account(
  accountID INT NOT NULL PRIMARY KEY IDENTITY,
  username VARCHAR(12) NOT NULL,
  [password] VARCHAR(12) NOT NULL,
  email VARCHAR(12) NOT NULL,
  accountTypeID INT NULL FOREIGN KEY REFERENCES accountType(accountTypeID) ON DELETE CASCADE ON UPDATE CASCADE,
  accountStatusID INT NULL FOREIGN KEY REFERENCES accountStatus(accountStatusID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO
SELECT * FROM account;
GO




-- CREATE TABLE ACCOUNT CREATE --
CREATE TABLE accountCreated (
  accountID INT,
  dateCreated NVARCHAR(120)
);
GO


-- CREATE TABLE ACCOUNT DETAILS --
CREATE TABLE accountDetails(
  accountID INT NOT NULL FOREIGN KEY REFERENCES account(accountID) ON DELETE CASCADE ON UPDATE CASCADE,
	firstName VARCHAR(120) NOT NULL,
	lastName VARCHAR(120) NOT NULL,
	aptNumber VARCHAR(6) NULL,
	city VARCHAR(32) NULL,
	province VARCHAR(32) NULL,
	country VARCHAR(32) NULL,
	postalCode VARCHAR(12) NULL,
	mobilePhone INT NULL,
	phoneNumber INT NULL
);


-- CREATE TABLE BRANCH --
CREATE TABLE branch(
  branchID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  branchName VARCHAR(40) NOT NULL,
  branch_Address VARCHAR(120) NOT NULL,
  email VARCHAR(120) NOT NULL,
  contactNumber VARCHAR(20) NOT NULL
);
GO


-- CREATE TABLE MANUFACTURER --
CREATE TABLE manufacturer(
  manufacturerID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  manufacturerName VARCHAR(40) NOT NULL,
  manufacturer_Address VARCHAR(120) NOT NULL,
  email VARCHAR(120) NOT NULL,
  contactNumber VARCHAR(20) NOT NULL
);
GO


-- CREATE TABLE PRODUCT CATEGORY --
CREATE TABLE product.category(
  categoryID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  categoryName VARCHAR(120) NOT NULL
);
GO


-- CREATE TABLE PRODUCT BRAND --
CREATE TABLE product.brand(
  brandID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  brandName VARCHAR(120) NOT NULL
);
GO


-- CREATE TABLE PRODUCT DETAILS --
CREATE TABLE product.productDetails(
  productID INT NOT NULL PRIMARY KEY IDENTITY,
  productName VARCHAR(120) NOT NULL,
  productDescription NVARCHAR NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  manufacturerID INT NOT NULL FOREIGN KEY REFERENCES manufacturer(manufacturerID) ON DELETE CASCADE ON UPDATE CASCADE,
  categoryID INT NOT NULL FOREIGN KEY REFERENCES product.category(categoryID) ON DELETE CASCADE ON UPDATE CASCADE,
  brandID INT NOT NULL FOREIGN KEY REFERENCES product.brand(brandID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- CREATE TABLE PRODUCT MISCELLANEOUS --
CREATE TABLE product.productMisc (
  miscID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  label VARCHAR(120) NOT NULL
);
GO


-- CREATE TABLE MISCELLANEOUS CONTENT --
CREATE TABLE product.miscContent(
  productID INT NOT NULL FOREIGN KEY REFERENCES product.productDetails(productID) ON DELETE CASCADE ON UPDATE CASCADE,
  miscID INT NOT NULL FOREIGN KEY REFERENCES product.productMisc(miscID) ON DELETE CASCADE ON UPDATE CASCADE,
	Title VARCHAR(120) NOT NULL,
	[Description] TEXT NULL
);
GO


-- CREATE TABLE PRODUCT STOCKS --
CREATE TABLE product.stocks(
  productID INT NOT NULL FOREIGN KEY REFERENCES product.productDetails(productID) ON DELETE CASCADE ON UPDATE CASCADE,
  branchID INT NULL FOREIGN KEY REFERENCES branch(branchID) ON DELETE CASCADE ON UPDATE CASCADE,
  qty INT NOT NULL
);


-- CREATE TABLE ORDER STATUS --
CREATE TABLE sales.orderStatus(
  orderStatusID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  label VARCHAR(12)
);
GO


-- CREATE TABLE SALES ORDERS --
CREATE TABLE sales.orders (
  orderID INT NOT NULL IDENTITY (1, 1) PRIMARY KEY, 
  orderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  accountID INT NOT NULL FOREIGN KEY REFERENCES account(accountID) ON DELETE CASCADE ON UPDATE CASCADE,
  branchID INT NULL FOREIGN KEY REFERENCES branch(branchID) ON DELETE CASCADE ON UPDATE CASCADE,
  orderStatusID INT NULL FOREIGN KEY REFERENCES sales.orderStatus(orderStatusID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- CREATE TABLE ORDER ITEMS --
CREATE TABLE sales.orderItems(
  orderID INT NULL FOREIGN KEY REFERENCES sales.orders(orderID) ON DELETE CASCADE ON UPDATE CASCADE,
  productID INT NOT NULL FOREIGN KEY REFERENCES product.productDetails(productID) ON DELETE CASCADE ON UPDATE CASCADE,
  qty INT NOT NULL,
  price DECIMAL (10, 2) NOT NULL,
  discount DECIMAL (4, 2) NOT NULL DEFAULT 0
);
GO


-- CREATE TRIGGER TO ADD DATE OF ACCOUNT CREATED --
CREATE TRIGGER accountCreatedTrigger
ON account
FOR INSERT
AS
BEGIN
 DECLARE @accountID INT
 SELECT @accountID = accountID FROM inserted
 
 INSERT INTO accountCreated 
 VALUES(CAST(@accountID AS NVARCHAR(5)),CAST(GETDATE() AS NVARCHAR(20)))
END;
GO


-- PRESETS --
INSERT INTO accountType(accountTypeName) VALUES ('admin'), ('staff'), ('customers'), ('suppliers');
GO

INSERT INTO accountStatus (label) VALUES ('active'), ('inactive'), ('deactivate');
GO

INSERT INTO product.productMisc(label) VALUES ('Overview'),('Specifications'),('Warranty & Returns');
GO

INSERT INTO sales.orderStatus(label) VALUES ('Pending'), ('Processing'), ('Rejected'), ('Completed');
GO