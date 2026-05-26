# M3 Name Conversion

## Purpose
Convert SQL queries written with M3 MDP (Metadata Publisher) naming standard into technical M3 names (Usually six characters in tables and columns). The MDP names are also referred to "user-friendly" [...]
The input is in MDP-format and the output is in technical M3 names.

## Critical instructions
Follow the convention in naming and commenting strictly according to the example below.
Never guess column names when unsure ask me and I'll input the column name.


## M3 Naming
In M3, table names are technical identifiers and are typically 6 characters long.

Examples:
- `MITMAS` = [Item Master]
- `OOLINE` = [Customer order, lines]
- `OOHEAD` = [Customer order, head]
- `ODLINE` = [Delivery customer order, line]
- `ODHEAD` = [Delivery customer order, head]
- `OCUSAD` = [Customer address]
- `CSYTAB` = [System tables file]
- `MHDISH` = [Delivery numbers]

The user-friendly names referred to in this document are the MDP names. MDP is M3's own user-friendly naming convention for tables and fields.

The user-friendly names referred to in this document are also known as MDP-names.

Translations between MDP-names and technical M3 names can be looked up in an MDP database. This database can be used to resolve:
- user-friendly MDP table names to technical M3 table names
- user-friendly MDP field names to technical M3 field names
- context-specific mappings where the same MDP-name may translate differently depending on table or usage context

SQL written by users may refer to business concepts such as:
- [Item Master]
- [Customer order, lines]
- [Customer order, head]
- [Delivery customer order, line]
- [Delivery customer order, head]
- [Customer address]
- [System tables file]
- [Delivery numbers]
- [Warehouse]
- [... CodeTable]

These should be translated into the corresponding M3 table and field names before execution or processing.

## Goal
Enable submission of SQL queries using user-friendly names and convert them into SQL using M3 technical table names and column names as output.

## Mapping Source
The source of truth for mappings between M3 technical names and user-friendly MDP-names may be stored in:
- an MDP database
- `M3 Vocabulary -columns1.csv`
- `M3 Vocabulary -columns2.csv`

These sources contain the vocabulary used to translate between:
- user-friendly MDP table names and M3 technical table names
- user-friendly MDP column names and M3 technical column names
- table-specific field mappings where the same friendly name may map differently depending on context
- logical `... CodeTable` view names that resolve to `CSYTAB` while retaining their own column naming context

The SQL conversion logic should use the MDP database and/or CSV files as the primary mapping source, depending on the available implementation.

## How CSV Mappings Are Used
- Load mappings from both CSV files before query conversion begins.
- Build a dictionary for table name mappings.
- Build a dictionary for column name mappings scoped by M3 table name.
- When converting a query, first resolve tables, then resolve columns using the mapped table context.
- If the same user-friendly column name exists in multiple tables, table context must decide the correct technical name.
- If no mapping exists in the CSV files, the identifier should either remain unchanged or be flagged for review.
- Some tables store the key for an entity, while the related descriptive text is stored in `CSYTAB`.
- `CSYTAB` should therefore be treated as a shared text holder for many entities in the system.
- Submitted SQL may reference `... CodeTable` names that do not physically exist in the MDP library.
- These `... CodeTable` names should be treated as logical views over `CSYTAB`.
- A `... CodeTable` view resolves to `CSYTAB` for the technical table name, but keeps its own friendly column names for mapping purposes.


### User-Friendly (MDP -Metadata Publisher) input
```sql
SELECT
    [OL].[Company],
    [OL].[Facility],
    [OL].[Warehouse],
    [OH].[Customer order number],
	[OL].[Ordered quantity - basic U/M],
	[OL].[Ordered quantity - basic U/M] [Customer Order Qty],
	[OL].[Ordered quantity - basic U/M] - [OL].[Delivered quantity - basic U/M] [My Calculation Remaining]
FROM [Staging_ERP].[dbo].[Customer order, lines] AS [OL]
    INNER JOIN [Staging_ERP].[dbo].[Customer order, head] AS [OH] ON [OL].[Company] = [OH].[Company]
    AND [OL].[Division] = [OH].[Division]
    AND [OL].[Customer order number] = [OH].[Customer order number]
	AND [OL].[Highest status - customer order]=77

```

### Converted M3-style output
```sql
SELECT
    [OL].[OBCONO] AS [Company],
    [OL].[OBFACI] AS [Facility],
    [OL].[OBWHLO] AS [Warehouse],
    [OH].[OAORST] AS [Customer order number],
	[OL].[OBORQT] AS [Ordered quantity - basic U/M],
	[OL].[OBORQT] AS [Ordered quantity - basic U/M (Customer Order Qty)],
	[OL].[OBORQT] - [OL].[OBDLQT] AS [My Calculation Remaining]
FROM [Staging_ERP].[dbo].[OOLINE] AS [OL] --[Customer order, lines]
    INNER JOIN [Staging_ERP].[dbo].[OOHEAD] AS [OH] --[Customer order, head]
	ON [OL].[OBCONO] = [OH].[OACONO] --[Company]
    AND [OL].[OBDIVI] = [OH].[OADIVI] --[Division]
    AND [OL].[OBORST] = [OH].[OAORST] --[Customer order number]
	AND [OL].[OBORST] = 77 --[Highest status - customer order]
```

## Conversion Rules
- Friendly business table names must be mapped to M3 table names.
- M3 table names are technical identifiers such as `MITMAS`, `OOLINE`, `OOHEAD`, `ODLINE`, `ODHEAD`, `OCUSAD`, `CSYTAB`, and `MHDISH`.
- Friendly field names must be mapped to M3 field names.
- Field mappings should be resolved in the context of the selected table alias.
- The same friendly field name may map to different M3 technical names depending on the table.
- SQL structure must remain unchanged except for name conversion.
- Database name, schema name, aliases, joins, filters, and SQL keywords must be preserved.
- In the `SELECT` statement, output aliases should always be kept when present.
- Unknown names should be flagged or left unchanged depending on system rules.
- Delivery customer order line fields in `ODLINE` typically start with `UB`.
- Delivery customer order head fields in `ODHEAD` typically start with `UA`.
- Customer address fields in `OCUSAD` typically start with `OP`.
- System tables file fields in `CSYTAB` include mappings such as `[Description]` → `CTTX40`.
- `CSYTAB` often stores descriptive text values for keys that originate in other tables.
- Submitted SQL may reference `... CodeTable` names that do not exist as physical MDP tables.
- These `... CodeTable` names must resolve to `CSYTAB`, while their column mappings remain specific to the logical CodeTable view.

## Conversion Logic
The conversion process should take a SQL query written with user-friendly table names and column names and translate it into a SQL query that uses M3 technical table and field names.

### Step 1: Parse the SQL query
Identify the main SQL parts:
- SELECT
- FROM
- JOIN
- WHERE
- GROUP BY
- ORDER BY

The parser must also detect:
- database and schema references
- table names
- aliases
- column references
- join conditions

### Step 2: Resolve table mappings
For each table in the query, translate the friendly table name into the corresponding M3 technical table name using the CSV mapping source.

Examples:
- `[Item Master]` → `MITMAS`
- `[Customer order, lines]` → `OOLINE`
- `[Customer order, head]` → `OOHEAD`
- `[Delivery customer order, line]` → `ODLINE`
- `[Delivery customer order, head]` → `ODHEAD`
- `[Customer address]` → `OCUSAD`
- `[System tables file]` → `CSYTAB`
- `[Status CodeTable]` → `CSYTAB`
- `[Delivery numbers]` → `MHDISH`

Table aliases must be preserved.

Example:
- `[Staging_ERP].[dbo].[Customer order, lines] AS [OL]`
becomes:
- `[Staging_ERP].[dbo].[OOLINE] AS [OL]`

### Step 3: Resolve column mappings using table context
For each column reference, use the table alias and mapped table name to determine the correct M3 field name from the CSV mappings.

Examples:
- `[OL].[Company]` → `[OL].[OBCONO]`
- `[OH].[Company]` → `[OH].[OACONO]`
- `[CA].[Customer Number]` → `[CA].[OPCUNO]`
- `[ST].[Description]` → `[ST].[CTTX40]`

This is important because the same friendly column name may map to different technical names depending on the table.

For delivery customer order tables:
- fields mapped for `ODLINE` should resolve to technical names that typically begin with `UB`
- fields mapped for `ODHEAD` should resolve to technical names that typically begin with `UA`

For customer address tables:
- fields mapped for `OCUSAD` should resolve to technical names that typically begin with `OP`
- for example, `[Customer Number]` maps to `OPCUNO`

For system tables file:
- fields mapped for `CSYTAB` should resolve using the `CSYTAB` field mappings from the mapping source
- for example, `[Description]` maps to `CTTX40`
- `CSYTAB` may need to be used when a source table contains a code or key, but the descriptive text is stored separately in `CSYTAB`

For `... CodeTable` references:
- a submitted `... CodeTable` name may not exist as a physical table in the MDP library
- the table name should still resolve to `CSYTAB`
- the column mappings should be resolved using the specific logical CodeTable/view context, not only the base `CSYTAB` context
- this allows a CodeTable view to expose its own friendly column names while still being backed by `CSYTAB`

### Step 4: Replace identifiers
Replace only mapped table names and column names.
Do not change:
- SQL keywords
- aliases
- database names
- schema names
- operators
- literals
- query structure

### Step 5: Preserve query logic
The converted query must keep the original logic unchanged:
- selected columns
- joins
- filters
- sorting
- grouping

Only the identifiers should change.

### Step 6: Handle unknown mappings
If a friendly name cannot be mapped from the CSV files:
- leave it unchanged, or
- return a warning/error for manual review

The preferred behavior should be configurable.

## Mapping Examples
| Friendly Name | M3 Technical Name | Type | Context |
|---|---|---|---|
| [Item Master] | MITMAS | Table | General |
| [Item number] | MMITNO | Field | MITMAS |
| [Item Description] | MMITDS | Field | MITMAS |
| [Customer order, lines] | OOLINE | Table | General |
| [Customer order, head] | OOHEAD | Table | General |
| [Delivery customer order, line] | ODLINE | Table | General |
| [Delivery customer order, head] | ODHEAD | Table | General |
| [Customer address] | OCUSAD | Table | General |
| [System tables file] | CSYTAB | Table | General |
| [... CodeTable] | CSYTAB | Logical View/Table | CodeTable context |
| [Delivery numbers] | MHDISH | Table | General |
| [Company] | OBCONO | Field | OOLINE |
| [Company] | OACONO | Field | OOHEAD |
| [Facility] | OBFACI | Field | OOLINE |
| [Warehouse] | OBWHLO | Field | OOLINE |
| [Division] | OBDIVI | Field | OOLINE |
| [Division] | OADIVI | Field | OOHEAD |
| [Customer order number] | OBORNO | Field | OOLINE |
| [Customer order number] | OAORNO | Field | OOHEAD |
| [Customer order status] | OBORST | Field | OOLINE |
| [Customer order status] | OAORST | Field | OOHEAD |
| [Customer Number] | OPCUNO | Field | OCUSAD |
| [Description] | CTTX40 | Field | CSYTAB |
| [Delivery customer order fields] | UB* | Field Prefix | ODLINE |
| [Delivery customer order fields] | UA* | Field Prefix | ODHEAD |
| [Customer address fields] | OP* | Field Prefix | OCUSAD |

## Notes
- M3 fields are often prefixed in a way that relates to the table structure.
- The same friendly field name may map differently depending on table context.
- The user-friendly names used for conversion are MDP names, which are M3's own user-friendly labels.
- A central mapping dictionary is recommended.
- Query conversion should work for SELECT lists, FROM clauses, JOIN clauses, WHERE conditions, and other SQL expressions where mapped identifiers are used.
- The mapping dictionary should be generated from the CSV vocabulary files.
- For delivery customer order tables, field prefixes can help validate the result:
  - `ODLINE` fields typically begin with `UB`
  - `ODHEAD` fields typically begin with `UA`
- For customer address tables, field prefixes can help validate the result:
  - `OCUSAD` fields typically begin with `OP`
- For system tables file, fields should be resolved using the `CSYTAB` mapping context.
- `CSYTAB` is often used as a shared text repository where many other tables store the key, while the descriptive text is stored in `CSYTAB`.
- `... CodeTable` references in submitted SQL may represent logical views over `CSYTAB` even when no physical MDP table exists with that name.
- Those logical CodeTable names should keep their own column naming context during field resolution.

## Future Enhancements
- Support aliases
- Support joins across multiple M3 tables
- Handle ambiguous business terms
- Validate mappings against metadata
- Store mappings in a configurable dictionary or metadata table
