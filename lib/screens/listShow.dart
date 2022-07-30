import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/database/dbhelper.dart';
import 'package:shopping_list/models/ListModel.dart';
import 'package:shopping_list/screens/listAdd.dart';
import 'package:shopping_list/ui_elements/Styles.dart';

import '../ui_elements/components.dart';

class listShow extends StatefulWidget {
  final int listId;
  final String listName;
  listShow({Key? key, required int this.listId, required String this.listName})
      : super(key: key);

  @override
  State<listShow> createState() => _listShowState();
}

class _listShowState extends State<listShow> {
  final dbhelper = Databasehelper.instance;
  List<ShowList> showLi = [], saveList = [];

  final List<popMenu> menus = const <popMenu>[
    const popMenu(title: 'Sort', icon: Icons.sort, onClick: "sort"),
    // const popMenu(title: 'Share', icon: Icons.share, onClick: "share"),
    popMenu(
        title: 'Delete all checked',
        icon: Icons.delete_outline,
        onClick: "delete-check"),
     popMenu(
        title: 'Uncheck All',
        icon: Icons.circle_outlined,
        onClick: "un-check-all"),
    // const popMenu(title: 'import', icon: Icons.import_export),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _updateItems();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () async {
              await _updateItems();
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Text(widget.listName, style: titleText()),
          actions: [listMenu(context)],
          backgroundColor: Colors.blueGrey.shade200,
        ),
        body: showList(),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add New list',
          onPressed: () {
            // _addList(context);
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ListAddPage(ListId: widget.listId)))
                .then((value) => _getList());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  showList() {
    if (showLi.length == 0) {
      _getList();
      return Center(child: Text("Not list added."));
    }
    if (showLi.isNotEmpty) {
      return ListView.builder(
        itemCount: showLi.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                color: showLi[index].Item_Status == 0
                    ? Colors.white
                    : Colors.grey[100],
                border: Border(bottom: BorderSide(color: Colors.black12))),
            child: ListTile(
              onTap: () {
                showLi[index].Item_Status =
                    showLi[index].Item_Status == 0 ? 1 : 0;
                setState(() {});
              },
              leading: Icon(
                showLi[index].Item_Status == 0
                    ? Icons.circle_outlined
                    : Icons.check_circle,
                size: 25,
                color: Colors.blueAccent,
              ),
              title: Text(
                showLi[index].List_Item,
                style: ShowTileText(showLi[index].Item_Status),
              ),
              trailing: showLi[index].Item_Nos > 1
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        showLi[index].Item_Nos.toString(),
                        style: ShowTileText(showLi[index].Item_Status),
                      ),
                    )
                  : SizedBox(),
            ),
          );
        },
      );
    }
  }

  void _getList() async {
    var allrows = await dbhelper.getAllItems(widget.listId);
    if (allrows.isNotEmpty) {
      showLi.clear();
      allrows.forEach((row) => {
            showLi.add(ShowList.fromMap(row)),
            saveList.add(ShowList.fromMap(row))
          });
      setState(() {});
    }
  }

  Future<int> _updateItems() async {
    List<Map<String, dynamic>> li = [];
    try {
      for (var i = 0; i < showLi.length; i++) {
        if (showLi[i].Item_Status != saveList[i].Item_Status) {
          li.add(showLi[i].toMap());
        }
      }
      if (li.isNotEmpty) {
        final id = await dbhelper.updateItems(li);
        return id;
      } else {
        return 1;
      }
    } catch (e) {
      errMessage(e.toString());
      return 0;
    }
  }

  listMenu(BuildContext context) {
    return PopupMenuButton<popMenu>(
      icon: Icon(Icons.more_vert, color: Colors.black,),
        // onSelected: ,
      itemBuilder: (BuildContext context) {
        return menus.map((popMenu menu) {
          return PopupMenuItem<popMenu>(
            value: menu,
            child: GestureDetector(
              onTap: () {
                actionPop(menu.onClick).then((val) {
                  Navigator.pop(context);
                  setState(() {});
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                color: Colors
                    .white, // this color for when user click on any every than on tab funcation is working
                child: Row(
                  children: [
                    Icon(menu.icon, color: Colors.black45, size: 28),
                    SizedBox(width: 10.0),
                    Text(menu.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        )),
                  ],
                ),
              ),
            ),
          );
        }).toList();
      },
    );
  }

  Future<String?> actionPop(String title) async {
    if (title == "sort") {
      showLi.sort((a, b) => a.List_Item.compareTo(b.List_Item));
      return "ok";
    }
    // if (title == "share") {}
    else if (title == "delete-check") {
      
      showLi.removeWhere((element) => false);
      for (var i = 0; i < showLi.length; i++) {
        if (showLi[i].Item_Status == 1) {
          await dbhelper.deleteItemChecked(showLi[i]);
        }
      }
      _getList();
      return "OK";
    } else if (title == "un-check-all") {
      for (var i = 0; i < showLi.length; i++) {
        if (showLi[i].Item_Status != 0) {
          showLi[i].Item_Status = 0;
        }
      }
    }
    return null;
  }
}
