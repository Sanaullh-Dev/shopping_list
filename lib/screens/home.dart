import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopping_list/database/dbhelper.dart';
import 'package:shopping_list/models/ListModel.dart';
import 'package:shopping_list/screens/listAdd.dart';
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
  // List<ListData> liData = getList1();
  List<ListData> liData = [];
  // PopupMenuButton listBtn = listMenu();
  final liNameController = TextEditingController();

  final dbhelper = Databasehelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu, color: Colors.black),
        title: Text(widget.title, style: titleText()),
        backgroundColor: Colors.blue.shade50,
      ),
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
    if (liData.isEmpty) {
      _getList();
      return Center(
        child: Text("Data not available"),
      );
    } else {
      return ListView.builder(
        itemCount: liData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              onTap: () {},
              leading: const CircleAvatar(
                radius: 25,
                child: Text("3/5",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                backgroundColor: Color(0xFFD5E1F4),
              ),
              title: Text(liData[index].listname, style: titleText()),
              // title: Text("Hello", style: titleText()),
              // subtitle: Text(li[index].subList),
              subtitle: Text("Sub total"),
              trailing: listMenu(liData[index]),
            ),
          );
        },
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
                // height: MediaQuery.of(context).size.height * 0.3,
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
                                child: FlatButton(
                                    height: 20.0,
                                    padding: EdgeInsets.all(25.0),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cencel",
                                      style: BtnTextCancel(),
                                    ))),
                            Expanded(
                                child: FlatButton(
                                    height: 20.0,
                                    padding: EdgeInsets.all(25.0),
                                    onPressed: () {
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
      allrows.forEach((row) => liData.add(ListData.fromMap(row)));
      setState(() {});
    }
  }

  void insertData(String LiName) async {
    if (LiName == "") {
      LiName = "New List -" + DateFormat('MMM-dd kk:mm').format(DateTime.now());
    }
    Map<String, dynamic> row = {
      Databasehelper.columnname: LiName,
      Databasehelper.columnDate:
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
      Databasehelper.columnitems: 0,
      Databasehelper.columncomplete: 0
    };

    final id = await dbhelper.insert(row);
    if (id != null) {
      _getList();
      // Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ListAddPage(ListId: id)));
    }
  }

  List<ListData> getList1() {
    List<ListData> liData = [];
    liData.add(ListData(1, "List No 1", "01/04/2022", 0, 0));
    liData.add(ListData(1, "List No 2", "10/04/2022", 0, 0));
    liData.add(ListData(1, "List No 3", "15/04/2022", 0, 0));
    liData.add(ListData(1, "List No 4", "20/04/2022", 0, 0));

    return liData;
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
                    onTap: () {
                        dbhelper.delete(_li.id);
                        Navigator.pop(context);
                        _getList();
                        mesToast(_li.listname);
                    }),
                value: "delete",
              ),
              PopupMenuItem<String>(
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
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
