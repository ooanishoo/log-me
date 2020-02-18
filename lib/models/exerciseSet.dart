import 'package:enum_to_string/enum_to_string.dart';
import 'package:scoped_log_me/models/enums/exerciseSetType.dart';
class ExerciseSet {
  int index;
  double weight;
  int reps;
  bool isCheck;
  List<String> notes;
  ExerciseSetType type;

  ExerciseSet(
      {this.index,
      this.weight,
      this.reps,
      this.notes,
      this.isCheck = false,
      this.type = ExerciseSetType.workingSet});

  ExerciseSet.fromMap(Map<String, dynamic> map) {
    this.index = map['index'];
    this.weight = map['weight'];
    this.reps = map['reps'];
    this.isCheck = map['isCheck'];
    if(map['notes'] !=null){
      this.notes = new List<String>();
      map['notes'].forEach((v)=>notes.add(v.toString()));
    }
    this.type = EnumToString.fromString(ExerciseSetType.values, map['type']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['index'] = this.index;
    map['weight'] = this.weight;
    map['reps'] = this.reps;
    map['isCheck'] = this.isCheck;
    map['note'] = this.notes;
    map['type'] = EnumToString.parse(this.type);
    return map;
  }
}
