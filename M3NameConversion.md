# M3 Name Conversion

## Purpose
Convert SQL queries written with M3 MDP (Metadata Publisher) user-friendly names into technical M3 names (typically 6-character identifiers for tables and columns).

## Critical Instructions
- Follow the naming and commenting convention strictly as shown in the example below.

## M3 Naming
M3 table and field names are short technical identifiers, typically 6 characters long. MDP (Metadata Publisher) is M3's own user-friendly naming layer for tables and fields.

**Common table mappings:**
| MDP Name | M3 Technical Name |
|---|---|
| [Item Master] | `MITMAS` |
| [Customer order, lines] | `OOLINE` |
| [Customer order, head] | `OOHEAD` |
| [Delivery customer order, line] | `ODLINE` |
| [Delivery customer order, head] | `ODHEAD` |
| [Customer address] | `OCUSAD` |
| [System tables file] | `CSYTAB` |
| [Delivery numbers] | `MHDISH` |

> **Note on CSYTAB:** Many tables store a code or key while the descriptive text lives in `CSYTAB`. SQL may also reference `... CodeTable` names that do not physically exist — these are logical views over `CSYTAB` and resolve to it at runtime while keeping their own column-mapping context.

## Mapping Source
Mappings between MDP names and M3 technical names are stored in:
- An MDP database
- `M3 Vocabulary -columns1.csv`
- `M3 Vocabulary -columns2.csv`

**How mappings are loaded:**
- Load both CSV files before query conversion begins.
- Build a dictionary for table name mappings.
- Build a dictionary for column name mappings scoped by M3 table name (the same friendly name may map differently depending on context).
- If no mapping exists, leave the identifier unchanged or flag it for review (behavior should be configurable).

## Example

### User-Friendly (MDP) input
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

## Conversion Logic

### Step 1: Parse the SQL query
Identify all SQL clauses (`SELECT`, `FROM`, `JOIN`, `WHERE`, `GROUP BY`, `ORDER BY`) and extract:
- database and schema references
- table names and aliases
- column references
- join conditions

### Step 2: Resolve table mappings
Translate each friendly table name to its M3 technical name using the mapping source. Preserve aliases and all other SQL structure.

Example:
```
[Staging_ERP].[dbo].[Customer order, lines] AS [OL]
→ [Staging_ERP].[dbo].[OOLINE] AS [OL]
```

`... CodeTable` names (e.g. `[Status CodeTable]`) resolve to `CSYTAB` but keep their own column-mapping context.

### Step 3: Resolve column mappings
Use the table alias + mapped table name to look up the correct M3 field name. The same friendly name may map differently per table.

Examples:
- `[OL].[Company]` → `[OL].[OBCONO]` (OOLINE)
- `[OH].[Company]` → `[OH].[OACONO]` (OOHEAD)
- `[CA].[Customer Number]` → `[CA].[OPCUNO]` (OCUSAD)
- `[ST].[Description]` → `[ST].[CTTX40]` (CSYTAB)

**Field-prefix hints for validation:**
- `ODLINE` fields → typically begin with `UB`
- `ODHEAD` fields → typically begin with `UA`
- `OCUSAD` fields → typically begin with `OP`

### Step 4: Replace identifiers and preserve everything else
Replace only mapped table and column names. Leave unchanged:
- SQL keywords, operators, literals
- aliases, database names, schema names
- query structure, joins, filters, sorting, grouping
- `SELECT` output aliases (keep when present)

### Step 5: Handle unknown mappings
If a friendly name has no mapping: leave it unchanged or flag it for review. The preferred behavior should be configurable.

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

## Future Enhancements
- Support aliases
- Support joins across multiple M3 tables
- Handle ambiguous business terms
- Validate mappings against metadata
- Store mappings in a configurable dictionary or metadata table
