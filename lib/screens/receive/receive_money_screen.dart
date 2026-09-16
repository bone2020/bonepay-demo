import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/wallet_service.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({super.key});

  @override
  State<ReceiveMoneyScreen> createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    final walletService = context.watch<WalletService>();
    final wallet = walletService.wallet;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Money'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'DEMO - simulated receive flow',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.onErrorContainer,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.qr_code_2, size: 56, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(height: 16),
              Text(
                wallet.displayName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                wallet.email,
                style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  wallet.userId,
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 32),
              Text('Select currency to receive', style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 10),
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: wallet.balances.map((b) {
                    final selected = b.code == _selectedCurrency;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(b.code),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedCurrency = b.code),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your receive address',
                      style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedCurrency,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onPrimaryContainer),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SelectableText(
                            'BP-$_selectedCurrency-${wallet.userId.toUpperCase()}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () => _simulateTopUp(walletService),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Simulate receiving funds'),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Color(0xFF90A4AE)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'This adds a demo top-up so you can try the wallet.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _simulateTopUp(WalletService walletService) {
    final amount = _selectedCurrency == 'NGN'
        ? 50000.0
        : _selectedCurrency == 'KES'
            ? 20000.0
            : _selectedCurrency == 'GHS'
                ? 1000.0
                : 100.0;
    walletService.topUp(amount, _selectedCurrency);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Received $amount $_selectedCurrency (demo)'),
        backgroundColor: Colors.green,
      ),
    );
  }
}