import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/core/constants/constants.dart';
import 'package:share_records/src/core/others/common_func.dart';
import 'package:share_records/src/core/sqflite/sqflite_dbhelper.dart';
import 'package:share_records/src/modules/portfolio/portfolio_model.dart';
import 'package:share_records/src/modules/portfolio/tuenover_model.dart';
import 'package:share_records/src/modules/portfolio/portfolio_state.dart';
import 'package:share_records/src/shared/helper/api_repo.dart';

class PortfolioCubit extends Cubit<PortfolioState> {

  List<PortfolioModel> mySharesData = [];
  TurnOverModel? turnOver;
  bool isMarketOpen = false;
  bool wasMarketOpenToday = false;
  double totalLtpAmount = 0.0;
  double totalClosingAmount = 0.0;

  PortfolioCubit() : super(PortfolioLoadingState()) {
    getPortfolio();
  }

  getPortfolio() async {
    await getPortfolioData();
    await refresh();
  }

  refresh() async {
    await getMarketSummary();
    await updateSharesDataWithLtp();
  }

  getPortfolioData() async {
    try {
      emit(PortfolioLoadingState());
      mySharesData = await DBHelper().getMyPortfolio();
    } catch(e) {
      emit(PortfolioErrorState(e.toString()));
      log('Failed to get data getPortfolioData()');
    }
  }

  getMarketSummary() async {
    try {
      totalLtpAmount = 0.0;
      totalClosingAmount = 0.0;
      emit(PortfolioLoadingState());
      var response = await ApiRepo.apiGet(marketSummary, '');
      if(response != null) {
        var jsonDecode = json.decode(response);
        var data = TurnOverModel.fromJson(jsonDecode['turnover']); //jsonDecode['turnover'].map((item) => TurnOverModel.fromJson(item)).toList();
        turnOver = data;
        isMarketOpen = CommonFunction().isMarketOpenNow(turnOver!.date!);
        wasMarketOpenToday = CommonFunction().wasMarketOpenToday(turnOver!.date!);
        for(var item in mySharesData) {
          totalLtpAmount += double.parse(item.ltpValue!);
          totalClosingAmount += double.parse(item.pcpValue!);
        }
      }
    } catch(e) {
      emit(PortfolioErrorState(e.toString()));
      log('Failed to get company data getMarketSummary()');
    }
  }

  updateSharesDataWithLtp() async {
    try {
      if(isMarketOpen == true || wasMarketOpenToday == true) {
        for(var share in mySharesData) {
          Detail? data = turnOver!.detail!.firstWhere((item) => item.s == share.scrip, orElse: () => Detail());
          share.ltp = data.lp == null ? '0' : data.lp!.toStringAsFixed(2);
          share.ltpValue = data.lp == null ? '0' : getTotal(share.balanceAfterTransaction, data.lp);
          share.pcp = data.op == null ? '0' : data.op!.toStringAsFixed(2);
          share.pcpValue = data.op == null ? '0' : getTotal(share.balanceAfterTransaction, data.op);
          // now update ltp
          await DBHelper().updateData('Portfolio', share.toJson());
        }
        // now get latest data
        List<PortfolioModel> latestUpdatedData = await DBHelper().getMyPortfolio();
        emit(PortfolioLoadedState(latestUpdatedData));
      } else {
        emit(PortfolioLoadedState(mySharesData));        
      }
    } catch(e) {
      emit(PortfolioErrorState(e.toString()));
      log('Failed to get data at updateSharesDataWithLtp()');
    }
  }

  getTotal(String? noOfShares, double? amount) {
    double totalAmt = double.parse(noOfShares!) * amount!;
    return totalAmt.toStringAsFixed(2);
  }

}