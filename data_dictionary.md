# Data Dictionary — Mutual Fund Analytics

This dictionary describes the source fields found in the current project files and the proposed star-schema fields. Exact source definitions should be confirmed against the internship-provided CSVs when supplied.

## Existing source CSV fields

| Field | Typical type | Business definition | Source |
|---|---|---|---|
| scheme_code | integer/text | Scheme identifier used by MFAPI | fund_master.csv, live_nav_history.csv, public NAV CSVs |
| fund_name | text | Mutual fund scheme name | fund_master.csv, live_nav_history.csv |
| date | date/text | NAV valuation date | live_nav_history.csv, public NAV CSVs |
| nav | decimal | Net asset value per unit; must be positive | live_nav_history.csv, public NAV CSVs |
| fetched_at | timestamp/text | Time the NAV record was fetched | live_nav_history.csv |
| schemeCode | integer/text | Scheme identifier in public scheme master | public_scheme_master.csv |
| schemeName | text | Scheme name in public scheme master | public_scheme_master.csv |
| isinGrowth | text | ISIN for growth option, when supplied | public_scheme_master.csv |
| isinDivReinvestment | text | ISIN for dividend reinvestment option, when supplied | public_scheme_master.csv |

## Star schema fields

- `dim_fund`: `fund_key` (surrogate primary key), `amfi_code` (scheme code), `fund_name`, `expense_ratio` (percentage points as represented in source).
- `dim_date`: `date_key` (primary key), `full_date`, `year`, `month`, `day`.
- `fact_nav`: `nav_key` (primary key), `fund_key` and `date_key` (foreign keys), `nav`.
- `fact_transactions`: transaction key, fund/date foreign keys, transaction type, positive amount, state and KYC status.
- `fact_performance`: performance key, fund/date foreign keys, 1/3/5-year returns, expense ratio and anomaly flag.
- `fact_aum`: AUM key, fund/date foreign keys and assets-under-management value.

## Data availability note
The uploaded ZIP currently contains NAV and scheme-master files, but does not contain `investor_transactions.csv` or `scheme_performance.csv`, nor all ten internship-provided source datasets. Therefore transaction/performance fields above are based on the task specification, not verified source columns. Do not treat missing source tables as populated until the original datasets are provided.
