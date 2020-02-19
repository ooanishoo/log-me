import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/pages/start_workout_page.dart';
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
            title: Text('Home'),
            centerTitle: false,
          ),
          body: ListView(
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
              Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('My Routines'),
                      trailing:
                          IconButton(icon: Icon(Icons.add), onPressed: null),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(children: [
                  ListTile(
                    title: Text('My Workout Plans'),
                    trailing:
                        IconButton(icon: Icon(Icons.add), onPressed: null),
                  )
                ]),
              ),
              Card(
                borderOnForeground: false,
                color: Theme.of(context).accentColor,
                child: FlatButton(
                  color: Theme.of(context).accentColor,
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
                            onCancel: (() =>
                                setState(() => this.unfinishedWorkout = false)),
                            onFinish: (() => setState(
                                () => this.unfinishedWorkout = false)))));
                  },
                ),
              ),
            ],
          )),
    );
  }
}
