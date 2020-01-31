import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/ui/views/list_exercise_view.dart';

class DisplayExercise extends StatelessWidget {
  const DisplayExercise({Key key, this.model}) : super(key: key);

  final AppModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Exercise Page'),
      ),
      body: ScopedModel<AppModel>(
          model: model,
          child: Column(
            children: <Widget>[
              ListExercise(),
            ],
          )),
    );
  }
}
