PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS dim_fund (
  fund_key INTEGER PRIMARY KEY,
  amfi_code TEXT UNIQUE NOT NULL,
  fund_name TEXT NOT NULL,
  expense_ratio REAL
);

CREATE TABLE IF NOT EXISTS dim_date (
  date_key INTEGER PRIMARY KEY,
  full_date TEXT UNIQUE NOT NULL,
  year INTEGER NOT NULL,
  month INTEGER NOT NULL,
  day INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS fact_nav (
  nav_key INTEGER PRIMARY KEY,
  fund_key INTEGER NOT NULL,
  date_key INTEGER NOT NULL,
  nav REAL NOT NULL CHECK (nav > 0),
  FOREIGN KEY (fund_key) REFERENCES dim_fund(fund_key),
  FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

CREATE TABLE IF NOT EXISTS fact_transactions (
  transaction_key INTEGER PRIMARY KEY,
  fund_key INTEGER,
  date_key INTEGER,
  transaction_type TEXT CHECK (transaction_type IN ('SIP','Lumpsum','Redemption')),
  amount REAL CHECK (amount > 0),
  state TEXT,
  kyc_status TEXT,
  FOREIGN KEY (fund_key) REFERENCES dim_fund(fund_key),
  FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

CREATE TABLE IF NOT EXISTS fact_performance (
  performance_key INTEGER PRIMARY KEY,
  fund_key INTEGER NOT NULL,
  date_key INTEGER,
  return_1y REAL,
  return_3y REAL,
  return_5y REAL,
  expense_ratio REAL,
  anomaly_flag INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (fund_key) REFERENCES dim_fund(fund_key),
  FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

CREATE TABLE IF NOT EXISTS fact_aum (
  aum_key INTEGER PRIMARY KEY,
  fund_key INTEGER NOT NULL,
  date_key INTEGER,
  aum REAL CHECK (aum >= 0),
  FOREIGN KEY (fund_key) REFERENCES dim_fund(fund_key),
  FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);
