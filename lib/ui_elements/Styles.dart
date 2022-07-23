import 'package:flutter/material.dart';

TextStyle LeadingText() {
  // ignore: prefer_const_constructors
  return TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);
}

TextStyle titleText() {
  // ignore: prefer_const_constructors
  return TextStyle(
    fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.bold);
}

TextStyle subTitleText() {
  // ignore: prefer_const_constructors
  return TextStyle(fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.bold);
}

TextStyle TextFiledLabel() {
  // ignore: prefer_const_constructors
  return TextStyle(
      color: Color(0x9C838383), fontWeight: FontWeight.w600, fontSize: 15.0);
}

TextStyle BtnTextPrimery() {
  // ignore: prefer_const_constructors
  return TextStyle(
      color: Colors.blueAccent,
      fontWeight: FontWeight.w600,
      fontSize: 20.0,
      );
}

TextStyle BtnTextCancel() {
  // ignore: prefer_const_constructors
  return TextStyle(
      color: Colors.grey.shade400,
      fontWeight: FontWeight.w600,
      fontSize: 20.0,
      );
}

TextStyle trailingText() {
  // ignore: prefer_const_constructors
  return TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w600,
      fontSize: 20.0,
      );
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);
