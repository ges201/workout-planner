import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:workout_planner/logic/workout_creation_screen_logic.dart';
import 'package:provider/provider.dart';
import '../data/workout_repository.dart';
import '../models/workout/workout_day.dart';
import '../screen/workout_creation_screen.dart';

class WorkoutListLogic {
  final WorkoutRepository repository;

  WorkoutListLogic(this.repository);

  /// Loads all workouts from the repository
  Future<List<WorkoutDay>> loadWorkouts() async {
    return await repository.getAllWorkouts();
  }

  /// Provides a listenable for workouts
  ValueListenable<Box<WorkoutDay>> getWorkoutsListenable() {
    return repository.getWorkoutsListenable();
  }

  /// Handles workout deletion
  Future<void> deleteWorkout(WorkoutDay workout) async {
    await repository.deleteWorkout(workout);
  }

  /// Navigates to the workout creation screen for editing
  void navigateToEditScreen(BuildContext context, WorkoutDay workout) {
    // Pass the ORIGINAL workout instance
    final logic = WorkoutScreenLogic(
      workoutName: workout.name,
      existingWorkout: workout, // <-- No copy here
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChangeNotifierProvider.value(
              value: logic,
              child: WorkoutCreationScreen(
                workoutName: workout.name,
                existingWorkout: workout, // <-- Original workout
              ),
            ),
      ),
    );
  }
}
