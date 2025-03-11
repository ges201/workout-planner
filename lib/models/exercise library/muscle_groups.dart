import 'package:hive/hive.dart';

part 'muscle_groups.g.dart';

@HiveType(typeId: 4) // Unique type ID
enum MuscleGroup {
  @HiveField(0) chest,
  @HiveField(1) back,
  @HiveField(2) triceps,
  @HiveField(3) biceps,
  @HiveField(4) shoulders,
  @HiveField(5) lowerBack,
  @HiveField(6) core,
  @HiveField(7) glutes,
  @HiveField(8) hamstrings,
  @HiveField(9) quadriceps,
  @HiveField(10) calves,
  @HiveField(11) abs,
}