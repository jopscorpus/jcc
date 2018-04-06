
DECLARE @V_ETL_DB			varchar(30)  
DECLARE @V_SMDB_DB			varchar(30)  

SELECT  @V_ETL_DB  = ETL_DB,  
		@V_SMDB_DB = SMDB_DB  
FROM Config_Supply_Chain.dbo.CFG_Database_Settings  
WHERE ChainNo  = @INP_Chain


select * from Config_Supply_Chain.dbo.CFG_Database_Settings  


select * into #tempONE from Supply_Chain_ETL.dbo.Fact_Variable_TCP_stg_Orders 


select 
	d.ID_Category,
	CONVERT(VARCHAR(8),B.NA_Dt,112) AS ID_Day,
	ISNULL(B.Dif_Mode,'NA') Dif_Mode,
	'1' Value_Type_Code,
	isnull(D.Variable_TCP_Code,'Z9'),
	SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_Cost,0)) AS Unit_Cost,
	--CASE WHEN CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) < 20180401 
	--	THEN SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_RSP / 1.14,0))
	--		WHEN CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) >= 20180401 or CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) is NULL
	--			THEN SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_RSP / 1.15,0))
	--END AS Unit_RSP,	--ZA VAT CHANGE 3/9/2018
	
	
	
	
	SUM(a.Ord_Units) AS Units
	--MAX(isnull(D.Variable_Percentage,' + CAST(@Variable_Percentage as varchar(20)) + ')) Variable_Percentage,
--	MAX(isnull(D.Fixed_Percentage   ,' + CAST(@Fixed_Percentage as varchar(20)) + ')) Fixed_Percentage 

	--INTO #tempTWO
	
from			Supply_Chain_SMDB.dbo.vw_Fact_OrderDetail_OrderSkuStore	as A	
INNER JOIN		Supply_Chain_SMDB.dbo.vw_Dim_Order_Header					as B ON A.id_Order	= B.id_Order
--inner join	' +  @V_SMDB_DB + '.dbo.Dim_Product							as c on A.ID_SKU	= C.ID_SKU
left outer JOIN	Supply_Chain_SMDB.dbo.VW_Dim_TCP_DimProduct				as D ON a.ID_SKU	= d.ID_SKU
Inner join		Supply_Chain_SMDB.dbo.vw_dimorder							as E ON A.id_Order	= E.id_Order
WHERE a.Ord_Units <> 0 AND a.Ord_Unit_Cost <> 0 AND a.Ord_Unit_RSP <> 0
	  and CONVERT(VARCHAR(8),B.NA_Dt,112) between 20180331 and 20180401
	  and ID_Category in ('100002433','150000413','100002577','150000413')
GROUP BY
	d.ID_Category,
	CONVERT(VARCHAR(8),B.NA_Dt,112),
	ISNULL(B.Dif_Mode,'NA'),
	isnull(D.Variable_TCP_Code,'Z9'),
	a.Ord_Unit_RSP,
	B.Ord_Appr_Dt,
	e.Dc_rec_end_Ts
	having 	isnull(d.ID_Category,0) > 0  
	
	
	
	
	select 
	d.ID_Category,
	CONVERT(VARCHAR(8),B.NA_Dt,112) AS ID_Day,
	ISNULL(B.Dif_Mode,'NA') Dif_Mode,
	'1' Value_Type_Code,
	isnull(D.Variable_TCP_Code,'Z9'),
	SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_Cost,0)) AS Unit_Cost,
	--CASE WHEN CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) < 20180401 
	--	THEN SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_RSP / 1.14,0))
	--		WHEN CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) >= 20180401 or CONVERT(VARCHAR(8),e.Dc_rec_end_Ts,112) is NULL
	--			THEN SUM(ISNULL(a.Ord_Units,0) * ISNULL(a.Ord_Unit_RSP / 1.15,0))
	--END AS Unit_RSP,	--ZA VAT CHANGE 3/9/2018
	SUM(a.Ord_Units) AS Units,
	MAX(isnull(D.Variable_Percentage,' + CAST(@Variable_Percentage as varchar(20)) + ')) Variable_Percentage,
	MAX(isnull(D.Fixed_Percentage   ,' + CAST(@Fixed_Percentage as varchar(20)) + ')) Fixed_Percentage 
	INTO #TempTWO
	
from			Supply_Chain_SMDB.dbo.vw_Fact_OrderDetail_OrderSkuStore	as A	
INNER JOIN		' +  @V_SMDB_DB + '.dbo.vw_Dim_Order_Header					as B ON A.id_Order	= B.id_Order
--inner join	' +  @V_SMDB_DB + '.dbo.Dim_Product							as c on A.ID_SKU	= C.ID_SKU
left outer JOIN	' +  @V_SMDB_DB + '.dbo.VW_Dim_TCP_DimProduct				as D ON a.ID_SKU	= d.ID_SKU
Inner join		' +  @V_SMDB_DB + '.dbo.vw_dimorder							as E ON A.id_Order	= E.id_Order
WHERE a.Ord_Units <> 0 AND a.Ord_Unit_Cost <> 0 AND a.Ord_Unit_RSP <> 0
GROUP BY
	d.ID_Category,
	CONVERT(VARCHAR(8),B.NA_Dt,112),
	ISNULL(B.Dif_Mode,'NA'),
	isnull(D.Variable_TCP_Code,'Z9'),
	B.Ord_Appr_Dt,
	e.Dc_rec_end_Ts
	having 	isnull(d.ID_Category,0) > 0  



select * from #tempONE
where ID_DAY between 20180331 and 20180401
and ID_Category in ('100002433','150000413','100002577','150000413')
order by ID_DAY desc


select top 100 *	from Supply_Chain_SMDB.dbo.vw_Fact_OrderDetail_OrderSkuStore	