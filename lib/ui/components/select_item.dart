// import 'package:enum_to_string/enum_to_string.dart';
// import 'package:flutter/material.dart';
// import 'package:scoped_log_me/models/enums/body_part.dart';
// import 'package:scoped_log_me/models/enums/exerciseCategory.dart';
// import 'package:scoped_log_me/models/exercise.dart';

// class SelectItem extends StatefulWidget {
//   SelectItem(
//       {Key key,
//       this.exercise,
//       this.onSelection,
//       this.data,
//       this.placeHolder = 'Select an item',
//       this.items,
//       this.type,
//       this.className})
//       : super(key: key);

//   final Exercise exercise;
//   final Function onSelection;
//   final dynamic data;
//   final String placeHolder;
//   final List<String> items;
//   final Type type;
//   final String className;

//   @override
//   _SelectItemState createState() =>
//       _SelectItemState(exercise, type, className, data);
// }

// class _SelectItemState extends State<SelectItem> {
//   final Exercise exercise;
//   final dynamic data;
//   final Type type;
//   final String className;

//   String selectedItem;

//   final expansionTile = new GlobalKey();

//   _SelectItemState(this.exercise, this.type, this.className, this.data);

//   @override
//   void initState() {
//     // typeofwidget.data
//     super.initState();
//     exercise.exerciseCategory == null
//         ? this.selectedItem = widget.placeHolder
//         : this.selectedItem = EnumToString.parse(exercise.exerciseCategory);
//     Type type = className as Type;
//     print(type.toString());
//     if (data is ExerciseCategory) {
//       print('its exerciseCategory');
//     }
//     if (data is BodyPart) {
//       print('its BodyPart');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(title: Text('test'));
//     // return ExpansionTile(
//     //     key: GlobalKey(),
//     //     title: new Text(this.selectedItem),
//     //     backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
//     //     children: widget.items
//     //         .map((exerciseCategory) => Visibility(
//     //               visible: this.selectedItem == exerciseCategory ? false : true,
//     //               child: ListTileTheme(
//     //                 dense: true,
//     //                 child: ListTile(
//     //                   title: Text(exerciseCategory.firstLetterToUpper()),
//     //                   onTap: () {
//     //                     setState(() {
//     //                       this.selectedItem = exerciseCategory;

//     //                       ExerciseCategory cat = ExerciseCategory.values.firstWhere((value) =>
//     //                           value.toString() == 'ExerciseCategory.' + exerciseCategory);
//     //                       widget.onSelection(cat);
//     //                     });
//     //                   },
//     //                 ),
//     //               ),
//     //             ))
//     //         .toList());
//   }
// }

// // Extension method for string
// extension StringExtension on String {
//   get firstLetterToUpper {
//     if (this != null) {
//       return this[0].toUpperCase() + this.substring(1);
//     } else
//       return null;
//   }
// }
