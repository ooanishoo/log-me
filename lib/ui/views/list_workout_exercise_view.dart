import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:scoped_log_me/models/exercise.dart';

import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ListWorkoutExercise extends StatefulWidget {
  const ListWorkoutExercise({
    Key key,
  }) : super(key: key);

  @override
  _ListWorkoutExerciseState createState() => _ListWorkoutExerciseState();
}

class _ListWorkoutExerciseState extends State<ListWorkoutExercise> {
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return ScopedModelDescendant<WorkoutModel>(builder: (x, y, mdl) {
      return (mdl.currentWorkout.exercise != null &&
              mdl.currentWorkout.exercise.length > 0)
          ? Expanded(
              child: ListView.builder(
                itemCount: mdl.currentWorkout.exercise.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text((index + 1).toString() +
                        ". " +
                        mdl.currentWorkout.exercise[index].name),
                    trailing:
                        _actionMenu(mdl, mdl.currentWorkout.exercise[index]),
                  );
                },
              ),
            )
          : Center(
              child: Text('No exercise added'),
            );
    });
  }
}

Widget _actionMenu(WorkoutModel model, Exercise exercise) =>
    PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "replace",
          child: Text("Replace Exercise"),
        ),
        PopupMenuItem(
          value: "remove",
          child: Text("Remove Exercise"),
        ),
      ],
      onSelected: (action) {
        switch (action) {
          case "replace":
            break;
          case "remove":
            model.removeExercise(exercise);
            break;
          default:
        }
        print("value:$action");
      },
    );
