# Mutual Fund Data Ingestion and Analytics

## Project Overview
A Python-based project to fetch mutual fund Net Asset Value (NAV) data using MFAPI, store raw data, clean NAV records, and perform data quality checks.

## Features
- Fetch NAV history for six mutual fund schemes.
- Save original API responses as JSON files.
- Combine NAV records into a CSV file.
- Clean data types and remove records with missing essential values.
- Remove duplicate records based on scheme code and date.
- Generate a data quality summary.
- Validate scheme codes between the fund master and NAV history.

## Project Structure
- `data/raw/` — Raw NAV data and fund master files.
- `data/processed/` — Cleaned CSV files.
- `sql/` — SQL schema and query scripts.
- `reports/` — Data quality and processing reports.
- `live_nav_fetch.py` — Fetches NAV data from MFAPI.
- `data_ingestion.py` — Inspects CSV files and generates a data quality report.
- `process_nav_data.py` — Cleans and saves NAV history.
- `validate_scheme_codes.py` — Validates scheme codes.
- `schema.sql` — Database schema.
- `queries.sql` — Ten analytical SQL queries.
- `data_dictionary.md` — Data dictionary.
- `bluestock_mf.db` — SQLite database.

## Setup
Install dependencies:

```bash
pip install -r requirements.txt
```

## Run the Project
```bash
python live_nav_fetch.py
python data_ingestion.py
python process_nav_data.py
python validate_scheme_codes.py
```

## Data Source
Mutual fund NAV data is fetched from the MFAPI service.

## Day 2 Progress
- Added cleaned versions of available CSV datasets.
- Created the SQLite database with `dim_date`, `dim_fund`, `fact_nav`, `fact_transactions`, `fact_performance`, and `fact_aum`.
- Added schema, analytical queries, data dictionary, and processing reports.
- Transaction, performance, and AUM tables remain empty because the required original datasets were not available. These tables must be populated when the original data is supplied.

## Limitation
The complete set of ten internship-provided CSV datasets was not present in the available project files. No missing transaction or performance data has been fabricated.
