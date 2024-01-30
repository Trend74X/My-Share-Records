import 'dart:io';
import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/core/others/common_func.dart';
import 'package:share_records/src/core/others/data_mapping.dart';
import 'package:share_records/src/core/sqflite/sqflite_dbhelper.dart';
import 'package:share_records/src/modules/history/history_model.dart';
import 'package:share_records/src/modules/history/history_state.dart';
import 'package:share_records/src/modules/app_data/app_data_cubit.dart';
import 'package:share_records/src/modules/my_shares/my_share_cubit.dart';

class HistoryCubit extends Cubit<HistoryState> {

  List<List<dynamic>> breakIntoSeven = [];

  HistoryCubit() : super(HistoryLoadingState()) {
    // initial create function if any
    getHistoryData();
  }

  importAndReadCsv() async{
    await getFiles();
    await insertToHistoryDB(breakIntoSeven);
    await getHistoryData();
    await insertIntoMyShareDb();
  }

  Future<void> deleteDatas() async {
    await DBHelper().deleteAll('History');
    await DBHelper().deleteAll('MyShares');
    await DBHelper().deleteAll('Portfolio');
  }

  getHistoryData() async {
    try {
      List<HistoryModel> historyData = await DBHelper().getAllHistory();
      emit(HistoryLoadedState(historyData));
    } catch(e) {
      emit(HistoryErrorState(e.toString()));
      log('Failed to get history');
    }
  }

  getFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv']
      );
      if (result != null) {
        emit(HistoryLoadingState());
        await deleteDatas();
        // await DBHelper().deleteAll('CompanyList');
        String path = result.files.single.path!;
        if (await File(path).exists()) {
          final csvFile = File(path);
          String csvString = csvFile.readAsStringSync();
          String modifiedCsvString = CommonFunction().addCommaAtEndOfRow(csvString);
          List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
            fieldDelimiter: ',', // Specify the delimiter used in your CSV file
            textEndDelimiter: '"',
          ).convert(modifiedCsvString);
          breakIntoSeven = CommonFunction().breakIntoSeven(rowsAsListOfValues);
        }
      }
    } catch(e) {
      emit(HistoryErrorState(e.toString()));
      log(e.toString());
    }
  }

  insertToHistoryDB(allData) async {
    final AppDataCubit appCubit = AppDataCubit();
    try {
      await appCubit.getCompanyLists();
      List jsonData = DataMapping().csvToHeaderJson(allData);
      for(var data in jsonData) {
        data['name'] = await appCubit.getCompanyName(data['scrip']);
        await DBHelper().insertIntoHistory(data);
      }
    } catch(e) {
      emit(HistoryErrorState(e.toString()));
      log('Error at insertToHistoryDB()');
    }
  }

  insertIntoMyShareDb() async {
    try {
      final MySharesCubit shareCubit = MySharesCubit();
      List data = await shareCubit.getMySharesFromHistoryForInsert();
      //insert into My Share
      for(var item in data) {
        final Map<String, dynamic> json = {};
        for (var columnName in item.keys) {
          json[columnName] = item[columnName];
        }
        await DBHelper().insertIntoMyShare(json);
        await insertIntoPortfolioDb(json);
      }
    } catch(e) {
      emit(HistoryErrorState(e.toString()));
      log('Something went wrong at insertIntoMyShareDb()');
    }
  }

  insertIntoPortfolioDb(json) async {
    try {
      var portfolioData = DataMapping().portfolioHeaderMapper(json);
      await DBHelper().insertIntoPortfolio(portfolioData);
    } catch(e) {
      emit(HistoryErrorState(e.toString()));
      log('Something went wrong at insertIntoMyShareDb()');
    }
  }

}