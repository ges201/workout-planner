import '../models/exercise library/exercise.dart';
import '../models/exercise library/exercise_categories.dart';
import '../models/exercise library/muscle_groups.dart';

/// Immutable seed data for exercises
const kDefaultExercises = [
  Exercise(
    // Add const before Exercise
    name: "Barbell Bench Press",
    category: ExerciseCategory.freeWeights,
    primaryMuscles: [MuscleGroup.chest], // Add const here
    secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
  ),
  Exercise(
    // Repeat for all entries
    name: "Lat Pulldown",
    category: ExerciseCategory.machine,
    primaryMuscles: [MuscleGroup.back],
    secondaryMuscles: [MuscleGroup.biceps],
  ),
  Exercise(
    name: "Pull-ups",
    category: ExerciseCategory.freeBody,
    primaryMuscles: [MuscleGroup.back],
    secondaryMuscles: [MuscleGroup.biceps],
  ),
];
