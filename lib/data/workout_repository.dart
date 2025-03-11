import 'package:hive/hive.dart';
import '../models/workout/workout_day.dart';

class WorkoutRepository {
  static const _boxName = 'workouts';

  Future<Box<WorkoutDay>> get _box async => await Hive.openBox(_boxName);

  Future<void> saveWorkout(WorkoutDay workout) async {
    final box = await _box;
    if (workout.key != null) {
      await box.put(workout.key, workout); // Force update using put()
    } else {
      await box.add(workout);
    }
  }

  Future<List<WorkoutDay>> getAllWorkouts() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> deleteWorkout(WorkoutDay workout) async {
    final box = await _box;
    final index = box.values.toList().indexOf(workout);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  Future<void> updateWorkout(WorkoutDay workout) async {
    final box = await _box;
    if (workout.key != null) {
      await box.put(workout.key, workout);
    }
  }
}