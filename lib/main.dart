import 'package:flutter/material.dart';
import 'package:shopping_list/screens/SplashScreen.dart';
import 'package:shopping_list/screens/Home.dart';

void main() {
  Map<int, Widget> op = {1: SplashScreen(title: "List Check"), 2: Home(title: "List Check")};
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final _title = "List Check" ;
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    home: SplashScreen(title: _title)
  );
  }
}
