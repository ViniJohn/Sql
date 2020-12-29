
--Creating a view to simpily excel reporting/ automating copy past. Previous process was Manual copy pasting on a daily basis (min 50 records a day). 
CREATE VIEW  PET_LAMD AS 
SELECT  CONCAT(Track,Material) AS string,Track,Material, NUll AS matdesc,Material2, null AS matdesc2, Mat2Use AS uniqueid,Lami_with,Dia FROM 

   (SELECT distinct Temp1.*, ROUND((Temp1.Lami_with)/(PI()*2*(Temp1.Dia/2)),0) AS Track  FROM (

         SELECT Temp.Material,Temp.Material2,Temp.Mat2Desc,
                  CASE WHEN Temp.Lamiwidth = '?' THEN 0
                  ELSE cASt(Temp.Lamiwidth AS FLOAT)
                  END AS Lami_with ,cASt (FLA_ZMATCHAR.TubeDia AS FLOAT) AS Dia,
                Temp.Mat2Use
         FROM (
               SELECT distinct FLA_BOM_AUTO_UNION.Material,FLA_BOM_AUTO_UNION.Material2,FLA_BOM_AUTO_UNION.Mat2Desc,  (ltrim(FLA_ZMATCHAR.LaminateWidth)) AS Lamiwidth,FLA_BOM_AUTO_UNION.Mat2Use 
               FROM FLA_BOM_AUTO_UNION 
                  Left Join FLA_ZMATCHAR on FLA_BOM_AUTO_UNION.Material2=FLA_ZMATCHAR.Material
                  where FLA_BOM_AUTO_UNION.Material in (
                  SELECT FLA_BOM_AUTO_UNION.Material2 FROM FLA_BOM_AUTO_UNION
                  where FLA_BOM_AUTO_UNION.Mat2Desc LIKE 'PW%'
                   )  and FLA_BOM_AUTO_UNION.Mat2Desc LIKE 'SLT%' ) AS Temp
   Left join FLA_ZMATCHAR on Temp.Material =FLA_ZMATCHAR.Material
   where FLA_ZMATCHAR.CostStatus not LIKE '%99%'   
) AS Temp1 
) AS Temp2
