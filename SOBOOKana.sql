with SOBOOK as (
SELECT 
      ----preapring data : converitng  int to date 
       cast(concat (SUBSTRING(convert(nvarchar(50),RID),5,2),'.',SUBSTRING(convert(nvarchar(50),RID),7,2 ),'.',SUBSTRING(convert(nvarchar(50),RID),1,4 )) as date) as RID
      ,[Sold2P]
      ,[Sold2PName]
      ,[Ship2P]
      ,[Ship2PName]
      ,[SGrp] 
      ,[SO]
      --preapring data : converitng  string to date 
      ,cast(concat (SUBSTRING(SODocDate,4,2),'.',SUBSTRING(SODocDate,1,2 ),'.',SUBSTRING(SODocDate,7,4 )) as date) as SODoc_Date
      ,[Division]
      ,[Material]
      ,[MatDia]
      ,[MatCust]
      ,[MatCustDesc]
      ,[Plant]
      ,[PONumber],
      ----preapring data/cleaning data : converitng  string to date 
        
        case when PODocDate like '00.00.0000' then NUll
            else cast(concat (SUBSTRING(PODocDate,4,2),'.',SUBSTRING(PODocDate,1,2 ),'.',SUBSTRING(PODocDate,7,4 )) as date) 
        end as PODoc_Date ,
        

        case when SOReqDate like '00.00.0000' then NUll
            else cast(concat (SUBSTRING(SOReqDate,4,2),'.',SUBSTRING(SOReqDate,1,2 ),'.',SUBSTRING(SOReqDate,7,4 )) as date) 
        end as SOReq_Date ,
        
        case when SODueDate like '00.00.0000' then NUll
            else cast(concat (SUBSTRING(SODueDate,4,2),'.',SUBSTRING(SODueDate,1,2 ),'.',SUBSTRING(SODueDate,7,4 )) as date) 
        end as SODue_Date,

      [DispQty]
      ,[PendingQty]
      ,[AvailPallets]
      ,[AvailSOStock]
      ,[ToMfgQty]
      ,[HoldQty]
      ,[CostingStat]
      ,[Remarks]
      ,[SOType]
  FROM [epp_planning].[dbo].[INC_ZSOBOOK]
)   

SELECT * FROM SOBOOK
WHERE RID = (select max(RID) from SOBOOK)
