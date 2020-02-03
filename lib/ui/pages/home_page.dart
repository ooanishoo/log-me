import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/pages/add_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/select_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/list_workout_page.dart';
import 'package:scoped_log_me/ui/pages/start_workout_page.dart';
import 'package:scoped_log_me/ui/views/add_exercise_view.dart';
import 'package:scoped_log_me/ui/views/display_exercise_view.dart';
import 'package:scoped_log_me/ui/views/list_exercise_view.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppModel myModel = AppModel();
  WorkoutModel workoutModel = WorkoutModel();
  bool unfinishedWorkout = false;

  @override
  void initState() {
    super.initState();
    print('getting all the exercises');
    myModel.getAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: myModel,
      child: Scaffold(
          appBar: AppBar(title: Text('Log me')),
          body: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Add Exercises'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AddExercisePage(model: myModel)));
                    },
                  ),
                  RaisedButton(
                    child: Text('Display Exercises'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DisplayExercise(model: myModel)));
                    },
                  ),
                  RaisedButton(
                    child: Text('Select Exercises'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SelectExercisePage(model: myModel)));
                    },
                  ),
                  RaisedButton(
                    child: Text('Completed Workouts'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ListWorkoutPage(model: workoutModel)));
                    },
                  ),
                  RaisedButton(
                    child: !this.unfinishedWorkout
                        ? Text('Start a new workout')
                        : Text('Continue workout'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      if (!this.unfinishedWorkout) {
                        workoutModel.startWorkout();
                        setState(() => this.unfinishedWorkout = true);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StartWorkoutPage(
                              model: myModel,
                              workoutModel: workoutModel,
                              onCancel: (() => setState(
                                  () => this.unfinishedWorkout = false)),
                              onFinish: (() => setState(
                                  () => this.unfinishedWorkout = false)))));
                    },
                  ),
                ],
              ),
              AddExercise(),
              ListExercise(),
            ],
          )),
    );
  }
}
