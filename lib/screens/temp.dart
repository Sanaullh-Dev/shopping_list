// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shopping_list/database/dbhelper.dart';
// import 'package:shopping_list/models/ListModel.dart';

// class ListAddPage extends StatefulWidget {
//   final int ListId;

//   ListAddPage({Key? key, required this.ListId}) : super(key: key);

//   @override
//   State<ListAddPage> createState() => _ListAddPageState();
// }

// class _ListAddPageState extends State<ListAddPage> {
//   final dbhelper = Databasehelper.instance;

//   // List<ListItems> listItems = [];
//   List<MainItemsList> mainLi = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: TextField(
//           autofocus: true,
//           decoration:
//               InputDecoration(hintText: "Add Item", border: InputBorder.none),
//         ),
//       ),
//       body: FutureBuilder(
//           future: _getList(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               if (snapshot.hasError) {
//                 return Center(child: Text("${snapshot.error} occurred"));
//               } else if (snapshot.hasData) {
//                 final data = snapshot.data;
//                 return Listview(data);
//               } else {
//                 return Center(
//                   child: Text("List is empty"),
//                 );
//               }
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           }),
//     );
//   }

//   Widget Listview(List<MainItemsList> li) {
//     return ListView.builder(
//       itemCount: li.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Container(
//           padding: EdgeInsets.symmetric(vertical: 8.0),
//           margin: EdgeInsets.symmetric(horizontal: 15.0),
//           decoration: BoxDecoration(
//               border: Border(bottom: BorderSide(color: Colors.black12))),
//           child: ListTile(
//             onTap: () {
//               // _insertItems(li[index].List_Item);
//               // _updateList(index);

//               // mainLi[index].Item_type = mainLi[index].Item_type == 0 ? 1 : 0;
//               li[index].Item_type = li[index].Item_type == 0 ? 1 : 0;
//               notifyListeners();

//               // Fluttertoast.showToast(
//               //     msg: "This is Center Short Toast",
//               //     toastLength: Toast.LENGTH_SHORT,
//               //     gravity: ToastGravity.CENTER,
//               //     timeInSecForIosWeb: 1,
//               //     backgroundColor: Colors.red,
//               //     textColor: Colors.white,
//               //     fontSize: 16.0);
//             },
//             leading: Icon(
//               Icons.add,
//               color: Colors.blueAccent,
//             ),
//             title: Text(li[index].List_Item),
//             trailing: li[index].Item_type != 0
//                 ? Icon(
//                     Icons.close_rounded,
//                     color: Colors.red.shade400,
//                   )
//                 : SizedBox(),
//           ),
//         );
//       },
//     );
//   }

//   void _insertItems(String ItemName) async {
//     Map<String, dynamic> row = {
//       Databasehelper.columnID: widget.ListId,
//       Databasehelper.colItem: ItemName,
//       Databasehelper.colItemNos: 1
//     };

//     final id = await dbhelper.insertItems(row);
//     print(id);
//     // setState(() {
//     //   _getList();
//     // });
//   }

//   void _updateList(int index) {
    
//     // setState(() {
//     // });
//   }

//   Future<List<MainItemsList>> _getList() async {
//     if (mainLi.length == 0) {
//       var allrows = await dbhelper.getMainList();
//       if (allrows.isNotEmpty) {
//         allrows.forEach((row) {
//           mainLi.add(MainItemsList.fromMap(row));
//         });
//       }
//     } 
//     return mainLi;
//   }

//   defultList() async {
//     var _allrows = await dbhelper.getMainItems();
//     mainLi.clear();
//     _allrows.forEach((row) {
//       mainLi.add(MainItemsList.fromMap(row));
//     });

//     print(mainLi);
//   }
// }

