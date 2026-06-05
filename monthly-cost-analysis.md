# Monthly Cost Analysis

## Explanations

### Scope
This analysis focuses on the different type of costs in the P&L.

### Company
The companies in the group are:
- **SE** = Sweden
- **SK** = Slovakia
- **CN-NT** = China Nantong
- **CN** = China Shanghai (**legacy**)

**CN** is a legacy company. Financial transactions may still occur on this company and it can be used for **validation** and reconciliation purposes, but it should **not** be used in **performance studies**.

### Cost Center Group
**Cost Center Group** is a grouping of Cost Centers. It maps where the cost appears in the **functional cost analysis**.

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
- **Monthly** = the single month only
- **YTD** = accumulated from the beginning of the fiscal year

Example:
- **YTD in 202611** = `202609 + 202610 + 202611`

## Accounting String Dimensions
The analysis is based on the following accounting string dimensions:

- **Account** = General Ledger account
- **CC (Cost Center)** = three-digit number
- **PC (Profit Center)** = Profit Center
- **Profit Center Name** = descriptive name used together with the Profit Center code

For **Cost Centers**, use the cost center code only, since there is no separate **Cost Center Name** column.

## Cost Center Logic

Cost Centers are categorized as either:
- **CC-CC**
- **CC-PC**

### CC-CC Cost Centers
**CC-CC** cost centers are allocation cost centers. They are allocated to other **CC-PC** cost centers.

They are the cost centers that belong to the cost center groups:
- **Internal fees common**
- **Internal fees local site support**
- **Internal fees IT**

Characteristics:
- They carry **Total Operating Costs**
- They receive offsetting income through **Total Internal Fees**
- Their result should always be **0**

This means the operating cost in a **CC-CC** cost center should be fully offset by internal fee postings.

### CC-PC Cost Centers
**CC-PC** cost centers are operational cost centers linked to Profit Centers.

Characteristics:
- They receive allocated costs from **CC-CC** cost centers through **Total Internal Fees**
- They usually show a **negative result**
- This negative result needs to be allocated to **Profit Centers**
- Their cost base reflects both direct costs and allocated costs

## Cost Calculations

- **TOTAL LOCAL COSTS** = **Total Operating Costs** + **TOTAL INTERNAL FEES**
- **Total Costs** = **TOTAL LOCAL COSTS** + **Service fee**

## Values
- **Value LOC** = Value in local currency of the company
- **Value EUR** = Value in EUR using the fixed standard exchange rate set for the full fiscal year

## Allocation Flow

### Step 1: CC-CC Cost Centers
- **CC-CC** cost centers collect operating costs
- These costs are offset through **Total Internal Fees**
- Result in **CC-CC** should always be **0**
- **CC-CC** cost centers are those in the cost center groups **Internal fees common**, **Internal fees local site support**, and **Internal fees IT**

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
- Exclude **CN** from performance studies because it is a legacy company
- Use **CN** only for validation, reconciliation, and historical transaction review
- Identify differences in cost base and structure
- Highlight currency and structural effects

### By Account
- Analyze General Ledger cost movements
- Review operating cost, internal fees, and service fee impacts
- Identify unusual or non-recurring postings

### By Cost Center
- Analyze cost ownership by Cost Center
- Distinguish between **CC-CC** and **CC-PC**
- Confirm that **CC-CC** cost centers net to zero
- Review how costs are allocated from **CC-CC** to **CC-PC** through **Total Internal Fees**
- Review how negative results in **CC-PC** are allocated onward to **Profit Centers**
- Use cost center codes only when referring to Cost Centers
- Treat cost centers in the cost center groups **Internal fees common**, **Internal fees local site support**, and **Internal fees IT** as **CC-CC** cost centers

### By Cost Center Group
- Analyze how costs are distributed in the functional cost analysis
- Track the impact of each functional area on total cost
- Use the cost center groups **Internal fees common**, **Internal fees local site support**, and **Internal fees IT** to identify **CC-CC** cost centers

### By Profit Center
- Analyze allocated cost burden by Profit Center
- Always refer to Profit Centers using both code and **Profit Center Name**
- Example: **Q11 Assembly**
- Compare cost absorption across profit-responsible units
- Evaluate the impact of allocated results from **CC-PC** cost centers

## Control Checks

### CC-CC Validation
For **CC-CC** cost centers, validate that:
- **Total Operating Costs** + **Total Internal Fees** offset each other
- the final result is always **0**
- any deviation indicates a possible allocation or posting issue
- the cost center belongs to one of the cost center groups **Internal fees common**, **Internal fees local site support**, or **Internal fees IT**

### CC-PC Validation
For **CC-PC** cost centers, validate that:
- allocated costs from **CC-CC** are included through **Total Internal Fees**
- they usually show a negative result before Profit Center allocation
- their negative result is allocated onward to Profit Centers
- cost responsibility at Profit Center level reflects these allocations

### Headcount Validation
Validate that:
- **Forecasted Headcount** is compared with **Approved Headcount**
- deviations between **Forecasted Headcount** and **Approved Headcount** are identified and reviewed
- this check is applied for both **WC (White collar)** and **BC (Blue collar)**

## Key Review Questions
- Which companies carry the largest cost base?
- Which accounts explain the main cost movements?
- Which cost centers or cost center groups are driving the cost base?
- Do all **CC-CC** cost centers net to zero as expected?
- Are allocated costs fully transferred from **CC-CC** to **CC-PC**?
- Are negative results in **CC-PC** allocated correctly to Profit Centers?
- Which Profit Centers absorb the highest costs?
- How do **Monthly** and **YTD** views differ across the fiscal year?
- Is **CN** only being used for validation and not for performance evaluation?
- Are Profit Centers consistently named using both code and **Profit Center Name**?
- Are **CC-CC** cost centers correctly identified through the cost center groups **Internal fees common**, **Internal fees local site support**, and **Internal fees IT**?
- Does **Forecasted Headcount** deviate from **Approved Headcount** for **WC (White collar)** or **BC (Blue collar)**?

## Notes
Use:
- **Monthly** for single-period analysis
- **YTD** for fiscal year accumulated analysis
- **Value LOC** when local entity cost analysis matters
- **Value EUR** when comparing across companies using the fixed fiscal-year exchange rate
- exclude **CN** from performance studies because it is a legacy company
- include **CN** for validation, reconciliation, and historical transaction checks
- always refer to Profit Centers using both the code and **Profit Center Name**
- refer to Cost Centers using the code only
- treat cost centers in the cost center groups **Internal fees common**, **Internal fees local site support**, and **Internal fees IT** as **CC-CC** cost centers
- validate deviations between **Forecasted Headcount** and **Approved Headcount** for both **WC (White collar)** and **BC (Blue collar)**
