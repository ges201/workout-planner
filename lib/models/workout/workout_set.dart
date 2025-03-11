import 'package:hive/hive.dart';

part 'workout_set.g.dart';

@HiveType(typeId: 2)
class WorkoutSet {
  @HiveField(0)
  final double weight;
  @HiveField(1)
  final int minReps;
  @HiveField(2)
  final int maxReps;
  @HiveField(3)
  final bool isRepRange;
  @HiveField(4)
  final int minRestSeconds;
  @HiveField(5)
  final int maxRestSeconds;
  @HiveField(6)
  final bool isRestRange;

  const WorkoutSet({
    this.weight = 0,
    this.minReps = 10,
    this.maxReps = 10,
    this.isRepRange = false,
    this.minRestSeconds = 60,
    this.maxRestSeconds = 60,
    this.isRestRange = false,
  });

  factory WorkoutSet.defaultSet() => const WorkoutSet();

  WorkoutSet copyWith({
    double? weight,
    int? minReps,
    int? maxReps,
    bool? isRepRange,
    int? minRestSeconds,
    int? maxRestSeconds,
    bool? isRestRange,
  }) {
    return WorkoutSet(
      weight: weight ?? this.weight,
      minReps: minReps ?? this.minReps,
      maxReps: maxReps ?? this.maxReps,
      isRepRange: isRepRange ?? this.isRepRange,
      minRestSeconds: minRestSeconds ?? this.minRestSeconds,
      maxRestSeconds: maxRestSeconds ?? this.maxRestSeconds,
      isRestRange: isRestRange ?? this.isRestRange,
    );
  }

  String formattedReps() {
    if (isRepRange) return '$minReps-$maxReps';
    return '$minReps';
  }

  String formattedRest() {
    String formatTime(int seconds) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (minutes > 0 && remainingSeconds == 0) return '${minutes}min';
      if (minutes > 0) {
        return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
      }
      return '${seconds}sec';
    }

    if (isRestRange) {
      return '${formatTime(minRestSeconds)}-${formatTime(maxRestSeconds)}';
    }
    return formatTime(minRestSeconds);
  }

  WorkoutSet copy() {
    return WorkoutSet(
      weight: weight,
      minReps: minReps,
      maxReps: maxReps,
      isRepRange: isRepRange,
      minRestSeconds: minRestSeconds,
      maxRestSeconds: maxRestSeconds,
      isRestRange: isRestRange,
    );
  }
}
