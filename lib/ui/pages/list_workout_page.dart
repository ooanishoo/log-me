import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/ui/views/list_workout_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';

class ListWorkoutPage extends StatefulWidget {
  const ListWorkoutPage({Key key, this.model}) : super(key: key);

  final WorkoutModel model;

  @override
  ListWorkoutPageState createState() => ListWorkoutPageState();
}

class ListWorkoutPageState extends State<ListWorkoutPage> {
  TextEditingController _controller = new TextEditingController();
  String filter = '';
  List<Exercise> selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print('listening');
      setState(() => filter = _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Completed Workouts Page'),
        ),
        body: Column(
          children: <Widget>[
            // Exercise List
            ScopedModel<WorkoutModel>(
              model: widget.model,
              child: ListWorkout(filter: filter),
            ),
          ],
        ));
  }
}
