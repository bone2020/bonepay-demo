enum TransactionType { sent, received, topUp, withdrawal, fee }

class DemoTransaction {
  final String id;
  final TransactionType type;
  final String recipientOrSender;
  final double amount;
  final String currency;
  final String description;
  final DateTime date;
  final String status;
  final String? reference;

  const DemoTransaction({
    required this.id,
    required this.type,
    required this.recipientOrSender,
    required this.amount,
    required this.currency,
    required this.description,
    required this.date,
    this.status = 'completed',
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'recipientOrSender': recipientOrSender,
      'amount': amount,
      'currency': currency,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'reference': reference,
    };
  }

  factory DemoTransaction.fromMap(Map<String, dynamic> map) {
    return DemoTransaction(
      id: map['id'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.sent,
      ),
      recipientOrSender: map['recipientOrSender'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'USD',
      description: map['description'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'completed',
      reference: map['reference'],
    );
  }
}
