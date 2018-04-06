/* Source */
SELECT   
 A.id_data_day,  
 B.id_chain,  
 B.id_store,  
 F.id_interface,  
 E.id_measure,  
 A.Amount

FROM 
			(  
			SELECT   
					 ID_Day     AS 'id_data_day'
					, id_store    AS 'id_store'
					, 'FACT ITEM SALES'   AS 'Interface_Name'
					, 'Regular Sales'  AS 'Measure_Name'
					--, CASE	WHEN ID_DAY < 20180401 THEN SUM(NET_RSP) / 1.14
					--	ELSE SUM(NET_RSP) / 1.15 END AS 'Value'  
					,SUM(NET_RSP) AS 'Amount'
					FROM NDCEI3P33.FS_SMDB.dbo.vw_FactItemSales  
			WHERE   1=1
				--and ID_DAY = 20180401
			GROUP BY   
				ID_Day,  
				id_store  
			) A  
   
  INNER JOIN InterSystemDI_ETL.dbo.DimLocation_Edcon B ON A.id_store = B.id_store  
  LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimMeasure E ON A.Measure_Name = E.Measure_Name  
  LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimInterfaces F ON A.Interface_Name = F.Interface_Name  
  where 1=1
	  and a.id_data_day between 20180331 and 20180401
	  and a.id_store in ('100000026','150000487','600002922','600002924')
	  and b.id_store <> 150000586 
	  and b.LocationCountryCode in ('ZA','LES')

Order by 1 desc

/* Destination */

select * from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FS  
	where 1=1
		and id_day between 20180331 and 20180401
		and id_data_day between 20180331 and 20180401
		and id_store in ('100000026','150000487','600002922','600002924')	  
	order by 1 desc