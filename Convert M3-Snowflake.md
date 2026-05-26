# Convert M3-Snowflake

## Purpose
This document is intended to simplify conversion between T-SQL and Snowflake SQL syntax.

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
                [DOH].[UAIVNO] AS [Invoice number],
                [DOH].[UAIVDT] AS [Invoice date],
                [DH].[OQDSDT] AS [Departure date],
                [DH].[OQFWNO] AS [Forwarding agent],
                [OL].[OBITNO] AS [Item number],
                [IM].[MMITGR] AS [Item group],
                [ST].[CTTX40] AS [Item group description],
                [IM].[MMITDS] AS [ItemName],
                [IM].[MMFUDS] AS [Description],
                [OL].[OBORQT] AS [Ordered quantity - basic U/M],
                [OL].[OBDLQT] AS [Delivered quantity - basic U/M],
                [OL].[OBIVQT] AS [Invoiced quantity - basic U/M],
                ISNULL([OH].[OACUCD], N'N/A') AS [Currency],
                [OL].[OBSAPR] AS [Sales price],
                [AU].[MUALUN] AS [Alternate U/M],
                [OL].[OBDIP1] + [OL].[OBDIP2] + [OL].[OBDIP3] AS [tot discount],
                0 AS [discount],
                CASE
                    WHEN [OL].[OBORST] < 66 THEN [OL].[OBLNAM]
                    ELSE [DOL].[UBLNAM]
                END AS [NetLineAmount],
                [OL].[OBCOFS] AS [Package content],
                [OL].[OBSPUN] AS [Package unit],
                [OL].[OBORQT] AS [Number of packages],
                0 AS [Standard cost],
                0 AS [Average cost],
                [OH].[OAORTP] AS [Customer order type],
                [OL].[OBADID] AS [Address number],
                [DH].[OQCONN] AS [Shipment],
                [DH].[OQVOL3] AS [Packed volume],
                [DH].[OQROUT] AS [Route],
                [OL].[OBMODL] AS [Delivery method],
                [CU].[OPCUNM] AS [Customer name],
                [CU].[OPADID] AS [Customer address number],
                [CU].[OPCUA1] AS [Address line 1],
                [CU].[OPCUA2] AS [Address line 2],
                [CU].[OPCUA3] AS [Address line 3],
                [CU].[OPCUA4] AS [Address line 4],
                [CU].[OPTOWN] AS [City],
                [CU].[OPCSCD] AS [Country],
                [country].[CTTX40] AS [Country Description],
                [OL].[OBCOFA] AS [package content2],
                [OL].[OBCOFA] AS [package content3],
                [IM].[MMUNMS] AS [Basic unit of measure],
                [OL].[OBORQT] * [AU].[MUCOFA] AS [Number of packages2]
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
                [Staging_ERP].[dbo].[ODHEAD] AS [DOH] --[Delivery customer order, head]
            ON  [OL].[OBCONO] = [DOH].[UACONO] --[Company]
                AND [OL].[OBDIVI] = [DOH].[UADIVI] --[Division]
                AND [OL].[OBORNO] = [DOH].[UAORNO] --[Customer order number]
                AND [DOL].[UBDLIX] = [DOH].[UADLIX] --[Delivery number]
 
            LEFT JOIN
                [Staging_ERP].[dbo].[MITMAS] AS [IM] --[Item - Master]
            ON  [OL].[OBCONO] = [IM].[MMCONO] --[Company]
                AND [OL].[OBITNO] = [IM].[MMITNO] --[Item number]
 
            LEFT JOIN
                [Staging_ERP].[dbo].[CSYTAB] AS [ST] --[Item group CodeTable]
            ON  [IM].[MMCONO] = [ST].[CTCONO] --[Item group Company]
                AND [IM].[MMITGR] = [ST].[CTSTKY] --[Item group Key value - ITGR]
                AND [ST].[CTSTCO] = 'ITGR'
            LEFT JOIN
                [Staging_ERP].[dbo].[MHDISH] AS [DH] --[Delivery numbers]
            ON  [DOH].[UACONO] = [DH].[OQCONO] --[Company]
                AND [DOH].[UADLIX] = [DH].[OQDLIX] --[Delivery number]
                AND [DH].[OQINOU] = 1 --[Direction]
 
            LEFT JOIN
                [Staging_ERP].[dbo].[OCUSAD] AS [CU] --[Customer address]
            ON  [OL].[OBCONO] = [CU].[OPCONO] --[Company]
                AND [OL].[OBCUNO] = [CU].[OPCUNO] --[Customer number]
                AND [OL].[OBADID] = [CU].[OPADID] --[Address number]
                AND [CU].[OPADRT] = 1 --[Address type]
 
            LEFT JOIN
                [Staging_ERP].[dbo].[CSYTAB] AS [country] --[Country CodeTable]
            ON  [country].[CTCONO] = [OL].[OBCONO] --[Country Company]
                AND [country].[CTSTKY] = [CU].[OPCSCD] --[Country Key value - CSCD]
                AND [country].[CTSTCO] = 'CSCD'
 
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
    TRIM(OL.OBPROJ) AS "Project element",
    OL.OBCONO AS "Company",
    OL.OBFACI AS "Facility",
    OL.OBWHLO AS "Warehouse",
    COALESCE(DOL.UBPONR, OL.OBPONR) AS "Line number",
    COALESCE(DOL.UBPOSX, OL.OBPOSX) AS "Line suffix",
    COALESCE(DOL.UBDLIX, '') AS "Delivery number",
    '' AS "Receiving DC",
    OL.OBORNO AS "Customer order number",
    OL.OBCUNO AS "Customer number",
    DOH.UAIVNO AS "Invoice number",
    DOH.UAIVDT AS "Invoice date",
    DH.OQDSDT AS "Departure date",
    DH.OQFWNO AS "Forwarding agent",
    OL.OBITNO AS "Item number",
    IM.MMITGR AS "Item group",
    ST.CTTX40 AS "Item group description",
    IM.MMITDS AS "ItemName",
    IM.MMFUDS AS "Description",
    OL.OBORQT AS "Ordered quantity - basic U/M",
    OL.OBDLQT AS "Delivered quantity - basic U/M",
    OL.OBIVQT AS "Invoiced quantity - basic U/M",
    COALESCE(OH.OACUCD, 'N/A') AS "Currency",
    OL.OBSAPR AS "Sales price",
    AU.MUALUN AS "Alternate U/M",
    OL.OBDIP1 + OL.OBDIP2 + OL.OBDIP3 AS "tot discount",
    0 AS "discount",
    CASE
        WHEN OL.OBORST < 66 THEN OL.OBLNAM
        ELSE DOL.UBLNAM
    END AS "NetLineAmount",
    OL.OBCOFS AS "Package content",
    OL.OBSPUN AS "Package unit",
    OL.OBORQT AS "Number of packages",
    0 AS "Standard cost",
    0 AS "Average cost",
    OH.OAORTP AS "Customer order type",
    OL.OBADID AS "Address number",
    DH.OQCONN AS "Shipment",
    DH.OQVOL3 AS "Packed volume",
    DH.OQROUT AS "Route",
    OL.OBMODL AS "Delivery method",
    CU.OPCUNM AS "Customer name",
    CU.OPADID AS "Customer address number",
    CU.OPCUA1 AS "Address line 1",
    CU.OPCUA2 AS "Address line 2",
    CU.OPCUA3 AS "Address line 3",
    CU.OPCUA4 AS "Address line 4",
    CU.OPTOWN AS "City",
    CU.OPCSCD AS "Country",
    country.CTTX40 AS "Country Description",
    OL.OBCOFA AS "package content2",
    OL.OBCOFA AS "package content3",
    IM.MMUNMS AS "Basic unit of measure",
    OL.OBORQT * AU.MUCOFA AS "Number of packages2"
FROM STAGING_ERP.DBO.OOLINE AS OL
INNER JOIN STAGING_ERP.DBO.OOHEAD AS OH
    ON OL.OBCONO = OH.OACONO
   AND OL.OBDIVI = OH.OADIVI
   AND OL.OBORNO = OH.OAORNO
LEFT JOIN STAGING_ERP.DBO.ODLINE AS DOL
    ON OL.OBCONO = DOL.UBCONO
   AND OL.OBDIVI = DOL.UBDIVI
   AND OL.OBORNO = DOL.UBORNO
   AND OL.OBPONR = DOL.UBPONR
   AND OL.OBPOSX = DOL.UBPOSX
LEFT JOIN STAGING_ERP.DBO.ODHEAD AS DOH
    ON OL.OBCONO = DOH.UACONO
   AND OL.OBDIVI = DOH.UADIVI
   AND OL.OBORNO = DOH.UAORNO
   AND DOL.UBDLIX = DOH.UADLIX
LEFT JOIN STAGING_ERP.DBO.MITMAS AS IM
    ON OL.OBCONO = IM.MMCONO
   AND OL.OBITNO = IM.MMITNO
LEFT JOIN STAGING_ERP.DBO.CSYTAB AS ST
    ON IM.MMCONO = ST.CTCONO
   AND IM.MMITGR = ST.CTSTKY
   AND ST.CTSTCO = 'ITGR'
LEFT JOIN STAGING_ERP.DBO.MHDISH AS DH
    ON DOH.UACONO = DH.OQCONO
   AND DOH.UADLIX = DH.OQDLIX
   AND DH.OQINOU = 1
LEFT JOIN STAGING_ERP.DBO.OCUSAD AS CU
    ON OL.OBCONO = CU.OPCONO
   AND OL.OBCUNO = CU.OPCUNO
   AND OL.OBADID = CU.OPADID
   AND CU.OPADRT = 1
LEFT JOIN STAGING_ERP.DBO.CSYTAB AS country
    ON country.CTCONO = OL.OBCONO
   AND country.CTSTKY = CU.OPCSCD
   AND country.CTSTCO = 'CSCD'
LEFT JOIN STAGING_ERP.DBO.MITAUN AS AU
    ON OL.OBCONO = AU.MUCONO
   AND OL.OBITNO = AU.MUITNO
   AND AU.MUAUS9 = 1
WHERE OH.OAORDT >= 20260501;
```

## Notes

- Replaced T-SQL square-bracket identifiers with Snowflake-compatible identifiers and double-quoted output aliases.
- Replaced `ISNULL(...)` with `COALESCE(...)`.
- Replaced `N''` and `N'N/A'` Unicode string literals with standard string literals.
- Preserved the original database/schema/table naming pattern as `STAGING_ERP.DBO.TABLE_NAME`; adjust object names if your Snowflake database and schema names differ.
- If columns such as `OAORDT`, `UAIVDT`, or `OQDSDT` are stored as numeric date keys rather than true DATE values, you may want to cast/convert them separately in Snowflake.
- Snowflake M3 column names should use the four-character business field name without the original two-character table prefix. For example, `OACONO` becomes `CONO`, not `OACONO`.
- Snowflake M3 table names should use the `M3_` prefix followed by the original table name. For example, `ODHEAD` becomes `M3_ODHEAD` and `ODLINE` becomes `M3_ODLINE`.

---

## Snowflake SQL Example 2

```sql
SELECT
    1 AS "IC_type",
    TRIM(OL.PROJ) AS "Project element",
    OL.CONO AS "Company",
    OL.FACI AS "Facility",
    OL.WHLO AS "Warehouse",
    COALESCE(DOL.PONR, OL.PONR) AS "Line number",
    COALESCE(DOL.POSX, OL.POSX) AS "Line suffix",
    COALESCE(DOL.DLIX, '0') AS "Delivery number",
    '' AS "Receiving DC",
    OL.ORNO AS "Customer order number",
    OL.CUNO AS "Customer number",
    DOH.IVNO AS "Invoice number",
    DOH.IVDT AS "Invoice date",
    DH.DSDT AS "Departure date",
    DH.FWNO AS "Forwarding agent",
    OL.ITNO AS "Item number",
    IM.ITGR AS "Item group",
    ST.TX40 AS "Item group description",
    IM.ITDS AS "ItemName",
    IM.FUDS AS "Description",
    OL.ORQT AS "Ordered quantity - basic U/M",
    OL.DLQT AS "Delivered quantity - basic U/M",
    OL.IVQT AS "Invoiced quantity - basic U/M",
    IFNULL(OH.CUCD, 'N/A') AS "Currency",
    OL.SAPR AS "Sales price",
    AU.ALUN AS "Alternate U/M",
    OL.DIP1 + OL.DIP2 + OL.DIP3 AS "tot discount",
    0 AS "discount",
    CASE
        WHEN OL.ORST < 66 THEN OL.LNAM
        ELSE DOL.LNAM
    END AS "NetLineAmount",
    OL.COFS AS "Package content",
    OL.SPUN AS "Package unit",
    OL.ORQT AS "Number of packages",
    0 AS "Standard cost",
    0 AS "Average cost",
    OH.ORTP AS "Customer order type",
    OL.ADID AS "Address number",
    DH.CONN AS "Shipment",
    DH.VOL3 AS "Packed volume",
    DH.ROUT AS "Route",
    OL.MODL AS "Delivery method",
    CU.CUNM AS "Customer name",
    CU.ADID AS "Customer address number",
    CU.CUA1 AS "Address line 1",
    CU.CUA2 AS "Address line 2",
    CU.CUA3 AS "Address line 3",
    CU.CUA4 AS "Address line 4",
    CU.TOWN AS "City",
    CU.CSCD AS "Country",
    country.TX40 AS "Country Description",
    OL.COFA AS "package content2",
    OL.COFA AS "package content3",
    IM.UNMS AS "Basic unit of measure",
    OL.ORQT * AU.COFA AS "Number of packages2"
FROM M3_OOLINE AS OL
INNER JOIN M3_OOHEAD AS OH
    ON OL.CONO = OH.CONO
   AND OL.DIVI = OH.DIVI
   AND OL.ORNO = OH.ORNO
LEFT JOIN M3_ODLINE AS DOL
    ON OL.CONO = DOL.CONO
   AND OL.DIVI = DOL.DIVI
   AND OL.ORNO = DOL.ORNO
   AND OL.PONR = DOL.PONR
   AND OL.POSX = DOL.POSX
LEFT JOIN M3_ODHEAD AS DOH
    ON OL.CONO = DOH.CONO
   AND OL.DIVI = DOH.DIVI
   AND OL.ORNO = DOH.ORNO
   AND DOL.DLIX = DOH.DLIX
LEFT JOIN M3_MITMAS AS IM
    ON OL.CONO = IM.CONO
   AND OL.ITNO = IM.ITNO
LEFT JOIN M3_CSYTAB AS ST
    ON IM.CONO = ST.CONO
   AND IM.ITGR = ST.STKY
LEFT JOIN M3_MHDISH AS DH
    ON DOH.CONO = DH.CONO
   AND DOH.DLIX = DH.DLIX
   AND DH.INOU = 1
LEFT JOIN M3_OCUSAD AS CU
    ON OL.CONO = CU.CONO
   AND OL.CUNO = CU.CUNO
   AND OL.ADID = CU.ADID
   AND CU.ADRT = 1
LEFT JOIN M3_CSYTAB AS country
    ON country.CONO = OL.CONO
   AND country.STKY = CU.CSCD
LEFT JOIN M3_MITAUN AS AU
    ON OL.CONO = AU.CONO
   AND OL.ITNO = AU.ITNO
   AND AU.AUS9 = 1
WHERE OH.ORDT >= 20250501;
```

## Notes for Example 2

- This query is already very close to Snowflake syntax.
- `IFNULL(...)` is valid in Snowflake, so no change was required.
- Double-quoted aliases are valid in Snowflake and were preserved.
- Table aliases like `"OH"` and `"country"` were normalized to unquoted aliases for readability.
- If `ST` and `country` are code tables requiring additional filters such as a code type column, you may want to add those predicates explicitly.
- If `ORDT`, `IVDT`, or `DSDT` are stored as numeric YYYYMMDD values, consider converting them with `TO_DATE(TO_VARCHAR(column), 'YYYYMMDD')`.
