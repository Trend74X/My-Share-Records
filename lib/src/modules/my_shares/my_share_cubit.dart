import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/core/sqflite/sqflite_dbhelper.dart';
import 'package:share_records/src/modules/history/history_model.dart';
import 'package:share_records/src/modules/my_shares/my_share_state.dart';

class MySharesCubit extends Cubit<MyShareState> {

  MySharesCubit() : super(MyShareLoadingState()) {
    // initial create function if any
    getMyShares();
  }

  getMyShares() async {
    try {
      List<HistoryModel> mySharesData = await DBHelper().getMyShares();
      emit(MyShareLoadedState(mySharesData));
    } catch(e) {
      emit(MyShareErrorState(e.toString()));
      log('Failed to get data at getMyShares()');
    }
  }

  getMySharesFromHistoryForInsert() async {
    try {
      List mySharesData = await DBHelper().getMySharesForInsertion();
      return mySharesData;
    } catch(e) {
      log('Failed to get my share data');
    }
  }

}