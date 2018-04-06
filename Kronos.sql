

SELECT 
	--A.id_day,
	A.id_data_day,
	A.id_chain,
	A.id_store,
	F.id_interface,
	E.id_measure,
	A.Amount
	--GetDate()			AS DateRecordLoaded
	into #tempTHREE
FROM (
	SELECT 
		--' + @ID_CurrectDay + '			AS 'ID_Day',
		A.ID_Day				AS 'id_data_day',
		B.id_chain				AS 'id_chain',
		B.id_Store				AS 'id_Store',
		'HR KRONOS'				AS 'Interface_Name',
		'Ticket Sales'		AS 'Measure_Name',
		--CASE WHEN a.ID_DAY < 20180401 THEN SUM(Value)/1.14 	
		--	ELSE  SUM(Value)/1.15 END 	AS 'Value'
		SUM(Value) AS 'Amount'
	FROM NDCEI3P34.HR_Kronos_SMDB.dbo.vw_FactHourlySales  A
	--FROM NDCEI3P34.[HR_Kronos_SMDB].[dbo].[z_ditesh_VATTest] A
	  INNER JOIN DimLocation_Edcon B ON CAST(A.Store_Code AS Int) = B.StoreCode
	WHERE 
		--A.ID_Day BETWEEN ' + @FirstDayMonth + ' AND ' + @LastDayMonth + '
		  B.id_store <> 150000586
		  and a.ID_DAY between 20180331 and 20180401
		 -- and B.ID_Store = 100000875 -- in ('100000875','600000508','600002952')
	   	--  and b.LocationCountryCode in ('ZA','LES')
	GROUP BY   
		A.ID_Day,
		B.id_chain,
		B.id_Store
	  ) A
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimMeasure	E ON A.Measure_Name = E.Measure_Name
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimInterfaces F ON A.Interface_Name = F.Interface_Name
 
 select * 
 
 from NDCEI3P34.HR_Kronos_SMDB.dbo.vw_FactHourlySales a
 INNER JOIN DimLocation_Edcon B ON CAST(A.Store_Code AS Int) = B.StoreCode
 and B.ID_Store in ('100000875','600000508','600002952')
 order by 1 desc
 
 select * from #tempTHREE
 where 1=1
	and ID_DATA_DAY between 20180331 and 20180401
	AND ID_STORE in ('100000875','600000508','600002952')

	
/* Destination */	
select * from InterSystemDI_SMDB.dbo.Fact_DI_EI3_HR
where 1=1
	AND ID_DAY between 20180331 and 20180401
	AND ID_DATA_DAY between 20180331 and 20180401
	AND ID_DAY = ID_DATA_DAY 
	AND ID_STORE in ('100000875','600000508','600002952')
	order by 1 asc