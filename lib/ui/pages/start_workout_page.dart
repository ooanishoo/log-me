import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/ui/views/list_workout_exercise_set_view_new.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/pages/select_exercise_page.dart';
import 'package:scoped_log_me/ui/views/list_workout_exercise_set_view.dart';

class StartWorkoutPage extends StatefulWidget {
  StartWorkoutPage(
      {Key key, this.workoutModel, this.model, this.onCancel, this.onFinish})
      : super(key: key);

  final WorkoutModel workoutModel;
  final AppModel model;
  final VoidCallback onCancel;
  final VoidCallback onFinish;
  @override
  _StartWorkoutPageState createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  TextEditingController _workoutNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start workout Page'),
      ),
      body: Column(
        children: <Widget>[
          ScopedModel<WorkoutModel>(
              model: widget.workoutModel,
              child:
                  ScopedModelDescendant<WorkoutModel>(builder: (x, y, model) {
                _workoutNameController.text = model.currentWorkout.name;

                return ListTile(
                  //title: Text(model.currentWorkout.name),
                  title: TextField(
                    controller: _workoutNameController,
                    onChanged: ((value) => model.currentWorkout.name = value),
                    //model.currentWorkout.name
                  ),
                  trailing: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text('Finish'),
                      color: Colors.green,
                      disabledColor: Colors.green,
                      disabledTextColor: Colors.white,
                      textColor: Colors.white,
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        model.finishWorkout();
                        widget.onFinish();
                        Navigator.of(context).pop();
                      }),
                );
              })),
          // List of exercises in the current workout
          ScopedModel<WorkoutModel>(
            model: widget.workoutModel,
            child: ListWorkoutExerciseSetNew(),
            //child: ListWorkoutExerciseSet(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ScopedModel<WorkoutModel>(
                  model: widget.workoutModel,
                  child:
                      ScopedModelDescendant<WorkoutModel>(builder: (x, y, m) {
                    return RaisedButton(
                      child: Text('Cancel workout'),
                      onPressed: (() {
                        // cancel the current workout
                        m.cancelWorkout();
                        widget.onCancel();
                        Navigator.of(context).pop();
                      }),
                    );
                  }),
                ),
                ScopedModel<AppModel>(
                  model: AppModel(),
                  child: ScopedModelDescendant<AppModel>(builder: (x, y, m) {
                    return RaisedButton(
                      child: Text('Add Exercises'),
                      onPressed: () {
                        HapticFeedback.heavyImpact();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelectExercisePage(
                                model: widget.model,
                                workoutModel: widget.workoutModel)));
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
