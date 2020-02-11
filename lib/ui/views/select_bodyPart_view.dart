import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/body_part.dart';
import 'package:scoped_log_me/models/exercise.dart';

class SelectBodyPart extends StatefulWidget {
  SelectBodyPart({Key key, this.exercise, this.onSelection}) : super(key: key);

  final Exercise exercise;
  final Function onSelection;

  @override
  _SelectBodyPartState createState() => _SelectBodyPartState();
}

class _SelectBodyPartState extends State<SelectBodyPart> {
  final expansionTile = new GlobalKey();
  String selectedBodyPart = 'Body Part';
  List<String> bodyParts = [
    'chest',
    'back',
    'arms',
    'shoulders',
    'legs',
    'core',
    'full_body',
    'cardio',
    'other'
  ];

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        key: GlobalKey(),
        title: new Text(this.selectedBodyPart),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
        children: bodyParts
            .map((bodyPart) => ListTileTheme(
                  dense: true,
                  child: ListTile(
                    title: Text(bodyPart.firstLetterToUpper()),
                    onTap: () {
                      setState(() {
                        this.selectedBodyPart = bodyPart;

                        BodyPart bp = BodyPart.values.firstWhere((value) =>
                            value.toString() == 'BodyPart.' + bodyPart);
                        widget.onSelection(bp);
                      });
                    },
                  ),
                ))
            .toList());
  }
}

// Extension method for string
extension StringExtension on String {
  get firstLetterToUpper {
    if (this != null) {
      return this[0].toUpperCase() + this.substring(1);
    } else
      return null;
  }
}
