USE [SALESDB]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_NEW_INVOICE_NO]    Script Date: 12/7/2021 2:01:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[GET_NEW_INVOICE_NO]
(
)
RETURNS VARCHAR(18) 
AS 
BEGIN

		
		DECLARE @tmp_id  VARCHAR (18)
		DECLARE @tmp_serial   VARCHAR (18)	
		
		SELECT @tmp_id  =  ISNULL(MAX(AUTO_ID),  '00000')
		FROM  dbo.SALES
		
		SET @tmp_serial=SUBSTRING(@tmp_id, 1, 6)
		SET @tmp_serial= RIGHT('000000'+CONVERT(VARCHAR(18),@tmp_serial+1),6)
		SET @tmp_id=SUBSTRING(@tmp_id, 1, 1)+@tmp_serial
		return 'INV' + RIGHT('000000'+@tmp_id,4);
	
	END
	
GO
/****** Object:  Table [dbo].[SALES]    Script Date: 12/7/2021 2:01:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SALES](
	[AUTO_ID] [int] IDENTITY(1001,1) NOT NULL,
	[INVOICE_NO] [nvarchar](50) NOT NULL,
	[DATE] [datetime] NULL,
	[CUSTOMER_MOBILE] [nvarchar](50) NULL,
	[TOTAL_AMOUNT] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_SALE] PRIMARY KEY CLUSTERED 
(
	[INVOICE_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SALES_ITEMS]    Script Date: 12/7/2021 2:01:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SALES_ITEMS](
	[SALESID_INVOICE] [nvarchar](50) NOT NULL,
	[ITEM_ID] [int] NOT NULL,
	[QTY] [int] NOT NULL,
	[SALES_PRICE] [decimal](18, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STOCK]    Script Date: 12/7/2021 2:01:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STOCK](
	[ITEM_ID] [int] IDENTITY(1,1) NOT NULL,
	[PURCHASE_PRICE] [decimal](18, 2) NOT NULL,
	[ITEM_NAME] [nvarchar](50) NULL,
 CONSTRAINT [PK_STOCK] PRIMARY KEY CLUSTERED 
(
	[ITEM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SALES] ON 

INSERT [dbo].[SALES] ([AUTO_ID], [INVOICE_NO], [DATE], [CUSTOMER_MOBILE], [TOTAL_AMOUNT]) VALUES (1010, N'INV1010', CAST(N'2019-07-24T07:37:51.000' AS DateTime), N'01771591857', CAST(18000.00 AS Decimal(18, 2)))
INSERT [dbo].[SALES] ([AUTO_ID], [INVOICE_NO], [DATE], [CUSTOMER_MOBILE], [TOTAL_AMOUNT]) VALUES (1011, N'INV1011', CAST(N'2019-07-24T07:37:51.000' AS DateTime), N'01771654322', CAST(5500.00 AS Decimal(18, 2)))
INSERT [dbo].[SALES] ([AUTO_ID], [INVOICE_NO], [DATE], [CUSTOMER_MOBILE], [TOTAL_AMOUNT]) VALUES (1012, N'INV1012', CAST(N'2019-07-24T07:37:51.000' AS DateTime), N'01987365443', CAST(800.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[SALES] OFF
GO
INSERT [dbo].[SALES_ITEMS] ([SALESID_INVOICE], [ITEM_ID], [QTY], [SALES_PRICE]) VALUES (N'INV1010', 1, 1, CAST(18000.00 AS Decimal(18, 2)))
INSERT [dbo].[SALES_ITEMS] ([SALESID_INVOICE], [ITEM_ID], [QTY], [SALES_PRICE]) VALUES (N'INV1011', 2, 1, CAST(5500.00 AS Decimal(18, 2)))
INSERT [dbo].[SALES_ITEMS] ([SALESID_INVOICE], [ITEM_ID], [QTY], [SALES_PRICE]) VALUES (N'INV1012', 3, 1, CAST(800.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[STOCK] ON 

INSERT [dbo].[STOCK] ([ITEM_ID], [PURCHASE_PRICE], [ITEM_NAME]) VALUES (1, CAST(15000.00 AS Decimal(18, 2)), N'LAPTOP')
INSERT [dbo].[STOCK] ([ITEM_ID], [PURCHASE_PRICE], [ITEM_NAME]) VALUES (2, CAST(5000.00 AS Decimal(18, 2)), N'MOBILE')
INSERT [dbo].[STOCK] ([ITEM_ID], [PURCHASE_PRICE], [ITEM_NAME]) VALUES (3, CAST(500.00 AS Decimal(18, 2)), N'WATCH')
SET IDENTITY_INSERT [dbo].[STOCK] OFF
GO
ALTER TABLE [dbo].[SALES] ADD  CONSTRAINT [DF_SALE_TOTAL_AMOUNT]  DEFAULT ((0)) FOR [TOTAL_AMOUNT]
GO
ALTER TABLE [dbo].[SALES_ITEMS] ADD  CONSTRAINT [DF_SALES_ITEMS_SALES_ID_INVOICE]  DEFAULT ((0)) FOR [SALESID_INVOICE]
GO
ALTER TABLE [dbo].[SALES_ITEMS] ADD  CONSTRAINT [DF_SALES_ITEMS_ITEM_ID]  DEFAULT ((0)) FOR [ITEM_ID]
GO
ALTER TABLE [dbo].[SALES_ITEMS] ADD  CONSTRAINT [DF_SALES_ITEMS_QTY]  DEFAULT ((0)) FOR [QTY]
GO
ALTER TABLE [dbo].[SALES_ITEMS] ADD  CONSTRAINT [DF_SALES_ITEMS_SALES_PRICE]  DEFAULT ((0)) FOR [SALES_PRICE]
GO
ALTER TABLE [dbo].[STOCK] ADD  CONSTRAINT [DF_STOCK_PURCHASE_PRICE]  DEFAULT ((0)) FOR [PURCHASE_PRICE]
GO
ALTER TABLE [dbo].[SALES_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_SALES_ITEMS_SALES] FOREIGN KEY([SALESID_INVOICE])
REFERENCES [dbo].[SALES] ([INVOICE_NO])
GO
ALTER TABLE [dbo].[SALES_ITEMS] CHECK CONSTRAINT [FK_SALES_ITEMS_SALES]
GO
ALTER TABLE [dbo].[SALES_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_SALES_ITEMS_STOCK] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[STOCK] ([ITEM_ID])
GO
ALTER TABLE [dbo].[SALES_ITEMS] CHECK CONSTRAINT [FK_SALES_ITEMS_STOCK]
GO
/****** Object:  StoredProcedure [dbo].[SALE_PURCHASE]    Script Date: 12/7/2021 2:01:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE  PROCEDURE   [dbo].[SALE_PURCHASE]
@ITEM_NAME nvarchar(50)
AS
SET NOCOUNT ON
IF (@ITEM_NAME = '')
BEGIN
  
SELECT S.INVOICE_NO, convert(varchar(12),S.DATE, 103) AS ENTRY_DATE,ST.ITEM_NAME,SI.SALES_PRICE,ST.PURCHASE_PRICE,(SI.SALES_PRICE-ST.PURCHASE_PRICE) AS PROFIT FROM SALES S,SALES_ITEMS SI,STOCK ST
WHERE S.INVOICE_NO=SI.SALESID_INVOICE AND ST.ITEM_ID=SI.ITEM_ID

END
ELSE
BEGIN
  SELECT S.INVOICE_NO, convert(varchar(12),S.DATE, 103) AS ENTRY_DATE,ST.ITEM_NAME,SI.SALES_PRICE,ST.PURCHASE_PRICE,(SI.SALES_PRICE-ST.PURCHASE_PRICE) AS PROFIT FROM SALES S,SALES_ITEMS SI,STOCK ST
WHERE S.INVOICE_NO=SI.SALESID_INVOICE AND ST.ITEM_ID=SI.ITEM_ID AND ITEM_NAME LIKE '%' + @ITEM_NAME + '%'
END


GO
