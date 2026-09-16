import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction.dart';
import '../../services/wallet_service.dart';
import '../../widgets/transaction_tile.dart';
import 'transaction_details_screen.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  String _currencySymbol(String code) {
    switch (code) {
      case 'USD':
        return '\$';
      case 'GHS':
        return 'GH₵';
      case 'NGN':
        return '₦';
      case 'KES':
        return 'KSh';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletService = context.watch<WalletService>();
    final transactions = walletService.transactions;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'DEMO DATA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scheme.onErrorContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'All transactions below are simulated.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF607D8B)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: transactions.length,
                separatorBuilder: (_, _) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final txn = transactions[index];
                  final isSent = txn.type == TransactionType.sent ||
                      txn.type == TransactionType.fee ||
                      txn.type == TransactionType.withdrawal;
                  return TransactionTile(
                    icon: isSent ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                    iconColor: isSent ? Colors.orange : Colors.green,
                    title: txn.recipientOrSender,
                    subtitle: '${txn.description} • ${txn.date.toLocal().toIso8601String().substring(0, 10)}',
                    trailingTitle:
                        '${isSent ? '-' : '+'}${_currencySymbol(txn.currency)} ${txn.amount.toStringAsFixed(2)}',
                    trailingSubtitle: txn.status,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TransactionDetailsScreen(transaction: txn),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}