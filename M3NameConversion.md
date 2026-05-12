# M3 Name Conversion

## Purpose
Convert SQL queries written with friendly or business-oriented names into technical M3 names.

## M3 Naming
In M3, table names are technical identifiers and are typically 6 characters long.

Example:
- `MITMAS` = Item Master

SQL written by users may refer to business concepts such as:
- Item Master
- Customer
- Supplier
- Warehouse

These should be translated into the corresponding M3 table and field names before execution or processing.

## Goal
Enable SQL-like input using friendly names and convert it into SQL using M3 technical table names and column names.

## Example
### Friendly input
```sql
SELECT Item, Item Description
FROM Item Master
WHERE Item = 'A100'
```

### Converted M3-style input
```sql
SELECT MMITNO, MMITDS
FROM MITMAS
WHERE MMITNO = 'A100'
```

## Conversion Rules
- Friendly business table names must be mapped to M3 table names.
- M3 table names are technical identifiers such as `MITMAS`.
- Friendly field names must be mapped to M3 field names.
- Field mappings should be resolved in the context of the selected table.
- SQL structure must remain unchanged except for name conversion.
- Unknown names should be flagged or left unchanged depending on system rules.

## Mapping Examples
| Friendly Name | M3 Technical Name | Type |
|---|---|---|
| Item Master | MITMAS | Table |
| Item | MMITNO | Field |
| Item Description | MMITDS | Field |

## Notes
- M3 fields are often prefixed in a way that relates to the table structure.
- The same friendly field name may map differently depending on table context.
- A central mapping dictionary is recommended.

## Future Enhancements
- Support aliases
- Support joins across multiple M3 tables
- Handle ambiguous business terms
- Validate mappings against metadata
