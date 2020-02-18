import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/pages/add_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/select_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/list_workout_page.dart';
import 'package:scoped_log_me/ui/pages/start_workout_page.dart';
import 'package:scoped_log_me/ui/views/display_exercise_view.dart';
import 'package:scoped_log_me/ui/views/list_exercise_view.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.workoutModel, this.model}) : super(key: key);

  final WorkoutModel workoutModel;
  final AppModel model;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool unfinishedWorkout = false;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    print('getting all the exercises');
    widget.workoutModel.getCurrentWorkout();
    widget.model.getAllExercises();
    if (widget.workoutModel.currentWorkout != null)
      unfinishedWorkout = widget.workoutModel.currentWorkout.isActive;
    print(this.unfinishedWorkout);
    // widget.workoutModel.currentWorkout != null
    //     ? unfinishedWorkout = widget.workoutModel.currentWorkout.isActive
    //     : false;

    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: widget.model,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Log me'),
            centerTitle: false,
          ),
          body: Column(
            children: [
              TableCalendar(
                calendarController: _calendarController,
                startingDayOfWeek: StartingDayOfWeek.monday,
                initialCalendarFormat: CalendarFormat.week,
                calendarStyle: CalendarStyle(
                  markersColor: Theme.of(context).accentColor,
                  selectedColor: Theme.of(context).accentColor,
                  holidayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Theme.of(context).buttonColor),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: !this.unfinishedWorkout
                        ? Text('Start a new workout')
                        : Text('Continue workout'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      if (!this.unfinishedWorkout) {
                        widget.workoutModel.startWorkout();
                        setState(() => this.unfinishedWorkout = true);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StartWorkoutPage(
                              model: widget.model,
                              workoutModel: widget.workoutModel,
                              onCancel: (() => setState(
                                  () => this.unfinishedWorkout = false)),
                              onFinish: (() => setState(
                                  () => this.unfinishedWorkout = false)))));
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
