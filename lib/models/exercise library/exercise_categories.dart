import 'package:hive/hive.dart';

part 'exercise_categories.g.dart';

@HiveType(typeId: 3) // Unique type ID
enum ExerciseCategory {
  @HiveField(0)
  freeWeights,
  @HiveField(1)
  machine,
  @HiveField(2)
  cables,
  @HiveField(3)
  freeBody
}