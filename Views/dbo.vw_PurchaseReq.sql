SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_PurchaseReq]
AS
SELECT PRN.PRNum, PR.RequestorId, PR.CreatedDate, PR.CreatedBy, LV.LookupText AS PRType, ISNULL(LK.LookupText, PR.Status) AS Status, 
               ISNULL(PRC_VALUE.PRValue, 0.00) AS PRValue, ISNULL(SUPPLIER.SupplierName, '') AS SupplierName, ISNULL(SC.ContactName, '') 
               AS ContactName, ISNULL(SC.ContactPhone, '') AS ContactPhone, ISNULL(SC.ContactEmail, '') AS ContactEmail, 
               PR.RequestorDept AS DepartmentName, PR.Priority, coalesce(PRC_VALUE.DelDate,PR.RequestedDate)RequestedDate, PR.Justification, ISNULL(PR.PONumber, '') AS PONumber, PR.ModifiedBy, 
               PR.ModifiedDate, PR.Status AS StatusValue, PR.Buyer AS BuyerId, ISNULL(PR.Title, '') AS Title
FROM  dbo.tbl_PurchaseReq AS PR LEFT OUTER JOIN
               dbo.tbl_PRNumbers AS PRN ON PR.PRId = PRN.PRId LEFT OUTER JOIN
               dbo.tbl_Lookup_Values AS LK ON PR.Status = LK.LookupValue LEFT OUTER JOIN
               dbo.tbl_Lookup_Values AS LV ON PR.GLCode = LV.LookupValue LEFT OUTER JOIN
                   (SELECT PRID, CAST(ISNULL(SUM((100.00 - PartDiscount) *LocalToUsd * PartQty * PartUnitPrice / 100.00), 0) AS decimal(25, 2)) AS PRValue,MIN(DeliveryDate) DelDate
                    FROM   dbo.tbl_PurchaseReq_Cart AS PRC
                    WHERE (UPPER(Status) = 'ACTIVE')
                    GROUP BY PRID) AS PRC_VALUE ON PRC_VALUE.PRID = PR.PRId LEFT OUTER JOIN
                   (SELECT DISTINCT PC.PRID, S.SupplierName
                    FROM   dbo.tbl_PurchaseReq_Cart AS PC LEFT OUTER JOIN
                                   dbo.tbl_Part_Supplier AS PS ON PC.PartSupplierId = PS.PartSupplierId LEFT OUTER JOIN
                                   dbo.tbl_SupplierInfo AS S ON PS.SupplierId = S.SupplierId) AS SUPPLIER ON PR.PRId = SUPPLIER.PRID LEFT OUTER JOIN
               dbo.tbl_SupplierInfo_Contact AS SC ON PR.PRId = SC.PRId
WHERE (LV.LookupType = 'PR_TYPE') AND (LK.LookupType = 'STATUS')
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[20] 3) )"
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
         Begin Table = "PR"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 225
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PRN"
            Begin Extent = 
               Top = 7
               Left = 273
               Bottom = 99
               Right = 446
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LV"
            Begin Extent = 
               Top = 105
               Left = 273
               Bottom = 233
               Right = 446
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PRC_VALUE"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 232
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SUPPLIER"
            Begin Extent = 
               Top = 238
               Left = 48
               Bottom = 330
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SC"
            Begin Extent = 
               Top = 238
               Left = 269
               Bottom = 366
               Right = 442
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
         Column = 2436
         Alias = 2040
         ', 'SCHEMA', N'dbo', 'VIEW', N'vw_PurchaseReq', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'Table = 1170
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_PurchaseReq', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_PurchaseReq', NULL, NULL
GO
