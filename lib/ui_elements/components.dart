import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


mesToast(String name) {
  return Fluttertoast.showToast(
      msg: "List - $name is deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade600,
      textColor: Colors.white,
      fontSize: 16.0);
}

errMessage(String _error) {
  return Fluttertoast.showToast(
      msg: _error,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade600,
      textColor: Colors.white,
      fontSize: 16.0);
}

