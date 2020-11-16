SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*** This query creates a View called PET_LAMINATECONFIRMATION.
The orignal process is to pull  3 different  tables from  the sql server to an excel workbook and upate formulas to on a daily basis to report the excel sheet 
below query is simplies the day to day manual operation. ***/


CREATE View [dbo].[PET_LAMINATECONFIRMATION] AS

select *,
		case when Reqdate < Planning_duedate  then 'NOK' /****** OTIF Column ******/
       else 'OK'
		end as OTIF

from 
(
select SO,Customer,Material,Mat_status,OldMaterial,MaterialDesc,Reqdate,

Case
       when Reqdate < Planningconfirmation then  Planningconfirmation
       else 
       (Case when DATEPART(weekday, Reqdate) = 1 or DATEPART(weekday, Reqdate)=7 then DATEADD(Day,2,Reqdate)else Reqdate end) 
		END as Planning_duedate/****** Planning_duedate --> adds 2 days to the Confirmation date if it lies on the weekend ******/

from (
select distinct INC_LAMICONFIRM.SO,INC_ZSOBOOK.Ship2PName as Customer,INC_ZSOBOOK.Material,FLA_ZMATCHAR.OldMatNo as OldMaterial,FLA_ZMATCHAR.MatDesc as MaterialDesc,LEFT(FLA_ZMATCHAR.costStatus,2) as Mat_status ,
		        convert(date,concat(RIGHT(INC_ZSOBOOK.SOReqDate,4),'-',substring(INC_ZSOBOOK.SOReqDate,4,2),'-',LEFT(INC_ZSOBOOK.SOReqDate,2)),0) as Reqdate,/******converting date formate from 10.12.2020 to 2020-12-10 ******/
				INC_LAMICONFIRM.ConfDate As Planningconfirmation

from INC_LAMICONFIRM

       Left join INC_ZSOBOOK on INC_LAMICONFIRM.SO = INC_ZSOBOOK.SO
       left join FLA_ZMATCHAR on INC_ZSOBOOK.Material =FLA_ZMATCHAR.Material
       
where INC_LAMICONFIRM.RID =(select max(INC_LAMICONFIRM.RID) from INC_LAMICONFIRM)
	  and INC_ZSOBOOK.RID = (select max(INC_ZSOBOOK.RID) from INC_ZSOBOOK)

) as Plannedworkorder 

) as finalconfirm

GO
