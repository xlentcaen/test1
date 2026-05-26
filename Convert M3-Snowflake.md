# Convert M3-Snowflake

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
