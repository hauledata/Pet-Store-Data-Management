--1.1 Truy vấn bảng 
--Câu 1: Truy vấn thông tin Pet_ID, Breed, Color, Sex, Age trong bảng Animal
SELECT Pet_ID
    ,Breed
    ,Color
    ,Sex 
    ,Age
FROM Animal

--Câu 2: Truy vấn thông tin mã nhân viên, họ, tên lót, tên, ngày sinh, số điện thoại, giới tính, địa chỉ, ngày vào làm của nhân viên 
SELECT Staff_ID   
    ,Last_Name
    ,Middle_Name
    ,First_Name
    ,Birthday
    ,Phone
    ,Gender
    ,Address
    ,Start_Date
FROM Staff_Infomation

--Câu 3: Truy vấn thông tin mã cung cấp, tên công ty,tên người liên lạc, số điện thoại người liên lạc của nhà cung cấp
SELECT Supply_ID
    ,Company_Name
    ,Company_Contact_Name
    ,Company_Contact_Number
FROM Supplier

--Câu 4: Truy vấn thông tin mã sản phẩm, tên sản phẩm, số lượng tồn kho
SELECT PP_ID 
    ,PP_Name
    ,Inventory
FROM Pet_Products

--1.2 Truy vấn nhiều bảng (Phép kết)
--Câu 1: Truy vấn thông tin Pet_ID, Breed, Color, Sex, Vaccinated, Status của các thú cưng thuộc loại Animal
SELECT ani.Pet_ID
    ,Breed
    ,Color
    ,Sex
    ,Vaccinated
    ,[Status]
FROM Animal ani 
INNER JOIN Pet ON ani.Pet_ID=Pet.Pet_ID

--Câu 2: Truy vấn mã nhân viên, họ và tên, loại nhân viên, tên phòng ban, mã người quản lí của nhân viên 
SELECT st.Staff_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
    ,Staff_Type
    ,Department_Name
    ,st.Manager_ID
FROM Staff st 
LEFT JOIN Staff_Infomation info ON st.Staff_ID=info.Staff_ID
LEFT JOIN Department de ON st.De_ID=de.De_ID

/*Câu 3: Truy vấn thông tin mã hoá đơn, mã thú cưng, loại thú cưng, giá bán, giảm giá, thành tiền, họ và tên người mua, thời gian giao dịch 
--của các giao dịch bán hàng */
SELECT re.Re_ID
    ,sal.Pet_ID
    ,Pet_Category
    ,Cost
    ,Discount
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
    ,CONVERT(nvarchar,Transaction_Time,104) AS Transaction_Time
FROM Pet_Sales_Detail sal 
INNER JOIN Receipt re ON sal.Re_ID = re.Re_ID
LEFT JOIN Pet ON sal.Pet_ID = Pet.Pet_ID 
LEFT JOIN Customer cus ON re.CS_ID=cus.CS_ID

--Câu 4: Truy vấn thông tin mã hoá đơn, mã sản phẩm, tên sản phẩm thú cưng và tên công ty cung cấp
SELECT Re_ID
    ,pro.PP_ID
    ,PP_Name
    ,Company_Name
FROM Product_Order_Detail slord 
LEFT JOIN Pet_Products pro ON slord.PP_ID = pro.PP_ID
LEFT JOIN Supplier sup ON slord.Supply_ID = sup.Supply_ID

--1.3 Truy vấn có điều kiện (and, or, like, between, …)
--Câu 1: Truy vấn mã thú cưng, giống loài, màu sắc, tuổi, tình trạng tiêm chủng, trạng thái còn hay không của Animal
SELECT ani.Pet_ID
    ,Breed
    ,Color
    ,Age
    ,Vaccinated
    ,Status
FROM Animal ani 
LEFT JOIN Pet ON ani.Pet_ID=Pet.Pet_ID
WHERE Sex LIKE 'Neutered Male'

/*Câu 2: Truy vấn thông tin người mua hàng có hoá đơn thanh toán bằng hình thức tiền mặt 
và giới tính là nữ hoặc thời gian mua hàng trong khoảng tháng 5 và 10 */
SELECT Re_ID
    ,Payment_Type
    ,MONTH(Transaction_Time) AS Month_Trans
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
    ,Gender
    ,Phone
    ,Loyalty_Points
FROM Receipt re 
LEFT JOIN Customer cus ON re.CS_ID=cus.CS_ID
LEFT JOIN Payment_Method me ON re.Payment_Method_ID=me.Payment_Method_ID
WHERE re.Payment_Method_ID = 2 AND re.Receipt_Type = 'Sales' AND
    (cus.Gender LIKE 'Female' OR MONTH(Transaction_Time) BETWEEN 5 AND 10)

/* Câu 3 Truy vấn thông tin mã nhân viên, họ và tên, ngày sinh, giới tính, mã phòng ban, tên phòng ban,mã người quản lí 
mà nhân viên đó thuộc phòng ban technical hoặc marketing và mã nhân viên có chứa số 8 */
SELECT info.Staff_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
    ,Birthday
    ,Gender
    ,de.De_ID
    ,Department_Name
    ,de.Manager_ID
FROM Staff_Infomation info
LEFT JOIN Staff ON info.Staff_ID = Staff.Staff_ID
LEFT JOIN Department de ON Staff.De_ID = de.De_ID
WHERE de.De_ID IN ('DE01','DE05') AND info.Staff_ID LIKE '%8%'

--Câu 4: Truy vấn mã sản phẩm, tên sản phẩm, số lượng tồn kho điều kiện là trong tên sản phẩm chứa 'Hills' và loại sản phẩm khô
SELECT *
FROM Pet_Products
WHERE PP_Name LIKE '%Hills%' AND PP_Type LIKE '%dry%'

--7.4 Truy vấn tính toán
--Câu 1: Truy vấn nhân viên làm từ 4 năm trở lên thông tin hiển thị gồm mã nhân viên, họ và tên, ngày sinh, giới tính, số năm làm việc 
SELECT Staff_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
    ,Birthday
    ,Gender
    ,YEAR(GETDATE())-YEAR(Start_Date) AS Work_Year_Number
FROM Staff_Infomation 
WHERE YEAR(GETDATE())-YEAR(Start_Date) >= 4

--Câu 2: Tìm mức lương tối đa, thấp nhất và trung bình mà nhân viên nhận được trong tháng 10
SELECT MAX(Base_Salary+Bonus+Minus) AS Max_Salary
    ,MIN(Base_Salary+Bonus+Minus) AS Min_Salary
    ,AVG(Base_Salary+Bonus+Minus) AS Avg_Salary
FROM Salary 
WHERE [Month] = 10

/* Câu 3 Tìm sản phẩm có số lượng nhập về nhiều nhất hoặc ít nhất thông tin hiển thị gồm mã sản phẩm, mã nhà cung cấp, tên sản phẩm
loại sản phẩm, giá nhập về, số lượng nhập */
SELECT ord.PP_ID
    ,Supply_ID
    ,PP_Name
    ,PP_Type
    ,Original_Price
    ,Quantity
FROM Product_Order_Detail ord 
JOIN Pet_Products pro ON ord.PP_ID = pro.PP_ID
WHERE Quantity = (SELECT MAX(Quantity) FROM Product_Order_Detail)
    OR Quantity = (SELECT MIN(Quantity) FROM Product_Order_Detail)

--Câu 4: Tính số tiền thu về (sau khi giảm giá) của từng mã thú cưng trong tháng 10. Thông tin hiển thị mã thú cưng, giá bán, giảm giá, thành tiền
SELECT Pet_ID
    ,Cost
    ,Discount
    ,Total_Amount = Cost - Discount
FROM Pet_Sales_Detail slpet 
LEFT JOIN Receipt re ON slpet.Re_ID = re.Re_ID
WHERE MONTH(Transaction_Time) = 10

--7.5.	Truy vấn có gom nhóm (group by)

--Câu 1: Đêm số lượng các con thú cưng đang có ở cửa hàng theo từng loại
SELECT Pet_Category
    ,COUNT(Pet_ID) AS Number_Pet
FROM Pet 
GROUP BY Pet_Category

--Câu 2: Đếm số lượng dịch vụ được khách hàng sử dụng trong tháng 10 theo tên dịch vụ và loại dịch vụ
SELECT Se_Name
    , Sub_category
    ,COUNT(ser.[No]) AS number_service
FROM Services ser 
LEFT JOIN Service_Type typ ON ser.Se_ID = typ.Se_ID
WHERE MONTH(Create_Date)= 10
GROUP BY Se_Name, Sub_category

--Câu 3: Cho biết những khách hàng đã sử dụng loại hình dịch vụ thú cưng bao nhiêu lần, tính tổng số tiền mà họ chi cho dịch vụ đó 
SELECT CS_ID
    ,ser.Se_ID
    ,COUNT(No) AS Number_Repeat
    ,SUM(Cost*Quantity- IIF(vou.Value != NULL,Value,0)) AS Total_Amount
FROM Services ser 
LEFT JOIN Service_Type typ ON ser.Se_ID=typ.Se_ID
LEFT JOIN Voucher vou ON ser.Voucher_ID= vou.Voucher_ID
GROUP BY CS_ID,ser.Se_ID

--Câu 4 Cho biết số lượng hoá đơn theo mỗi loại hình thanh toán
SELECT Payment_Type
    ,COUNT(Re_ID) AS number_trans
FROM Receipt re 
LEFT JOIN Payment_Method pm ON re.Payment_Method_ID = pm.Payment_Method_ID
GROUP BY Payment_Type

--7.6.	Truy vấn gom nhóm có điều kiện (having)
--Câu 1: Tìm ra những loại sản phẩm được bán với doanh thu từ 3.000.000 đồng trở lên
SELECT PP_Type
    ,SUM(prde.Cost*Quantity-Discount) AS Total_Charge_Amount
FROM Product_Sales_Detail prde 
LEFT JOIN Pet_Products pro ON prde.PP_ID=pro.PP_ID
GROUP BY PP_Type
HAVING SUM(prde.Cost*Quantity-Discount) >= 3000000

--Câu 2: Cho biết những phòng ban có tổng lương tháng 10 trong khoảng 50.000.000 đồng đến 70.000.000 đồng
SELECT Department_Name
    ,SUM(Base_Salary+Bonus+Minus) AS Total_Salary_Department
FROM Staff st 
LEFT JOIN Salary sal ON st.Staff_ID = sal.Staff_ID
LEFT JOIN Department de ON st.De_ID = de.De_ID
WHERE sal.Month = 10
GROUP BY Department_Name
HAVING SUM(Base_Salary+Bonus+Minus) BETWEEN 50000000 AND 70000000

--Câu 3: Cho biết những ngày mà tổng số người làm việc cho ca làm đó bé hơn hoặc bằng 3
SELECT DAY(Day_Work) AS Day
    ,tim.Shift_ID
    ,COUNT(Staff_ID) AS Number_Staff
FROM TimeSheet tim  
LEFT JOIN Work_Calendar cal ON tim.Shift_ID = cal.Shift_ID
WHERE MONTH(Day_Work)=10
GROUP BY DAY(Day_Work), tim.Shift_ID
HAVING COUNT(Staff_ID) <= 3
ORDER BY Day ASC, tim.Shift_ID ASC

--Câu 4: Tính tổng số tiền mà mỗi khách hàng đã chi trả cho dịch vụ thú cưng. Cho biết những mã khách hàng có tổng số tiền chi trả trên 500.000Đ
SELECT CS_ID
    ,SUM(Cost*Quantity-IIF(vou.Value !=NULL,vou.Value,0)) AS Total_Amount
FROM Services se 
LEFT JOIN Voucher vou ON se.Voucher_ID=vou.Voucher_ID
GROUP BY CS_ID
HAVING SUM(Cost*Quantity-IIF(vou.Value !=NULL,vou.Value,0)) > 500000

--7.7.Truy vấn có sử dụng phép giao, hội, trừ
--<Phép giao> Câu 1: Sử dụng phép giao cho biết những con thú cưng đã được bán, thông tin hiển thị mã thú cưng 
SELECT Pet_ID
FROM Pet_Sales_Detail
INTERSECT
SELECT Pet_ID
FROM Pet 

--<Phép giao> Câu 2: Sử dụng phép giao cho biết những nhân viên đi làm đủ 31 ngày trong tháng 10. Thông tin hiển thị gồm mã nhân viên, họ và tên
SELECT Staff_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
FROM Staff_Infomation info 
WHERE Staff_ID IN 
(
    SELECT Staff_ID
    FROM Staff 
    INTERSECT 
    SELECT Staff_ID
    FROM TimeSheet
    WHERE MONTH(Day_Work) = 10
    GROUP BY Staff_ID
    HAVING COUNT(Day_Work) = 31
)

--<Phép hội> Câu 1: Sử dụng phép hội cho biết thông tin chi tiết gồm mã thú cưng, tên thú cưng, màu sắc, loại thú cưng 
SELECT ani.Pet_ID
    ,Breed AS Pet_Name
    ,Color
    ,Pet_Category
FROM Animal ani
INNER JOIN Pet ON ani.Pet_ID = Pet.Pet_ID
UNION 
SELECT Bird.Pet_ID 
    ,Bird_Category
    ,Color
    ,Pet_Category
FROM Bird
INNER JOIN Pet ON Bird.Pet_ID = Pet.Pet_ID

/*<Phép hội> Câu 2: Cho biết thông tin của tất cả hoá đơn (bao gồm bán thú cưng và dịch vụ thú cưng). 
Thông tin hiển thị mã hoá đơn, mã loại dịch vụ/mã thú cưng, tổng số tiền thu được */
SELECT Re_ID
    ,Pet_ID AS Code_Type
    ,Cost - Discount AS Charge_Amount
FROM Pet_Sales_Detail   
UNION 
SELECT Re_ID
    ,PP_ID AS Code_Type
    ,Cost*Quantity-Discount AS Charge_Amount
FROM Product_Sales_Detail 
UNION
SELECT Re_ID
    ,Se_ID AS Code_Type
    ,(Cost*Quantity - IIF(vou.Value !=NULL,vou.Value,0)) AS Charge_Amount
FROM Services ser 
LEFT JOIN Voucher vou ON ser.Voucher_ID=vou.Voucher_ID
WHERE Status_ID = 1

/* <Phép trừ> Câu 1: Cho biết những sản phảm thú cưng chưa được mua lần nào. 
Thông tin hiển thị gồm mã sản phẩm, tên sản phẩm, loại sản phẩm, số lượng tồn kho */
SELECT PP_ID
    ,PP_Name
    ,PP_Type
    ,Inventory
FROM Pet_Products
WHERE PP_ID IN 
(
    SELECT PP_ID
    FROM Pet_Products
    EXCEPT
    SELECT PP_ID
    FROM Product_Sales_Detail
)

/*--<Phép trừ> Câu 2: Tìm ra những khách hàng đến cửa hàng chỉ mua thú cưng mà không mua sản phẩm dành cho thú cưng.
Thông tin hiển thị gồm mã hoá đơn, họ và tên khách hàng */
SELECT Re_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
FROM Receipt re
LEFT JOIN Customer cus ON re.CS_ID = cus.CS_ID
WHERE Re_ID IN 
(
    SELECT Re_ID
    FROM Pet_Sales_Detail
    EXCEPT
    SELECT Re_ID
    FROM Product_Sales_Detail
)

--7.8.	Truy vấn con
--Câu 1: Cho biết những Animal đã được bán. Thông tin hiển thị gồm mã thú cưng, tên giống loài, màu sắc, giới tính, tuổi 
SELECT Pet_ID
    ,Breed
    ,Color
    ,Sex
    ,Age
FROM Animal 
WHERE Pet_ID IN 
(
    SELECT Pet_ID
    FROM Pet
    WHERE Status = 'Sold'
)

/* Câu 2: Cho biết những nhân viên thuộc loại nhân viên bán thời gian.
Thông tin hiển thị gồm mã nhân viên, họ và tên, giới tính, ngày sinh, ngày vào làm */
SELECT Staff_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
    ,Gender
    ,Birthday
    ,Start_Date
FROM Staff_Infomation 
WHERE Staff_ID IN 
(
    SELECT Staff_ID
    FROM Staff 
    WHERE Staff_Type = 'Part-Time'
)

/*Câu 3: Tìm những khách hàng không có hoá đơn vào tháng 10. 
Thông tin hiển thị gồm mã khách hàng, họ và tên, giới tính, địa chỉ, điểm tích luỹ*/ 
SELECT CS_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
    ,Gender
    ,Address
    ,Loyalty_Points
FROM Customer
WHERE CS_ID NOT IN 
(
    SELECT CS_ID
    FROM Receipt 
    WHERE MONTH(Transaction_Time) = 10
)

--Câu 4: Cho biết mã nhân viên, họ và tên những nhân viên full-time đi làm không nghỉ ngày nào trong tháng 10
SELECT inf.Staff_ID
    ,CONCAT(TRIM(Last_Name),' ',TRIM(Middle_Name),' ',TRIM(First_Name)) AS Full_Name
FROM (
    SELECT Staff.Staff_ID
    FROM TimeSheet
    LEFT JOIN Staff ON TimeSheet.Staff_ID = Staff.Staff_ID
    WHERE Staff_Type = 'Full-time'and MONTH(Day_Work) =10
    GROUP BY Staff.Staff_ID
    HAVING COUNT(Day_Work) =31
    ) AS full_staff 
INNER JOIN Staff_Infomation inf ON full_staff.Staff_ID = inf.Staff_ID

--7.9.	Truy vấn chéo
--Câu 1: Tính doanh thu của dịch vụ thú cưng trong 3 tháng (9,10,11) sau đó chuyển đổi bảng 
SELECT Se_Name 
    ,[9], [10], [11]
FROM (SELECT MONTH(Create_Date) AS Month
        ,Se_Name
        ,SUM(Cost*Quantity-IIF(vo.Value != NULL,vo.Value,0)) AS Total_Charge_Amount
    FROM Services se 
    LEFT JOIN Service_Type typ ON se.Se_ID = typ.Se_ID
    LEFT JOIN Voucher vo ON se.Voucher_ID = vo.Voucher_ID
    WHERE MONTH(Create_Date) IN ('9','10','11')
    GROUP BY MONTH(Create_Date), Se_Name) AS source 
PIVOT 
(
    MIN(Total_Charge_Amount)
    FOR Month IN ([9],[10],[11])
) AS pivottable 

--Câu 2: Tính số lượng người thanh toán theo các hình thức giao dịch mà cửa hàng có trong năm 2022 theo từng tháng. Sau đó chuyển đổi bảng 
SELECT Payment_Type
    ,ISNULL([1],0) AS [1],ISNULL([2],0) AS [2],ISNULL([3],0) AS [3],ISNULL([4],0) AS [4],ISNULL([5],0) AS [5],ISNULL([6],0) AS [6]
    ,ISNULL([7],0) AS [7],ISNULL([8],0) AS [8],ISNULL([9],0) AS [9],ISNULL([10],0) AS [10],ISNULL([11],0) AS [11],ISNULL([12],0) AS [12]
FROM 
(
    SELECT MONTH(Transaction_Time) AS Month
    ,Payment_Type
    ,COUNT(DISTINCT CS_ID) AS Number_Customer
    FROM Receipt re 
    LEFT JOIN Payment_Method me ON re.Payment_Method_ID = me.Payment_Method_ID
    WHERE Receipt_Type = 'Sales' AND YEAR(Transaction_Time) = 2022
    GROUP BY Payment_Type, MONTH(Transaction_Time)
) as source 
PIVOT
(
    SUM(Number_Customer)
    FOR Month IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS pivottable 

--Câu 3: Tính số lượng các loại hàng được nhập theo mã hoá đơn, tên công ty. Sau đó chuyển đổi bảng 
SELECT Company_Name
    ,Category
    ,ISNULL([198],0) AS [198],ISNULL([201],0) AS [201],ISNULL([210],0) AS [210]
    ,ISNULL([311],0) AS [311],ISNULL([312],0) AS [312],ISNULL([333],0) AS [333]
FROM 
(
    SELECT Re_ID 
        ,Company_Name
        ,Pet_Category AS Category
        ,COUNT(orpe.Pet_ID) AS Amount
    FROM Pet_Order_Detail orpe 
    LEFT JOIN Supplier sup ON orpe.Supply_ID = sup.Supply_ID
    LEFT JOIN Pet ON orpe.Pet_ID = Pet.Pet_ID
    WHERE Re_ID IN (SELECT Re_ID FROM Receipt WHERE YEAR(Transaction_Time)=2022)
    GROUP BY Re_ID, Company_Name, Pet_Category
    UNION
    SELECT Re_ID
        ,Company_Name
        ,PP_Type AS Category
        ,SUM(Quantity) AS Amount
    FROM Product_Order_Detail orpr
    LEFT JOIN Pet_Products pro ON orpr.PP_ID = pro.PP_ID
    LEFT JOIN Supplier sup ON orpr.Supply_ID = sup.Supply_ID
    WHERE Re_ID IN (SELECT Re_ID FROM Receipt WHERE YEAR(Transaction_Time)=2022)
    GROUP BY Re_ID, Company_Name, PP_Type 
) as source 
PIVOT
(
    SUM(Amount)
    FOR Re_ID IN ([198],[201],[210],[311],[312],[333])
) AS pivottable 
ORDER BY Company_Name ASC, Category ASC 

--Câu 4 Tính số lượng giao dịch của khách hàng trong từng quý. Sau đó chuyển đổi bảng 
SELECT CS_ID
    ,ISNULL([1],0) AS 'Quarter 1'
    ,ISNULL([2],0) AS 'Quarter 2'
    ,ISNULL([3],0) AS 'Quarter 3'
    ,ISNULL([4],0) AS 'Quarter 4'
FROM (
    SELECT CS_ID
        ,DATEPART(QUARTER,Transaction_Time) AS Quarter
        ,COUNT(DISTINCT Re_ID) AS number_trans
    FROM Receipt 
    WHERE Receipt_Type = 'Sales'
    GROUP BY CS_ID,DATEPART(QUARTER,Transaction_Time)
) AS source
PIVOT
(
    SUM(number_trans)
    FOR Quarter IN ([1],[2],[3],[4])
) AS pivottable 

