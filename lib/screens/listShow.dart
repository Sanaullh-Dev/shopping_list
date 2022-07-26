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
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Text(widget.listName, style: titleText()),
          actions: [
            listMenu()
            ],
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

  listMenu() {
    return PopupMenuButton(
        // icon: Icon(Icons.more_vert),
        icon: Icon(Icons.more_vert_outlined, color: Colors.black),
        onSelected: (_) {},
        itemBuilder: (_) => <PopupMenuItem<String>>[
              PopupMenuItem(
                // ignore: unnecessary_const
                child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(Icons.delete),
                    title: Align(
                      child: Text("Delete"),
                      alignment: Alignment(-1.5, 0),
                    ),
                    onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          _getList();
                          mesToast("Hello");
                        });
                      
                    }),
                value: "delete",
              ),
              PopupMenuItem<String>(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Icon(Icons.copy),
                  title: Align(
                    child: Text("Copy"),
                    alignment: Alignment(-1.5, 0),
                  ),
                ),
                value: "copy",
              ),
              PopupMenuItem<String>(
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Icon(Icons.edit),
                  title: Align(
                    child: Text("Rename"),
                    alignment: Alignment(-1.8, 0),
                  ),
                ),
                value: "rename",
              ),
            ]);
  }


}
