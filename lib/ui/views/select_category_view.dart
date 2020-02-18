import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/enums/body_part.dart';
import 'package:scoped_log_me/models/enums/exercise_category.dart';
import 'package:scoped_log_me/models/exercise.dart';

class SelectExerciseCategory extends StatefulWidget {
  SelectExerciseCategory({Key key, this.exercise, this.onSelection})
      : super(key: key);

  final Exercise exercise;
  final Function onSelection;

  @override
  _SelectExerciseCategoryState createState() =>
      _SelectExerciseCategoryState(exercise);
}

class _SelectExerciseCategoryState extends State<SelectExerciseCategory> {
  final Exercise exercise;
  String selectedCategory;
  List<String> categories = [];

  final expansionTile = new GlobalKey();

  _SelectExerciseCategoryState(this.exercise);

  @override
  void initState() {
    super.initState();
    exercise.exerciseCategory == null
        ? this.selectedCategory = 'Exercise Category'
        : this.selectedCategory = EnumToString.parse(exercise.exerciseCategory);
    getExerciseCategories();
  }

  void getExerciseCategories() {
    ExerciseCategory.values.forEach((v) => this.categories.add(describeEnum(v).toString()));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        key: GlobalKey(),
        title: new Text(this.selectedCategory.firstLetterToUpper()),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
        children: categories
            .map((exerciseCategory) => Visibility(
                  visible:
                      this.selectedCategory == exerciseCategory ? false : true,
                  child: ListTileTheme(
                    dense: true,
                    child: ListTile(
                      title: Text(exerciseCategory.firstLetterToUpper()),
                      onTap: () {
                        setState(() {
                          this.selectedCategory = exerciseCategory;

                          ExerciseCategory cat = ExerciseCategory.values
                              .firstWhere((value) =>
                                  value.toString() ==
                                  'ExerciseCategory.' + exerciseCategory);
                          widget.onSelection(cat);
                        });
                      },
                    ),
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
