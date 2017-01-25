use AdventureWorksDW2014;


--Find the top products of 2013

SELECT 
		RANK() OVER (ORDER BY sum(s.SalesAmount) DESC) as 'Rank'
	,	count(DISTINCT s.SalesOrderNumber) 'OrderCount' -- use 1 instead of a field for faster performance
	,	sum(s.SalesAmount) 'TotalSales'
	,	cat.EnglishProductCategoryName 'Category'
    ,	sub.EnglishProductSubcategoryName 'SubCategory'	
FROM FactInternetSales s
INNER JOIN DimProduct p ON s.ProductKey = p.ProductKey
INNER JOIN DimProductSubcategory sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
INNER JOIN DimProductCategory cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
-- filter
WHERE YEAR(s.OrderDate) = 2013 --use date function to parse year
-- must use group by in order for aggregation to work properly
GROUP BY
		cat.EnglishProductCategoryName -- column aliases aren't allowed
    ,	sub.EnglishProductSubcategoryName	

ORDER BY 1;