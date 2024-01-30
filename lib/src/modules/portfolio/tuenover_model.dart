class TurnOverModel {
  String? date;
  List<Detail>? detail;

  TurnOverModel({this.date, this.detail});

  TurnOverModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  String? s;
  String? n;
  double? lp;
  double? t;
  double? pc;
  double? h;
  double? l;
  double? op;
  double? q;

  Detail(
      {this.s,
      this.n,
      this.lp,
      this.t,
      this.pc,
      this.h,
      this.l,
      this.op,
      this.q});

  Detail.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    n = json['n'];
    lp = json['lp'];
    t = json['t'];
    pc = json['pc'];
    h = json['h'];
    l = json['l'];
    op = json['op'];
    q = json['q'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['s'] = s;
    data['n'] = n;
    data['lp'] = lp;
    data['t'] = t;
    data['pc'] = pc;
    data['h'] = h;
    data['l'] = l;
    data['op'] = op;
    data['q'] = q;
    return data;
  }
}
