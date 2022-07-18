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

  // List<ListItems> listItems = [];
  List<MainItemsList> mainLi = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          decoration:
              InputDecoration(hintText: "Add Item", border: InputBorder.none),
        ),
      ),
      body: Listview(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _insertItems().then((value) => {
            Navigator.pop(context)
          });
        },
        child: Icon(Icons.done_rounded),
      ),
    );
  }

  Listview() {
    if (mainLi.length == 0) {
      _getList();
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
                color: mainLi[index].Item_type != 0
                    ? Colors.blue.shade50
                    : Colors.white,
                border: Border(bottom: BorderSide(color: Colors.black12))),
            child: ListTile(
                onTap: () {
                  // _insertItems(li[index].List_Item);
                  // _updateList(index);
                  mainLi[index].Item_type = mainLi[index].Item_type + 1;
                  setState(() {});

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
                  mainLi[index].Item_type > 0 ? Icons.done : Icons.add,
                  size: 25,
                  color: mainLi[index].Item_type != 0
                      ? Colors.blue
                      : Colors.blueAccent,
                ),
                title: Text(
                  mainLi[index].List_Item,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: mainLi[index].Item_type != 0
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
                trailing: mainLi[index].Item_type == 0
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          mainLi[index].Item_type = mainLi[index].Item_type - 1;
                          setState(() {});
                        },
                        child: mainLi[index].Item_type > 1
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    mainLi[index].Item_type.toString(),
                                    style: trailingText(),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
                                      mainLi[index].Item_type =
                                          mainLi[index].Item_type - 1;
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

  Widget getTrailing(int index) {
    if (mainLi[index].Item_type == 0) {
      return SizedBox();
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            mainLi[index].Item_type = 0;
          });
        },
        // child:
        // Wrap(
        //       spacing: 12,
        //         children: [
        //           Text("$mainLi[index].Item_type"),
        //           SizedBox(width: 10.0),
        //           Icon(
        //             Icons.remove_circle_outline,
        //             color: Colors.red.shade400,
        //           )
        //         ],
        //       )
      );
    }
  }

  Future<int> _insertItems() async {
    List<Map<String, dynamic>> li = [];
    try {
      mainLi.forEach((val) async {
        if (val.Item_type > 0) {
          li.add({
            Databasehelper.columnID: widget.ListId,
            Databasehelper.colItem: val.List_Item,
            Databasehelper.colItemNos: val.Item_type
          });
          // _result = await dbhelper.insertItems(row);
        }
      });
        final id = await dbhelper.insertItems(li);
        return id;
     
    } catch (e) {
      errMessage(e.toString());
      return 0;
    }
  }

  void _updateList(int index) {
    // setState(() {
    // });
  }

  void _getList() async {
    var allrows = await dbhelper.getMainList();
    if (allrows.isNotEmpty) {
      mainLi.clear();
      allrows.forEach((row) => mainLi.add(MainItemsList.fromMap(row)));
      setState(() {});
    }
  }
}
