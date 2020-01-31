enum ExerciseSetType { warmupSet, dropSet, failureSet, workingSet }

class ExerciseSet {
  int index;
  double weight;
  int reps;
  bool isCheck;
  List<String> note;
  ExerciseSetType type;

  ExerciseSet(
      {this.index,
      this.weight,
      this.reps,
      this.note,
      this.isCheck = false,
      this.type = ExerciseSetType.workingSet});

  ExerciseSet.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    weight = json['weight'];
    reps = json['reps'];
    isCheck = json['isCheck'];
    type = json['type'];
    note = json['note'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['weight'] = this.weight;
    data['reps'] = this.reps;
    data['isCheck'] = this.isCheck;
    data['note'] = this.note;
    data['type'] = this.type;
    return data;
  }
}
