ALTER View PET_VMI as 
/****
This Query creates a view To get the newly uploaded orders to syetem and assign the orders to the corresponding Machines as per the techincal manual. 
****/

SELECT PWO,Material,
      case when Machine like 'AISA2' then PWO end as ASIA2,
      case when Machine like 'AISA5' then PWO end as AISA5,
      case when Machine like 'AISA6' then PWO end as AISA6,
      case when Machine like 'LT01' then PWO end as LT01, 
      case when Machine like 'LT02' then PWO end as LT02,
      Case when Machine Like 'ALL_LT250' then PWO end as ALL_LT250,
      case when Machine like 'LT03' then PWO end as LT03,
      case when Machine like 'LT04' then PWO end as LT04,
      case when Machine like 'LT05' then PWO end as LT05, 
      case when Machine like 'LT06' then PWO end as LT06,
      case when Machine like 'LT07' then PWO end as LT07,
      case when Machine like 'LT08' then PWO end as LT08,
            case when Machine like 'CHECK' then PWO end as [CHECK]  

From(


select convert(bigint,INC_COOIS.[order])as PWO ,
        convert(Date, concat(SUBSTRING(INC_COOIS.SchedStart,1,2),'/',SUBSTRING(INC_COOIS.SchedStart,4,2),
        '/',SUBSTRING(INC_COOIS.SchedStart,7,4)),103)as Schdate,
        INC_COOIS.Material,
        cast(RTRIM(LTRIM(FLA_ZMATCHAR.TubeDia)) as float) as DIA,
        LEFT(FLA_ZMATCHAR.TubeType,3) as Tubestruct,
        FLA_ZMATCHAR.Inserts,
        FLA_ZMATCHAR.ShoulderT as Tooling ,
        FLA_ZMATCHAR.TopSeal,

        Case
            when FLA_ZMATCHAR.TubeDia like '%22%' then 'AISA2'
            when FLA_ZMATCHAR.TubeDia like '%25%' then 'LT03'
            when FLA_ZMATCHAR.TubeDia like '%28%' and left(FLA_ZMATCHAR.TubeType,3) like '%ABL' and FLA_ZMATCHAR.Inserts like '%NO%'  then 'AISA6'
            when FLA_ZMATCHAR.TubeDia like '%28%' and left(FLA_ZMATCHAR.TubeType,3) like '%ABL' and FLA_ZMATCHAR.Inserts like '%YES%'  then 'LT01'
            when FLA_ZMATCHAR.TubeDia like '%28%' and left(FLA_ZMATCHAR.TubeType,3) like '%PBL' and (FLA_ZMATCHAR.Inserts like '%YES%' or FLA_ZMATCHAR.Inserts like '%NO%')  then 'LT02'            
            when FLA_ZMATCHAR.TubeDia like '%28%' and (FLA_ZMATCHAR.Inserts like '%YES%' or FLA_ZMATCHAR.Inserts like '%NO%') and FLA_ZMATCHAR.TopSeal like '%YES%' then 'LT02'
            when FLA_ZMATCHAR.TubeDia like '%32%' then 'ALL_LT250'
            when FLA_ZMATCHAR.TubeDia like '%35%' and FLA_ZMATCHAR.Inserts like '%NO%' and FLA_ZMATCHAR.ShoulderT Not like '%CLICK-ON%' then 'LT08'
            when FLA_ZMATCHAR.TubeDia like '%35%' and FLA_ZMATCHAR.ShoulderT like '%CLICK-ON%' then 'LT06'
            when FLA_ZMATCHAR.TubeDia like '%35%' and FLA_ZMATCHAR.Inserts like '%YES%' and FLA_ZMATCHAR.ShoulderT Not like '%CLICK-ON%' then 'LT03'
        Else
            'CHECK'
        END AS Machine

from INC_COOIS

left join FLA_ZMATCHAR on INC_COOIS.Material = FLA_ZMATCHAR.Material

where 
    INC_COOIS.RID = (select MAX(RID)from INC_COOIS)

    and not EXISTS (select convert(bigint,PlanSO) from INC_TUBPLANFULL 
                            where INC_COOIS.[Order] = INC_TUBPLANFULL.PlanSO                            
                            and INC_TUBPLANFULL.RID=(select max(INC_TUBPLANFULL.RID)FROM INC_TUBPLANFULL)
                            and PlanSO like '9%')
    and INC_COOIS.SO like '9%'
    and INC_COOIS.[Order] like '9%'

) VMI
