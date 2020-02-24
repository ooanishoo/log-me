import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
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
  List<dynamic>_selectedEvents =[];


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
    _selectedEvents=[];
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
          centerTitle: false,
          bottom: TabBar(
            tabs: [
              Tab(text: "Calendar",),
              Tab(text: "Workouts",),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: (() => widget.workoutModel.getEvents())),
        body: TabBarView(
          children: [
            TableCalendar(
                events: widget.workoutModel.getEvents(),
                calendarController: _calendarController,
                startingDayOfWeek: StartingDayOfWeek.monday,
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  markersColor: Theme.of(context).accentColor,
                  selectedColor: Theme.of(context).accentColor.withOpacity(0.25),
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
                    borderRadius: new BorderRadius.all(
                                              new Radius.circular(8.0))
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).buttonColor
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).buttonColor
                  )
                ),
                onDaySelected: (date, events) {
                  setState(() {
                    this._selectedEvents = events;
                  });
                },
              ),
            ScopedModel<WorkoutModel>(
              model: widget.workoutModel,
              child: ListWorkout(filter: filter),
            ),
          ]),   
      ), 
    );
          //Column(
          // children: <Widget>[
          //   // Exercise List
          //   ScopedModel<WorkoutModel>(
          //     model: widget.workoutModel,
          //     child: ListWorkout(filter: filter),
          //   ),
          // ],
        //));
  }
}
