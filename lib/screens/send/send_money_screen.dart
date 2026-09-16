import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../services/demo_data.dart';
import '../../services/wallet_service.dart';

class SendMoneyScreen extends StatefulWidget {
  final WalletService walletService;
  const SendMoneyScreen({super.key, required this.walletService});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _recipientCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedCurrency = 'USD';
  bool _confirming = false;
  bool _loading = false;

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    final recipient = _recipientCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (recipient.isEmpty) {
      _showError('Please enter a recipient');
      return;
    }
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }
    final wallet = widget.walletService.wallet;
    final bal = wallet.balances.firstWhere((b) => b.code == _selectedCurrency);
    final fee = DemoDataService.calculateDemoFee(amount, _selectedCurrency);
    if (amount + fee > bal.amount) {
      _showError('Insufficient demo balance (you have ${bal.amount.toStringAsFixed(2)} $_selectedCurrency)');
      return;
    }
    setState(() => _confirming = true);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _executeTransfer() async {
    final amount = double.tryParse(_amountCtrl.text.trim())!;
    final fee = DemoDataService.calculateDemoFee(amount, _selectedCurrency);

    setState(() => _loading = true);

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('calculateDemoFee')
          .call({'amount': amount, 'currency': _selectedCurrency});
      final serverFee = (result.data['fee'] as num).toDouble();
      // Use server-computed fee if it came back
      if (serverFee > 0) {
        _doLocalTransfer(amount, serverFee);
        return;
      }
    } catch (e) {
      // Cloud Function not deployed or failed; use local fee
    }
    _doLocalTransfer(amount, fee);
  }

  void _doLocalTransfer(double amount, double fee) {
    widget.walletService.sendMoney(
      recipient: _recipientCtrl.text.trim(),
      amount: amount,
      currency: _selectedCurrency,
      description: _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : 'Demo transfer',
    );
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo transfer completed!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  Widget _buildForm() {
    final wallet = widget.walletService.wallet;
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.errorContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 16, color: scheme.onErrorContainer),
                const SizedBox(width: 6),
                Text(
                  'DEMO MODE - no real money moves',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Recipient name', style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          TextField(
            controller: _recipientCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. Ama Mensah',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          Text('Amount', style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    items: wallet.balances
                        .map((b) => DropdownMenuItem(value: b.code, child: Text(b.code)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedCurrency = v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Description (optional)', style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          TextField(
            controller: _descCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. Lunch split',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _validate,
              style: FilledButton.styleFrom(backgroundColor: scheme.primary),
              child: const Text('Review transfer', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    final fee = DemoDataService.calculateDemoFee(amount, _selectedCurrency);
    final total = amount + fee;
    final wallet = widget.walletService.wallet;
    final bal = wallet.balances.firstWhere((b) => b.code == _selectedCurrency);
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.receipt_long_rounded, color: scheme.primary, size: 64),
          const SizedBox(height: 16),
          const Text('Confirm Demo Transfer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _ConfirmRow(label: 'To', value: _recipientCtrl.text.trim()),
          _ConfirmRow(label: 'Currency', value: _selectedCurrency),
          _ConfirmRow(label: 'Amount', value: '$amount $_selectedCurrency'),
          _ConfirmRow(label: 'Fee', value: '$fee $_selectedCurrency'),
          const Divider(height: 28),
          _ConfirmRow(label: 'Total', value: '$total $_selectedCurrency', bold: true),
          const SizedBox(height: 10),
          _ConfirmRow(
            label: 'Your balance',
            value: '${bal.amount.toStringAsFixed(2)} $_selectedCurrency',
          ),
          _ConfirmRow(
            label: 'After transfer',
            value: '${(bal.amount - total).toStringAsFixed(2)} $_selectedCurrency',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'This is a demo transfer. No real money will move.',
                  style: TextStyle(fontSize: 13, color: Color(0xFFEF6C00)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _loading ? null : () => setState(() => _confirming = false),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _loading ? null : _executeTransfer,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Confirm & send'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: _confirming ? _buildConfirmation() : _buildForm(),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _ConfirmRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}