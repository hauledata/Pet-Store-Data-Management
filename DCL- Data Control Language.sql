--PROCEDURE
--Câu 1: Viết Stored Procedure insert thông tin thú cưng thuộc loại animal vào database
GO
CREATE PROCEDURE insert_animal_data( @petid CHAR(10),@petcategory NVARCHAR(100),@vaccinated CHAR(2),@status CHAR(10)
                                    ,@animalid CHAR(10),@breed CHAR(10),@Color NVARCHAR(50),@sex NVARCHAR(50),@age NVARCHAR(50))
AS
IF NOT EXISTS (SELECT Pet_ID FROM Pet WHERE Pet_ID=@petid)
    BEGIN 
        INSERT INTO Pet VALUES (@petid,@petcategory,@vaccinated,@status)
        PRINT 'Table Pet inserted successfully'
    END
    ELSE 
    BEGIN
        PRINT 'Pet_ID already exists'
    END
IF NOT EXISTS (SELECT Animal_ID FROM Animal WHERE Animal_ID=@animalid)
    BEGIN
        INSERT INTO Animal VALUES (@animalid,@petid,@breed,@Color,@sex,@age)
        PRINT 'Table Animal inserted successfully'
    END
    ELSE
    BEGIN
        PRINT 'Animal_ID already exists '
    END
GO;

--Gọi thủ tục 
EXEC insert_animal_data 'P101','Dog','1','Still','A171','Chinese','Grey','Spayed Female','3 months'
-- DELETE FROM Bird WHERE Pet_ID = 'P102'
-- DELETE FROM Pet WHERE Pet_ID = 'P102'
-- -- SELECT * FROM Pet
-- -- SELECT * FROM Animal

--Câu 2: Viết Stored Procedure insert thông tin thú cưng thuộc loại bird vào database
GO
CREATE PROCEDURE insert_bird_data( @petid CHAR(10),@petcategory NVARCHAR(100),@vaccinated CHAR(2),@status CHAR(10)
                                ,@birdid CHAR(10),@birdcategory NVARCHAR(20), @color NVARCHAR(50),@noise NVARCHAR(50))
AS
IF NOT EXISTS (SELECT Pet_ID FROM Pet WHERE Pet_ID=@petid)
    BEGIN 
        INSERT INTO Pet VALUES (@petid,@petcategory,@vaccinated,@status)
        PRINT 'Table Pet inserted successfully'
    END
    ELSE 
    BEGIN
        PRINT 'Pet_ID already exists'
    END
IF NOT EXISTS (SELECT Bird_ID FROM Bird WHERE Bird_ID = @birdid)
    BEGIN
        INSERT INTO Bird VALUES (@birdid,@petid,@birdcategory,@color,@noise)
        PRINT 'Table Bird inserted successfully'
    END
    ELSE
    BEGIN
        PRINT 'Bird ID already exists '
    END
GO
--Gọi thủ tục
EXEC insert_bird_data 'P102','Bird','1','Still','B131','Chicken Mix','Red','Moderate'

SELECT * FROM Pet
SELECT * FROM Bird

--Câu 3: Viết Stored Procedure thêm dữ liệu thông tin khách hàng 
GO
CREATE PROCEDURE insert_customer (@id CHAR(10),@firstname NVARCHAR(50),@middlename NVARCHAR(50),@lastname NVARCHAR(50)
                                    ,@phone NVARCHAR(10),@gender CHAR(50),@address NVARCHAR(100),@loyalty INT)
AS 
IF NOT EXISTS (SELECT CS_ID FROM Customer WHERE CS_ID = @id)
BEGIN 
    INSERT INTO Customer VALUES (@id,@firstname,@middlename,@lastname,@phone,@gender,@address,@loyalty)
    PRINT 'Table Customer inserted successfully'
END
ELSE 
    PRINT 'CS_ID already exists'

--Gọi thủ tục
EXEC insert_customer '9999',N'Lê',N'Văn',N'An','0231254374','Male',N'Phường Tân Lập, Quận 10, TPHCM','100'

SELECT * FROM Customer
--Câu 4: Viết Stored Procedure thêm dữ liệu vào Receipt
GO 
CREATE PROCEDURE insert_receipt (@reid CHAR(10),@paymentmethodid CHAR(10),@staffid CHAR(10),@csid CHAR(10),@receipttype NVARCHAR(20))
AS
IF NOT EXISTS (SELECT Re_ID FROM Receipt WHERE Re_ID = @reid)
BEGIN
    IF EXISTS (SELECT Payment_Method_ID FROM Payment_Method WHERE Payment_Method_ID = @paymentmethodid)
        BEGIN
            IF EXISTS (SELECT Staff_ID FROM Staff WHERE Staff_ID = @staffid)
                BEGIN
                    IF EXISTS (SELECT CS_ID FROM Customer WHERE CS_ID = @csid)
                        BEGIN
                            INSERT INTO Receipt VALUES (@reid,@paymentmethodid,@staffid,@csid,@receipttype,GETDATE())
                            PRINT 'Table Receipt inserted successfully'
                        END
                        ELSE
                        BEGIN 
                            PRINT 'CS_ID does not exists in table Customer'
                        END
                END
                ELSE 
                    PRINT 'Staff_ID does not exists in table Staff '
        END
        ELSE 
            PRINT 'Payment_Method_ID does not exists in table Payment_Method'
END
ELSE
    PRINT 'Re_ID already exists'

--Gọi thủ tục
EXEC insert_receipt '754','1','ST027','9999','Sales'     

SELECT * FROM Receipt
--Câu 5: Viết Stored Procedure thêm dữ liệu vào chi tiết hoá đơn bán thú cưng
GO 
CREATE PROCEDURE insert_petsale_detail (@reid CHAR(10),@petid CHAR(10),@cost INT,@discount INT)
AS
IF EXISTS (SELECT Re_ID FROM Receipt WHERE Re_ID = @reid)
BEGIN
    IF EXISTS (SELECT Pet_ID FROM Pet WHERE Pet_ID = @petid)
        BEGIN
            IF NOT EXISTS (SELECT Pet_ID FROM Pet WHERE Pet_ID = @petid AND [Status] = 'Sold')
                BEGIN
                    INSERT INTO Pet_Sales_Detail VALUES (@reid,@petid,@cost,@discount)
                    PRINT 'Table Pet_Sales_Detail inserted successfully'
                END
                ELSE
                BEGIN
                    PRINT 'Pet is sold. Insert Failed'
                END
        END
        ELSE
            PRINT 'Pet_ID does not exists in table Pet'
END
ELSE
    PRINT 'Re_ID does not exists in table Receipt'

--Gọi thủ tục
EXEC insert_petsale_detail '754','P101','2000000','300000'

SELECT * FROM Pet_Sales_Detail

--Câu 6: Viết Stored Procedure thêm dữ liệu vào chi tiết hoá đơn bán đồ dùng thú cưng
GO 
CREATE PROCEDURE insert_productsale_detail (@reid CHAR(10),@pptid CHAR(10),@cost INT,@quantity INT,@discount INT)
AS 

IF EXISTS (SELECT Re_ID FROM Receipt WHERE Re_ID = @reid)
BEGIN
    IF EXISTS (SELECT PP_ID FROM Pet_Products WHERE PP_ID = @pptid)
        BEGIN
            IF NOT EXISTS (SELECT PP_ID FROM Pet_Products WHERE PP_ID = @pptid AND Inventory = 0)
                BEGIN
                    INSERT INTO Product_Sales_Detail VALUES (@reid,@pptid,@cost,@quantity,@discount)
                    PRINT 'Table Product_Sales_Detail inserted successfully'
                END
                ELSE
                    PRINT 'Product is out of stock'
        END
        ELSE 
            PRINT 'PP_ID does not exists in table Pet_Product'
END
ELSE 
    PRINT 'Re_ID does not exists in table Receipt'

--Gọi thủ tục
EXEC insert_productsale_detail '754','Ad102',500000,2,0;

-- DELETE from Product_Sales_Detail WHERE Re_ID = '754'

SELECT * FROM Product_Sales_Detail

--Câu 7: Viết stored procedure thêm dữ liệu vào bảng staff, cập nhật mã người quản lí cho nhân viên 
GO 
CREATE PROCEDURE insert_staff (@staff_ID CHAR(10),@stafftype NVARCHAR(20),@deid CHAR(10))
AS
IF NOT EXISTS (SELECT Staff_ID FROM Staff WHERE Staff_ID = @staff_ID)
BEGIN
    INSERT INTO Staff(Staff_ID,Staff_Type,De_ID) VALUES (@staff_ID,@stafftype,@deid)
    UPDATE Staff SET Manager_ID = (SELECT Manager_ID FROM Department WHERE De_ID = @deid) WHERE Staff_ID = @staff_ID
    PRINT 'Table Staff inserted successfully'
END
ELSE
    PRINT 'Staff_ID exists in table Staff'

--GỌI thủ tục
EXEC insert_staff 'ST030','Full-time','DE05'
SELECT * FROM Staff

--Câu 8: Viết stored procedure thêm thông tin nhân viên
GO
CREATE PROCEDURE insert_staff_info (@staff_id CHAR(10), @firstname NVARCHAR(50),@middlename NVARCHAR(50),@lastname NVARCHAR(50)
                                    ,@birthday DATE,@phone CHAR(10),@gender CHAR(10),@address NVARCHAR(100), @startdate DATE)
AS
IF EXISTS (SELECT Staff_ID FROM Staff WHERE Staff_ID = @staff_id)
BEGIN
    INSERT INTO Staff_Infomation VALUES (@staff_id,@firstname,@middlename,@lastname,@birthday,@phone,@gender,@address,@startdate)
    PRINT 'Table Staff_Infomation inserted successfully'
END
ELSE 
    PRINT 'Staff_ID does not exists in table Staff '

--GỌI thủ tục
EXEC insert_staff_info 'ST030',N'Lê',N'Đức',N'Nhân','1996-12-05','0932416721','Male',N'Quận Tân Bình, TP.HCM','2018-05-05';

SELECT * FROM Staff_Infomation
--Câu 9: Viết stored procedure cập nhật số điện thoai liên lạc với nhà cung cấp
GO 
CREATE PROCEDURE update_contact_supplier (@supply_id CHAR(10),@contactnumber CHAR(10))
AS
IF EXISTS (SELECT Supply_ID FROM Supplier WHERE Supply_ID = @supply_id)
BEGIN
    UPDATE Supplier SET Company_Contact_Number = @contactnumber WHERE Supply_ID = @supply_id
    PRINT 'Table Supplier updated successfully'
END
ELSE
    PRINT 'Supply_ID does not exists in table Supplier'

--GỌI thủ tục
EXEC update_contact_supplier 'SP001','0839463823';

SELECT * FROM Supplier

--Câu 10: Viết stored procedure đếm số lượng pet còn trong cửa hàng theo từng loại mà cửa hàng có
GO 
CREATE PROCEDURE Number_Category_Pet AS
BEGIN 
    SELECT Pet_Category
        ,COUNT(Pet_ID) AS Number_Pet
    FROM Pet
    WHERE [Status] = 'Still'
    GROUP BY Pet_Category
END

--GỌI thủ tục
EXEC Number_Category_Pet

--Câu 11: Viết stored procedure đếm số lượng Animal theo ký tự 
GO
CREATE PROCEDURE Count_Animal_By_Character (@title NVARCHAR(50),@titlecount INT OUT)
AS
BEGIN 
    SELECT @titlecount = COUNT(*) 
    FROM Animal
    WHERE Breed LIKE '%'+@title+'%'
END

--GỌI thủ tục
DECLARE @count INT
EXEC Count_Animal_By_Character 'Bull',@count OUTPUT 
SELECT @count AS Number_Animal

/*Câu 12: Viết stored procedure in ra thông tin đầy đủ của pet. 
Thông tin hiển thị gồm Pet_ID, Pet_Name,Pet_Category,Color, Vaccinated,Status */
GO 
CREATE PROCEDURE pet_full 
AS 
BEGIN 
    SELECT ani.Pet_ID
        ,Pet_Category
        ,Breed AS Pet_Name
        ,Color
        ,Vaccinated
        ,[Status]
    FROM Animal ani
    INNER JOIN Pet ON ani.Pet_ID = Pet.Pet_ID
    UNION 
    SELECT Bird.Pet_ID 
        ,Pet_Category
        ,Bird_Category AS Pet_Name
        ,Color
        ,Vaccinated
        ,[Status]
    FROM Bird
    INNER JOIN Pet ON Bird.Pet_ID = Pet.Pet_ID
END 

--GỌI thủ tục
EXEC pet_full

--Câu 13: Tạo stored procedure để xoá 1 dòng dữ liệu trong bảng Pet_Sales_Detail
GO 
CREATE PROCEDURE delete_product_sales (@petid CHAR(10))
AS
BEGIN 
    DELETE FROM Pet_Sales_Detail
    WHERE Pet_ID = @petid
END 

--Gọi thủ tục
EXEC delete_product_sales 'P101'
SELECT *From Pet_Sales_Detail


--FUNCTION
--Câu 1: Hàm tính toán doanh thu dựa trên giá ,số lượng, chiết khấu
GO
CREATE FUNCTION revenue (
    @price DEC(10,2)
    ,@quantity int
    ,@discount DEC(10,2) )
RETURNS DEC(10,2)
AS 
BEGIN 
    RETURN (@price *@quantity) - @discount
END
GO;
--Gọi hàm tính doanh thu của hoá đơn bán thú cưng
SELECT *
    ,dbo.revenue(Cost,1,Discount) AS Total_Amount
FROM Pet_Sales_Detail

--Câu 2: Hàm tính tổng tiền vốn 
GO 
CREATE FUNCTION fund (
    @price DEC(10,2)
    ,@quantity INT
)
RETURNS DEC(10,2)
AS 
BEGIN
    RETURN (@price * @quantity)
END
GO

--Gọi hàm tính vốn cửa hàng đã nhập sản phẩm và thú cưng về.
SELECT 
    Re_ID
    ,SUM(Total_Amount) AS Total_Fund
FROM 
(
    SELECT Re_ID
    ,dbo.fund(Original_Price,1) AS Total_Amount
    FROM Pet_Order_Detail
    UNION 
    SELECT Re_ID
        ,dbo.fund(Original_Price,Quantity) AS Total_Amount
    FROM Product_Order_Detail
    ) AS order_table
GROUP BY Re_id


-- Câu 3: Hàm tính lương 
GO 
CREATE FUNCTION staff_salary (
    @base_salary INT
    ,@bonus INT 
    ,@minus INT 
)
RETURNS DEC(10,2)
AS
BEGIN 
    RETURN(@base_salary +@bonus+@minus)
END
GO

--Gọi hàm tính lương tháng 10 của nhân viên
SELECT *
    ,dbo.staff_salary(Base_Salary,Bonus,Minus) AS Total_Salary
FROM Salary
WHERE [Month] = 10

--Câu 4 Hàm bảng tính lương của các nhân viên trong một tháng.
GO 
CREATE FUNCTION Salary_Month (@month CHAR(10))
RETURNS TABLE 
AS 
RETURN 
    SELECT *
        ,dbo.staff_salary(Base_Salary,Bonus,Minus) AS Total_Salary
    FROM Salary
    WHERE [Month] = @month
GO

--Gọi Hàm
SELECT *
FROM dbo.Salary_Month(10)

/* Câu 5: Viết hàm tính tiền vốn nhập các sản phẩm thú cưng 
thông tin hiển thị gồm mã hoá đơn, tên sản phẩm, loại sản phẩm, tiền vốn */
GO 
CREATE FUNCTION Fund_Product()
RETURNS TABLE 
AS
RETURN
    SELECT Re_ID
        ,PP_Name
        ,PP_Type
        ,dbo.fund(Original_Price,Quantity) AS Total_Amount
    FROM Product_Order_Detail orpro 
    LEFT JOIN Pet_Products pro ON orpro.PP_ID=pro.PP_ID
GO

--Gọi hàm
SELECT * 
FROM dbo.Fund_Product();


--TRIGGER
--Câu 1: Tạo một trigger cập nhật trạng thái của các thú cưng trong cửa hàng là "Sold" khi thêm một chi tiết hoá đơn mua thú cưng 
GO
CREATE TRIGGER update_pet_status ON Pet_Sales_Detail
AFTER INSERT
AS
BEGIN
    UPDATE Pet SET [Status]='Sold' 
    WHERE Pet.Pet_ID = (SELECT Pet_ID FROM inserted)
END 

SELECT * FROM Pet
SELECT * FROM Receipt
SELECT * FROM Pet_Sales_Detail
--Thực hiện insert dữ liệu vào bảng pet và pet_sales_detail
INSERT INTO Pet VALUES ('P101','Dog',1,'Still')
--thêm dữ liệu vào chi tiết hoá đơn thú cưng 
EXEC dbo.insert_petsale_detail '112','P101',1000000,0


--Câu 2: Tạo một trigger cập nhật trạng thái thú cưng trong cửa hàng là "Still" khi xoá một chi tiết hoá đơn mua thú cưng 
GO
CREATE TRIGGER update_pet_status_del ON Pet_Sales_Detail
AFTER DELETE
AS
BEGIN
    UPDATE Pet SET [Status]='Still' 
    WHERE Pet.Pet_ID = (SELECT Pet_ID FROM deleted)
END

-- Xoá một dòng trong chi tiết hoá đơn thú cưng
DELETE FROM Pet_Sales_Detail WHERE Pet_ID = 'P101'
SELECT * FROM Pet
SELECT * FROM Pet_Sales_Detail

--Câu 3: Tạo trigger cảnh báo khi thêm một mã thú cưng đã được bán vào trong Pet_Sales_Detail
GO
CREATE TRIGGER check_sold ON Pet_Sales_Detail 
FOR INSERT
AS
DECLARE @check INT;
SET @check = (SELECT COUNT(*) FROM Pet_Sales_Detail WHERE Pet_ID = (SELECT Pet_ID FROM inserted))
IF(@check >1)
    BEGIN 
        PRINT 'Pet is sold'
        ROLLBACK TRAN
        RETURN
    END

-- DROP TRIGGER check_sold
--Thêm một dòng dữ liệu với mã Pet_ID ='P101'
INSERT INTO Pet_Sales_Detail VALUES ('113','P101',1000000,0)
SELECT * FROM Pet_Sales_Detail
SELECT * FROM Pet


--Câu 4: Khi thêm chi tiết hoá đơn bán product thì cập nhật lại tồn kho
GO
CREATE TRIGGER trg_sales ON Product_Sales_Detail 
AFTER INSERT
AS 
BEGIN 
    UPDATE Pet_Products 
    SET Inventory = Inventory - (SELECT Quantity FROM inserted)
    FROM Pet_Products
    JOIN inserted ON Pet_Products.PP_ID = inserted.PP_ID
END

--Thêm mặt hàng vào chi tiết hoá đơn bán product
INSERT INTO Product_Sales_Detail VALUES ('102','Ne102',1000000,3,0)

SELECT * FROM Product_Sales_Detail
SELECT * FROM Pet_Products

--Câu 5: Khi xoá một chi tiết hoá đơn bán product thì cập nhật lại tồn kho
GO 
CREATE TRIGGER trg_dele ON Product_Sales_Detail
FOR DELETE
AS 
BEGIN 
    UPDATE Pet_Products
    SET Inventory = Inventory + (SELECT Quantity FROM deleted)
    FROM Pet_Products
    JOIN deleted ON Pet_Products.PP_ID = deleted.PP_ID
END

--Xoá mặt hàng từ chi tiết hoá đơn bán product 
DELETE FROM Product_Sales_Detail WHERE Re_ID = '102' AND PP_ID = 'Ne102'

--Câu 6: Cập nhật hàng trong kho sau khi cập nhật đơn hàng 
GO
CREATE TRIGGER trg_update ON Product_Sales_Detail
AFTER UPDATE
AS 
BEGIN 
    UPDATE Pet_Products
    SET Inventory = Inventory - (SELECT Quantity FROM inserted WHERE PP_ID = Pet_Products.PP_ID) + (SELECT Quantity FROM deleted WHERE PP_ID = Pet_Products.PP_ID)
    FROM Pet_Products
    JOIN deleted ON  Pet_Products.PP_ID = deleted.PP_ID
    JOIN inserted ON Pet_Products.PP_ID = inserted.PP_ID
END

--Cập nhật số lượng đơn bán hàng  
UPDATE Product_Sales_Detail SET Quantity = 3 WHERE Re_ID = '101' AND PP_ID = 'Ne102'
SELECT * FROM Product_Sales_Detail
SELECT * FROM Pet_Products

--Câu 7: cập nhật số lượng tồn kho khi thêm dữ liệu vào chi tiết hoá đơn nhập hàng 
GO 
CREATE TRIGGER trg_ins ON Product_Order_Detail 
AFTER INSERT,UPDATE 
AS
BEGIN 
        UPDATE Pet_Products
        SET Inventory = Inventory + (SELECT Quantity FROM inserted WHERE PP_ID =Pet_Products.PP_ID) - (SELECT Quantity FROM deleted WHERE PP_ID =Pet_Products.PP_ID)
        WHERE Pet_Products.PP_ID = (SELECT PP_ID FROM inserted) AND Pet_Products.PP_ID = (SELECT PP_ID FROM deleted)
END

-- DROP TRIGGER trg_ins
--Update dữ liệu vào chi tiết hoá đơn nhập hàng
UPDATE Product_Order_Detail SET Quantity = 20 WHERE Re_ID = '311' AND PP_ID='Ne102' 
SELECT * FROM Product_Order_Detail
SELECT * FROM Pet_Products

--Câu 8: Khi thêm 1 hoá đơn thì cập nhật lại bảng Service bao gồm Modify_Date, Re_ID, Status_ID, 
GO 
CREATE TRIGGER trg_insert_receipt ON Receipt 
AFTER INSERT
AS
BEGIN
    UPDATE Services SET Re_ID = (SELECT Re_ID FROM inserted), Status_ID = 1,Modify_Date=GETDATE()
    WHERE CS_ID IN (SELECT CS_ID FROM inserted) AND Re_ID IS NULL
END

-- DROP TRIGGER trg_insert_receipt
-- Thêm dữ liệu vào bảng Receipt
INSERT INTO Receipt VALUES ('999','2','ST026','7205','Sales','2022-11-05')

SELECT * FROm Services
SELECT * FROM Dim_Status
SELECT * from Cage
SELECT * FROM Receipt

--Câu 10: Khi xoá một mã hoá đơn dịch vụ cập nhật lại Re_ID, Status_ID, Modify_Date
GO 
CREATE TRIGGER trg_del_receipt ON Receipt 
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Services SET Re_ID = NULL, Status_ID = 2 ,Modify_Date=GETDATE()
    WHERE CS_ID IN (SELECT CS_ID FROM deleted) AND Re_ID = (SELECT Re_ID FROM deleted)
    DELETE FROM Receipt WHERE Re_ID = (SELECT Re_ID FROM deleted)
END

-- DROP TRIGGER trg_del_receipt
--Xoá hoá đơn 999
DELETE FROM Receipt WHERE Re_ID = '999'

--Câu 9: Khi hoá đơn dịch vụ đã trả tiền hoặc bị xoá, cập nhật trạng thái của chuồng 
GO
CREATE TRIGGER up_cage ON Services 
AFTER UPDATE,DELETE
AS
BEGIN
    UPDATE Cage SET Availability = 1 
    WHERE Cage_ID = (SELECT Cage_ID FROM inserted) AND Cage_ID = (SELECT Cage_ID FROM deleted)
    UPDATE Cage SET Availability =0 
    WHERE Cage_ID = (SELECT Cage_ID FROM deleted)
END

SELECT * FROM Cage
--Câu 11: Mỗi nhân viên nếu đi làm sẽ cập nhật total_work_number trong bảng lương
GO 
CREATE TRIGGER cal_work_number ON TimeSheet 
AFTER INSERT 
AS 
BEGIN 
    UPDATE Salary 
    SET Total_Work_Number = Total_Work_Number + (SELECT Work_Number FROM inserted)
    WHERE Staff_ID = (SELECT Staff_ID FROM inserted) AND [Month] = (SELECT MONTH(Day_Work) FROM inserted)
END

--Sau ngày 02/11/2022 đi làm tổng số công của nhân viên ST001 sẽ cập nhật
INSERT INTO TimeSheet VALUES ('ST001','F1','2022-11-02',1)

SELECT * FROM Salary
SELECT * FROM TimeSheet

--Phân quyền 
--Master
CREATE LOGIN staff WITH PASSWORD = 'Petshop123@'
--Tạo user login trong database PetShop
CREATE USER hau for LOGIN staff
--Gán quyền SELECT cho cả database đối với user hau
GRANT SELECT TO hau

--Backup
GO
CREATE PROCEDURE SaoLuuDuLieu(@tencsdl NVARCHAR(200),@tentaptin NVARCHAR(200))
AS
BEGIN
	BACKUP DATABASE @tencsdl TO DISK = @tentaptin
END
--Thực hiện thủ tục
EXEC dbo.SaoLuuDuLieu 'PetShop','c:\backup\PetShop.bak'

--restore 
Go
CREATE PROCEDURE restoreDatabse(@tencsdl NVARCHAR(100),@tenpath NVARCHAR(256))
AS
BEGIN
  RESTORE DATABASE @tencsdl FROM DISK = @tenpath
END
--Thực hiện thủ tục
EXEC restoreDatabse 'PetShop', 'c:\backup\PetShop.bak'
