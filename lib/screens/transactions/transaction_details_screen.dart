import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final DemoTransaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

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

  String get _typeLabel {
    switch (transaction.type) {
      case TransactionType.sent:
        return 'Money Sent';
      case TransactionType.received:
        return 'Money Received';
      case TransactionType.topUp:
        return 'Wallet Top-up';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.fee:
        return 'Transfer Fee';
    }
  }

  IconData get _typeIcon {
    switch (transaction.type) {
      case TransactionType.sent:
        return Icons.arrow_upward_rounded;
      case TransactionType.received:
        return Icons.arrow_downward_rounded;
      case TransactionType.topUp:
        return Icons.add_circle_rounded;
      case TransactionType.withdrawal:
        return Icons.arrow_outward_rounded;
      case TransactionType.fee:
        return Icons.payments_rounded;
    }
  }

  Color get _typeColor {
    final sent = transaction.type == TransactionType.sent ||
        transaction.type == TransactionType.fee;
    return sent ? Colors.orange : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isSent = transaction.type == TransactionType.sent;
    final amountLabel = '${isSent ? '-' : '+'}${_currencySymbol(transaction.currency)} ${transaction.amount.toStringAsFixed(2)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _typeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_typeIcon, color: _typeColor, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                _typeLabel,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amountLabel,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${transaction.recipientOrSender} • ${transaction.status}',
                style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    _DetailRow(label: 'Description', value: transaction.description),
                    const SizedBox(height: 14),
                    _DetailRow(label: 'Counterparty', value: transaction.recipientOrSender),
                    const SizedBox(height: 14),
                    _DetailRow(label: 'Currency', value: transaction.currency),
                    const SizedBox(height: 14),
                    _DetailRow(
                      label: 'Date',
                      value: transaction.date.toLocal().toString(),
                    ),
                    const SizedBox(height: 14),
                    _DetailRow(label: 'Status', value: transaction.status),
                    const SizedBox(height: 14),
                    if (transaction.reference != null) ...[
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: transaction.reference!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reference copied to clipboard')),
                          );
                        },
                        child: _DetailRow(
                          label: 'Reference',
                          value: transaction.reference!,
                          isCopyable: true,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: scheme.onSurfaceVariant, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Demo transaction - no real money moved.',
                    style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCopyable;

  const _DetailRow({required this.label, required this.value, this.isCopyable = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        if (isCopyable)
          const Icon(Icons.copy_rounded, size: 16, color: Colors.grey),
      ],
    );
  }
}