/*
  # Create Banana Shop Ledger Schema

  1. New Tables
    - `ledger_entries`
      - `id` (uuid, primary key)
      - `type` (text: 'sale' or 'payment')
      - `customer_name` (text)
      - `quantity` (numeric, for sales)
      - `amount` (numeric, for payments in rupees)
      - `description` (text)
      - `created_at` (timestamp)
      - `created_date` (date, for grouping by day)
    - `customers`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `balance` (numeric, running balance)
      - `last_transaction` (timestamp)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on both tables (public data for ledger app)
    - Create policies for unrestricted access (shop owner uses alone)

  3. Indexes
    - Index on `created_at` for fast queries
    - Index on `created_date` for daily summaries
    - Index on `customer_name` for customer lookups
*/

CREATE TABLE IF NOT EXISTS customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  balance numeric DEFAULT 0,
  last_transaction timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ledger_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text NOT NULL CHECK (type IN ('sale', 'payment')),
  customer_name text NOT NULL REFERENCES customers(name) ON DELETE RESTRICT,
  quantity numeric,
  amount numeric,
  description text,
  created_at timestamptz DEFAULT now(),
  created_date date DEFAULT CURRENT_DATE
);

CREATE INDEX IF NOT EXISTS idx_ledger_entries_created_at ON ledger_entries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ledger_entries_created_date ON ledger_entries(created_date DESC);
CREATE INDEX IF NOT EXISTS idx_ledger_entries_customer ON ledger_entries(customer_name);
CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(name);

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE ledger_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public access to customers"
  ON customers
  FOR ALL
  TO public
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Public access to ledger entries"
  ON ledger_entries
  FOR ALL
  TO public
  USING (true)
  WITH CHECK (true);
