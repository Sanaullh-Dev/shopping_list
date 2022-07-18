import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_list/models/ListModel.dart';
import 'package:shopping_list/ui_elements/components.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasehelper {
  static final _databasename = "shopppingli.db";
  static final _databaseversion = 1;

  static final table = 'list_tb';
  static final columnID = 'id';
  static final columnname = 'listname';
  static final columnDate = 'lidate';
  static final columnitems = 'items';
  static final columncomplete = 'items_complate';

  static final tableItems = 'item_tb';
  static final colItem = 'List_Item';
  static final colItemNos = 'Item_Nos';

  static final tableItemsMain = 'item_main';
  static final colItemType = 'Item_type';

  static Database? _database;

  Databasehelper._privateConstructor();
  static final instance = Databasehelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _InitDatabase();
    return _database;
  }

  _InitDatabase() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, _databasename);

    return await openDatabase(path,
        version: _databaseversion, onCreate: _onCreate);
  }

  
  Future _onCreate(Database db, int version) async {
    try {
      Batch batch = db.batch();

      batch.execute("DROP TABLE IF EXISTS $table;");
      batch.execute("DROP TABLE IF EXISTS $tableItems;");
      batch.execute("DROP TABLE IF EXISTS $tableItemsMain;");

      batch.execute("CREATE TABLE $table ("
          "$columnID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnname TEXT NOT NULL,"
          "$columnDate DATETIME NOT NULL,"
          "$columnitems INTEGER NOT NULL,"
          "$columncomplete INTEGER NOT NULL"
          ")");

      // await db.execute("DROP TABLE IF EXISTS $tableItems ;");
      batch.execute("CREATE TABLE $tableItems ("
          "$columnID INTEGER NOT NULL,"
          "$colItem TEXT NOT NULL,"
          "$colItemNos INTEGER NOT NULL,"
          "FOREIGN KEY($columnID) REFERENCES articles($columnID)"
          ")");

      batch.execute("CREATE TABLE $tableItemsMain ("
          "$colItem TEXT NOT NULL,"
          "$colItemType INTEGER NOT NULL"
          ")");

      List<dynamic> result = await batch.commit();
      await insertMainList();
    } catch (e) {}
  }

  // Function to insert, query, update, delete

  // Get All Main List
  Future<List<Map<String, dynamic>>> getMainItems() async {
    Database? db = await instance.database;
    // db.query(table, orderBy: "column_1 ASC, column_2 DESC");
    return await db!.rawQuery('SELECT * FROM $tableItemsMain;');
    // .rawQuery('SELECT * FROM $tableItemsMain ORDER BY $colItemType ASC;');
  }

  // Function for insert List
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // Funcation for delete
   Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.rawDelete("DELETE from $table WHERE $columnID = ?", [id]);
    
  }

  // Future<List<Map<String, dynamic>>> querAll() async {
  Future<List<Map<String, dynamic>>> querAll() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }


  //----------------- Lists Items Function ------------
  Future<int> insertItems(List<Map<String, dynamic>> rows) async {
    try {
    
    Database? db = await instance.database;
    Batch batch = db!.batch();
    rows.forEach((row) {
      batch.insert(tableItems, row);  
    });
    
    List<dynamic> result = await batch.commit();
    return result.isEmpty ? 0 : 1;

    } catch (e) {
      errMessage(e.toString());
      return 0;
    }
  }
  

  Future<List<Map<String, dynamic>>> getAllItems(int id) async {
    Database? db = await instance.database;
    return await db!
        .rawQuery('SELECT * FROM $tableItems WHERE $columnID=?', [id]);
  }

  insertMainList() async {     
    var items = ["Milk","Bread","Eggs", "Butter", "Cheese", "Toilet Paper",
      "Chicken", "Patatoes","Coffee","Toothpaste","Rice"];

     items.forEach((val) async {
      Map<String, dynamic> row = {
      Databasehelper.colItem: val,
      Databasehelper.colItemType: 0
    };

      Database? db = await instance.database;
      await db!.insert(tableItemsMain, row);
    });
    // print(id);   
  }

  Future<List<Map<String, dynamic>>> getMainList() async {
    Database? db = await instance.database;
    return await db!
        .rawQuery('SELECT * FROM $tableItemsMain;');
  }

}
