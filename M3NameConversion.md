# M3 Name Conversion

## Purpose
Convert SQL queries written with friendly or business-oriented names into technical M3 names.

## M3 Naming
In M3, table names are technical identifiers and are typically 6 characters long.

Examples:
- `MITMAS` = Item Master
- `OOLINE` = Customer order, lines
- `OOHEAD` = Customer order, head

SQL written by users may refer to business concepts such as:
- Item Master
- Customer order, lines
- Customer order, head
- Warehouse

These should be translated into the corresponding M3 table and field names before execution or processing.

## Goal
Enable submission of SQL queries using user-friendly names and convert them into SQL using M3 technical table names and column names.

## Example 1
### Friendly input
```sql
SELECT Item number, Item Description
FROM Item Master
WHERE Item number = 'A100'
```

### Converted M3-style input
```sql
SELECT MMITNO, MMITDS
FROM MITMAS
WHERE MMITNO = 'A100'
```

## Example 2
### Friendly input
```sql
SELECT
    [OL].[Company],
    [OL].[Facility],
    [OL].[Warehouse],
    [OH].[Customer order number]
FROM [Staging_ERP].[dbo].[Customer order, lines] AS [OL]
    INNER JOIN [Staging_ERP].[dbo].[Customer order, head] AS [OH] ON [OL].[Company] = [OH].[Company] AND [OL].[Division] = [OH].[Division] AND [OL].[Customer order number] = [OH].[Customer order number]
```

### Converted M3-style input
```sql
SELECT
    [OL].[OBCONO],
    [OL].[OBFACI],
    [OL].[OBWHLO],
    [OH].[OAORST]
FROM [Staging_ERP].[dbo].[OOLINE] AS [OL]
    INNER JOIN [Staging_ERP].[dbo].[OOHEAD] AS [OH] ON [OL].[OBCONO] = [OH].[OACONO] AND [OL].[OBDIVI] = [OH].[OADIVI] AND [OL].[OBORST] = [OH].[OAORST]
```

## Conversion Rules
- Friendly business table names must be mapped to M3 table names.
- M3 table names are technical identifiers such as `MITMAS`, `OOLINE`, and `OOHEAD`.
- Friendly field names must be mapped to M3 field names.
- Field mappings should be resolved in the context of the selected table alias.
- The same friendly field name may map to different M3 technical names depending on the table.
- SQL structure must remain unchanged except for name conversion.
- Database name, schema name, aliases, joins, filters, and SQL keywords must be preserved.
- Unknown names should be flagged or left unchanged depending on system rules.

## Mapping Examples
| Friendly Name | M3 Technical Name | Type | Context |
|---|---|---|---|
| Item Master | MITMAS | Table | General |
| Item number | MMITNO | Field | MITMAS |
| Item Description | MMITDS | Field | MITMAS |
| Customer order, lines | OOLINE | Table | General |
| Customer order, head | OOHEAD | Table | General |
| Company | OBCONO | Field | OOLINE |
| Company | OACONO | Field | OOHEAD |
| Facility | OBFACI | Field | OOLINE |
| Warehouse | OBWHLO | Field | OOLINE |
| Division | OBDIVI | Field | OOLINE |
| Division | OADIVI | Field | OOHEAD |
| Customer order number | OBORST | Field | OOLINE |
| Customer order number | OAORST | Field | OOHEAD |

## Notes
- M3 fields are often prefixed in a way that relates to the table structure.
- The same friendly field name may map differently depending on table context.
- A central mapping dictionary is recommended.
- Query conversion should work for SELECT lists, FROM clauses, JOIN clauses, WHERE conditions, and other SQL expressions where mapped identifiers are used.

## Future Enhancements
- Support aliases
- Support joins across multiple M3 tables
- Handle ambiguous business terms
- Validate mappings against metadata
- Store mappings in a configurable dictionary or metadata table
