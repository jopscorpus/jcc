/*Quer used for UP_IntersystemDI_00700_Load_EI3_CUST_ITEM_SALES */
/*Data before 04012018*/
select * from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FS 
where 1=1
and id_day = 20180331
and id_data_day = 20180331
and id_chain = 2
and id_store = 600000532

select SUM(NET_RSP) from ndcei3p33.FS_SMDB.dbo.vw_FactItemSales
where 1=1 
and id_day = 20180331
and id_store = 600000532

/*Data after 04012018*/
select * from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FS 
where 1=1
and id_day = 20180401
and id_data_day = 20180401
and id_chain = 2
and id_store = 600000532

select SUM(NET_RSP) from ndcei3p33.FS_SMDB.dbo.vw_FactItemSales
where 1=1 
and id_day = 20180401
and id_store = 600000532


/*Query used for UP_IntersystemDI_00300_Load_EI3_FBI_CFR*/

select * into #tempA from InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
where 1=1
	and id_day = 20180331
	and id_data_day = 20180331
	and id_chain = 100000000
	and id_store = 100000045
	and id_measure = 1
order by 1 desc


select id_store,amount  into #tempB from Edcon_SMDB.dbo.Fact_CFR_storedaytran
where 1=1
	and trancode = '030'
	and id_day = 20180331
	and id_store = 100000045
GROUP BY id_store,id_day, trancode, amount
order by 1 desc


select a.id_store, 
	   b.amount, 
	   a.Value, 
	   round((b.amount/a.Value),2) [VATMultiplier]

from #tempA a
	join #tempB b on a.id_store = b.id_store