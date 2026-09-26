import 'dart:convert';

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

class WalletModel {
  final int id;
  final String balance;
  final List<WalletTransactionModel> transactions;

  WalletModel({
    required this.id,
    required this.balance,
    required this.transactions,
  });

  double get balanceDouble => double.tryParse(balance) ?? 0.0;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        id: json['id'] ?? 0,
        balance: json['balance']?.toString() ?? '0.00',
        transactions: (json['transactions'] as List<dynamic>?)
                ?.map((e) => WalletTransactionModel.fromJson(e))
                .toList() ??
            [],
      );
}

class WalletTransactionModel {
  final int id;
  final String type;
  final String typeLabel;
  final String amount;
  final String description;
  final String previousBalance;
  final String newBalance;
  final String createdAt;
  final int? appointmentId;

  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.amount,
    required this.description,
    required this.previousBalance,
    required this.newBalance,
    required this.createdAt,
    this.appointmentId,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      WalletTransactionModel(
        id: json['id'] ?? 0,
        type: json['type'] ?? '',
        typeLabel: json['type_label'] ?? '',
        amount: json['amount']?.toString() ?? '0',
        description: json['description'] ?? '',
        previousBalance: json['previous_balance']?.toString() ?? '0',
        newBalance: json['new_balance']?.toString() ?? '0',
        createdAt: json['created_at'] ?? '',
        appointmentId: json['appointment'],
      );

  bool get isDeposit => type == 'deposit';
  bool get isDebt => type == 'debt';
  bool get isWithdrawal => type == 'withdrawal';
}
