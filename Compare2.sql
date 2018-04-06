SET @SQL =     
INSERT INTO InterSystemDI_SMDB.dbo.Fact_DI_EI3_FBI   
SELECT     
 A.id_day,    
 A.id_data_day,    
 A.id_chain,    
 A.id_store,    
 F.id_interface,    
 E.id_measure,    
 A.Value,    
 GetDate()   AS DateRecordLoaded    
FROM (    
 SELECT     
  ' + @ID_CurrectDay + '   AS ''ID_Day'',    
  A.ID_Day    AS ''id_data_day'',    
  B.id_chain    AS ''id_chain'',    
  B.id_Store    AS ''id_Store'',    
  ''FBI CFR''    AS ''Interface_Name'',    
  CASE     
   WHEN A.TranCode IN (''005'')     
   THEN ''Ticket Sales''       
  END      AS ''Measure_Name'',    
 ----SUM(amount / ISNULL(VATMultiplier, 1.14)) AS ''Value''  
	
	--GHANA VAT CHANGE
	SUM(amount	/ ISNULL(
		CASE
			WHEN c.VATCountryCode = ''GHA'' AND A.ID_Day < 20170701				
			THEN NULL
			WHEN c.VATCountryCode in (''ZA'', ''LES'') AND A.ID_Day < 20180401				--ZA VAT CHANGE
			THEN 1.14
		ELSE VATMultiplier
		END , 1.14))
		AS ''Value''

 ----FROM NDCEI3PPP01.Financial_AS.dbo.v_CFR_FactCFR_StoreDayTran A    
 FROM Edcon_SMDB.dbo.Fact_CFR_storedaytran A    
 ----   INNER JOIN NDCEI3PPP01.Financial_AS.dbo.DimLocation_Edcon B ON A.id_store = B.ID_Store   
  INNER JOIN Edcon_SMDB.dbo.DimLocation_Edcon B ON A.id_store = B.ID_Store   
     LEFT OUTER JOIN InterSystemDI_ETL.dbo.ValueAddedTaxTable C ON C.VATCountryCode = B.LocationCountryCode COLLATE Latin1_General_CI_AS  
 WHERE     
  A.TranCode = ''005''     
 ----     AND Currency_MemberID = 5011    
  AND A.ID_Day BETWEEN ' + @FirstDayMonth + ' AND ' + @LastDayMonth + '    
 GROUP BY     
  A.ID_Day,    
  B.id_chain,    
  B.id_Store,    
  A.TranCode    
   ) A    
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimMeasure E ON A.Measure_Name = E.Measure_Name    
 LEFT OUTER JOIN InterSystemDI_ETL.dbo.DimInterfaces F ON A.Interface_Name = F.Interface_Name    
     
 