import 'package:shopping_list/database/dbhelper.dart';

// List Model
class ListData {
  late int id;
  late String listname;
  late String lidate;
  late int items;
  late int items_complate;

  ListData(this.id, this.listname, this.lidate, this.items, this.items_complate);

  ListData.fromMap(Map<String , dynamic> map) {
    id = map["id"];
    listname = map["listname"];
    lidate = map["lidate"];
    items = map["items"];
    items_complate = map["items_complate"];
  }

  Map<String, dynamic> toMap() {
    return {
      Databasehelper.columnID : id,
      Databasehelper.columnname : listname,
      Databasehelper.columnDate : lidate,
      Databasehelper.columnitems : items,
      Databasehelper.columncomplete : items_complate,
    };
  }
  
}

// List Items Model
class ListItems {
  late int id;
  late String List_Item;
  late int Item_Nos;

  ListItems(this.id, this.List_Item, this.Item_Nos);

  ListItems.fromMap(Map<String , dynamic> map) {
    id = map["id"];
    List_Item = map["List_Item"];
    Item_Nos = map["Item_Nos"];
  }

  Map<String, dynamic> toMap() {
    return {
      Databasehelper.columnID : id,
      Databasehelper.colItem : List_Item,
      Databasehelper.colItemNos : Item_Nos,
    };
  }
  
}

class MainItemsList {

  late String List_Item;
  late int Item_type;

  MainItemsList(this.List_Item, this.Item_type);

  MainItemsList.fromMap(Map<String , dynamic> map) {
    List_Item = map["List_Item"];
    Item_type = map["Item_type"];
  }

  Map<String, dynamic> toMap() {
    return {
      Databasehelper.colItem : List_Item,
      Databasehelper.colItemType : Item_type
    };
  }
  
}
