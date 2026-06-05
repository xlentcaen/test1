# Monthly Cost Analysis

## Purpose and Scope
This document defines the structure, terminology, and review logic for monthly cost analysis in the P&L. It is intended to support consistent analysis across companies, accounts, cost centers, cost center groups, and profit centers.

## Core Definitions

### Company
The companies in the group are:
- **SE** = Sweden
- **SK** = Slovakia
- **CN-NT** = China Nantong
- **CN** = China Shanghai (**legacy**)

**CN** is a legacy company. It may still contain financial transactions and can be used for **validation**, **reconciliation**, and **historical transaction review**, but it must **not** be used for **performance analysis**.

### Cost Center Group
A **Cost Center Group** is a grouping of cost centers used to show where cost appears in the **functional cost analysis**.

The following cost center groups define **CC-CC** cost centers:
- **Internal fees common**
- **Internal fees local site support**
- **Internal fees IT**

### Period
**Period** is the month in format `YYYYMM`.

The fiscal year starts in **September** and ends in **August** of the following year.

Example:
- Fiscal year start: `202609`
- Fiscal year end: `202708`

### Accumulation
- **Monthly** = single month only
- **YTD** = accumulated from the beginning of the fiscal year

Example:
- **YTD in 202611** = `202609 + 202610 + 202611`

## Accounting String Dimensions
The analysis is based on the following accounting string dimensions:

- **Account** = General Ledger account
- **CC (Cost Center)** = three-digit cost center code
- **PC (Profit Center)** = profit center code
- **Profit Center Name** = descriptive name used together with the profit center code

Guidelines:
- Always refer to **Profit Centers** using both the code and **Profit Center Name**
- Refer to **Cost Centers** using the code only, since there is no separate **Cost Center Name** column

## Cost Center Logic
Cost centers are categorized as either:
- **CC-CC**
- **CC-PC**

### CC-CC Cost Centers
**CC-CC** cost centers are allocation cost centers that are allocated to **CC-PC** cost centers.

A cost center is classified as **CC-CC** if it belongs to one of these cost center groups:
- **Internal fees common**
- **Internal fees local site support**
- **Internal fees IT**

Characteristics:
- Carry **Total Operating Costs**
- Receive offsetting income through **Total Internal Fees**
- Should always have a final result of **0**

This means that operating cost in a **CC-CC** cost center should be fully offset by internal fee postings.

### CC-PC Cost Centers
**CC-PC** cost centers are operational cost centers linked to profit centers.

Characteristics:
- Receive allocated costs from **CC-CC** cost centers through **Total Internal Fees**
- Usually show a **negative result**
- Have their negative result allocated onward to **Profit Centers**
- Reflect both direct costs and allocated costs in their cost base

## Cost Calculations
- **TOTAL LOCAL COSTS** = **Total Operating Costs** + **Total Internal Fees**
- **Total Costs** = **TOTAL LOCAL COSTS** + **Service fee**

## Values
- **Value LOC** = value in the local currency of the company
- **Value EUR** = value in EUR using the fixed standard exchange rate for the full fiscal year

## Allocation Flow

### Step 1: CC-CC Cost Centers
- **CC-CC** cost centers collect operating costs
- These costs are offset through **Total Internal Fees**
- The final result in **CC-CC** should always be **0**

### Step 2: CC-PC Cost Centers
- **CC-PC** cost centers receive allocations from **CC-CC** through **Total Internal Fees**
- They typically show a **negative result**

### Step 3: Profit Centers
- The negative result from **CC-PC** cost centers is allocated to **Profit Centers**
- This ensures cost responsibility is reflected at **PC** level

## Monthly Cost Summary

| Month | Company | Account | CC | PC | Value LOC | Value EUR | Accumulation |
|-------|---------|---------|----|----|-----------|-----------|--------------|
|       |         |         |    |    |           |           |              |

## Analysis Areas

### By Company
- Compare cost development across **SE**, **SK**, and **CN-NT**
- Exclude **CN** from performance analysis
- Use **CN** only for validation, reconciliation, and historical review
- Identify differences in cost base and cost structure
- Highlight currency and structural effects

### By Account
- Analyze General Ledger cost movements
- Review impacts from operating cost, internal fees, and service fee
- Identify unusual or non-recurring postings

### By Cost Center
- Analyze cost ownership by cost center
- Distinguish between **CC-CC** and **CC-PC**
- Confirm that **CC-CC** cost centers net to zero
- Review how costs are allocated from **CC-CC** to **CC-PC** through **Total Internal Fees**
- Review how negative results in **CC-PC** are allocated onward to **Profit Centers**

### By Cost Center Group
- Analyze how costs are distributed in the functional cost analysis
- Track the impact of each functional area on total cost
- Use the cost center groups **Internal fees common**, **Internal fees local site support**, and **Internal fees IT** to identify **CC-CC** cost centers

### By Profit Center
- Analyze allocated cost burden by profit center
- Always refer to profit centers using both code and **Profit Center Name**
- Example: **Q11 Assembly**
- Compare cost absorption across profit-responsible units
- Evaluate the impact of allocated results from **CC-PC** cost centers

## Control Checks

### CC-CC Validation
For **CC-CC** cost centers, validate that:
- **Total Operating Costs** + **Total Internal Fees** offset each other
- The final result is always **0**
- Any deviation indicates a possible allocation or posting issue
- The cost center belongs to one of the following cost center groups:
  - **Internal fees common**
  - **Internal fees local site support**
  - **Internal fees IT**

### CC-PC Validation
For **CC-PC** cost centers, validate that:
- Allocated costs from **CC-CC** are included through **Total Internal Fees**
- They usually show a negative result before profit center allocation
- Their negative result is allocated onward to profit centers
- Cost responsibility at profit center level reflects these allocations

### Headcount Validation
Validate that:
- **Forecasted Headcount** is compared with **Approved Headcount**
- Deviations between **Forecasted Headcount** and **Approved Headcount** are identified and reviewed
- The check is applied for both **WC (White collar)** and **BC (Blue collar)**

## Key Review Questions
- Which companies carry the largest cost base?
- Which accounts explain the main cost movements?
- Which cost centers or cost center groups are driving the cost base?
- Do all **CC-CC** cost centers net to zero as expected?
- Are allocated costs fully transferred from **CC-CC** to **CC-PC**?
- Are negative results in **CC-PC** allocated correctly to profit centers?
- Which profit centers absorb the highest costs?
- How do **Monthly** and **YTD** views differ across the fiscal year?
- Is **CN** used only for validation and not for performance evaluation?
- Are profit centers consistently named using both code and **Profit Center Name**?
- Are **CC-CC** cost centers correctly identified through the cost center groups **Internal fees common**, **Internal fees local site support**, and **Internal fees IT**?
- Does **Forecasted Headcount** deviate from **Approved Headcount** for **WC (White collar)** or **BC (Blue collar)**?

## Practical Notes
Use:
- **Monthly** for single-period analysis
- **YTD** for fiscal year accumulated analysis
- **Value LOC** when local entity cost analysis matters
- **Value EUR** when comparing across companies using the fixed fiscal-year exchange rate
- **CN** only for validation, reconciliation, and historical transaction checks

Remember:
- Exclude **CN** from performance analysis
- Always refer to **Profit Centers** using both code and **Profit Center Name**
- Refer to **Cost Centers** using the code only
- Treat cost centers in **Internal fees common**, **Internal fees local site support**, and **Internal fees IT** as **CC-CC** cost centers
- Validate deviations between **Forecasted Headcount** and **Approved Headcount** for both **WC (White collar)** and **BC (Blue collar)**
