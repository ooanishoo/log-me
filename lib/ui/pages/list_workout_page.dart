import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/ui/pages/edit_workout_page.dart';
import 'package:scoped_log_me/ui/views/list_workout_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:table_calendar/table_calendar.dart';

class ListWorkoutPage extends StatefulWidget {
  const ListWorkoutPage({Key key, this.model, this.workoutModel})
      : super(key: key);

  final WorkoutModel workoutModel;
  final AppModel model;

  @override
  ListWorkoutPageState createState() => ListWorkoutPageState();
}

class ListWorkoutPageState extends State<ListWorkoutPage> {
  TextEditingController _controller = new TextEditingController();
  String filter = '';
  List<Exercise> selectedExercises = [];
  CalendarController _calendarController;
  List<dynamic> _selectedEvents = [];
  int page = 0;

  @override
  void initState() {
    super.initState();
    print('getting all the workouts');
    widget.workoutModel.getAllWorkouts();
    _controller.addListener(() {
      print('listening');
      setState(() => filter = _controller.text);
    });
    _calendarController = CalendarController();
    _selectedEvents = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: this.page,
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
          centerTitle: false,
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Calendar",
              ),
              Tab(
                text: "Workouts",
              ),
            ],
            onTap: ((int index) => setState(() {
                  this.page = index;
                })),
          ),
        ),
        body: TabBarView(children: [
          Column(
            children: <Widget>[
              TableCalendar(
                events: widget.workoutModel.getEvents(),
                calendarController: _calendarController,
                startingDayOfWeek: StartingDayOfWeek.monday,
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  markersColor: Theme.of(context).accentColor,
                  selectedColor:
                      Theme.of(context).accentColor.withOpacity(0.25),
                  holidayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Theme.of(context).buttonColor),
                ),
                headerStyle: HeaderStyle(
                    centerHeaderTitle: false,
                    decoration: BoxDecoration(
                        //color: Colors.green,
                        ),
                    formatButtonVisible: true,
                    formatButtonDecoration: BoxDecoration(
                        //color: Theme.of(context).buttonColor
                        color: Theme.of(context).accentColor.withOpacity(0.25),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(8.0))),
                    leftChevronIcon: Icon(Icons.chevron_left,
                        color: Theme.of(context).buttonColor),
                    rightChevronIcon: Icon(Icons.chevron_right,
                        color: Theme.of(context).buttonColor)),
                onDaySelected: (date, events) {
                  setState(() {
                    this._selectedEvents = events;
                  });
                },
              ),
              ..._selectedEvents.map((workout) => ListTile(
                    title: Text(workout.name),
                    subtitle: new Text(
                      new DateFormat.MMMd().format(workout.date).toString(),
                      style: TextStyle(color: Theme.of(context).iconTheme.color),
                    ),
                    trailing: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            style: BorderStyle.solid,
                            color: Theme.of(context).iconTheme.color,
                          )),
                      child: Text(
                        'View Workout',
                        style: TextStyle(color: Theme.of(context).buttonColor),
                      ),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        WorkoutModel newWorkoutModel = WorkoutModel();
                        newWorkoutModel.currentWorkout = workout;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditWorkoutPage(
                                  workoutModel: newWorkoutModel,
                                  model: new AppModel(),
                                )));
                      },
                    ),
                  )),
            ],
          ),
          ScopedModel<WorkoutModel>(
            model: widget.workoutModel,
            child: ListWorkout(filter: filter),
          ),
        ]),
      ),
    );
  }
}
