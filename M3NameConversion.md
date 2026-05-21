# M3 Name Conversion

## Purpose
Convert SQL queries written with M3 MDP (Metadata Publisher) naming standard into technical M3 names (Usually six characters in tables and columns). The MDP names are also referred to "user-friendly" [...]

## M3 Naming
In M3, table names are technical identifiers and are typically 6 characters long.

Examples:
- `MITMAS` = [Item Master]
- `OOLINE` = [Customer order, lines]
- `OOHEAD` = [Customer order, head]
- `ODLINE` = [Delivery customer order, line]
- `ODHEAD` = [Delivery customer order, head]
- `OCUSAD` = [Customer address]
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
- [Delivery numbers]
- [Warehouse]

These should be translated into the corresponding M3 table and field names before execution or processing.

## Goal
Enable submission of SQL queries using user-friendly names and convert them into SQL using M3 technical table names and column names.

## Mapping Source
The source of truth for mappings between M3 technical names and user-friendly MDP-names may be stored in:
- an MDP database
- `M3 Vocabulary -columns1.csv`
- `M3 Vocabulary -columns2.csv`

These sources contain the vocabulary used to translate between:
- user-friendly MDP table names and M3 technical table names
- user-friendly MDP column names and M3 technical column names
- table-specific field mappings where the same friendly name may map differently depending on context

The SQL conversion logic should use the MDP database and/or CSV files as the primary mapping source, depending on the available implementation.

## How CSV Mappings Are Used
- Load mappings from both CSV files before query conversion begins.
- Build a dictionary for table name mappings.
- Build a dictionary for column name mappings scoped by M3 table name.
- When converting a query, first resolve tables, then resolve columns using the mapped table context.
- If the same user-friendly column name exists in multiple tables, table context must decide the correct technical name.
- If no mapping exists in the CSV files, the identifier should either remain unchanged or be flagged for review.


## Example
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

### Converted M3-style input
```sql
SELECT
    [OL].[OBCONO] AS [Company],
    [OL].[OBFACI] AS [Facility],
    [OL].[OBWHLO] AS [Warehouse],
    [OH].[OAORST] AS [Customer order number],
	[OL].[OBORQT] AS [Ordered quantity - basic U/M],
	[OL].[OBORQT] AS [Ordered quantity - basic U/M - Customer Order Qty],
	[OL].[OBORQT] - [OL].[OBDLQT] AS [My Calculation Remaining]
FROM [Staging_ERP].[dbo].[OOLINE] AS [OL]
    INNER JOIN [Staging_ERP].[dbo].[OOHEAD] AS [OH] ON [OL].[OBCONO] = [OH].[OACONO] --[Company]
    AND [OL].[OBDIVI] = [OH].[OADIVI] --[Division]
    AND [OL].[OBORST] = [OH].[OAORST] --[Customer order number]
	AND [OL].[OBORST] = 77 --[Highest status - customer order]
```

## Conversion Rules
- Friendly business table names must be mapped to M3 table names.
- M3 table names are technical identifiers such as `MITMAS`, `OOLINE`, `OOHEAD`, `ODLINE`, `ODHEAD`, `OCUSAD`, and `MHDISH`.
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

This is important because the same friendly column name may map to different technical names depending on the table.

For delivery customer order tables:
- fields mapped for `ODLINE` should resolve to technical names that typically begin with `UB`
- fields mapped for `ODHEAD` should resolve to technical names that typically begin with `UA`

For customer address tables:
- fields mapped for `OCUSAD` should resolve to technical names that typically begin with `OP`
- for example, `[Customer Number]` maps to `OPCUNO`

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
| [Delivery numbers] | MHDISH | Table | General |
| [Company] | OBCONO | Field | OOLINE |
| [Company] | OACONO | Field | OOHEAD |
| [Facility] | OBFACI | Field | OOLINE |
| [Warehouse] | OBWHLO | Field | OOLINE |
| [Division] | OBDIVI | Field | OOLINE |
| [Division] | OADIVI | Field | OOHEAD |
| [Customer order number] | OBORST | Field | OOLINE |
| [Customer order number] | OAORST | Field | OOHEAD |
| [Customer Number] | OPCUNO | Field | OCUSAD |
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

## Future Enhancements
- Support aliases
- Support joins across multiple M3 tables
- Handle ambiguous business terms
- Validate mappings against metadata
- Store mappings in a configurable dictionary or metadata table
