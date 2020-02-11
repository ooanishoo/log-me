import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/models/exerciseSet.dart';

import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';

class ListWorkoutExerciseSet extends StatefulWidget {
  const ListWorkoutExerciseSet({
    Key key,
  }) : super(key: key);

  @override
  _ListWorkoutExerciseSetState createState() => _ListWorkoutExerciseSetState();
}

class _ListWorkoutExerciseSetState extends State<ListWorkoutExerciseSet> {
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return ScopedModelDescendant<WorkoutModel>(builder: (x, y, mdl) {
      return (mdl.currentWorkout.exercises != null &&
              mdl.currentWorkout.exercises.length > 0)
          ? Expanded(
              child: ListView.builder(
                itemCount: mdl.currentWorkout.exercises.length,
                itemBuilder: (BuildContext context, int index) {
                  return _exerciseSet(mdl, index);
                },
              ),
            )
          : Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No exercise added.'),
                  Text('Click on Add Exercises!'),
                ],
              ),
            );
    });
  }

  Widget _exerciseSet(WorkoutModel model, int index) {
    Exercise exercise = model.currentWorkout.exercises[index];
    List<ExerciseSet> sets = exercise.exerciseSets;
    List<String> notes = exercise.notes;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ListTile(
              title: Text((index + 1).toString() + ". " + exercise.name),
              trailing: _actionMenu(model, exercise),
            ),
            Column(
                children: notes
                    .map(
                      (note) => Dismissible(
                        onDismissed: (direction) {
                          model.removeNoteFromExercise(
                              exercise, note.toString());
                        },
                        direction: DismissDirection.endToStart,
                        key: UniqueKey(),
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: TextField(
                            decoration: InputDecoration(hintText: 'Add a note'),
                          ),
                        ),
                      ),
                    )
                    .toList()),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: DataTable(
                    headingRowHeight: 70,
                    horizontalMargin: 30,
                    columnSpacing: 10,
                    columns: [
                      DataColumn(
                        label: Container(
                          width: 40,
                          child: Text('Set'),
                          //decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                      DataColumn(
                          label: Container(
                        width: 40,
                        child: Text('Weight'),
                        //decoration: BoxDecoration(color: Colors.blue),
                      )),
                      DataColumn(
                          label: Container(
                        width: 40,
                        child: Text('Reps'),
                        //decoration: BoxDecoration(color: Colors.yellow),
                      )),
                      DataColumn(
                          label: Container(
                        width: 40,
                        child: Text('Actions'),
                        //decoration: BoxDecoration(color: Colors.purple),
                      )),
                      // DataColumn(label: Text('Weight')),
                      // DataColumn(label: Text('Reps')),
                      // DataColumn(label: Icon(Icons.delete)),
                      //DataColumn(label: Icon(Icons.done_all)),
                    ],
                    rows: sets
                        .map(
                          ((set) => DataRow(
                                selected: !set.isCheck ? false : true,
                                cells: <DataCell>[
                                  DataCell(Container(
                                    width: 40,
                                    //decoration: BoxDecoration(color: Colors.green),
                                    child: _exerciseSetMenu(model, set),
                                  )),
                                  DataCell(Container(
                                    width: 40,
                                    //decoration: BoxDecoration(color: Colors.blue),
                                    child: Form(
                                      child: TextField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                      ),
                                    ),
                                  )),
                                  DataCell(Container(
                                    width: 40,
                                    //decoration: BoxDecoration(color: Colors.yellow),
                                    child: TextField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                  )),
                                  DataCell(ButtonBar(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          model.removeSet(
                                              model.currentWorkout
                                                  .exercises[index],
                                              set);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.done),
                                        onPressed: () {
                                          this.setState(() {
                                            set.isCheck = !set.isCheck;
                                          });
                                        },
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.chat),
                                          onPressed: () {}),
                                    ],
                                  )),
                                ],
                              )),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            ListTile(
              trailing: RaisedButton(
                child: Text(
                  'Add set',
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.grey,
                onPressed: () {
                  model.addSet(model.currentWorkout.exercises[index]);
                  HapticFeedback.heavyImpact();
                },
              ),
            )
          ]),
    );
  }
}

Widget _actionMenu(WorkoutModel model, Exercise exercise) =>
    PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "replace",
          child: Text("Replace Exercise"),
        ),
        PopupMenuItem(
          value: "remove",
          child: Text("Remove Exercise"),
        ),
        PopupMenuItem(
          value: "note",
          child: Text("Add a note"),
        ),
      ],
      onSelected: (action) {
        switch (action) {
          case "replace":
            break;
          case "remove":
            model.removeExercise(exercise);
            break;
          case "note":
            model.addNoteToExercise(exercise);
            break;
          default:
        }
        print("value:$action");
      },
    );

Widget _exerciseSetMenu(WorkoutModel model, ExerciseSet set) =>
    PopupMenuButton<String>(
      child: FlatButton(
        onPressed: () {},
        child: Text(set.type == ExerciseSetType.workingSet
            ? set.index.toString()
            : describeEnum(set.type).toString().substring(0, 1).toUpperCase()),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "warmupSet",
          child: Text("W Warmup"),
        ),
        PopupMenuItem(
          value: "dropSet",
          child: Text("D Dropset"),
        ),
        PopupMenuItem(
          value: "failureSet",
          child: Text("F Failure"),
        ),
        PopupMenuItem(
          value: "workingSet",
          child: Text("Working set"),
        ),
      ],
      onSelected: (action) {
        switch (action) {
          case "warmupSet":
            model.updateSetType(set, ExerciseSetType.warmupSet);
            break;
          case "dropSet":
            model.updateSetType(set, ExerciseSetType.dropSet);
            break;
          case "failureSet":
            model.updateSetType(set, ExerciseSetType.failureSet);
            break;
          case "workingSet":
            model.updateSetType(set, ExerciseSetType.workingSet);
            break;
          default:
        }
        print("value:$action");
      },
    );
