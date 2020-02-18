import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/views/add_exercise_view.dart';

class AddExercisePage extends StatelessWidget {
  const AddExercisePage({Key key, this.model, this.workoutModel, this.title='Add New Exercise', this.exercise, this.isUpdateMode=false})
      : super(key: key);

  final AppModel model;
  final WorkoutModel workoutModel;
  final String title;
  final Exercise exercise;
  final bool isUpdateMode;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: AddExercise(
            exercise: exercise,
            isUpdateMode: isUpdateMode,
          )),
    );
  }
}
