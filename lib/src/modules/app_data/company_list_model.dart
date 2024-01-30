class CompanyListModel {
  String? value;
  String? scrip;
  String? name;

  CompanyListModel({this.value, this.scrip, this.name});

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    value = json['v'];
    scrip = json['d'];
    name = json['l'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['l'] = name;
    data['v'] = value;
    data['d'] = scrip;
    return data;
  }
}
