import 'package:flutter/material.dart';

final defaultTheme = ThemeData.light().copyWith(
  primaryColor: Colors.deepOrange,
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    buttonColor: Colors.blue[200],
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.5,
      ),
    ),
    prefixStyle: TextStyle(
      color: Colors.black,
    ),
    errorStyle: TextStyle(color: Colors.orange[100]),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.orange[100],
        width: 1.5,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      color: Colors.black,
    ),
    bodyText1: TextStyle(
      color: Colors.black,
    ),
    headline5: TextStyle(color: Colors.black, fontSize: 25.0),
    headline6: TextStyle(color: Colors.black, fontSize: 35.0),
  ),
  scrollbarTheme: ScrollbarThemeData(
    isAlwaysShown: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      primary: Colors.black54, //Colors.green[600],
      alignment: Alignment.center,
      elevation: 6.0,
    ),
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
    margin: EdgeInsets.all(20.0),
    elevation: 6.0,
    color: Colors.white38,
  ),
  buttonBarTheme: ButtonBarThemeData(alignment: MainAxisAlignment.spaceEvenly),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
    elevation: 30.0,
  ),
);
