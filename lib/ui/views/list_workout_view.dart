import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/workout.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';

import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/service_locator.dart';
import 'package:scoped_log_me/ui/pages/edit_workout_page.dart';
import 'package:scoped_model/scoped_model.dart';

class ListWorkout extends StatefulWidget {
  const ListWorkout({Key key, this.filter}) : super(key: key);

  final String filter;

  @override
  _ListWorkoutState createState() => _ListWorkoutState();
}

class _ListWorkoutState extends State<ListWorkout> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<WorkoutModel>(
      builder: (x, y, model) {
        return Expanded(
            // GestureDetector is added for hiding keyboard when swiping down
            child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(height: 0),
            ),
            itemCount: model.workouts.length,
            itemBuilder: (context, index) {
              // store the object to a local variable
              Workout workout = model.workouts[index];
              // Display all when search filter is empty
              return widget.filter == null || widget.filter == ''
                  ? workoutTile(model, workout)
                  : workout.name.contains(widget.filter)
                      ? workoutTile(model, workout)
                      : new Container();
            },
          ),
        ));
      },
    );
  }

  Widget workoutTile(WorkoutModel model, Workout workout) {
    return ListTile(
      title: new Text(workout.name),
      subtitle: new Text(workout.date.toString()),
      onTap: () {
        WorkoutModel newWorkoutModel = WorkoutModel();
        newWorkoutModel.currentWorkout = workout;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditWorkoutPage(
              workoutModel:newWorkoutModel,
              model: new AppModel(),
            )));
      },
    );
  }
}
