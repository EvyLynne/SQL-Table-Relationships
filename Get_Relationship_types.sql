

-- all relationships in database
-- https://dataedo.com/kb/query/sql-server/list-foreign-keys-sql-queries
	
select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
    '>-' as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table,


    fk_col.name as fk_column_name,
    ' = ' as [join],
    pk_col.name as pk_column_name,
	
	case when (count( fk_col.name) over (partition by pk_tab.name) > 1) then 'many'  
	 when (count( fk_col.name) over (partition by pk_tab.name) = 1) then 'one' end
	as foreign_table_relationship,
	'to' 'to',
	case when (count(  pk_col.name) over (partition by fk_tab.name) > 1) then 'many'  
	 when (count(  pk_col.name) over (partition by fk_tab.name) = 1) then 'one' end
	as primary_table_relationship,

    fk.name as fk_constraint_name



from sys.foreign_keys fk
    inner join sys.tables fk_tab
        on fk_tab.object_id = fk.parent_object_id
    inner join sys.tables pk_tab
        on pk_tab.object_id = fk.referenced_object_id
    inner join sys.foreign_key_columns fk_cols
        on fk_cols.constraint_object_id = fk.object_id
    inner join sys.columns fk_col
        on fk_col.column_id = fk_cols.parent_column_id
        and fk_col.object_id = fk_tab.object_id
    inner join sys.columns pk_col
        on pk_col.column_id = fk_cols.referenced_column_id
        and pk_col.object_id = pk_tab.object_id
order by schema_name(fk_tab.schema_id) + '.' + fk_tab.name,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name, 
    fk_cols.constraint_column_id

		-- one umanResources.Employee  has many Production.Document
--select 
--hre.BusinessEntityID 'HR ID',

--hre.MaritalStatus,
--prd.Document, prd.DocumentSummary
--from HumanResources.Employee hre
--full outer join Production.Document prd
--on hre.BusinessEntityID =  prd.Owner
-- -- 217, 219, 220
--where hre.BusinessEntityID in ( 217, 219, 220)
