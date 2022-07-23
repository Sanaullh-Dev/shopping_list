import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_list/database/dbhelper.dart';
import 'package:shopping_list/models/ListModel.dart';
import 'package:shopping_list/ui_elements/Styles.dart';
import 'package:shopping_list/ui_elements/components.dart';

class ListAddPage extends StatefulWidget {
  final int ListId;

  ListAddPage({Key? key, required this.ListId}) : super(key: key);

  @override
  State<ListAddPage> createState() => _ListAddPageState();
}

class _ListAddPageState extends State<ListAddPage> {
  final dbhelper = Databasehelper.instance;
  List<ShowList> saveLi = []; // this for saving in database
  List<ShowList> mainLi = []; // this for showing on screen
  List<ShowList> editLi = []; // this for showing on screen
  final addItemController = TextEditingController();

  @override
  void initState() {
    _getList();
    super.initState();
  }

  void _getList() async {
    // ------- adding all saved list items
    var savedList = await dbhelper.getAllItems(widget.ListId);
    if (savedList.isNotEmpty) {
      saveLi.clear();
      savedList.forEach((val) {
        saveLi.add(ShowList.fromMap(val));
      });
    }
    await getMainList();

    setState(() {
      addSaveToMain();
    });
  }

  getMainList() async {
    // ------- adding all Main list items
    var mainList = await dbhelper.getMainItems();
    if (mainList.isNotEmpty) {
      mainList.forEach((val) {
        mainLi.add(
            ShowList(widget.ListId, val["List_Item"], 0, 0, val["Item_type"]));
      });
    }

    editLi = List.from(mainLi);
  }

  addSaveToMain() {
    var match = false;

    for (var i = 0; i < mainLi.length; i++) {
      for (var s = 0; s < saveLi.length; s++) {
        if (mainLi[i].List_Item == saveLi[s].List_Item) {
          mainLi[i].Item_Nos = saveLi[s].Item_Nos;
          match = true;
          break;
        }
      }
      if (match == false) {
        saveLi.add(mainLi[i]);
      }
    }
    editLi = List.from(mainLi);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _insertItems();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: TextField(
            autofocus: true,
            controller: addItemController,
            onChanged: (context) {
              if (addItemController.text != "") {
                editLi.clear();
                editLi.add(
                    ShowList(widget.ListId, addItemController.text, 0, 0, 1));

                mainLi.forEach((val) {
                  if (val.List_Item.toLowerCase()
                      .contains(addItemController.text)) {
                    editLi.add(val);
                  }
                });
                setState(() {});
              }
            },
            decoration:
                InputDecoration(hintText: "Add Item", border: InputBorder.none),
          ),
        ),
        body: Listview(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _insertItems().then((value) => {Navigator.pop(context)});
          },
          child: Icon(Icons.done_rounded),
        ),
      ),
    );
  }

  Listview() {
    if (mainLi.length == 0) {
      return Center(child: Text("Loading..."));
    }
    if (mainLi.isNotEmpty) {
      return ListView.builder(
        itemCount: editLi.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                color: editLi[index].Item_Nos != 0
                    ? Colors.blue.shade50
                    : Colors.white,
                border: Border(bottom: BorderSide(color: Colors.black12))),
            child: ListTile(
                onTap: () {
                  // addItems(mainLi[index]);
                  setState(() {
                    bool match = false;
                    for (var i = 0; i < mainLi.length; i++) {
                      if (mainLi[i].List_Item == editLi[index].List_Item) {
                        mainLi[i].Item_Nos = mainLi[i].Item_Nos + 1;
                        match = true;
                        break;
                      }
                    }
                    if (match == false) {
                      editLi[index].Item_Nos = editLi[index].Item_Nos + 1;
                      mainLi.add(editLi[index]);
                    }
                    editLi = List.from(mainLi);
                    setState(() {
                      addSaveToMain();
                    });
                  });
                  Fluttertoast.showToast(
                      msg: "List Added",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey.shade600,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                leading: Icon(
                  editLi[index].Item_Nos > 0 ? Icons.done : Icons.add,
                  size: 25,
                  color: editLi[index].Item_Nos != 0
                      ? Colors.blue
                      : Colors.blueAccent,
                ),
                title: Text(
                  editLi[index].List_Item,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: editLi[index].Item_Nos != 0
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
                trailing: editLi[index].Item_Nos == 0
                    ? editLi[index].Item_type != 0 &&
                            editLi[index].Item_Nos != 0
                        ? GestureDetector(
                            onTap: () {
                              dbhelper
                                  .deleteMainItem(editLi[index].List_Item)
                                  .then((value) => setState(() async {
                                        mainLi.clear();
                                        await getMainList();
                                        addSaveToMain();
                                      }));
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade400,
                            ),
                          )
                        : SizedBox()
                    : GestureDetector(
                        onTap: () {
                          mainLi[index].Item_Nos = mainLi[index].Item_Nos - 1;
                          setState(() {});
                        },
                        child: editLi[index].Item_Nos > 1
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    editLi[index].Item_Nos.toString(),
                                    style: trailingText(),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
                                      editLi[index].Item_Nos =
                                          editLi[index].Item_Nos - 1;
                                      mainLi[index].Item_Nos =
                                          mainLi[index].Item_Nos - 1;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red.shade400,
                                    ),
                                  )
                                ],
                              )
                            : Icon(
                                Icons.close_outlined,
                                color: Colors.red.shade400,
                              ),
                      )),
          );
        },
      );
    }
  }

  Future<int?> _insertItems() async {
    List<Map<String, dynamic>> li = [];
    try {
      mainLi.forEach((val) async {
        li.add({
          Databasehelper.columnID: widget.ListId,
          Databasehelper.colItem: val.List_Item,
          Databasehelper.colItemNos: val.Item_Nos,
          Databasehelper.colItemStatus: val.Item_Status,
          Databasehelper.colItemType: val.Item_type
        });
      });

      await dbhelper.insertItems(li);
      await dbhelper.newInsetMainList(li);

      return 1;
    } catch (e) {
      errMessage(e.toString());
      return 0;
    }
  }
}
