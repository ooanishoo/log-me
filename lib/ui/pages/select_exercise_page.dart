import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/ui/pages/add_exercise_page.dart';
import 'package:scoped_log_me/ui/views/list_exercise_view.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';

class SelectExercisePage extends StatefulWidget {
  const SelectExercisePage({Key key, this.model, this.workoutModel})
      : super(key: key);

  final AppModel model;
  final WorkoutModel workoutModel;

  @override
  _SelectExercisePageState createState() => _SelectExercisePageState();
}

class _SelectExercisePageState extends State<SelectExercisePage> {
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
          title: Text('Select Exercise Page'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddExercisePage(model: widget.model)));
                  },
                )),
          ],
        ),
        body: Column(
          children: <Widget>[
            // Search Bar
            searchBar(),
            // Exercise List
            ScopedModel<AppModel>(
              model: widget.model,
              child: ListExercise(filter: filter, isSelectable:true ),
            ),
            // Add Buttons
            ScopedModel<AppModel>(
              model: widget.model,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                child: ScopedModelDescendant<AppModel>(builder: (x, y, model) {
                  String exerciseLength =
                      model.selectedExercises.length.toString();
                  return ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Add Superset ($exerciseLength)'),
                        onPressed: () {},
                      ),
                      RaisedButton(
                          child: Text('Add Exercise ($exerciseLength)'),
                          onPressed: (() {
                            HapticFeedback.heavyImpact();

                            // add the selected exercise to workout
                            widget.workoutModel
                                .addExercises(model.selectedExercises);
                            // remove all the selectedWorkout from exerciseList
                            model.clearSelection();
                            Navigator.of(context).pop();
                          })),
                    ],
                  );
                }),
              ),
            ),
          ],
        ));
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) {
          print(text);
        },
        controller: _controller,
        decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }
}
