import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPayScreen extends StatefulWidget {
  const QrPayScreen({super.key});

  @override
  State<QrPayScreen> createState() => _QrPayScreenState();
}

class _QrPayScreenState extends State<QrPayScreen> {
  final _amountCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  String _currency = 'USD';
  String? _generatedPayload;

  static const _demoSecret = 'BONEPAY-DEMO-2026';

  @override
  void dispose() {
    _amountCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  String _buildPayload() {
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    final memo = _memoCtrl.text.trim();
    return 'bonepay://pay?merchant=demo_user_001&currency=$_currency'
        '&amount=$amount&memo=${Uri.encodeComponent(memo)}&key=$_demoSecret';
  }

  void _generate() {
    setState(() {
      _generatedPayload = _buildPayload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Pay'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: scheme.onErrorContainer),
                    const SizedBox(width: 6),
                    Text(
                      'DEMO payment request - not a real invoice',
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
                    child: DropdownButton<String>(
                      value: _currency,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'GHS', child: Text('GHS')),
                        DropdownMenuItem(value: 'NGN', child: Text('NGN')),
                        DropdownMenuItem(value: 'KES', child: Text('KES')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _currency = v);
                      },
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
              Text('Memo (optional)', style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              TextField(
                controller: _memoCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. Coffee at DemoTown cafe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _generate,
                  child: const Text('Generate payment QR',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),
              if (_generatedPayload != null) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: _generatedPayload!,
                        version: QrVersions.auto,
                        size: 220,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Pay \$${_amountCtrl.text.trim().isEmpty ? '0.00' : _amountCtrl.text.trim()} $_currency',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      if (_memoCtrl.text.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _memoCtrl.text.trim(),
                            style: const TextStyle(fontSize: 13, color: Color(0xFF607D8B)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner_rounded, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      'Scan to pay (simulated)',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}