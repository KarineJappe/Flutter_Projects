import 'dart:io';
import 'package:listaCompras/Models/list_purchase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String purchaseTable= 'purchase';
  String colId = 'id';
  String colName = 'name';
  String colData = 'date';

  DatabaseHelper._create();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._create();
    }

    return _databaseHelper;
  }

  void _createDataBase(Database db, int newVersion) async {
    await db.execute(
        'CREATE table $purchaseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colData TEXT)');
  }

  Future<Database> inicializeDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'PurchaseDatabase.db';

    var purchaseDataBase =
        openDatabase(path, version: 1, onCreate: _createDataBase);

    return purchaseDataBase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await inicializeDataBase();
    }

    return _database;
  }

  Future<int> add(Purchase purchase) async {
    Database db = await this.database;

    var result = await db.insert(purchaseTable, purchase.toMap());

    return result;
  }

  Future<List<Map<String, dynamic>>> getMapList() async {
    Database db = await this.database;

    var result = await db.query(purchaseTable, orderBy: '$colId ASC');

    return result;
  }

  Future<List<Purchase>> getPurchase() async {
    var shoppMap = await getMapList();
    int count = shoppMap.length;
    List<Purchase> shoppList = List<Purchase>();

    for (int i = 0; i < count; i++) {
      shoppList.add(Purchase.fromMapObject(shoppMap[i]));
    }

    return shoppList;
  }

  Future<int> update(Purchase purchase) async {
    Database db = await this.database;

    var result = await db.update(purchaseTable, purchase.toMap(),
        where: '$colId=?', whereArgs: [purchase.id]);

    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;

    var result =
        await db.rawDelete('DELETE FROM $purchaseTable WHERE $colId=$id');

    return result;
  }
}