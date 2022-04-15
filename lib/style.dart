import 'package:flutter/material.dart';

var theme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
      )
    ),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      actionsIconTheme: IconThemeData(color: Colors.black),
      elevation: 1,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
      centerTitle: false
    ),
    textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black)
    )
);