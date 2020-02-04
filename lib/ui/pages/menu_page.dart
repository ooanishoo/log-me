import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      body: Center(
        child: Container(
          child: Text('Menu Page'),
        ),
      ),
    );
  }
}
