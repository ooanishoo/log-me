//import 'package:flutter/foundation.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/enums/body_part.dart';
import 'package:scoped_log_me/models/enums/exercise_category.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/ui/views/select_bodyPart_view.dart';
import 'package:scoped_log_me/ui/views/select_category_view.dart';
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
  String _exerciseCategory;

  @override
  Widget build(BuildContext context) {
    List<String> categories = [];
    ExerciseCategory.values.map((v) => categories.add(v.toString()));

    List<SmartSelectOption<String>> bodyParts = [];
    BodyPart.values.forEach((v) => bodyParts.add(
          SmartSelectOption<String>(
              value: v.toString(),
              title: describeEnum(v).toString().firstLetterToUppers()),
        ));

    List<SmartSelectOption<String>> exerciseCategories = [];
    ExerciseCategory.values.forEach((v) => exerciseCategories.add(
          SmartSelectOption<String>(
              value: v.toString(),
              title: describeEnum(v).toString().firstLetterToUppers()),
        ));

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
          return Column(children: <Widget>[
            ListTile(
              title: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _controller,
                decoration: InputDecoration(hintText: 'Add name'),
                onChanged: ((val) => ex.name = val),
              ),
            ),
            SmartSelect<String>.single(
              title: 'Body Part',
              options: bodyParts,
              value: ex.bodyPart.toString().firstLetterToUppers(),
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
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    textStyle: TextStyle(color: Colors.white)),
                title: 'Select body Part',
                style: SmartSelectModalStyle(
                    backgroundColor: Colors.transparent),
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
              options: exerciseCategories,
              value: ex.exerciseCategory.toString().firstLetterToUppers(),
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
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    textStyle: TextStyle(color: Colors.white)),
                title: 'Select Exercise Category',
                style: SmartSelectModalStyle(
                    backgroundColor: Colors.transparent),
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
                ex.name = _controller.text;
                print('name is :: ${_controller.text}');
                widget.isUpdateMode
                    ? await model.updateExercise(ex)
                    : await model.addExercise(ex);
                setState(() {
                  _controller.text = "";
                  Navigator.pop(context, true);
                });
              },
            ),
          ]);
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
  get firstLetterToUppers {
    if (this != null) {
      return this[0].toUpperCase() + this.substring(1);
    } else
      return null;
  }
}
