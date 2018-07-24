-- PURPOSE
--      search for the largest tables of a mysql/mariadb server
-- 
-- COLUMNS
--      'num rows [Mio]'    Number of rows of a table
--      'data size [Gb]'    Size of the table content
--      'index size [Gb]'   Size of the indexing meta data of a table
--      'total size [Gb]'   Size for data content and indexing
--      'index vs data'     Index size per data size 
-- 

SELECT 
    CONCAT(table_schema, '.', table_name) as 'table name'
    ,ROUND(table_rows / 1000000, 2) 'num rows [Mio]'
    ,ROUND(data_length /  pow(1024,3), 2) as 'data size [Gb]'
    ,ROUND(index_length /  pow(1024,3), 2) as 'index size [Gb]'
    ,ROUND(( data_length + index_length ) /  pow(1024,3), 2) as 'total size [Gb]'
    ,ROUND(index_length / data_length, 2) as 'index size per data'
FROM information_schema.TABLES
-- ORDER BY 2 DESC  -- Most Rows
-- ORDER BY 3 DESC  -- Biggest Data content
-- ORDER BY 4 DESC  -- Biggest Table Index 
ORDER BY 5 DESC  -- Largest Tables
-- ORDER BY 6 DESC  -- Much Indexing for few data
LIMIT 15
;