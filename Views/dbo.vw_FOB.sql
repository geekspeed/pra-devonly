SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_FOB]
as
/*
SELECT RECNUM AS LookupId, 'FREIGHT_TERMS' AS LookupType, RTRIM(LTRIM(Description)) AS LookupText, RTRIM(LTRIM(Value)) AS LookupValue, 
               0 AS ParentLookupId, 0 AS SortOrder 
FROM  [EXPANDABLE\MSSQL2005].ESIDB.DBO.XXFDIC AS XXFDIC_1
WHERE (ENTRY_TYPE = 'T') AND (Delete_Flag = 'N') AND (DATA_ELEM_NAME = 'FOB')
*/
SELECT [LookupId]
      ,[LookupType]
      ,[LookupText]
      ,[LookupValue]
      ,[ParentLookupId]
      ,[SortOrder]
  FROM [dbo].[tbl_FOB] with (nolock)
GO
