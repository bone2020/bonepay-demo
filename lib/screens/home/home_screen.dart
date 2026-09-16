import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction.dart';
import '../../services/wallet_service.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/currency_balance_tile.dart';
import '../../widgets/quick_action_button.dart';
import '../../widgets/transaction_tile.dart';
import '../send/send_money_screen.dart';
import '../receive/receive_money_screen.dart';
import '../qr/qr_pay_screen.dart';
import '../transactions/transaction_details_screen.dart';
import '../transactions/transaction_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openSend(BuildContext context, WalletService walletService) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SendMoneyScreen(walletService: walletService),
      ),
    );
  }

  void _openReceive(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ReceiveMoneyScreen()),
    );
  }

  void _openQr(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const QrPayScreen()),
    );
  }

  void _openTransaction(BuildContext context, DemoTransaction txn) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TransactionDetailsScreen(transaction: txn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletService = context.watch<WalletService>();
    final wallet = walletService.wallet;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Color(0xFF1E88E5)),
                  const SizedBox(width: 8),
                  const Text(
                    'BonePay',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'DEMO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Hi, ${wallet.displayName.split(' ').first} 👋',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
              ),
              const SizedBox(height: 20),
              BalanceCard(
                displayName: wallet.displayName,
                totalBalance: wallet.totalBalancePrimary.toStringAsFixed(2),
                primaryCurrency: wallet.primaryCurrency,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  QuickActionButton(
                    icon: Icons.send_rounded,
                    label: 'Send',
                    onTap: () => _openSend(context, walletService),
                  ),
                  const SizedBox(width: 12),
                  QuickActionButton(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'QR Pay',
                    onTap: () => _openQr(context),
                  ),
                  const SizedBox(width: 12),
                  QuickActionButton(
                    icon: Icons.download_rounded,
                    label: 'Receive',
                    onTap: () => _openReceive(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Currency balances',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: scheme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...wallet.balances.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CurrencyBalanceTile(
                    code: b.code,
                    symbol: b.symbol,
                    amount: b.amount,
                    icon: b.icon,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent transactions',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: scheme.onSurface),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                      );
                    },
                    child: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ...walletService.recentTransactions(limit: 5).map((txn) {
                final isSent = txn.type == TransactionType.sent || txn.type == TransactionType.fee || txn.type == TransactionType.withdrawal;
                final amountStr = '${isSent ? '-' : '+'}${txn.currency == 'USD' ? '\$' : txn.currency == 'GHS' ? 'GH₵' : txn.currency == 'NGN' ? '₦' : 'KSh'} ${txn.amount.toStringAsFixed(2)}';
                return TransactionTile(
                  icon: isSent ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  iconColor: isSent ? Colors.orange : Colors.green,
                  title: txn.recipientOrSender,
                  subtitle: txn.description,
                  trailingTitle: amountStr,
                  trailingSubtitle: txn.date.toLocal().toIso8601String().substring(0, 10),
                  onTap: () => _openTransaction(context, txn),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}