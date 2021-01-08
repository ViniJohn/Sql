select * from (

	select Ship2PName as customer, MatDia as Dia, month_requested,sum(ToMFG) as QTY_MFG from (

		select Ship2PName,MatDia,cast(substring(SOReqDate,4,2) as int)as month_requested,sum(ToMfgQty) as ToMFG from INC_ZSOBOOK
	where RID = (select max(RID) from INC_ZSOBOOK)
	and Division = 10 
	and MatDia = 40 
	and SOReqDate like '%2021%'
	group by Ship2PName,MatDia,SOReqDate
	having SUM(ToMfgQty)>0
	) temp
		
		group by Ship2PName,MatDia,month_requested
		) temp1

pivot (
 avg(QTY_MFG) 

For month_requested in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]) 

) pVT
