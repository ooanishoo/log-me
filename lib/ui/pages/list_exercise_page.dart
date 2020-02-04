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

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print('listening');
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
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddExercisePage(model: widget.model)));
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
                hasCheckbox: false,
              ),
            ),
          ],
        ));
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) {
          print(text);
        },
        controller: _controller,
        decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }
}
