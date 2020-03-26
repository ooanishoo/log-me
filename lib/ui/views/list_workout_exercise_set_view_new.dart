import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/models/exerciseSet.dart';
import 'package:scoped_log_me/models/enums/exerciseSetType.dart';

import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:undraw/undraw.dart';

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
  UnDrawIllustration illustration;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();

    WorkoutModel model = ScopedModel.of(context);
    if (model.currentWorkout.exercises == null) setupController();

    // load the unDraw illustration only once
    if (this.illustration == null)
      setState(() => this.illustration = UnDrawIllustration.personal_trainer);
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
              child: UnDraw(
                color: Theme.of(context).accentColor,
                illustration: this.illustration,
                fit: BoxFit.scaleDown,
                padding: EdgeInsets.all(56.0),
              ),
            );
    });
  }

  Widget _exerciseSet(WorkoutModel model, int index) {
    Exercise exercise = model.currentWorkout.exercises[index];
    List<ExerciseSet> sets = exercise.exerciseSets ?? [];
    List<String> notes = exercise.notes ?? [];

    if (notes == null) {
      notes = new List<String>();
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
                      children: notes.map((note) {
                    var _controller = new TextEditingController(
                        text: note == null ? '' : note);
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        title: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            note = value;
                          },
                          decoration: InputDecoration(hintText: 'Add a note'),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        SlideAction(
                            child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Icon(Icons.delete)),
                            color: Colors.grey[900],
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              model.removeNoteFromExercise(
                                  exercise, note.toString());
                            }),
                      ],
                    );
                  }
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
                          //   ListTile(
                          // title: TextField(
                          //   decoration:
                          //       InputDecoration(hintText: 'Add a note'),
                          // ),
                          //),
                          //),
                          ).toList()),
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
                            width: 60,
                            child: Text('Weight'),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 60,
                            child: Text('Reps'),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              //width: 90,
                              child: Text('Actions'),
                            ),
                          ),
                        ],
                      )),
                  Divider(),
                  Column(
                      children: sets.map((set) {
                    var textEditingController1 = new TextEditingController(
                      text: set.weight == null ? '' : set.weight.toString(),
                    );
                    var textEditingController2 = new TextEditingController(
                      text: set.reps == null ? '' : set.reps.toString(),
                    );

                    FocusNode _focus1 = new FocusNode();
                    FocusNode _focus2 = new FocusNode();
                    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
                    return Container(
                        decoration: BoxDecoration(
                          color: set.isCheck
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        padding: EdgeInsets.only(right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              autovalidate: _autovalidate,
                              child: Row(children: <Widget>[
                                Container(
                                  width: 40,
                                  alignment: Alignment.centerLeft,
                                  child: _exerciseSetMenu(model, set),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  width: 60,
                                  child: TextFormField(
                                    //focusNode: _focus1,
                                    validator: (value) {
                                      print('validator :: $value');
                                      if (value.isEmpty) {
                                        print('weight is empty');
                                        //setState(() => _autovalidate = true);
                                        return '';
                                      }
                                      //print(value);
                                      return null;
                                    },

                                    controller: textEditingController1,
                                    onChanged: (value) {
                                      model.updateWeight(
                                          set,
                                          double.parse(
                                              textEditingController1.text));
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 0),
                                      isDense: true,
                                      //contentPadding:EdgeInsets.all(2),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color:
                                                Theme.of(context).buttonColor,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  width: 60,
                                  child: TextFormField(
                                    validator: (value) {
                                      print('validator :: $value');
                                      if (value.isEmpty) {
                                        print('reps is empty');
                                        //  setState(() => _autovalidate = true);
                                        return '';
                                      }
                                      return null;
                                    },
                                    controller: textEditingController2,
                                    onChanged: (value) {
                                      model.updateRep(
                                          set,
                                          int.parse(
                                              textEditingController2.text));
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 0),
                                      //filled: textEditingController2.text.isEmpty ? true: false,
                                      //fillColor: Colors.red[900],
                                      // focusedErrorBorder:
                                      //     new OutlineInputBorder(
                                      //   borderSide: new BorderSide(
                                      //       color: Theme.of(context).accentColor),
                                      // ),
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color:
                                                Theme.of(context).buttonColor,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  //color: Colors.red,
                                  width: MediaQuery.of(context).size.width -
                                      (40 + 60 + 60 + 16 + 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            HapticFeedback.selectionClick();
                                            model.removeSet(exercise, set);
                                          }),
                                      IconButton(
                                          icon: Icon(Icons.chat),
                                          onPressed: () {
                                            HapticFeedback.selectionClick();
                                          }),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: set.isCheck
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(8.0)),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).buttonColor,
                                          ),
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();
                                            if (_formKey.currentState
                                                .validate()) {
                                              this.setState(() {
                                                set.isCheck = !set.isCheck;
                                                model.completeSet();
                                              });
                                            } else {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      backgroundColor: Theme.of(
                                                              context)
                                                          .primaryColorLight,
                                                      content: Text(
                                                          'You forgot to mention how much weight you lifted 💪',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))));
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ));
                  }
                          // ),
                          ).toList()),
                ],
              ),
            ),
            //),
            ListTile(
              trailing: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).iconTheme.color,
                    )),
                child: Text(
                  'Add set',
                  style: TextStyle(color: Theme.of(context).buttonColor),
                ),

                //color: Colors.grey,
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
