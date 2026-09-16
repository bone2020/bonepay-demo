import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/wallet_service.dart';
import '../../widgets/bonepay_logo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletService>().wallet;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, const Color(0xFF0D47A1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white24,
                      child: Text(
                        wallet.displayName.split(' ').map((p) => p[0]).take(2).join(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wallet.email,
                            style: const TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Demo user ID: ${wallet.userId}',
                            style: const TextStyle(fontSize: 12, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'KYC Status',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Simulated KYC - no real identity documents are collected or stored.',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(Icons.verified_user_rounded, color: Colors.green, size: 22),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demo Verified',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)),
                        ),
                        Text(
                          'Level 2 identity check (simulated)',
                          style: TextStyle(fontSize: 12, color: Color(0xFF607D8B)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(icon: Icons.verified, label: 'Email verified'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoChip(icon: Icons.phone_android, label: 'Phone verified'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Demo documents',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
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
                    _DocRow(
                      title: 'Government photo ID',
                      status: 'Mock verified',
                      icon: Icons.badge_rounded,
                    ),
                    const Divider(height: 24),
                    _DocRow(
                      title: 'Proof of address',
                      status: 'Mock verified',
                      icon: Icons.home_work_rounded,
                    ),
                    const Divider(height: 24),
                    _DocRow(
                      title: 'Selfie check',
                      status: 'Mock verified',
                      icon: Icons.face_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.privacy_tip_outlined, size: 18, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'KYC in this demo is fully simulated. No real documents, selfies, '
                        'government IDs, or personal data are collected or transmitted.',
                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: Column(
                  children: [
                    const BonePayLogo(size: 36),
                    const SizedBox(height: 8),
                    Text(
                      'BonePay Demo v1.0.0',
                      style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Portfolio demo - not a production financial service',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;
  const _DocRow({required this.title, required this.status, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Verified',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)),
          ),
        ),
      ],
    );
  }
}