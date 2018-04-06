--select * into #tempOne from InterSystemDI_SMDB.dbo.Fact_DI_EI3_Merch

--where 1=1
-- --and id_day = 20180331 --10
-- and id_day between 20180331 and 20180401

SELECT 
	--A.id_day,
	A.id_data_day,
	A.id_chain,
	A.id_store,
	F.id_interface,
	E.id_measure,
	A.Amount
--	GetDate()			AS DateRecordLoaded
--	INTO #tempTWO
FROM  (
	SELECT 
		--' + @ID_CurrectDay + '			AS 'id_day',
		A.ID_Day				AS 'id_data_day',
		B.ID_Chain				AS 'ID_Chain',
		B.ChainNo				AS 'Chain',
		B.id_store				AS 'id_store',
		A.Store_Code			AS 'Storeno',
		'MERCH CFR'	AS 'Interface_Name',
		CASE 
			WHEN A.TranCode IN ('030') 
			THEN 'Regular Sales'			
		END						AS 'Measure_Name',
		

		--- Ghana VAT change
		--SUM(amount	/ ISNULL(
		--CASE
		--	WHEN c.VATCountryCode = 'GHA' AND A.ID_Day < 20170701				--GHANA VAT CHANGE
		--	THEN NULL
		--	WHEN c.VATCountryCode in ('ZA', 'LES') AND A.ID_Day < 20180401
		--	THEN 1.14
		--ELSE VATMultiplier
		--END , 1.14))															--ZA VAT CHANGE
		--AS 'Value'
		SUM(AMOUNT) as 'Amount'

	FROM Edcon_SMDB.dbo.Fact_CFR_storedaytran A
	  INNER JOIN Edcon_SMDB.dbo.DimLocation_Edcon B ON A.id_store = B.ID_Store
	  LEFT OUTER JOIN InterSystemDI_ETL.dbo.ValueAddedTaxTable C ON C.VATCountryCode = B.LocationCountryCode COLLATE Latin1_General_CI_AS
	WHERE 
		A.TranCode = '030'
		and a.id_day between 20180331 and 20180401
		and a.id_store in ('600002014','100001426','600000825') 
		--AND  
		--(
		--(A.ID_Day BETWEEN '' + @FirstDayMonth + '' AND '' + @LastDayMonth + '')
		--OR
		--(A.ID_Day BETWEEN '' + @LYFirstDayMonth + '' AND '' + @LYLastDayMonth + '')
		--)
		
	GROUP BY 
		A.ID_Day,
		B.ID_Chain,
		B.ChainNo,
		B.id_store,
		A.Store_Code,
		A.TranCode
	  ) A
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimMeasure	E ON A.Measure_Name = E.Measure_Name
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimInterfaces F ON A.Interface_Name = F.Interface_Name
 
 
 /*Source InterSystemDI_SMDB.dbo.Fact_DI_EI3_Merch */
-- select a.*,B.LocationCountryCode from #tempTWO a
-- INNER JOIN Edcon_SMDB.dbo.DimLocation_Edcon B ON A.id_store = B.ID_Store
-- where 1=1
--	and a.id_data_day between 20180331 and 20180401
--	and a.id_store in ('600002014','100001426','600000825')
----	and id_data_day = 20180331
----	and id_data_day = 20180401 --1342
--	and B.LocationCountryCode in ('ZA','LES')
-- order by 1 desc
 
 
 --select * from #tempONE a
 -- where 1=1
	--and a.id_day between 20180331 and 20180401
	--and a.id_data_day between 20180331 and 20180401
	--and a.id_store in ('600002014','100001426','600000825')
	--and a.id_interface = 10101
 
 /* Destination */
 
 select  * from InterSystemDI_SMDB.dbo.Fact_DI_EI3_Merch a
 where 1=1
	and a.id_day between 20180331 and 20180401
	and a.id_data_day between 20180331 and 20180401
	and a.id_store in ('600002014','100001426','600000825')
	and a.id_interface = 10101
	
	order by 1 asc