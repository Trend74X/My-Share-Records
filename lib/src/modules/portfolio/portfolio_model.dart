class PortfolioModel {
  int? id;
  String? scrip;
  String? name;
  String? balanceAfterTransaction;
  String? pcp;
  String? pcpValue;
  String? ltp;
  String? ltpValue;

  PortfolioModel(
      {this.id,
      this.scrip,
      this.name,
      this.balanceAfterTransaction,
      this.pcp,
      this.pcpValue,
      this.ltp,
      this.ltpValue,
  });

  PortfolioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scrip = json['scrip'];
    name = json['name'];
    balanceAfterTransaction = json['balance_after_transaction'];
    pcp = json['pcp'];
    pcpValue = json['pcp_value'];
    ltp = json['ltp'];
    ltpValue = json['ltp_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['scrip'] = scrip;
    data['name'] = name;
    data['balance_after_transaction'] = balanceAfterTransaction;
    data['pcp'] = pcp;
    data['pcp_value'] = pcpValue;
    data['ltp'] = ltp;
    data['ltp_value'] = ltpValue;
    return data;
  }
}
