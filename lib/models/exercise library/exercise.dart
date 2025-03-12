import 'muscle_groups.dart';
import 'exercise_categories.dart';
import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 5) // Unique type ID
class Exercise {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final ExerciseCategory category;

  @HiveField(2)
  final List<MuscleGroup> primaryMuscles;

  @HiveField(3)
  final List<MuscleGroup> secondaryMuscles;

  const Exercise({
    required this.name,
    required this.category,
    required this.primaryMuscles,
    required this.secondaryMuscles,
  });

  get id => null;

  Exercise copy({
    String? name,
    ExerciseCategory? category,
    List<MuscleGroup>? primaryMuscles,
    List<MuscleGroup>? secondaryMuscles,
  }) {
    return Exercise(
      name: name ?? this.name,
      category: category ?? this.category,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
    );
  }
}
