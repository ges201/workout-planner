import 'workout_exercise.dart';
import 'package:hive/hive.dart';

part 'workout_day.g.dart';

@HiveType(typeId: 0)
class WorkoutDay extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  List<WorkoutExercise> exercises;

  WorkoutDay({required this.name, required this.exercises, DateTime? date})
    : date = date ?? DateTime.now();

  WorkoutDay copyWith({
    String? name,
    List<WorkoutExercise>? exercises,
    DateTime? date,
  }) {
    final copy = WorkoutDay(
      name: name ?? this.name,
      exercises: exercises ?? List.from(this.exercises),
      date: date ?? this.date,
    );

    // If this object is already in a box, you'll need to save the copy separately
    return copy;
  }
}
