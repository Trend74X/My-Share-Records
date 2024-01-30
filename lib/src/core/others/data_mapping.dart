class DataMapping {

  csvToHeaderJson(data) {
    List csvDataWithHeaderInJson = [];
    for(var item in data) {
      var map ={
        "scrip"                     : item[1],
        "transaction_date"          : item[2],
        "credit_qnty"               : item[3],
        "debit_qnty"                : item[4],
        "balance_after_transaction" : item[5],
        "history_description"       : item[6]
      };
      csvDataWithHeaderInJson.add(map);
    }
    return csvDataWithHeaderInJson;
  }

  getCompanyListHeader(data) {
    List jsonData = [];
    for(var item in data) {
      var map = {
        "scrip"         : item.scrip,
        "name"          : item.name,
        "value"         : item.value
      };
      jsonData.add(map);
    }
    return jsonData;
  }

  portfolioHeaderMapper(data) {
    var item = {
      "scrip"                       : data["scrip"],
      "name"                        : data["name"] ,
      "balance_after_transaction"   : data['balance_after_transaction'] ,
      "pcp"                         : data["pcp"] ?? "" ,
      "pcp_value"                   : data["pcp_value"] ?? "" ,
      "ltp"                         : data["ltp"] ?? "" ,
      "ltp_value"                   : data["ltp_value"] ?? "" 
    };
    return item;
  }

}