import 'package:get_it/get_it.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Register services

  // Register models
  locator.registerLazySingleton<AppModel>(() => AppModel());
  locator.registerLazySingleton<WorkoutModel>(() => WorkoutModel());
}
