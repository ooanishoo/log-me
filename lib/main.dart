import 'package:flutter/material.dart';
import 'custom_theme.dart';
import 'service_locator.dart';
import 'package:scoped_log_me/controller/NavigationController.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool mode;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme(context),
      home: NavigationController(),
    );
  }
}
