
DECLARE @V_ETL_DB			varchar(30)  
DECLARE @V_SMDB_DB			varchar(30)  

SELECT  @V_ETL_DB  = ETL_DB,  
		@V_SMDB_DB = SMDB_DB  
FROM Config_Supply_Chain.dbo.CFG_Database_Settings  
WHERE ChainNo  = @INP_Chain


select * from Config_Supply_Chain.dbo.CFG_Database_Settings  


select * into #tempONE from Supply_Chain_ETL.dbo.Fact_Variable_TCP_stg_Orders 


select 
	d.ID_Category AS ID_Category,
	CONVERT(VARCHAR(8),B.NA_Dt,112) AS ID_Day,
	ISNULL(B.Dif_Mode,'NA')  ASDif_Mode,
	'1' AS Value_Type_Code,
	isnull(D.Variable_TCP_Code,'Z9') AS Variable_TCP_Code,
	
	SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_Cost,0)) AS Unit_Cost,
	--CASE WHEN CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) < 20180401 
	--	THEN SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_RSP / 1.14,0))
	--		WHEN CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) >= 20180401 or CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) is NULL
	--			THEN SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_RSP / 1.15,0))
	--END AS Unit_RSP	--ZA VAT CHANGE 3/9/2018
	
	
	SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_RSP,0))
	SUM(a.Ord_Units) AS Units
	--MAX(isnull(D.Variable_Percentage,' + CAST(@Variable_Percentage as varchar(20)) + ')) Variable_Percentage,
	--MAX(isnull(D.Fixed_Percentage   ,' + CAST(@Fixed_Percentage as varchar(20)) + ')) Fixed_Percentage 

	INTO #tempTHREE
	
from			Supply_Chain_SMDB.dbo.vw_Fact_OrderDetail_OrderSkuStore	as A	
INNER JOIN		Supply_Chain_SMDB.dbo.vw_Dim_Order_Header					as B ON A.id_Order	= B.id_Order
--inner join	' +  @V_SMDB_DB + '.dbo.Dim_Product							as c on A.ID_SKU	= C.ID_SKU
left outer JOIN	Supply_Chain_SMDB.dbo.VW_Dim_TCP_DimProduct				as D ON a.ID_SKU	= d.ID_SKU
Inner join		Supply_Chain_SMDB.dbo.vw_dimorder							as E ON A.id_Order	= E.id_Order
WHERE a.Ord_Units <> 0 AND a.Ord_Unit_Cost <> 0 AND a.Ord_Unit_RSP <> 0
	  and CONVERT(VARCHAR(8),B.NA_Dt,112) between 20180331 and 20180401
	  and ID_Category in ('150000396','150000417','150000411','150000402')
GROUP BY
	d.ID_Category,
	CONVERT(VARCHAR(8),B.NA_Dt,112),
	ISNULL(B.Dif_Mode,'NA'),
	isnull(D.Variable_TCP_Code,'Z9'),
	a.Ord_Unit_RSP,
	B.Ord_Appr_Dt,
	e.Dc_rec_end_Ts
	having 	isnull(d.ID_Category,0) > 0  
	
	
	

/* Destination */
--130
select			ID_Category,
				ID_Day,
				Dif_Mode,
				Value_Type_Code,
				Variable_TCP_Code,
				Unit_Cost,
				Unit_RSP,
				Units,
				Variable_Percentage,
				Fixed_Percentage
from Supply_Chain_ETL.dbo.Fact_Variable_TCP_stg_Orders 
where 1=1
	AND ID_DAY between 20180331 and 20180401
	AND ID_Category in ('150000396','150000417','150000411','150000402')
order by ID_DAY desc

 --1258
select 
				B.ID_Category,
				A.ID_Day,
			--	A.Dif_Mode,
				A.Value_Type_Code,
				A.Variable_TCP_Code,
				A.Unit_Cost,
				A.Ord_Units,
				A.Ord_Unit_RSP

	from #tempTHREE a
	LEFT JOIN (select distinct ID_Category from Supply_Chain_ETL.dbo.Fact_Variable_TCP_stg_Orders where ID_DAY = 20180401) b 
		ON a.ID_Category = b.ID_Category
	WHERE 1=1
		AND a.ID_DAY = 20180401

SELECT *

	 FROM #TempTHREE 
	where 1=1 
		AND ID_Category in ('150000396','150000417','150000411','150000402')
		AND ID_DAY between 20180331 and 20180401


select distinct a.ID_Category 
	from Supply_Chain_ETL.dbo.Fact_Variable_TCP_stg_Orders a
	join (select distinct ID_Category from Supply_Chain_ETL.dbo.Fact_Variable_TCP_stg_Orders where ID_DAY = 20180401) b
		ON a.ID_Category = b.ID_Category 
		where a.ID_Day = 20180331