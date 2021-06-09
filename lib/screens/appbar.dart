import 'dart:js';

import 'package:flutter/material.dart';

final appBar = AppBar(
  elevation: 4.0,
  backgroundColor: Colors.black,
  centerTitle: true,
  title: Text(
    'SkyWay',
    style: TextStyle(fontSize: 30, fontFamily: "Pacifica"),
  ),
);

void messenger(String message, int duration, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }