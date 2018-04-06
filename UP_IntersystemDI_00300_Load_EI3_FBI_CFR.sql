--USE InterSystemDI_ETL
--GO

--SET ANSI_NULLS OFF
--GO


/*Data before 20180401*/
select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
where 1=1
	and id_day = 20180331
	and id_data_day = 20180331
	and id_chain = 100000000
	and id_store = 100000045
	and id_measure = 1
order by 1 desc

select id_store,amount  from Edcon_SMDB.dbo.Fact_CFR_storedaytran
where 1=1
	and trancode = '030'
	and id_day = 20180331
	and id_store = 100000045
GROUP BY id_store,id_day, trancode, amount
order by 1 desc

100000045 

/*Data after 20180401*/
select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
where 1=1
	and id_day = 20180401
	and id_data_day = 20180401
	and id_chain = 100000000
	and id_store = 100000045
	and id_measure = 1
order by 1 desc

select id_store,amount  from Edcon_SMDB.dbo.Fact_CFR_storedaytran
where 1=1
	and trancode = '030'
	and id_day = 20180401
	and id_store = 100000045
GROUP BY id_store,id_day, trancode, amount
order by 1 desc


-----------


--/*Data before 20180401 100000000, 100002127*/
--select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
--where 1=1
--	and id_day = 20180331
--	and id_data_day = 20180331
--	and id_chain = 100000000
--	and id_store = 100002127
--	and id_measure = 1
--order by 1 desc

--select id_store,amount  from Edcon_SMDB.dbo.Fact_CFR_storedaytran
--where 1=1
--	and trancode = '030'
--	and id_day = 20180331
--	and id_store = 100002127
--GROUP BY id_store,id_day, trancode, amount
--order by 1 desc

--/*Data after 20180401*/
--select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
--where 1=1
--	and id_day = 20180401
--	and id_data_day = 20180401
--	and id_chain = 100000000
--	and id_store = 100002127
--	and id_measure = 1
--order by 1 desc

--select id_store,amount  from Edcon_SMDB.dbo.Fact_CFR_storedaytran
--where 1=1
--	and trancode = '030'
--	and id_day = 20180401
--	and id_store = 100002127
--GROUP BY id_store,id_day, trancode, amount
--order by 1 desc


-----------


--/*Data before 20180401 100000000, 100002127*/
--select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
--where 1=1
--	and id_day = 20180331
--	and id_data_day = 20180331
--	and id_chain = 2
--	and id_store = 600000835
--	and id_measure = 1
--order by 1 desc

--select id_store,amount  from Edcon_SMDB.dbo.Fact_CFR_storedaytran
--where 1=1
--	and trancode = '030'
--	and id_day = 20180331
--	and id_store = 600000835
--GROUP BY id_store,id_day, trancode, amount
--order by 1 desc

--/*Data after 20180401*/
--select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
--where 1=1
--	and id_day = 20180401
--	and id_data_day = 20180401
--	and id_chain = 2
--	and id_store = 600000835
--	and id_measure = 1
--order by 1 desc

--select id_store,amount  from Edcon_SMDB.dbo.Fact_CFR_storedaytran
--where 1=1
--	and trancode = '030'
--	and id_day = 20180401
--	and id_store = 600000835
--GROUP BY id_store,id_day, trancode, amount
--order by 1 desc


--2, 600000469

--100000000, 100002127

--select distinct trancode,id_store from Edcon_SMDB.dbo.Fact_CFR_storedaytran
--where 
----and id_chain = 100000000
-- id_store = 100002127

--order by 1,2 desc


--select distinct id_chain, id_store
--from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
--where 1=1
--and id_day = 20180331
--and id_store = 100002127












--/*

--Destination table: InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
--Source tables: Edcon_SMDB.dbo.Fact_CFR_storedaytran

--*/

/* Source */
SELECT     
	 --A.id_day,    
	 A.id_data_day,    
	 A.id_chain,    
	 A.id_store,   
	 F.id_interface,    
	 E.id_measure,    
	 A.amount,    
 GetDate()   AS DateRecordLoaded    
FROM (    
 SELECT      
	  A.ID_Day    AS 'id_data_day',    
	  B.id_chain    AS 'id_chain',    
	  B.id_Store    AS 'id_Store',    
	  'FBI CFR'    AS 'Interface_Name',    
	  CASE     
	   WHEN A.TranCode IN ('030')     
	   THEN 'Regular Sales'       
	  END      AS 'Measure_Name',    

 --GHANA VAT CHANGE
	--SUM(amount	/ ISNULL(
	--	CASE
	--		WHEN c.VATCountryCode = 'GHA' AND A.ID_Day < 20170701				--GHANA VAT CHANGE
	--		THEN NULL
	--		WHEN c.VATCountryCode in ('ZA', 'LES') AND A.ID_Day < 20180401				--ZA VAT CHANGE
	--		THEN 1.14
	--	ELSE VATMultiplier
	--	END , 1.14))
	--	AS 'Value'
	SUM(amount) AS 'amount'
	

	
FROM Edcon_SMDB.dbo.Fact_CFR_storedaytran A    
	INNER JOIN Edcon_SMDB.dbo.DimLocation_Edcon B ON A.id_store = B.ID_Store    
	LEFT OUTER JOIN InterSystemDI_ETL.dbo.ValueAddedTaxTable C ON C.VATCountryCode = B.LocationCountryCode COLLATE Latin1_General_CI_AS  
 WHERE     1=1
	and A.TranCode = '030'     
	and a.id_day between 20180331 and 20180401
	and a.id_store in ('100000045','100002127','600000835','100001438')
	and b.LocationCountryCode in ('ZA','LES')
 GROUP BY     
  A.ID_Day,    
  B.id_chain,    
  B.id_Store,    
  A.TranCode    
  
   ) A    
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimMeasure E ON A.Measure_Name = E.Measure_Name    
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimInterfaces F ON A.Interface_Name = F.Interface_Name    
 order by 1 asc
 
 /* Destination */
select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
	where 1=1
		and id_day between 20180331 and 20180401
		and id_data_day between 20180331 and 20180401
	--	and id_day = id_data_day
		and id_store in ('100000045','100002127','600000835','100001438')
		and id_measure = 1
		--and id_chain = 100000000
	order by id_data_day desc
	
select * from dbo.DimInterfaces
	
	
	select a.id_store, b.id_store 
	from #tempA a
	left join (
		select * from #tempA a where 1=1
		and a.Id_data_day = 20180331
			) b on a.id_store = b.id_store
	where 1=1
		and a.Id_data_day = 20180401
	
	
	--1215
	select * from #tempA a
	where 1=1
	and a.Id_data_day = 20180401
	--1248
	select * from #tempA a
	where 1=1
	and a.Id_data_day = 20180331
	

select * from #tempC
where 1=1
and id_store in ('100000045','100002127','600000835','100001438')
and id_chain = 100000000
and id_measure = 1
and id_day = id_data_day
order by id_day asc


/* Destination */
select *  from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
	where 1=1
	--	and id_day between 20180331 and 20180401
		and id_data_day between 20180331 and 20180401
		and id_day = id_data_day
		and id_store in ('100000045','100002127','600000835','100001438')
		and id_measure = 1
	order by id_data_day asc



	select * FROM Edcon_SMDB.dbo.Fact_CFR_storedaytran A    
	where id_store = '100002127'
	and id_day = 20180331 -- between 20180331 and 20180401
	and trancode = '030'
--	group by id_day,trancode,id_store
	
	
	select id_day,trancode,id_store, SUM(amount) FROM Edcon_SMDB.dbo.Fact_CFR_storedaytran A    
	where id_store = '100002127'
	and id_day = 20180331 -- between 20180331 and 20180401
	and trancode = '030'
	group by id_day,trancode,id_store
	
	
	select * from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI 
	where id_store = '100002127'
	and id_day = 20180331 -- between 20180331 and 20180401
	and id_measure = 1