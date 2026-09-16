import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import 'demo_data.dart';

class WalletService extends ChangeNotifier {
  late DemoWallet _wallet;
  late List<DemoTransaction> _transactions;

  WalletService() {
    _wallet = DemoDataService.demoWallet;
    _transactions = List.from(DemoDataService.demoTransactions);
  }

  DemoWallet get wallet => _wallet;
  List<DemoTransaction> get transactions => List.unmodifiable(_transactions);

  List<DemoTransaction> recentTransactions({int limit = 5}) {
    return _transactions.take(limit).toList();
  }

  void sendMoney({
    required String recipient,
    required double amount,
    required String currency,
    required String description,
  }) {
    final fee = DemoDataService.calculateDemoFee(amount, currency);
    final totalDeducted = amount + fee;

    // Deduct from wallet
    final updatedBalances = _wallet.balances.map((b) {
      if (b.code == currency) {
        return b.copyWith(amount: b.amount - totalDeducted);
      }
      return b;
    }).toList();

    _wallet = DemoWallet(
      userId: _wallet.userId,
      displayName: _wallet.displayName,
      email: _wallet.email,
      primaryCurrency: _wallet.primaryCurrency,
      balances: updatedBalances,
    );

    // Create transactions
    final ref = DemoDataService.generateReference();
    final now = DateTime.now();

    _transactions.insert(
      0,
      DemoTransaction(
        id: 'TXN-${_transactions.length + 1}',
        type: TransactionType.sent,
        recipientOrSender: recipient,
        amount: amount,
        currency: currency,
        description: description,
        date: now,
        reference: ref,
      ),
    );

    _transactions.insert(
      0,
      DemoTransaction(
        id: 'TXN-${_transactions.length + 1}',
        type: TransactionType.fee,
        recipientOrSender: 'BonePay',
        amount: fee,
        currency: currency,
        description: 'Transfer fee',
        date: now,
        reference: ref,
      ),
    );

    _saveToFirestore(ref, recipient, amount, currency, description, fee);
    notifyListeners();
  }

  void topUp(double amount, String currency) {
    final updatedBalances = _wallet.balances.map((b) {
      if (b.code == currency) {
        return b.copyWith(amount: b.amount + amount);
      }
      return b;
    }).toList();

    _wallet = DemoWallet(
      userId: _wallet.userId,
      displayName: _wallet.displayName,
      email: _wallet.email,
      primaryCurrency: _wallet.primaryCurrency,
      balances: updatedBalances,
    );

    _transactions.insert(
      0,
      DemoTransaction(
        id: 'TXN-${_transactions.length + 1}',
        type: TransactionType.topUp,
        recipientOrSender: 'BonePay Demo',
        amount: amount,
        currency: currency,
        description: 'Demo wallet top-up',
        date: DateTime.now(),
        reference: DemoDataService.generateReference(),
      ),
    );

    notifyListeners();
  }

  Future<void> _saveToFirestore(
    String reference,
    String recipient,
    double amount,
    String currency,
    String description,
    double fee,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('demo_transactions').add({
        'userId': _wallet.userId,
        'type': 'sent',
        'recipient': recipient,
        'amount': amount,
        'currency': currency,
        'description': description,
        'fee': fee,
        'reference': reference,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Firestore save skipped (demo): $e');
    }
  }
}
