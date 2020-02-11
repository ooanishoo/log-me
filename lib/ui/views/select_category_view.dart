import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/category.dart';
import 'package:scoped_log_me/models/exercise.dart';

class SelectExerciseCategory extends StatefulWidget {
  SelectExerciseCategory({Key key, this.exercise, this.onSelection})
      : super(key: key);

  final Exercise exercise;
  final Function onSelection;

  @override
  _SelectExerciseCategoryState createState() => _SelectExerciseCategoryState();
}

class _SelectExerciseCategoryState extends State<SelectExerciseCategory> {
  final expansionTile = new GlobalKey();
  String selectedCategory = 'Exercise Category';
  List<String> categories = [
    'barbell',
    'dumbbell',
    'machine',
    'cardio',
    'duration',
    'reps_only'
  ];

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        key: GlobalKey(),
        title: new Text(this.selectedCategory),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
        children: categories
            .map((category) => ListTileTheme(
                  dense: true,
                  child: ListTile(
                    title: Text(category.firstLetterToUpper()),
                    onTap: () {
                      setState(() {
                        this.selectedCategory = category;

                        Category cat = Category.values.firstWhere((value) =>
                            value.toString() == 'Category.' + category);
                        widget.onSelection(cat);
                      });
                    },
                  ),
                ))
            .toList());
  }
}

// Extension method for string
extension StringExtension on String {
  get firstLetterToUpper {
    if (this != null) {
      return this[0].toUpperCase() + this.substring(1);
    } else
      return null;
  }
}
