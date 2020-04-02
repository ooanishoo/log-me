import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/ui/views/list_workout_exercise_set_view_new.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/pages/select_exercise_page.dart';

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
  FocusNode myFocusNode = FocusNode();
  bool isCancelled = false;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      print("Has focus: ${myFocusNode.hasFocus}");
      if (!myFocusNode.hasFocus) {
        print('saving workout to db now');
        widget.workoutModel.saveWorkout();
      }
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  // Pop up dialog when Cancel workout is clicked
  Future<void> _cancelWorkoutDialog(WorkoutModel model) async {
    bool result;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          backgroundColor: Theme.of(context).primaryColorLight,
          title: new Text("Cancel Workout ?"),
          content: new Text(
            "Are you sure you want to cancel this workout? All progress will be lost.",
            style:
                TextStyle(color: Theme.of(context).accentTextTheme.title.color),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel workout'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Colors.red[900],
              onPressed: () {
                // Close the dialog first
                HapticFeedback.heavyImpact();
                Navigator.of(context).pop();
                result = true;
              },
            ),
            FlatButton(
              child: Text('Resume'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Theme.of(context).iconTheme.color,
              disabledColor: Colors.green,
              disabledTextColor: Colors.white,
              textColor: Colors.white,
              onPressed: () {
                HapticFeedback.heavyImpact();
                // Close the dialog first
                Navigator.of(context).pop();
                result = false;
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (result) {
        setState(() => isCancelled = true);
        model.cancelWorkout();
        widget.onCancel();
        // Go back to HomePage
        Navigator.of(context).pop();
      }
    });
  }

  // Pop up dialog when Cancel workout is clicked
  Future<void> _saveWorkoutDialog(WorkoutModel model) async {
    bool result;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          backgroundColor: Theme.of(context).primaryColorLight,
          title: new Text("Finish Workout ?"),
          content: new Text(
            "All invalid or empty sets wil be removed. All valid sets will be marked as complete.",
            style: TextStyle(color: Theme.of(context).accentTextTheme.title.color),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                HapticFeedback.heavyImpact();
                // Close the dialog first
                Navigator.of(context).pop();
                result = false;
              },
            ),
            FlatButton(
              child: Text('Finish'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Theme.of(context).accentColor,
              disabledColor: Colors.green,
              disabledTextColor: Colors.white,
              textColor: Colors.white,
              onPressed: () {
                HapticFeedback.heavyImpact();
                // Close the dialog first
                Navigator.of(context).pop();
                result = true;
              },
            ),
          ],
        );
      },
    ).then((value) async{
      if (result) {
        await model.finishWorkout();
        widget.onFinish();
        // Go back to HomePage
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Workout'),
      ),
      body: (isCancelled || widget.workoutModel.currentWorkout == null)
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                ScopedModel<WorkoutModel>(
                    model: widget.workoutModel,
                    child: ScopedModelDescendant<WorkoutModel>(
                        builder: (x, y, model) {
                      _workoutNameController.text = model.currentWorkout.name;

                      return ListTile(
                        //title: Text(model.currentWorkout.name),
                        title: TextField(
                          controller: _workoutNameController,
                          focusNode: myFocusNode,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: ((value) {
                            print('on change value :: $value');
                            model.currentWorkout.name = value;
                          }),
                          //onEditingComplete: (() {print('its completed);}),
                        ),
                        trailing: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text('Finish'),
                            color: Theme.of(context).accentColor,
                            disabledColor: Colors.green,
                            disabledTextColor: Colors.white,
                            textColor: Colors.white,
                            onPressed: () async {
                              HapticFeedback.heavyImpact();
                              _saveWorkoutDialog(model);

                              // await model.finishWorkout();
                              // widget.onFinish();
                              // Navigator.of(context).pop();
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
                        child: ScopedModelDescendant<WorkoutModel>(
                            builder: (x, y, m) {
                          return RaisedButton(
                            child: Text('Cancel workout'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            color: Theme.of(context).iconTheme.color,
                            onPressed: (() {
                              // cancel the current workout
                              HapticFeedback.heavyImpact();
                              _cancelWorkoutDialog(m);
                            }),
                          );
                        }),
                      ),
                      ScopedModel<AppModel>(
                        model: AppModel(),
                        child:
                            ScopedModelDescendant<AppModel>(builder: (x, y, m) {
                          return RaisedButton(
                            child: Text('Add Exercises'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
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
