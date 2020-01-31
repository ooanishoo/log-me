import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/views/add_exercise_view.dart';

class AddExercisePage extends StatelessWidget {
  const AddExercisePage({Key key, this.model, this.workoutModel})
      : super(key: key);

  final AppModel model;
  final WorkoutModel workoutModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add Exercises Page'),
          ),
          body: AddExercise()),
    );
  }
}
