import 'package:flutter/material.dart';

class Styles {
  static InputDecoration inputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 0.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 0.5),
    ),
    isDense: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 0.5),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 0.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 0.5),
    ),
  );

  static TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static TextStyle subTitleStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16,
  );
}
