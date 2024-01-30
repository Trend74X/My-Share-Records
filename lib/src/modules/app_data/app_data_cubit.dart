import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/core/constants/constants.dart';
import 'package:share_records/src/core/others/data_mapping.dart';
import 'package:share_records/src/core/sqflite/sqflite_dbhelper.dart';
import 'package:share_records/src/modules/app_data/app_data_state.dart';
import 'package:share_records/src/modules/app_data/company_list_model.dart';
import 'package:share_records/src/shared/helper/api_repo.dart';

class AppDataCubit extends Cubit<AppDataState> {

  AppDataCubit() : super(AppDataLoadingState());

  getCompanyLists() async {
    try {
      var response = await ApiRepo.apiGet(companyListUrl, '');
      if(response != null) {
        List<dynamic> jsonDecode = json.decode(response);
        final data = jsonDecode.map((item) => CompanyListModel.fromJson(item)).toList();
        emit(AppDataLoadedState());
        await insertCompanyListInDb(data);
      }
    } catch(e) {
      emit(AppDataErrorState(e.toString()));
      log('Failed to get company data getCompanyLists()');
    }
  }

  insertCompanyListInDb(data) async {
    // await DBHelper().deleteAll('CompanyList');
    try{
      List jsonData = DataMapping().getCompanyListHeader(data);
      for(var data in jsonData) {
        await DBHelper().insertCompanyList(data);
      }
      log('Company List inserted into db successfully');
    } catch(e) {
      emit(AppDataErrorState(e.toString()));
      log('Failed to get company data');
    }
  }

  Future<String> getCompanyName(String scrip) async {
    try {
      String result = await DBHelper().getCompanyName(scrip);
      RegExp regExp = RegExp(r'\(([^)]+)\)');
      Match? match = regExp.firstMatch(result);
      if (match != null) {
        return match.group(1) ?? "";
      } else {
        return ""; // Return an empty string if no match is found
      }
    } catch(e) {
      emit(AppDataErrorState(e.toString()));
      log('Failed to get company data');
    }
    return '';
  }

}