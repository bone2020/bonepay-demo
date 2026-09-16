import 'package:flutter/material.dart';

class BonePayLogo extends StatelessWidget {
  final double size;
  const BonePayLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).colorScheme.primary, const Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(Icons.account_balance_wallet, color: Colors.white, size: size * 0.6),
    );
  }
}