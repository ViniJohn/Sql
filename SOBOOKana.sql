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
       [OriginQty]
      ,[DispQty]
      ,[PendingQty]
      ,[AvailPallets]
      ,[AvailSOStock]
      ,[ToMfgQty]
      ,[HoldQty]
      ,[CostingStat]
      ,[Remarks]
      ,[SOType]
  FROM [epp_planning].[dbo].[INC_ZSOBOOK]
-- Distinct class could  be used on the select statment but  I want to try conveterting the column names into single row with comma sepreated values in a single row 
/*select COLUMN_NAME+',' as 'data()' from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'INC_ZSOBOOK'
for XML PATH('')*/
group by RID, Sold2P, Sold2PName, Ship2P, Ship2PName, SGrp, SO, SODocDate, Division, Material, MatDia, MatCust, MatCustDesc, Plant, PONumber, PODocDate, SOReqDate, SODueDate, OriginQty, DispQty, PendingQty, AvailPallets, AvailSOStock, ToMfgQty, HoldQty, CostingStat, Remarks, SOType
) 

/*analysis for a particular divsion*/
--Finding Leadtiems between orderpaced date vs requested of delivery for the last year 
select *,(coalesce(([January]+[February]+[March]+[April]+[May]+[June]+[July]+[August]+[September]+[October]+[November]+[December]),[January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December] ))/12 as AVG_Leadtime from  
    (select customer_name,[January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December] FROM
        (select customer_name,AVG(Leadtime) as Lead_Time,Order_month from 
            (select SO, Sold2PName as customer_name,Sold2P as customer_number ,SODoc_Date, SOReq_Date, 
                DATEDIFF(week, SODoc_Date,SOReq_Date) as Leadtime,
                DATENAME(MONTH, SODoc_Date) as Order_month 
            from  SOBOOK
            where SODoc_Date BETWEEN '2020-01-01' and '2020-12-31'
            and Division = 10
            GROUP by SO,Sold2PName,Sold2P,SODoc_Date, SOReq_Date) as tepmp 
        GROUP by customer_name,Order_month ) as Data_table
    PIVOT(
        AVG(Lead_Time)
        For Order_month in ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December] )
    ) as PVT ) as Reults
    order by AVG_Leadtime desc 

/*
--Finding delivery date chagnes on a single order 
select SOBOOK.SO, SOBOOK.Sold2PName as customer_name,Sold2P as customer_number ,PODoc_Date,SODoc_Date, SOReq_Date,SODue_Date, 
        DATEDIFF(week, SODoc_Date,SOReq_Date) as Leatime
from  SOBOOK
where RID BETWEEN '2020-12-01' and '2020-12-31'
and Division = 10
GROUP by SO,Sold2PName,Sold2P,PODoc_Date,SODoc_Date, SOReq_Date,SODue_Date
*/

