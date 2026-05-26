SELECT  DISTINCT
        2 AS [IC_type],
        '' AS [SO Project number],
        [SL].[Company], --[UNMAPPED]
        [SH].[Facility],
        [SH].[Warehouse],
        --[ID].[Warehouse],
        [SL].[Line number], --[UNMAPPED]
        [SL].[Line suffix (/MRPOSX    )], --[UNMAPPED]
        [DLL].[Delivery number],
        [SH].[To warehouse],
        [SL].[Order number], --[UNMAPPED]
        [ID].[Customer number],
        N'' AS [Internal invoice number],
        0 AS [Planned delivery date],
        --[ID].[Internal invoice number],
        --[ID].[Planned delivery date],
        [DLL].[Departure date],
        [DLL].[Forwarding agent],
        [SL].[Item number], --[UNMAPPED]
        [IM].[MMITGR] AS [Item group],
        [ST].[CTTX15] AS [Item group description],
        [IM].[MMITDS] AS [Item name],
        [IM].[MMFUDS] AS [Description 2],
        [SL].[Transaction quantity - basic U/M], --[UNMAPPED]
        [SL].[Reported quantity], --[UNMAPPED]
        0 AS [Invoiced qty],
        ISNULL([ID].[Internal transfer currency], N'N/A') AS [Currency],
        0 AS [Sales price],
        [AU].[MUALUN] AS [Alternate U/M],
        0 AS [tot disc],
        0 AS [discount],
        0 AS [NetLineAmount],
        [AU].[MUCOFA] AS [Package contents],
        [AU].[MUALUN] AS [Package unit],
        [SL].[Transaction quantity - basic U/M] AS [Number of Packages], --[UNMAPPED]
        0 AS [Standard cost],
        0 AS [Average cost],
        [SH].[Order type],
        '' AS [Adress number],
        [DLL].[Shipment],
        [DLL].[Volume] AS [Packed volume],
        [DLL].[Route],
        [SH].[Delivery method],
        [addr].[MACONM] AS [Customer name],
        '' AS [Address name],
        [addr].[MAADR1] AS [Customer address 1],
        [addr].[MAADR2] AS [Customer address 2],
        [addr].[MAADR3] AS [Customer address 3],
        [addr].[MAADR4] AS [Customer address 4],
        [addr].[MATOWN] AS [City],
        [addr].[MACSCD] AS [Country],
        [country].[CTTX40] AS [Country Description],
        0 AS [Package content 2],
        0 AS [Package content 3],
        '' AS [Basic unit of measure],
        [SL].[Transaction quantity - basic U/M] * [AU].[MUCOFA] AS [Number of Packages2] --[UNMAPPED]
FROM
        [Staging_ERP].[dbo].[Stock transaction, line] AS [SL] --[UNMAPPED]

    INNER JOIN
        [dbo].[tmp_stock_tran_head_44682] AS [SH]
    ON  [SL].[Company] = [SH].[Company] --[UNMAPPED]
        AND [SL].[Order number] = [SH].[Order number] --[UNMAPPED]

    INNER JOIN
        [Staging_ERP].[dbo].[Transaction types parameters] AS [ttp] --[UNMAPPED]
    ON  [ttp].[Company] = [SH].[Company] --[UNMAPPED]
        AND [ttp].[Order type] = [SH].[Order type] --[UNMAPPED]
        AND [ttp].[Stock transaction type] = 51 --[UNMAPPED] -- N'MVW'

    LEFT JOIN
        [dbo].[tmp_internal_delivery_44682] AS [ID]
    ON  [SL].[Company] = [ID].[Company] --[UNMAPPED]
        AND [SL].[Order number] = [ID].[Order number] --[UNMAPPED]
        AND [SL].[Line number] = [ID].[Order line] --[UNMAPPED]
        AND [SL].[Line suffix (/MRPOSX    )] = [ID].[Line suffix] --[UNMAPPED]

    LEFT JOIN
        [Staging_ERP].[dbo].[MITMAS] AS [IM] --[Item - Master]
    ON  [SL].[Company] = [IM].[MMCONO] --[UNMAPPED]
        AND [SL].[Item number] = [IM].[MMITNO] --[UNMAPPED]

    LEFT JOIN
        [Staging_ERP].[dbo].[CSYTAB] AS [ST] --[Item group CodeTable]
    ON  [IM].[MMCONO] = [ST].[CTCONO] --[Company]
        AND [IM].[MMITGR] = [ST].[CTSTKY] --[Item group / Key value]

    LEFT JOIN
        [Staging_ERP].[dbo].[MGDADR] AS [addr] --[Stock transaction, Delivery address file]
    ON  [SL].[Company] = [addr].[MACONO] --[UNMAPPED]
        AND [SL].[Order number] = [addr].[MATRNR] --[UNMAPPED]

    LEFT JOIN
        [Staging_ERP].[dbo].[CSYTAB] AS [country] --[Country CodeTable]
    ON  [country].[CTSTKY] = [addr].[MACSCD] --[Key value / Country]
        AND [country].[CTCONO] = [addr].[MACONO] --[Company]

    LEFT JOIN
        [dbo].[tmp_delivery_44682] AS [DLL]
    ON  [DLL].[Company] = [SL].[Company] --[UNMAPPED]
        AND [DLL].[Order number] = [SL].[Order number] --[UNMAPPED]
        AND [DLL].[Order line] = [SL].[Line number] --[UNMAPPED]

    LEFT JOIN
        [Staging_ERP].[dbo].[MITAUN] AS [AU] --[Alternative units]
    ON  [SL].[Company] = [AU].[MUCONO] --[UNMAPPED]
        AND [SL].[Item number] = [AU].[MUITNO] --[UNMAPPED]
        AND [AU].[Standard U/M - sales price] = 1 --[UNMAPPED]
WHERE
        [SH].[Company] = 300
        AND [SH].[Entry date] >= @testdate;
