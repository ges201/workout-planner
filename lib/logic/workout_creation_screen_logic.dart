import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise library/exercise.dart';
import '../models/workout/workout_day.dart';
import '../models/workout/workout_exercise.dart';
import '../models/workout/workout_set.dart';
import '../data/workout_repository.dart';

class WorkoutScreenLogic with ChangeNotifier {
  String workoutName;
  WorkoutDay? existingWorkout;
  final List<WorkoutExercise> selectedExercises = [];

  WorkoutScreenLogic({required this.workoutName, this.existingWorkout}) {
    if (existingWorkout != null) {
      selectedExercises.addAll(existingWorkout!.exercises.map((e) => e.copy()));
    }
  }

  /// Updates the workout name and notifies listeners
  void updateWorkoutName(String newName) {
    workoutName = newName;
    notifyListeners();
  }

  /// Getter to determine if there are unsaved changes
  bool get hasUnsavedChanges {
    if (existingWorkout == null) {
      // New workout: Different if name is not empty or exercises are added
      return workoutName.isNotEmpty || selectedExercises.isNotEmpty;
    } else {
      // Existing workout: Different if name or exercises have changed
      final nameChanged = workoutName != existingWorkout!.name;
      final exercisesChanged =
          !_areExercisesEqual(existingWorkout!.exercises, selectedExercises);
      return nameChanged || exercisesChanged;
    }
  }

  /// Helper method to compare two lists of exercises
  bool _areExercisesEqual(
    List<WorkoutExercise> list1,
    List<WorkoutExercise> list2,
  ) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].exercise.name != list2[i].exercise.name) return false;
      if (list1[i].sets.length != list2[i].sets.length) return false;
      for (int j = 0; j < list1[i].sets.length; j++) {
        final set1 = list1[i].sets[j];
        final set2 = list2[i].sets[j];
        if (set1.weight != set2.weight ||
            set1.minReps != set2.minReps ||
            set1.maxReps != set2.maxReps ||
            set1.minRestSeconds != set2.minRestSeconds ||
            set1.maxRestSeconds != set2.maxRestSeconds ||
            set1.isRepRange != set2.isRepRange ||
            set1.isRestRange != set2.isRestRange) {
          return false;
        }
      }
    }
    return true;
  }

  /// Adds a new exercise to the list
  void addExercise(Exercise exercise) {
    selectedExercises.add(
      WorkoutExercise(exercise: exercise, sets: [WorkoutSet.defaultSet()]),
    );
    notifyListeners();
  }

  /// Updates the weight of a specific set
  void updateSetWeight(int exerciseIndex, int setIndex, double weight) {
    selectedExercises[exerciseIndex]
        .sets[setIndex] = selectedExercises[exerciseIndex].sets[setIndex]
        .copyWith(weight: weight);
    notifyListeners();
  }

  /// Updates the rest time of a specific set
  void updateSetRest(
    int exerciseIndex,
    int setIndex,
    int minRestSeconds,
    int maxRestSeconds,
    bool isRestRange,
  ) {
    selectedExercises[exerciseIndex].sets[setIndex] =
        selectedExercises[exerciseIndex].sets[setIndex].copyWith(
          minRestSeconds: minRestSeconds,
          maxRestSeconds: maxRestSeconds,
          isRestRange: isRestRange,
        );
    notifyListeners();
  }

  /// Updates the reps of a specific set
  void updateSetReps(
    int exerciseIndex,
    int setIndex,
    int minReps,
    int maxReps,
    bool isRepRange,
  ) {
    selectedExercises[exerciseIndex]
        .sets[setIndex] = selectedExercises[exerciseIndex].sets[setIndex]
        .copyWith(minReps: minReps, maxReps: maxReps, isRepRange: isRepRange);
    notifyListeners();
  }

  /// Removes an exercise from the list
  void removeExercise(int index) {
    selectedExercises.removeAt(index);
    notifyListeners();
  }

  /// Removes a set from an exercise
  void removeSet(int exerciseIndex, int setIndex) {
    selectedExercises[exerciseIndex].sets.removeAt(setIndex);
    notifyListeners();
  }

  /// Adds a new set to an exercise
  void addSet(int exerciseIndex) {
    final exercise = selectedExercises[exerciseIndex];
    exercise.sets.add(exercise.sets.last.copyWith());
    notifyListeners();
  }

  /// Saves the workout to the repository
  Future<void> saveWorkout(BuildContext context) async {
    final repository = Provider.of<WorkoutRepository>(context, listen: false);
    if (existingWorkout != null) {
      existingWorkout!
        ..name = workoutName
        ..exercises = List.from(selectedExercises);
      await repository.saveWorkout(existingWorkout!);
    } else {
      final workout = WorkoutDay(
        name: workoutName,
        exercises: List.from(selectedExercises),
      );
      await repository.saveWorkout(workout);
      existingWorkout = workout;
    }
    notifyListeners();
  }
}
