# Convert M3-Snowflake

## Purpose
This document is intended to simplify conversion between Original T-SQL to Snowflake SQL syntax.

## Original T-SQL

```sql
SELECT
                1 AS [IC_type],
                TRIM([OL].[OBPROJ]) AS [Project element],
                [OL].[OBCONO] AS [Company],
                [OL].[OBFACI] AS [Facility],
                [OL].[OBWHLO] AS [Warehouse],
                COALESCE([DOL].[UBPONR], [OL].[OBPONR]) AS [Line number],
                COALESCE([DOL].[UBPOSX], [OL].[OBPOSX]) AS [Line suffix],
                COALESCE([DOL].[UBDLIX], N'') AS [Delivery number],
                '' AS [Receiving DC],
                [OL].[OBORNO] AS [Customer order number],
                [OL].[OBCUNO] AS [Customer number],
                [IM].[MMITDS] AS [ItemName],
                [AU].[MUALUN] AS [Alternate U/M],
FROM
                [Staging_ERP].[dbo].[OOLINE] AS [OL] --[Customer order, lines]
 
            INNER JOIN
                [Staging_ERP].[dbo].[OOHEAD] AS [OH] --[Customer order, head]
            ON  [OL].[OBCONO] = [OH].[OACONO] --[Company]
                AND [OL].[OBDIVI] = [OH].[OADIVI] --[Division]
                AND [OL].[OBORNO] = [OH].[OAORNO] --[Customer order number]
 
            LEFT JOIN
                [Staging_ERP].[dbo].[ODLINE] AS [DOL] --[Delivery customer order, line]
            ON  [OL].[OBCONO] = [DOL].[UBCONO] --[Company]
                AND [OL].[OBDIVI] = [DOL].[UBDIVI] --[Division]
                AND [OL].[OBORNO] = [DOL].[UBORNO] --[Customer order number]
                AND [OL].[OBPONR] = [DOL].[UBPONR] --[Line number]
                AND [OL].[OBPOSX] = [DOL].[UBPOSX] --[Line suffix]

            LEFT JOIN
                [Staging_ERP].[dbo].[MITMAS] AS [IM] --[Item - Master]
            ON  [OL].[OBCONO] = [IM].[MMCONO] --[Company]
                AND [OL].[OBITNO] = [IM].[MMITNO] --[Item number]

            LEFT JOIN
                [Staging_ERP].[dbo].[MITAUN] AS [AU] --[Alternative units]
            ON  [OL].[OBCONO] = [AU].[MUCONO] --[Company]
                AND [OL].[OBITNO] = [AU].[MUITNO] --[Item number]
                AND [AU].[MUAUS9] = 1 --[Standard U/M - sales price]
WHERE
                [OH].[OAORDT] >= 20260501 --[Order date]
```

## Snowflake SQL

```sql
SELECT
    1 AS "IC_type",
    TRIM(OL.PROJ) AS "Project element",
    OL.CONO AS "Company",
    OL.FACI AS "Facility",
    OL.WHLO AS "Warehouse",
    COALESCE(DOL.PONR, OL.PONR) AS "Line number",
    COALESCE(DOL.POSX, OL.POSX) AS "Line suffix",
    COALESCE(DOL.DLIX, '') AS "Delivery number",
    '' AS "Receiving DC",
    OL.ORNO AS "Customer order number",
    OL.CUNO AS "Customer number",
    IM.ITDS AS "ItemName",
    AU.ALUN AS "Alternate U/M",
FROM RAW.M3_OOLINE AS OL
INNER JOIN RAW.M3_OOHEAD AS OH
    ON OL.CONO = OH.CONO
   AND OL.DIVI = OH.DIVI
   AND OL.ORNO = OH.ORNO
LEFT JOIN RAW.M3_ODLINE AS DOL
    ON OL.CONO = DOL.CONO
   AND OL.DIVI = DOL.DIVI
   AND OL.ORNO = DOL.ORNO
   AND OL.PONR = DOL.PONR
   AND OL.POSX = DOL.POSX
LEFT JOIN RAW.M3_MITMAS AS IM
    ON OL.CONO = IM.CONO
   AND OL.ITNO = IM.ITNO
LEFT JOIN RAW.M3_MITAUN AS AU
    ON OL.CONO = AU.CONO
   AND OL.ITNO = AU.ITNO
   AND AU.AUS9 = 1
WHERE OH.ORDT >= 20260501;
```

## Notes

- Replaced T-SQL square-bracket identifiers with Snowflake-compatible identifiers and double-quoted output aliases.
- Replaced `ISNULL(...)` with `COALESCE(...)`.
- Replaced `N''` and `N'N/A'` Unicode string literals with standard string literals.
- Preserved the original database/schema/table naming pattern as `STAGING_ERP.DBO.TABLE_NAME`; adjust object names if your Snowflake database and schema names differ.
- If columns such as `OAORDT`, `UAIVDT`, or `OQDSDT` are stored as numeric date keys rather than true DATE values, you may want to cast/convert them separately in Snowflake.
- Snowflake M3 column names should use the four-character business field name without the original two-character table prefix. For example, `OBCONO` becomes `CONO`, not `OBCONO`.
- This applies consistently across all converted columns. Examples: `OBFACI` → `FACI`, `OBWHLO` → `WHLO`, `UBPONR` → `PONR`, `MMITDS` → `ITDS`, and `MUALUN` → `ALUN`.
- Snowflake M3 table names should use the `M3_` prefix followed by the original table name. For example, `ODHEAD` becomes `M3_ODHEAD` and `ODLINE` becomes `M3_ODLINE`.
- If `ST` and `country` are code tables requiring additional filters such as a code type column, you may want to add those predicates explicitly.
- If `ORDT`, `IVDT`, or `DSDT` are stored as numeric YYYYMMDD values, consider converting them with `TO_DATE(TO_VARCHAR(column), 'YYYYMMDD')`.
