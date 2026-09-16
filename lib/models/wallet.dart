import 'package:flutter/material.dart';

class CurrencyBalance {
  final String code;
  final String symbol;
  final double amount;
  final IconData icon;

  const CurrencyBalance({
    required this.code,
    required this.symbol,
    required this.amount,
    required this.icon,
  });

  CurrencyBalance copyWith({double? amount}) {
    return CurrencyBalance(
      code: code,
      symbol: symbol,
      amount: amount ?? this.amount,
      icon: icon,
    );
  }
}

class DemoWallet {
  final String userId;
  final String displayName;
  final String email;
  final String primaryCurrency;
  final List<CurrencyBalance> balances;

  const DemoWallet({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.primaryCurrency,
    required this.balances,
  });

  double get totalBalancePrimary {
    // Simplified: show USD equivalent of all balances
    return balances.fold(0.0, (sum, b) => sum + b.amount);
  }
}
