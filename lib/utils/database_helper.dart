import 'package:expense_manager/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String expenseTable = 'expense_table';
  String colId = 'id';
  String colName = 'name';
  String colAmount = 'amount';
  String colDate = 'date';
  String colIsExpense = 'isExpense';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'expenses.db';
    print(path);

    var expensesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return expensesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $expenseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colAmount TEXT, $colDate TEXT, $colIsExpense INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getExpenseMapList() async {
    Database db = await this.database;

    var result = await db.query(expenseTable, orderBy: '$colDate ASC');
    return result;
  }

  Future<int> insertExpense(Expense expense) async {
    Database db = await this.database;
    var result = await db.insert(expenseTable, expense.toMap());
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'expenses.db';
    print(path);
    print(expense.toMap());
    return result;
  }

  Future<int> updateExpense(Expense expense) async {
    var db = await this.database;
    var result = await db.update(expenseTable, expense.toMap(),
        where: '$colId = ?', whereArgs: [expense.id]);
    return result;
  }

  Future<int> deleteExpense(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $expenseTable WHERE $colId = $id');
    return result;
  }

  Future<List<Expense>> getExpenseList() async {
    var expenseMapList = await getExpenseMapList();
    int count = expenseMapList.length;

    List<Expense> expenseList = List<Expense>();
    for (int i = 0; i < count; i++) {
      expenseList.add(Expense.fromMapObject(expenseMapList[i]));
    }

    return expenseList;
  }
}
