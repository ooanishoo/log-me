import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/models/exerciseSet.dart';

import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ListWorkoutExerciseSetNew extends StatefulWidget {
  const ListWorkoutExerciseSetNew({
    Key key,
  }) : super(key: key);

  @override
  _ListWorkoutExerciseSetNewState createState() =>
      _ListWorkoutExerciseSetNewState();
}

class _ListWorkoutExerciseSetNewState extends State<ListWorkoutExerciseSetNew> {
  List<TextEditingController> controller;
  Map<Exercise, List<TextEditingController>> controllers =
      new Map<Exercise, List<TextEditingController>>();

  List<TextEditingController> list = new List<TextEditingController>();

  @override
  void initState() {
    super.initState();

    WorkoutModel model = ScopedModel.of(context);
    if (model.currentWorkout.exercises == null) setupController();

    //work on the controller
    // model.currentWorkout.exercises.forEach((ex) {
    //   return controllers.putIfAbsent(ex,
    //       ex.exerciseSets.map((set) => list.add(new TextEditingController())));
    // });
  }

  void setupController() {
    controller = [];
    print(controller.length);
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return ScopedModelDescendant<WorkoutModel>(builder: (x, y, mdl) {
      return (mdl.currentWorkout.exercises != null &&
              mdl.currentWorkout.exercises.length > 0)
          ? Expanded(
              child: ListView.builder(
                // reverse: true,
                itemCount: mdl.currentWorkout.exercises.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanDown: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: _exerciseSet(mdl, index));
                },
              ),
            )
          : Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No exercise addedss.'),
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
    if (notes == null) {
      notes = [];
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ListTile(
                      title:
                          Text((index + 1).toString() + ". " + exercise.name),
                      trailing: _actionMenu(model, exercise),
                    ),
                  ),
                  Column(
                      children: notes
                          .map(
                            (note) =>
                                // Dismissible(
                                //   onDismissed: (direction) {
                                //     HapticFeedback.heavyImpact();
                                //     model.removeNoteFromExercise(
                                //         exercise, note.toString());
                                //   },
                                //   direction: DismissDirection.endToStart,
                                //   key: UniqueKey(),
                                //   background: Container(
                                //     alignment: AlignmentDirectional.centerEnd,
                                //     color: Colors.red,
                                //     child: Padding(
                                //       padding:
                                //           EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.end,
                                //         children: <Widget>[
                                //           Icon(
                                //             Icons.delete,
                                //             color: Colors.white,
                                //           ),
                                //           Text('Delete'),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                //  child:
                                ListTile(
                              title: TextField(
                                decoration:
                                    InputDecoration(hintText: 'Add a note'),
                              ),
                            ),
                            //),
                          )
                          .toList()),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 40,
                            child: Text('Set'),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 90,
                            child: Text('Weight'),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 90,
                            child: Text('Reps'),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              // width: MediaQuery.of(context).size.width -
                              //    (40 + 90 + 90 - 32),
                              child: Text('Actions'),
                            ),
                          ),
                        ],
                      )),
                  Divider(),
                  Column(
                      children: sets
                          .map(
                            (set) =>
                                // Dismissible(
                                //   onDismissed: (direction) {
                                //     HapticFeedback.heavyImpact();
                                //     model.removeSet(
                                //         model.currentWorkout.exercises[index], set);
                                //   },
                                //   direction: DismissDirection.endToStart,
                                //   key: UniqueKey(),
                                //   background: Container(
                                //     alignment: AlignmentDirectional.centerEnd,
                                //     color: Colors.red,
                                //     child: Padding(
                                //       padding:
                                //           EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.end,
                                //         children: <Widget>[
                                //           Icon(
                                //             Icons.delete,
                                //             color: Colors.white,
                                //           ),
                                //           Text('Delete'),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                //  child:
                                Container(
                                    decoration: BoxDecoration(
                                        color: set.isCheck
                                            ? Colors.grey[900]
                                            : Color(0xFF303030)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Form(
                                          child: Row(children: <Widget>[
                                            Container(
                                              width: 40,
                                              alignment: Alignment.centerLeft,
                                              child:
                                                  _exerciseSetMenu(model, set),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              width: 80,
                                              child: TextField(
                                                controller:
                                                    TextEditingController(),
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                  isDense: true,

                                                  //contentPadding:EdgeInsets.all(2),
                                                  border: OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              width: 80,
                                              child: TextField(
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  (40 + 80 + 80 + 16 + 16 + 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(Icons.chat),
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .selectionClick();
                                                      }),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: set.isCheck
                                                          ? Colors.green
                                                          : Colors.grey[800],
                                                      borderRadius:
                                                          new BorderRadius.all(
                                                              new Radius
                                                                      .circular(
                                                                  8.0)),
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(Icons.done),
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .heavyImpact();

                                                        this.setState(() {
                                                          set.isCheck =
                                                              !set.isCheck;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    )),
                            // ),
                          )
                          .toList()),
                ],
              ),
            ),
            //),
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
        HapticFeedback.selectionClick();
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
