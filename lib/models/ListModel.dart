import 'package:flutter/cupertino.dart';
import 'package:shopping_list/database/dbhelper.dart';

// List Model
class ListData {
  late int id;
  late String listname;
  late String lidate;
  late int totalItems;
  late int complated;
  late String itemsLi;

  ListData(this.id, this.listname, this.lidate, this.totalItems, this.complated, this.itemsLi);
  
  ListData.fromMap(Map<String , dynamic> map) {
    id = map["id"];
    listname = map["listname"];
    lidate = map["lidate"];
    totalItems = map["totalItems"];
    complated = map["complated"];
    itemsLi = map["itemsLi"];
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     Databasehelper.columnID : id,
  //     Databasehelper.columnname : listname,
  //     Databasehelper.columnDate : lidate,
  //     // Databasehelper.columnitems : items
  //   };
  // }
  
}

// List Items Model
class ListItems {
  late int id;
  late String List_Item;
  late int Item_Nos;
  late int Item_Status;
  
    
  ListItems(this.id, this.List_Item, this.Item_Nos, this.Item_Status);

  ListItems.fromMap(Map<String , dynamic> map) {
    id = map["id"];
    List_Item = map["List_Item"];
    Item_Nos = map["Item_Nos"];
    Item_Status = map["Item_Status"];
  }

  Map<String, dynamic> toMap() {
    return {
      Databasehelper.columnID : id,
      Databasehelper.colItem : List_Item,
      Databasehelper.colItemNos : Item_Nos,
      Databasehelper.colItemNos : Item_Status,
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

class ShowList {

  late int id;
  late String List_Item;
  late int Item_Nos;
  late int Item_Status;
  late int Item_type;

  ShowList(this.id, this.List_Item, this.Item_Nos, this.Item_Status, this.Item_type);

  ShowList.fromMap(Map<String , dynamic> map) {
    id = map["id"];
    List_Item = map["List_Item"];
    Item_Nos = map["Item_Nos"];
    Item_Status = map["Item_Status"];
    Item_type = map["Item_type"];
  }

  Map<String, dynamic> toMap() {
    return {
      Databasehelper.columnID : id,
      Databasehelper.colItem : List_Item,
      Databasehelper.colItemNos : Item_Nos,
      Databasehelper.colItemStatus : Item_Status,
      Databasehelper.colItemType : Item_type
    };
  }

  compareTo(ShowList b) {}
  
}


class popMenu {
  final String title;
  final IconData icon; 
  final String onClick;
  const popMenu({required this.title, required this.icon, required this.onClick});
}
