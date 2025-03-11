import 'package:flutter/material.dart';
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

  /// Handles workout deletion with error feedback
  Future<void> deleteWorkout(BuildContext context, WorkoutDay workout) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      await repository.deleteWorkout(workout);
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Deleted ${workout.name}'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Failed to delete: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
