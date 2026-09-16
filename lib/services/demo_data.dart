import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';

class DemoDataService {
  static final DemoWallet demoWallet = DemoWallet(
    userId: 'demo_user_001',
    displayName: 'Kofi Asante',
    email: 'kofi.asante@bonepay.demo',
    primaryCurrency: 'USD',
    balances: const [
      CurrencyBalance(code: 'USD', symbol: '\$', amount: 2485.50, icon: Icons.attach_money),
      CurrencyBalance(code: 'GHS', symbol: 'GH₵', amount: 12750.00, icon: Icons.currency_exchange),
      CurrencyBalance(code: 'NGN', symbol: '₦', amount: 385000.00, icon: Icons.currency_exchange),
      CurrencyBalance(code: 'KES', symbol: 'KSh', amount: 318500.00, icon: Icons.currency_exchange),
    ],
  );

  static final List<DemoTransaction> demoTransactions = [
    DemoTransaction(
      id: 'TXN-001',
      type: TransactionType.received,
      recipientOrSender: 'Ama Mensah',
      amount: 250.00,
      currency: 'USD',
      description: 'Freelance payment',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      reference: 'REF-20260916-001',
    ),
    DemoTransaction(
      id: 'TXN-002',
      type: TransactionType.sent,
      recipientOrSender: 'Kwame Boateng',
      amount: 150.00,
      currency: 'USD',
      description: 'Dinner split',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      reference: 'REF-20260916-002',
    ),
    DemoTransaction(
      id: 'TXN-003',
      type: TransactionType.topUp,
      recipientOrSender: 'BonePay Demo',
      amount: 500.00,
      currency: 'USD',
      description: 'Demo wallet top-up',
      date: DateTime.now().subtract(const Duration(days: 1)),
      reference: 'REF-20260915-001',
    ),
    DemoTransaction(
      id: 'TXN-004',
      type: TransactionType.received,
      recipientOrSender: 'Nana Aba',
      amount: 3500.00,
      currency: 'GHS',
      description: 'Birthday gift',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      reference: 'REF-20260915-002',
    ),
    DemoTransaction(
      id: 'TXN-005',
      type: TransactionType.sent,
      recipientOrSender: 'Emeka Okoro',
      amount: 45000.00,
      currency: 'NGN',
      description: 'Vendor payment',
      date: DateTime.now().subtract(const Duration(days: 2)),
      reference: 'REF-20260914-001',
    ),
    DemoTransaction(
      id: 'TXN-006',
      type: TransactionType.fee,
      recipientOrSender: 'BonePay',
      amount: 2.50,
      currency: 'USD',
      description: 'Transfer fee',
      date: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      reference: 'REF-20260914-002',
    ),
    DemoTransaction(
      id: 'TXN-007',
      type: TransactionType.sent,
      recipientOrSender: 'Wanjiku Kamau',
      amount: 12000.00,
      currency: 'KES',
      description: 'Invoice #1042',
      date: DateTime.now().subtract(const Duration(days: 3)),
      reference: 'REF-20260913-001',
    ),
    DemoTransaction(
      id: 'TXN-008',
      type: TransactionType.received,
      recipientOrSender: 'Adaeze Chukwu',
      amount: 85000.00,
      currency: 'NGN',
      description: 'Contract payment',
      date: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
      reference: 'REF-20260913-002',
    ),
    DemoTransaction(
      id: 'TXN-009',
      type: TransactionType.withdrawal,
      recipientOrSender: 'Bank Account',
      amount: 200.00,
      currency: 'USD',
      description: 'Withdrawal to bank',
      date: DateTime.now().subtract(const Duration(days: 4)),
      reference: 'REF-20260912-001',
    ),
    DemoTransaction(
      id: 'TXN-010',
      type: TransactionType.received,
      recipientOrSender: 'Yaa Asantewaa',
      amount: 1800.00,
      currency: 'GHS',
      description: 'Shared expenses refund',
      date: DateTime.now().subtract(const Duration(days: 5)),
      reference: 'REF-20260911-001',
    ),
  ];

  static double calculateDemoFee(double amount, String currency) {
    // Simple flat + percentage fee for demo
    const double flatFeePercent = 0.5; // 0.5%
    const double minimumFee = 1.0;
    double fee = amount * (flatFeePercent / 100);
    return fee < minimumFee ? minimumFee : double.parse(fee.toStringAsFixed(2));
  }

  static String generateReference() {
    final now = DateTime.now();
    return 'REF-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecond}';
  }
}
