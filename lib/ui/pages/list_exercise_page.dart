import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/ui/pages/add_exercise_page.dart';
import 'package:scoped_log_me/ui/views/list_exercise_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';

class ListExercisePage extends StatefulWidget {
  const ListExercisePage({Key key, this.model}) : super(key: key);

  final AppModel model;

  @override
  _ListExercisePageState createState() => _ListExercisePageState();
}

class _ListExercisePageState extends State<ListExercisePage> {
  TextEditingController _controller = new TextEditingController();
  String filter = '';
  List<Exercise> selectedExercises = [];
  bool tapped = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print('listening');
      print(_controller.text.length);
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
          title: Text('Exercises'),
          centerTitle: false,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddExercisePage(
                            model: widget.model,
                            exercise: new Exercise(
                              id: Random().nextInt(1000000),
                            ))));
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
              child: ListExercise(
                filter: filter,
                hasActions: true,
              ),
            ),
          ],
        ));
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListTile(
        title: TextField(
          onChanged: (text) {
            print(text);
          },
          onTap: (() => this.tapped = true),
          controller: _controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).primaryColorLight,
            hintText: "Search Exercise",
            hintStyle: TextStyle(
              color: Theme.of(context).accentTextTheme.title.color,
            ),
            suffixIcon: this._controller.text.length == 0
                ? Container(
                    width: 0,
                  )
                : IconButton(
                    icon: Icon(Icons.cancel),
                    color: Theme.of(context).accentIconTheme.color,
                    onPressed: (() => setState(() => _controller.clear())),
                  ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ),
        trailing: this.tapped == true
            ? FlatButton(
                child: Text('Cancel'),
                onPressed: (() {
                  _controller.clear(); // clear the text in searchBar
                  FocusScope.of(context).unfocus(); // hide the keyboard
                }),
              )
            : Container(width: 0),
      ),
    );
  }
}
