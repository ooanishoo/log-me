import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<bool> _selections = [false, true];
  bool mode;

  void themeMode() async {
    bool val = await DynamicTheme.of(context).loadBrightness();
    setState(() => this.mode = val);
  }

  @override
  void initState() {
    super.initState();
    themeMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.brightness_3),
            title: Text('Dark mode'),
            trailing: LiteRollingSwitch(
              value: mode,
              colorOff: Colors.grey,
              animationDuration: Duration(milliseconds: 50),
              onChanged: (bool state) {
                print('turned ${(state) ? 'on' : 'off'}');
                DynamicTheme.of(context)
                    .setBrightness(state ? Brightness.dark : Brightness.light);
              },
            ),
          ),
        ],
      ),
    );
  }
}
