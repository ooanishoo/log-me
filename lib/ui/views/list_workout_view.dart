import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_log_me/models/workout.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';

import 'package:scoped_log_me/scoped_models/workout_model.dart';
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
        return ListView.separated(
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
          //   ),
          // )
        );
      },
    );
  }

  Widget workoutTile(WorkoutModel model, Workout workout) {
    return ListTile(
        title: new Text(workout.name),
        //subtitle: new Text(workout.date.toString()),
        subtitle: new Text(
          new DateFormat.yMMMd().format(workout.date).toString()
        ),
        trailing: ButtonBar(
          alignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                WorkoutModel newWorkoutModel = WorkoutModel();
                newWorkoutModel.currentWorkout = workout;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditWorkoutPage(
                          workoutModel: newWorkoutModel,
                          model: new AppModel(),
                        )));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: (() {
                model.removeWorkout(workout);
              }),
            ),
          ],
        ));
  }
}
