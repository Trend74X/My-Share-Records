import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_records/src/modules/history/history_model.dart';
import 'package:share_records/src/modules/portfolio/portfolio_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  static const dbName = 'ShareRecord.db';
  static Database? _database;

  Future<Database?> get db async {
    if(_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  Future<Database?> initDatabase() async {
    Directory directory =  await getApplicationDocumentsDirectory();
    var db = await openDatabase('${directory.path}/$dbName', version: 1, onCreate: onCreate);
    return db;
  }

  Future onCreate(Database db, int version) async {
    // create a table for company list
    await db.execute('''Create Table CompanyList(
      id integer primary key autoincrement,
      scrip TEXT NOT NULL,
      name TEXT NOT NULL,
      value TEXT NOT NULL
    )''');
    //create a table for history
    await db.execute('''Create Table History(
      id integer primary key autoincrement,
      scrip TEXT NOT NULL,
      name TEXT NOT NULL,
      transaction_date TEXT NOT NULL,
      credit_qnty TEXT NOT NULL,
      debit_qnty TEXT NOT NULL,
      balance_after_transaction TEXT NOT NULL,
      history_description TEXT NOT NULL
    )''');
    // create a table for my shares list
    await db.execute('''Create Table MyShares(
      id integer primary key autoincrement,
      scrip TEXT NOT NULL,
      name TEXT,
      transaction_date TEXT NOT NULL,
      credit_qnty TEXT NOT NULL,
      debit_qnty TEXT NOT NULL,
      balance_after_transaction TEXT NOT NULL,
      history_description TEXT NOT NULL
    )''');
    // create a table for portfolio
    await db.execute('''Create Table Portfolio(
      id integer primary key autoincrement,
      scrip TEXT NOT NULL,
      name TEXT,
      balance_after_transaction TEXT NOT NULL,
      pcp TEXT,
      pcp_value TEXT,
      ltp TEXT,
      ltp_value TEXT
    )''');
  }

  // History
  insertIntoHistory(data) async {
    Database? dbClient = await db;
    bool dataExists = await doesDataExists('History', data); 
    if (!dataExists) {
      int? result = await dbClient?.insert('History', data);
      if(result == -1) {
        log('Failed to insert into history!!!');
      }
    }
  }

  getAllHistory() async {
    Database? dbClient = await db;
    final List<Map<String, Object?>>? queryResult = await dbClient?.query('History',  orderBy: 'transaction_date DESC');
    return queryResult!.map((e) => HistoryModel.fromJson(e)).toList();
  }


  // My Shares
  getMySharesForInsertion() async {
    Database? dbClient = await db;
    try {
      final List<Map<String, Object?>>? queryResult = await dbClient?.query('History', groupBy: 'scrip', orderBy: 'scrip ASC');
      return queryResult;
    } catch (e) {
      log(e.toString());
    }
  }
  
  insertIntoMyShare(data) async {
    Database? dbClient = await db;
    bool dataExists = await doesDataExists('MyShares', data); 
    if (!dataExists) {
      int? result = await dbClient?.insert('MyShares', data);
      if(result == -1) {
        log('Failed to insert into My Shares!!!');
      }
    }
  }

  getMyShares() async {
    Database? dbClient = await db;
    try {
      final List<Map<String, Object?>>? queryResult = await dbClient?.query('MyShares', where: 'balance_after_transaction > 0.0',  orderBy: 'scrip');
      return queryResult!.map((e) => HistoryModel.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
    }
  }


  // Company names
  insertCompanyList(data) async {
    Database? dbClient = await db;
    bool dataExists = await doesDataExists('CompanyList', data); 
    if (!dataExists) {
      int? result = await dbClient?.insert('CompanyList', data);
      if(result == -1) {
        log('Failed to insert into history!!!');
      }
    }
  }

  getCompanyName(String scrip) async {
    Database? dbClient = await db;
    if(await doesTableExists('CompanyList') == true) {
      final List<Map<String, Object?>>? queryResult = await dbClient?.query('CompanyList',  where: 'scrip = ?' , whereArgs: [scrip]);
      if (queryResult != null && queryResult.isNotEmpty) {
        // Assuming CompanyListModel.fromJson returns a single CompanyListModel object
        return queryResult[0]['name'];
      }
    } else {
      return '';
    }
  }


  // Portfolio
  insertIntoPortfolio(data) async {
    Database? dbClient = await db;
    bool dataExists = await doesDataExists('Portfolio', data); 
    if (!dataExists) {
      int? result = await dbClient?.insert('Portfolio', data);
      if(result == -1) {
        log('Failed to insert into Portfolio!!!');
      }
    }
  }

  getMyPortfolio() async {
    Database? dbClient = await db;
    try {
      final List<Map<String, Object?>>? queryResult = await dbClient?.query('Portfolio', where: 'balance_after_transaction > 0.0' , orderBy: 'scrip');
      List data =  queryResult!.map((e) => PortfolioModel.fromJson(e)).toList();
      return data;
    } catch (e) {
      log(e.toString());
    }
  }


  // Misc
  Future<bool> doesTableExists(String tableName) async {
    Database? dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return res.isNotEmpty;
  }

  Future<bool> doesDataExists(String tableName, Map<String, dynamic> data) async {
    try {
      Database? dbClient = await db;
      if(tableName == 'History' || tableName == 'MyShares') {
        List<Map<String, dynamic>> result = await dbClient!.query(
          tableName,
          where: 'scrip = ? AND transaction_date = ? AND balance_after_transaction = ?' , // checking keys to check if exists
          whereArgs: [data['scrip'], data['transaction_date'], data['balance_after_transaction']], // checking values to check if exists
        );
        return result.isNotEmpty;
      } else if(tableName == 'CompanyList') {
        List<Map<String, dynamic>> result = await dbClient!.query(
          tableName,
          where: 'scrip = ? AND value = ?' , // checking keys to check if exists
          whereArgs: [data['scrip'], data['value']], // checking values to check if exists
        );
        return result.isNotEmpty;
      } else if(tableName == 'Portfolio') {
        List<Map<String, dynamic>> result = await dbClient!.query(
          tableName,
          where: 'scrip = ? AND name = ?' , // checking keys to check if exists
          whereArgs: [data['scrip'], data['name']], // checking values to check if exists
        );
        return result.isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return true;
  }

  updateData(tableName, data) async {
    Database? dbClient = await db;
    var result = await dbClient!.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [data['id']]
    );
    return result;
  }

  Future<int> deleteAll(String tableName) async {
    Database? dbClient = await db;
    var result = await dbClient!.delete(tableName);
    return result;
  }

}