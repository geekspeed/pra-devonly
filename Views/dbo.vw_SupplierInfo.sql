SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_SupplierInfo]
AS
/*
SELECT     VENDOR_NAME AS SupplierName, ADDRESS_1 AS SupplierAddrLine1, ADDRESS_2 + ADDRESS_3 AS SupplierAddrLine2, CITY AS SupplierCity, 
                      STATE AS SupplierState, COUNTRY AS SupplierCountry, ZIP_CODE AS SupplierZipCode, TAX_1099_NO AS SupplierTaxId, 
                      VENDOR_ID AS SupplierCode,isnull(PO_CONTACT,'') as ContactName, isnull(PO_PHONE_NO,'') as ContactPhone,isnull(FAX_NO,'') as ContactFax,
						isnull(POFVM_USER_1,'') as ContactEmail
FROM         [EXPANDABLE\MSSQL2005].esidb.dbo.pofvm AS pofvm_1
WHERE     (DELETE_FLAG = 'N')
  */

SELECT [VENDORID] AS SupplierCode
      ,isnull([VENDORNAME],'')  AS SupplierName
      ,isnull([STREET],'') AS SupplierAddrLine1
      ,isnull([CITY],'') AS SupplierCity
      ,isnull([COUNTRY],'') AS SupplierCountry
      ,isnull([PINCODE],'') AS SupplierZipCode
      ,isnull([TAXCODE],'') AS SupplierTaxId
      ,isnull([PHONE],'')  as ContactPhone
      ,isnull([POBOX],'') AS SupplierAddrLine2
      ,isnull([FAX],'') AS ContactFax
      ,isnull([STATE],'') AS SupplierState
      ,isnull([Email],'')  as ContactEmail
      ,isnull([NAME],'') AS ContactName
  FROM [PRA-devonly].[dbo].[tbl_SAP_Vendor] with (nolock)

GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "pofvm_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3645
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vw_SupplierInfo', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_SupplierInfo', NULL, NULL
GO
