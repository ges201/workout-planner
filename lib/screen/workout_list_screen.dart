import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Add this import
import '../models/workout/workout_day.dart';
import 'workout_creation_screen.dart';
import '../logic/workout_list_screen_logic.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WatchBoxBuilder(
                box: Hive.box<WorkoutDay>('workouts'),
                builder: (context, box) {
                  final List<WorkoutDay> workouts =
                  box.values.cast<WorkoutDay>().toList();
                  if (workouts.isNotEmpty) {
                    return _buildWorkoutList(workouts, context);
                  } else {
                    return _buildEmptyState(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => const WorkoutCreationScreen(
                workoutName: '', // Provide an empty name initially
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Workout'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildWorkoutList(List<WorkoutDay> workouts, BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return _buildSwipeableWorkoutCard(context, workout);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  Widget _buildSwipeableWorkoutCard(BuildContext context, WorkoutDay workout) {
    final logic = Provider.of<WorkoutListLogic>(context, listen: false);
    final isExpanded = _expandedWorkouts.contains(workout.key.toString());

    return Slidable(
      key: Key(workout.key.toString()), // Use Hive's unique key
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed:
                (context) => logic.navigateToEditScreen(context, workout),
            backgroundColor: Colors.blue.shade100,
            foregroundColor: Colors.blue.shade800,
            icon: Icons.edit_note_rounded,
            borderRadius: BorderRadius.circular(16),
            autoClose: true, // Close the slider after action
            padding: EdgeInsets.zero, // Remove default padding
          ),
          const SizedBox(width: 3.5), // Add space between the buttons
          SlidableAction(
            onPressed: (context) => logic.deleteWorkout(context, workout),
            backgroundColor: Colors.red.shade100,
            foregroundColor: Colors.red.shade800,
            icon: Icons.delete_rounded,
            borderRadius: BorderRadius.circular(16),
            autoClose: true, // Close the slider after action
            padding: EdgeInsets.zero, // Remove default padding
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggleWorkoutExpansion(workout.key.toString()),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${workout.exercises.length} exercises',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.yMd().format(workout.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                if (isExpanded) ..._buildExerciseDetails(workout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              'No Workouts Yet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Tap the + button below to create your first workout',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  final Set<String> _expandedWorkouts = {};

  void _toggleWorkoutExpansion(String workoutKey) {
    setState(() {
      if (_expandedWorkouts.contains(workoutKey)) {
        _expandedWorkouts.remove(workoutKey);
      } else {
        _expandedWorkouts.add(workoutKey);
      }
    });
  }

  List<Widget> _buildExerciseDetails(WorkoutDay workout) {
    return [
      const SizedBox(height: 12),
      const Divider(),
      const SizedBox(height: 8),
      ...workout.exercises.map((exercise) {
        final firstSet = exercise.sets.first;
        String repsText;

        if (firstSet.isRepRange) {
          repsText = "${firstSet.minReps}-${firstSet.maxReps}";
        } else {
          repsText = "${firstSet.minReps}";
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "${exercise.exercise.name} ${exercise.sets.length} x $repsText",
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        );
      }),
    ];
  }
}