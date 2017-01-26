USE AdventureWorksDW2014;


WITH mnthlysales (YearNum, MonthNum, Sales)
AS--Used to get previous year
(
	SELECT d.CalendarYear, d.MonthNumberOfYear, SUM(s.SalesAmount)
	FROM DimDate d, FactInternetSales s
	WHERE d.DateKey=s.OrderDateKey --and d.CalendarYear=2014
	GROUP BY d.CalendarYear, d.MonthNumberOfYear
	--ORDER BY 1 DESc 

)
-- Get Current Year and join to CTE for previous year
SELECT 
		d.CalendarYear AS Year
	,	d.MonthNumberOfYear AS Month
	,	ms.Sales AS PreviousYearSales
	,	SUM(s.SalesAmount) AS CurrentYearSales
	--get the percentage of difference. Percentage Profit = (profit/cost price)x 100%
	--new one is how much % of old one, eg: 100 is what percent of 50--> 100(new) is 200% of 50(old)=new*100/old
	--, (SUM(s.SalesAmount)*100)/ms.Sales AS PercentChange
	,(SUM(s.SalesAmount) - ms.Sales) / SUM(s.SalesAmount) AS 'PercentGrowth'
	,CASE WHEN SUM(s.SalesAmount) > ms.Sales THEN 'PROFIT' ELSE 'LOSS' END AS FinancialStatement
FROM DimDate d,FactInternetSales s,mnthlysales ms
WHERE d.DateKey = s.OrderDateKey AND d.CalendarYear-1 = ms.YearNum AND d.MonthNumberOfYear = ms.MonthNum
GROUP BY
		d.CalendarYear
	,	d.MonthNumberOfYear
	,	ms.Sales
ORDER BY
		1 DESC, 2 DESC

		;