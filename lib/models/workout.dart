import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:scoped_log_me/models/exercise.dart';

class Workout {
  int id;
  String name;
  DateTime date;
  bool isActive;
  List<Exercise> exercises = [];

  List get getExercise => exercises;
  set setExercise(List<Exercise> value) => this.exercises = value;

  Workout({
    this.id,
    this.name,
    this.exercises,
    this.isActive = false,
    this.date,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(this.id != null){
      map['id'] = this.id;
    }
    map['name'] = this.name;
    map['isActive'] = this.isActive;
    // Since DateTime is not a supported type in sembast
    map['date'] = this.date.toIso8601String();
    if (this.exercises != null) {
      map['exercises'] = this.exercises.map((ex) => ex.toMap()).toList();
    }
    return map;
  }

  Workout.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    // Since DateTime is not a supported type in sembast
    this.date = DateTime.parse(map['date']);
    this.isActive = map['isActive'];
    if (map['exercises'] != null) {
      this.exercises = new List<Exercise>();
      map['exercises'].forEach((map) {
        exercises.add(Exercise.fromMap(map));
      });
    }
  }
}
