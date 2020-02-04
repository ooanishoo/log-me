import 'package:flutter/material.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/service_locator.dart';
import 'package:scoped_log_me/ui/pages/add_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/home_page.dart';
import 'package:scoped_log_me/ui/pages/list_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/list_workout_page.dart';
import 'package:scoped_log_me/ui/pages/menu_page.dart';

class NavigationController extends StatefulWidget {
  NavigationController({Key key}) : super(key: key);

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  final List<Widget> pages = [
    HomePage(
      key: PageStorageKey('Page1'),
      model: locator<AppModel>(),
      workoutModel: locator<WorkoutModel>(),
    ),
    ListWorkoutPage(
      key: PageStorageKey('Page3'),
      model: locator<WorkoutModel>(),
    ),
    HomePage(
      key: PageStorageKey('Page2'),
      workoutModel: locator<WorkoutModel>(),
      model: locator<AppModel>(),
    ),
    ListExercisePage(
      key: PageStorageKey('Page4'),
      model: locator<AppModel>(),
    ),
    MenuPage(
      key: PageStorageKey('Page5'),
    ),
  ];

  final PageStorageBucket bucket = new PageStorageBucket();

  int _selectedIndex = 2;

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bottomNavigationBar(int _selectedIndex) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // added to show more than 3 items
      currentIndex: _selectedIndex,
      onTap: _changePage,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          title: Text("History"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          title: Text("Add"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          title: Text("Exercises"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          title: Text("Menu"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
