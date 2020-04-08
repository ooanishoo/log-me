//import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/models/enums/body_part.dart';
import 'package:scoped_log_me/models/enums/exercise_category.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_select/smart_select.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({
    Key key,
    this.exercise,
    this.isUpdateMode = false,
  }) : super(key: key);

  final Exercise exercise;
  final bool isUpdateMode;

  @override
  _AddExerciseState createState() => _AddExerciseState(exercise);
}

class _AddExerciseState extends State<AddExercise> {
  Exercise ex;
  _AddExerciseState(this.ex);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  FocusNode _focusNode = new FocusNode();

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [];
    ExerciseCategory.values.map((v) => categories.add(v.toString()));

    List<SmartSelectOption<String>> bodyParts = [];
    BodyPart.values.forEach((v) => bodyParts.add(SmartSelectOption<String>(
          value: v.toString(),
          title: describeEnum(v).toString().firstLetterToUpperCase(),
        )));

    List<SmartSelectOption<String>> exerciseCategories = [];
    ExerciseCategory.values
        .forEach((v) => exerciseCategories.add(SmartSelectOption<String>(
              value: v.toString(),
              title: describeEnum(v).toString().firstLetterToUpperCase(),
            )));

    TextEditingController _controller =
        TextEditingController(text: ex.name ?? '');

    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ScopedModelDescendant<AppModel>(builder: (x, y, model) {
          return Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(children: <Widget>[
                ListTile(
                  title: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    decoration: InputDecoration(hintText: 'Add name'),
                    onChanged: ((val) => ex.name = val),
                    validator: (value) {
                      print('validator :: $value');
                      if (value.isEmpty) {
                        print('weight is empty');
                        return 'Please enter exercise name';
                      }
                      return null;
                    },
                  ),
                ),
                SmartSelect<String>.single(
                  title: 'Body Part',
                  placeholder: 'Required',
                  options: bodyParts,
                  value: ex.bodyPart.toString().firstLetterToUpperCase(),
                  onChange: (val) {
                    BodyPart bp = BodyPart.values.firstWhere(
                        (value) => value.toString() == val,
                        orElse: () => null);
                    setState(() => ex.bodyPart = bp);
                  },
                  modalType: SmartSelectModalType.bottomSheet,
                  modalConfig: SmartSelectModalConfig(
                    headerStyle: SmartSelectModalHeaderStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        )),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        textStyle: TextStyle(color: Colors.white)),
                    title: 'Select body Part',
                    style: SmartSelectModalStyle(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  choiceConfig: SmartSelectChoiceConfig(
                    style: SmartSelectChoiceStyle(
                      titleStyle: TextStyle(color: Colors.white),
                      checkColor: Theme.of(context).accentColor,
                      activeColor: Theme.of(context).accentColor,
                      inactiveColor: Theme.of(context).disabledColor,
                    ),
                  ),
                  choiceType: SmartSelectChoiceType.radios,
                ),
                SmartSelect<String>.single(
                  title: 'Exercise Category',
                  placeholder: 'None',
                  options: exerciseCategories,
                  value:
                      ex.exerciseCategory.toString().firstLetterToUpperCase(),
                  onChange: (val) {
                    ExerciseCategory exCat = ExerciseCategory.values.firstWhere(
                        (value) => value.toString() == val,
                        orElse: () => null);
                    setState(() => ex.exerciseCategory = exCat);
                  },
                  modalType: SmartSelectModalType.bottomSheet,
                  modalConfig: SmartSelectModalConfig(
                    headerStyle: SmartSelectModalHeaderStyle(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        )),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        textStyle: TextStyle(color: Colors.white)),
                    title: 'Select Exercise Category',
                    style: SmartSelectModalStyle(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  choiceConfig: SmartSelectChoiceConfig(
                    style: SmartSelectChoiceStyle(
                      titleStyle: TextStyle(color: Colors.white),
                      checkColor: Theme.of(context).accentColor,
                      activeColor: Theme.of(context).accentColor,
                      inactiveColor: Theme.of(context).disabledColor,
                    ),
                  ),
                  choiceType: SmartSelectChoiceType.radios,
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text('Save'),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    if (_formKey.currentState.validate()) {
                      ex.name = _controller.text;
                      print('name is :: ${_controller.text}');
                      widget.isUpdateMode
                          ? await model.updateExercise(ex)
                          : await model.addExercise(ex);
                      setState(() {
                        _controller.text = "";
                        Navigator.pop(context, true);
                      });
                    } else {
                      // Enable autoValidate
                      setState(() => _autoValidate = true);
                      // Focus the keyboard on the exercise name
                      FocusScope.of(context).requestFocus(_focusNode);
                    }
                  },
                ),
              ]));
        }));
  }

//   Widget _exerciseCategoryMenu(AppModel model, Exercise exercise) =>
//       PopupMenuButton<String>(
//         child: FlatButton(
//           onPressed: () {},
//           child: exercise.exerciseCategory == null
//               ? Text('None')
//               : Text(describeEnum(exercise.exerciseCategory).toString().toUpperCase()),
//         ),
//         itemBuilder: (context) => [
//           PopupMenuItem(
//             value: "barbell",
//             child: Text("Barbell"),
//           ),
//           PopupMenuItem(
//             value: "dumbbell",
//             child: Text("Dumbbell"),
//           ),
//           PopupMenuItem(
//             value: "machine",
//             child: Text("Machine"),
//           ),
//           PopupMenuItem(
//             value: "cardio",
//             child: Text("Cardio"),
//           ),
//           PopupMenuItem(
//             value: "duration",
//             child: Text("Duration"),
//           ),
//           PopupMenuItem(
//             value: "reps_only",
//             child: Text("Reps Only"),
//           ),
//         ],
//         onSelected: (action) {
//           switch (action) {
//             case "barbell":
//               model.updateExerciseCategory(exercise, ExerciseCategory.ExerciseCategory.barbell);
//               break;
//             case "dumbbell":
//               model.updateExerciseCategory(
//                   exercise, ExerciseCategory.ExerciseCategory.dumbbell);
//               break;
//             case "machine":
//               model.updateExerciseCategory(exercise, ExerciseCategory.ExerciseCategory.machine);
//               break;
//             case "cardio":
//               model.updateExerciseCategory(exercise, ExerciseCategory.ExerciseCategory.cardio);
//               break;
//             case "duration":
//               model.updateExerciseCategory(
//                   exercise, ExerciseCategory.ExerciseCategory.duration);
//               break;
//             case "reps_only":
//               model.updateExerciseCategory(
//                   exercise, ExerciseCategory.ExerciseCategory.reps_only);
//               break;
//             default:
//           }
//           print("value:$action");
//         },
//       );
}

// Extension method for string
extension StringExtension on String {
  get firstLetterToUpperCase {
    if (this != null) {
      return this[0].toUpperCase() + this.substring(1).replaceAll('_', ' ');
    } else
      return null;
  }
}

extension ExtendedText on Widget {
  addContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      color: Colors.yellow,
      child: this,
    );
  }
}
