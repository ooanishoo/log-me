import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/exercise.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_model/scoped_model.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({Key key}) : super(key: key);

  @override
  _AddExerciseState createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (x, y, model) {
      return Column(children: <Widget>[
        TextField(
          controller: _controller,
        ),
        RaisedButton(
          child: Text('Submit'),
          onPressed: () {
            setState(() {
              print('name is :: ${_controller.text}');
              model.addExercise(Exercise(name: _controller.text));
              _controller.text = ""; // clear the input text
            });
          },
        ),
      ]);
    });
  }
}
