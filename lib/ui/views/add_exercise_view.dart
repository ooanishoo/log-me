import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/ui/views/select_bodyPart_view.dart';
import 'package:scoped_log_me/ui/views/select_category_view.dart';
import 'package:scoped_model/scoped_model.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({
    Key key,
  }) : super(key: key);

  @override
  _AddExerciseState createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  TextEditingController _controller = TextEditingController();
  Exercise ex = Exercise();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (x, y, model) {
      return Column(children: <Widget>[
        ListTile(
          title: TextField(
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
          onSelection: ((value) => ex.category = value),
        ),
        RaisedButton(
          color: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text('Save'),
          onPressed: () {
            setState(() async {
              print('name is :: ${_controller.text}');
              ex.name = _controller.text;
              await model.addExercise(ex);
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
//           child: exercise.category == null
//               ? Text('None')
//               : Text(describeEnum(exercise.category).toString().toUpperCase()),
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
//               model.updateExerciseCategory(exercise, Category.Category.barbell);
//               break;
//             case "dumbbell":
//               model.updateExerciseCategory(
//                   exercise, Category.Category.dumbbell);
//               break;
//             case "machine":
//               model.updateExerciseCategory(exercise, Category.Category.machine);
//               break;
//             case "cardio":
//               model.updateExerciseCategory(exercise, Category.Category.cardio);
//               break;
//             case "duration":
//               model.updateExerciseCategory(
//                   exercise, Category.Category.duration);
//               break;
//             case "reps_only":
//               model.updateExerciseCategory(
//                   exercise, Category.Category.reps_only);
//               break;
//             default:
//           }
//           print("value:$action");
//         },
//       );
}
