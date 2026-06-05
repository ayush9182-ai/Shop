export interface LedgerEntry {
  id: string;
  type: 'sale' | 'payment';
  customer_name: string;
  quantity?: number;
  amount?: number;
  description: string;
  created_at: string;
  created_date: string;
}

export interface Customer {
  id: string;
  name: string;
  balance: number;
  last_transaction: string;
  created_at: string;
}

export interface DashboardStats {
  totalKretToday: number;
  totalPaymentsToday: number;
  totalBalance: number;
  recentEntries: LedgerEntry[];
}

export type VoiceCommand =
  | {
      type: 'sale';
      customer_name: string;
      raw_text: string;
      quantity?: number;
    }
  | {
      type: 'payment';
      customer_name: string;
      raw_text: string;
      amount?: number;
    }
  | {
      type: 'query';
      customer_name: string;
      raw_text: string;
    };
