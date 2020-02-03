import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/models/exercise.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ListExercise extends StatefulWidget {
  const ListExercise({Key key, this.filter}) : super(key: key);

  final String filter;

  @override
  _ListExerciseState createState() => _ListExerciseState();
}

class _ListExerciseState extends State<ListExercise> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (x, y, model) {
        return Expanded(
            // GestureDetector is added for hiding keyboard when swiping down
            child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView.builder(
            itemCount: model.exercises.length,
            itemBuilder: (context, index) {
              // store the object to a local variable
              Exercise exercise = model.exercises[index];
              // Display all when search filter is empty
              return widget.filter == null || widget.filter == ''
                  ? exerciseTile(model, exercise)
                  : exercise.name.contains(widget.filter)
                      ? exerciseTile(model, exercise)
                      // : new Column(
                      //     children: <Widget>[
                      //       Text(widget.filter + ' not found'),
                      //     ],
                      //   );
                      : new Container();
            },
          ),
        ));
      },
    );
  }

  Widget exerciseTile(AppModel model, Exercise exercise) {
    return ListTile(
      title: new Text(exercise.name),
      trailing: Checkbox(
          value: exercise.isCheck,
          onChanged: (bool value) {
            HapticFeedback.selectionClick();

            setState(() {
              exercise.isCheck = value;

              // Add the exercise only if it is selected
              if (exercise.isCheck) {
                print('checked');
                // Add only if the list already doesn't have the exercise
                if (!model.selectedExercises.contains(exercise)) {
                  print("list doesn't contains Ex");
                  model.selectExercise(exercise);
                }
              } else {
                print('unchecked');
                if (model.selectedExercises.contains(exercise)) {
                  print("list contains Ex, need to remove it");
                  model.unselectExercise(exercise);
                }
              }
            });
          }),
    );
  }
}
