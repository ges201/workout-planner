import 'package:hive/hive.dart';
import 'package:workout_planner/models/workout/workout_set.dart';
import '../exercise library/exercise.dart';

part 'workout_exercise.g.dart';

@HiveType(typeId: 1)
class WorkoutExercise {
  @HiveField(0)
  final Exercise exercise;

  @HiveField(1)
  final List<WorkoutSet> sets;

  WorkoutExercise({required this.exercise, List<WorkoutSet>? sets})
    : sets = sets ?? [WorkoutSet.defaultSet()];

  WorkoutExercise copy() {
    return WorkoutExercise(
      exercise: exercise.copy(), // Ensure Exercise has a copy method
      sets:
          sets
              .map((set) => set.copy())
              .toList(), // Ensure WorkoutSet has a copy method
    );
  }
}
