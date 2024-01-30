class HistoryModel {
  int? id;
  String? scrip;
  String? transactionDate;
  String? creditQnty;
  String? debitQnty;
  String? balanceAfterTransaction;
  String? historyDescription;
  String? name;

  HistoryModel(
      {this.id,
      this.scrip,
      this.transactionDate,
      this.creditQnty,
      this.debitQnty,
      this.balanceAfterTransaction,
      this.historyDescription,
      this.name
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scrip = json['scrip'];
    transactionDate = json['transaction_date'];
    creditQnty = json['credit_qnty'];
    debitQnty = json['debit_qnty'];
    balanceAfterTransaction = json['balance_after_transaction'];
    historyDescription = json['history_description'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['scrip'] = scrip;
    data['transaction_date'] = transactionDate;
    data['credit_qnty'] = creditQnty;
    data['debit_qnty'] = debitQnty;
    data['balance_after_transaction'] = balanceAfterTransaction;
    data['history_description'] = historyDescription;
    data['name'] = name;
    return data;
  }
}
