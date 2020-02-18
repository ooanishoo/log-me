import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_log_me/models/enums/body_part.dart';
import 'package:scoped_log_me/models/exercise.dart';

class SelectBodyPart extends StatefulWidget {
  SelectBodyPart({Key key, this.exercise, this.onSelection}) : super(key: key);

  final Exercise exercise;
  final Function onSelection;

  @override
  _SelectBodyPartState createState() => _SelectBodyPartState(exercise);
}

class _SelectBodyPartState extends State<SelectBodyPart> {
  final Exercise exercise;
  String selectedBodyPart;
  List<String> bodyParts = [];

  final expansionTile = new GlobalKey();

  _SelectBodyPartState(this.exercise);

  @override
  void initState() {
    super.initState();
    exercise.bodyPart == null
        ? this.selectedBodyPart = 'Body Part'
        : this.selectedBodyPart = EnumToString.parse(exercise.bodyPart);
    getBodyparts();
  }

  void getBodyparts() {
    BodyPart.values
        .forEach((v) => this.bodyParts.add(describeEnum(v).toString()));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        key: GlobalKey(),
        title: new Text(this.selectedBodyPart.firstLetterToUpper()),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
        children: bodyParts
            .map((bodyPart) => Visibility(
                  visible:
                      this.selectedBodyPart == bodyPart ? false : true,
                  child: ListTileTheme(
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
