import 'package:flutter/material.dart';

ThemeData CustomTheme(BuildContext context) {
  return ThemeData(
      //primarySwatch: generateSwatch(Color(0xFF191414)),
      brightness: Brightness.dark,
      primaryColor: Color(0xFF191414),
      primaryColorLight: Color(0xFF262626),
      accentColor: Color(0xFF1DB954),
      scaffoldBackgroundColor: Color(0xFF191414),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: Color(0xFF191414),
      ),
      buttonColor: Colors.white,
      // applies color to appBar icons
      primaryIconTheme: IconThemeData(
        //color: Color(0xFF5A595D),
        color: Colors.white,
      ),
      accentTextTheme: TextTheme(
        title: TextStyle(
          //color: Color(0xFF5A595D),
          color: Color(0xFF8E8E92),
        ),
      ),
      accentIconTheme: IconThemeData(
        //color: Color(0xFF5A595D),
        color: Color(0xFF8E8E92),
      ),
      disabledColor: Color(0xFF909090),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      iconTheme: IconThemeData(
          color: Color(0xFF5A595D),
          // color: Colors.red
      ),
      primaryTextTheme: TextTheme());
}
