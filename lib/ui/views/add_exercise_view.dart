//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/enums/exercise_category.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/ui/components/select_item.dart';
import 'package:scoped_log_me/ui/views/select_bodyPart_view.dart';
import 'package:scoped_log_me/ui/views/select_category_view.dart';
import 'package:scoped_model/scoped_model.dart';

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

  @override
  Widget build(BuildContext context) {
    List<String> categories = [];
    ExerciseCategory.values.map((v) => categories.add(v.toString()));

    TextEditingController _controller =
        TextEditingController(text: ex.name ?? '');

    return ScopedModelDescendant<AppModel>(builder: (x, y, model) {
      return Column(children: <Widget>[
        ListTile(
          title: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            decoration: InputDecoration(hintText: 'Add name'),
          ),
        ),
        SelectBodyPart(
          exercise: ex,
          onSelection: ((value) => ex.bodyPart = value),
        ),
        SelectExerciseCategory(
          exercise: ex,
          onSelection: ((value) => ex.exerciseCategory = value),
        ),
        RaisedButton(
          color: Theme.of(context).accentColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
    });
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
