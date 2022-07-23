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
        mainLi.add(ShowList(widget.ListId, val["List_Item"], 0, 0));
      });
    }
  }

  addSaveToMain() {
    for (var i = 0; i < mainLi.length; i++) {
      for (var s = 0; s < saveLi.length; s++) {
        if (mainLi[i].List_Item == saveLi[s].List_Item) {
          mainLi[i].Item_Nos = saveLi[s].Item_Nos;
        } else if (mainLi[i].Item_Nos > 0) {
          saveLi.add(mainLi[i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _insertItems();
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
              var _temp = mainLi;
              mainLi.clear();

              mainLi.add(ShowList(widget.ListId, addItemController.text, 0, 0));

              _temp.forEach((val) {
                if (val.List_Item.toLowerCase()
                    .contains(addItemController.text)) {
                  mainLi.add(val);
                }
              });
              setState(() {});
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
        itemCount: mainLi.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                color: mainLi[index].Item_Nos != 0
                    ? Colors.blue.shade50
                    : Colors.white,
                border: Border(bottom: BorderSide(color: Colors.black12))),
            child: ListTile(
                onTap: () {
                  // addItems(mainLi[index]);
                  setState(() {
                    mainLi[index].Item_Nos = mainLi[index].Item_Nos + 1;
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
                  mainLi[index].Item_Nos > 0 ? Icons.done : Icons.add,
                  size: 25,
                  color: mainLi[index].Item_Nos != 0
                      ? Colors.blue
                      : Colors.blueAccent,
                ),
                title: Text(
                  mainLi[index].List_Item,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: mainLi[index].Item_Nos != 0
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
                trailing: mainLi[index].Item_Nos == 0
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          saveLi[index].Item_Nos = saveLi[index].Item_Nos - 1;
                          setState(() {
                            addSaveToMain();
                          });
                        },
                        child: mainLi[index].Item_Nos > 1
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    mainLi[index].Item_Nos.toString(),
                                    style: trailingText(),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
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
          Databasehelper.colItemStatus: val.Item_Status
        });
      });

      await dbhelper.insertItems(li);
      await dbhelper.newInsetMainList(saveLi);

      return 1;
    } catch (e) {
      errMessage(e.toString());
      return 0;
    }
  }
}
