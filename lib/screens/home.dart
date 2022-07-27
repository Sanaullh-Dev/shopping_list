import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shopping_list/database/dbhelper.dart';
import 'package:shopping_list/models/ListModel.dart';
import 'package:shopping_list/screens/listAdd.dart';
import 'package:shopping_list/screens/listShow.dart';
import 'package:shopping_list/ui_elements/NavDrawer.dart';
import 'package:shopping_list/ui_elements/Styles.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/ui_elements/components.dart';
// import 'package:shopping_list/'

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListData> liData = [];
  bool emptyCheck = false;
  final liNameController = TextEditingController();

  final dbhelper = Databasehelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu, color: Colors.black),
        title: Text(widget.title, style: titleText()),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      drawer: NaveDrawer(),
      body: Container(child: getLoad()),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {
          _addList(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  getLoad() {
    if (liData.isEmpty && emptyCheck == false) {
      _getList();
      return Center(
        child: Text("Data not available"),
      );
    } else if (liData.isNotEmpty) {
      var ledText = "";
      return ListView.builder(
        itemCount: liData.length,
        itemBuilder: (BuildContext context, int index) {
          ledText = "${liData[index].complated}/${liData[index].totalItems}";
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => listShow(
                                listId: liData[index].id,
                                listName: liData[index].listname)))
                    .then((value) => _getList());
              },
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: CircularPercentIndicator(
                  backgroundColor: Colors.black12,
                  radius: 28.0,
                  lineWidth: 3.0,
                  percent: liData[index].complated > 0 ? 1* liData[index].complated / liData[index].totalItems : 0,
                  center: Text(ledText,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold)),
                  progressColor: Colors.blue[400],
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(liData[index].listname,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: titleText()),
                        Text(
                          liData[index].lidate
                           , style: subTitleText())
                  ],
                ),
              ),
              subtitle: Text(
                liData[index].itemsLi,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:  subTitleText(),
              ),
              trailing: listMenu(liData[index]),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text("Data not available"),
      );
    }
  }

  void _addList(context) {
    liNameController.text = "";
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 20.0),
                child: Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text("Create new List",
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0, 0),
                          child: Text("Title", style: TextFiledLabel()),
                        ),
                        // ignore: prefer_const_constructors
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextField(
                            controller: liNameController,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "New List -" +
                                  DateFormat('MMM-dd kk:mm')
                                      .format(DateTime.now()),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextButton(
                                    style: flatButtonStyle,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cencel",
                                      style: BtnTextCancel(),
                                    ))),
                            Expanded(
                                child: TextButton(
                                    style: flatButtonStyle,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      insertData(liNameController.text);
                                    },
                                    child: Text(
                                      "Create",
                                      style: BtnTextPrimery(),
                                    ))),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  void _getList() async {
    var allrows = await dbhelper.querAll();
    if (allrows.isNotEmpty) {
      liData.clear();
      allrows.forEach((_li) {
        liData.add(new ListData(
            _li["id"], _li["listname"], _li["lidate"], 0, 0, "-"));
      });
      // ------  this logic for get nos of total item added and total completed items
      for (var i = 0; i < liData.length; i++) {
        var _li = liData[i];
        var itemsTotal = await dbhelper.getAllItems(_li.id);
        var itemsComplete =
            await dbhelper.getItemsWithStatus(_li.id, "completed");
        var itemsIncomplete =
            await dbhelper.getItemsWithStatus(_li.id, "incomplete");
        liData[i].complated = itemsComplete.length;
        liData[i].totalItems = itemsTotal.length;
        // this for get items list incomplete
        itemsIncomplete.asMap().forEach((index, val) {
          if (index == 0)
            liData[i].itemsLi = val["List_Item"] + ", ";
          else if (itemsIncomplete.length == index)
            liData[i].itemsLi = liData[i].itemsLi + val["List_Item"];
          else
            liData[i].itemsLi = liData[i].itemsLi + val["List_Item"] + ", ";
        });
        var sbstring = liData[i].itemsLi;
        if (itemsIncomplete.length > 0)
          liData[i].itemsLi = sbstring.substring(0, sbstring.length - 2);
      }
      emptyCheck = false;
    } else {
      emptyCheck = true;
    }
    setState(() {});
  }

  void insertData(String LiName) async {
    if (LiName == "") {
      LiName = "New List -" + DateFormat('MMM-dd kk:mm').format(DateTime.now());
    }
    Map<String, dynamic> row = {
      Databasehelper.columnname: LiName,
      Databasehelper.columnDate:
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    final id = await dbhelper.insert(row);
    if (id != null) {
      _getList();
      // Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ListAddPage(ListId: id)));
    }
  }

  listMenu(ListData _li) {
    return PopupMenuButton(
        // icon: Icon(Icons.more_vert),
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
                      var i = await dbhelper.delete(_li.id);
                      if (i != 0) {
                        Navigator.pop(context);
                        setState(() {
                          _getList();
                          mesToast(_li.listname);
                        });
                      }
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
