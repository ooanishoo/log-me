import 'package:flutter/material.dart';
import 'package:scoped_log_me/controller/NavigationController.dart';
import 'service_locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Material App',
      home: NavigationController(),
    );
  }
}
