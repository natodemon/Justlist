import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shopping_list_vs/models/item.dart';
import 'package:shopping_list_vs/models/shop_list.dart';

class DBHelper {
  static final _dbName = 'ShoppingList.db';
  static final _dbVersion = 3;
  static Database _database;

  final String tableItems = 'Items';
  final String tableLists = 'Lists';
  final String colId = 'id';
  final String colName = 'name';
  final String colTimeout = 'timeout';
  final String colFavourite = 'favourite';
  final String colListId = 'list_id';
  final String colTitle = 'title';
  final String colDateCreated = 'dateCreated';

  static DBHelper _dbHelper;  // DBHelper class singleton
  factory DBHelper() {
    if(_dbHelper == null) {
      _dbHelper = DBHelper._createInstance();
    }
    return _dbHelper;
  }
  DBHelper._createInstance();

  Future<Database> get database async {  // DB variable, ensures only single connection
    if(_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(docsDir.path, _dbName);
    
    return await openDatabase(dbPath, version: _dbVersion, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async{
    await db.execute(
      "CREATE TABLE $tableLists ("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colTitle TEXT NOT NULL,"
        "$colDateCreated INTEGER NOT NULL"
        ")"
      );
    await db.execute(
      "CREATE TABLE $tableItems ("
      "$colId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$colName TEXT NOT NULL,"
      "$colTimeout INTEGER NULL,"
      "$colFavourite INTEGER NOT NULL,"
      "$colListId INTEGER NULL,"
      "FOREIGN KEY ($colListId) REFERENCES $tableLists($colId)"
      ")"
      );
  }

  Future<List<Item>> getItemsForShopList(int listId) async{
    Database db = await this.database;

    var result = await db.query(tableItems,
      where: '$colListId = ?',
      whereArgs: [listId]
    );

    List<Item> selecItems = List<Item>();
    for(int i = 0; i < result.length; i++) {
      selecItems.add(Item.fromMapObj(result[i]));
    }

    return selecItems;
  }

  Future<List<Item>> getFavouriteItems() async {
    Database db = await this.database;

    var result = await db.query(tableItems,
      where: '$colFavourite = 1'
    );

    List<Item> favItems = List<Item>();
    for(int i = 0; i < result.length; i++) {
      favItems.add(Item.fromMapObj(result[i]));
    }

    return favItems;
  }

  Future<Item> getItemById(int id) async{
    Database db = await this.database;

    var result = await db.query(tableItems,
      where: '$colId = $id'
    );

    Item selecItem = Item.fromMapObj(result[0]);
    return selecItem;
  }

  Future<int> insertItem(Item newItem) async{
    Database db = await this.database;

    var result = await db.insert(tableItems, newItem.toMap());
    return result;
  }

  Future<int> deleteItem(int id) async{
    Database db = await this.database;

    var result = await db.delete(tableItems, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> removeFavItem(int id) async{
    return setItemShopList(id, 0);
  }

  Future<int> setItemShopList(int itemId, int shopListId) async{
    Database db = await this.database;

    Item itToUpdate = await getItemById(itemId);
    itToUpdate.listId = shopListId;

    var result = await db.update(tableItems,
      itToUpdate.toMap(), 
      where: '$colId = $itemId'
    );
    return result;
  }

  Future<ShopList> getShopListById(int id) async{
    Database db = await this.database;

    var result = await db.query(tableLists,
      where: '$colId = $id'
    );

    ShopList sList = ShopList.fromMapObj(result[0]);
    return sList;
  }

  Future<int> insertList(ShopList newList) async{
    Database db = await this.database;

    return await db.insert(tableLists, newList.toMap());
  }

  Future<int> deleteList(int id) async {
    Database db = await this.database;

    return await db.delete(tableLists, where: 'id = ? ', whereArgs: [id]);
  }

  // ****************************
  // Temp methods for development
  // ****************************

  Future<ShopList> getFirstList() async{
    Database db = await this.database;

    var result = await db.rawQuery("SELECT * FROM $tableLists ORDER BY $colId ASC LIMIT 1");
    ShopList fList = ShopList.fromMapObj(result[0]);
    return fList;
  }

  Future<bool> checkListIdExists(int id) async{
    Database db = await this.database;

    var result = await db.rawQuery("SELECT EXISTS(SELECT 1 FROM $tableLists WHERE $colId=$id LIMIT 1)");

    int resCount = Sqflite.firstIntValue(result);
    return (resCount == 1);
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
  Database db = await this.database;

  var result = await db.query(tableItems);
  return result;
  }
}