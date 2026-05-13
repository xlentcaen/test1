# Monthly P&L Analysis

## Explanations

### Scope
This is a **full P&L** analysis.

### Company
The companies in the group are:
- **SE** = Sweden
- **SK** = Slovakia
- **CN-NT** = China Nantong
- **CN** = China Shanghai (**legacy**)

**CN** is a legacy company. Financial transactions may still occur on this company and it can be used for **validation** and reconciliation purposes, but it should **not** be used in **performance[...]**

### Cost Center Group
**Cost Center Group** is a grouping of Cost Centers. It maps where the cost appears in the **functional P&L**.

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

When referring to a **Profit Center**, always use the code together with the value from **Profit Center Name**.

Example:
- **Q11** should be written as **Q11 Assembly**

For **Cost Centers**, use the cost center code only, since there is no separate **Cost Center Name** column.

## Cost Center Logic

Cost Centers are categorized as either:
- **CC-CC**
- **CC-PC**

### CC-CC Cost Centers
**CC-CC** cost centers are allocation cost centers. They are allocated to other cost centers.

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

## Account P&L Calculations

- **TOTAL LOCAL COSTS** = **Total Operating Costs** + **TOTAL INTERNAL FEES**
- **Total Costs** = **TOTAL LOCAL COSTS** + **Service fee**
- **Profit** = **Margin** - **Total Costs**

## Functional P&L Calculations

- **TOTAL COST** =
  **Category Area**
  + **Market costs**
  + **Supply Chain**
  + **Tools**
  + **Component Development & Range**
  + **Global Mgmt & Support**
  + **Process & Digital Development**
  + **Warehouse**

- **OPERATING RESULT** = **TOTAL GP** + **TOTAL COST**

## Values
- **Value LOC** = Value in local currency of the company
- **Value EUR** = Value in EUR using the fixed standard exchange rate set for the full fiscal year

## Allocation Flow

### Step 1: CC-CC Cost Centers
- **CC-CC** cost centers collect operating costs
- These costs are offset through **Total Internal Fees**
- Result in **CC-CC** should always be **0**

### Step 2: CC-PC Cost Centers
- **CC-PC** cost centers receive allocations from **CC-CC** through **Total Internal Fees**
- They typically show a **negative result**

### Step 3: Profit Centers
- The negative result from **CC-PC** cost centers is allocated to **Profit Centers**
- This ensures profitability is reflected at **PC** level

## Monthly P&L Summary

| Month | Company | Account | CC | PC | Value LOC | Value EUR | Accumulation |
|-------|---------|---------|----|----|-----------|-----------|--------------|
|       |         |         |    |    |           |           |              |

## Analysis Areas

### By Company
- Compare performance across **SE**, **SK**, and **CN-NT**
- Exclude **CN** from performance studies because it is a legacy company
- Use **CN** only for validation, reconciliation, and historical transaction review
- Identify differences in revenue, cost base, and profitability
- Highlight currency and structural effects

### By Account
- Analyze General Ledger movements
- Review revenue, margin, operating cost, internal fees, and service fee impacts
- Identify unusual or non-recurring postings

### By Cost Center
- Analyze cost ownership by Cost Center
- Distinguish between **CC-CC** and **CC-PC**
- Confirm that **CC-CC** cost centers net to zero
- Review how costs are allocated from **CC-CC** to **CC-PC** through **Total Internal Fees**
- Review how negative results in **CC-PC** are allocated onward to **Profit Centers**
- Use cost center codes only when referring to Cost Centers

### By Cost Center Group
- Analyze how costs are distributed in the functional P&L
- Track the impact of each functional area on total cost and operating result

### By Profit Center
- Analyze profitability by Profit Center
- Always refer to Profit Centers using both code and **Profit Center Name**
- Example: **Q11 Assembly**
- Compare commercial/business performance across profit-responsible units
- Evaluate the impact of allocated results from **CC-PC** cost centers

## Control Checks

### CC-CC Validation
For **CC-CC** cost centers, validate that:
- **Total Operating Costs** + **Total Internal Fees** offset each other
- the final result is always **0**
- any deviation indicates a possible allocation or posting issue

### CC-PC Validation
For **CC-PC** cost centers, validate that:
- allocated costs from **CC-CC** are included through **Total Internal Fees**
- they usually show a negative result before Profit Center allocation
- their negative result is allocated onward to Profit Centers
- profitability at Profit Center level reflects these allocations

### Profit Center Validation
Validate that:
- Profit Centers receive the allocated negative result from **CC-PC**
- the final Profit Center profitability reflects both direct and allocated costs
- Profit Centers are referred to using both code and **Profit Center Name**

## Key Review Questions
- Which companies contribute most to revenue and profit?
- Which accounts explain the main movements in margin and cost?
- Which cost centers or cost center groups are driving the cost base?
- Do all **CC-CC** cost centers net to zero as expected?
- Are allocated costs fully transferred from **CC-CC** to **CC-PC**?
- Are negative results in **CC-PC** allocated correctly to Profit Centers?
- Which Profit Centers generate the strongest results?
- How do **Monthly** and **YTD** views differ across the fiscal year?
- Is **CN** only being used for validation and not for performance evaluation?
- Are Profit Centers consistently named using both code and **Profit Center Name**?

## Notes
Use:
- **Monthly** for single-period analysis
- **YTD** for fiscal year accumulated analysis
- **Value LOC** when local entity performance matters
- **Value EUR** when comparing across companies using the fixed fiscal-year exchange rate
- exclude **CN** from performance studies because it is a legacy company
- include **CN** for validation, reconciliation, and historical transaction checks
- always refer to Profit Centers using both the code and **Profit Center Name**
- refer to Cost Centers using the code only
