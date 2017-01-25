use AdventureWorksDW2014;


--Find the top products of 2013

SELECT 
		RANK() OVER (ORDER BY sum(s.SalesAmount) DESC) as 'Rank'--You can use ROW_NUMBER() also
	,	count(DISTINCT s.SalesOrderNumber) as 'OrderCount'
	,	sum(s.SalesAmount) as 'TotalSales'
	,	cat.EnglishProductCategoryName as 'Category'
    ,	sub.EnglishProductSubcategoryName as 'SubCategory'	
FROM FactInternetSales s
INNER JOIN DimProduct p ON s.ProductKey = p.ProductKey
INNER JOIN DimProductSubcategory sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
INNER JOIN DimProductCategory cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
-- filter on Year 2013
WHERE YEAR(s.OrderDate) = 2013
GROUP BY
	cat.EnglishProductCategoryName 
    ,	sub.EnglishProductSubcategoryName	

ORDER BY 1;--order by RANK()
