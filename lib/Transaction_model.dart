class Transaction {
  final int id;
  final String price;
  final String type;
  final String status;

  Transaction({required this.id, required this.price, required this.type, required this.status});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      price: json['price'],
      type: json['type'],
      status: json['status'],
    );
  }
}

class TransactionResponse {
  final bool status;
  final String message;
  final List<Transaction> transactions;

  TransactionResponse({required this.status, required this.message, required this.transactions});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['transactions'] as List;
    List<Transaction> transactionsList = list.map((i) => Transaction.fromJson(i)).toList();

    return TransactionResponse(
      status: json['status'],
      message: json['message'],
      transactions: transactionsList,
    );
  }
}
