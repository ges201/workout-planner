import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'logic/workout_creation_screen_logic.dart';
import 'models/exercise library/exercise.dart';
import 'models/exercise library/exercise_categories.dart';
import 'models/exercise library/muscle_groups.dart';
import 'models/workout/workout_day.dart';
import 'models/workout/workout_exercise.dart';
import 'models/workout/workout_set.dart';
import 'screen/home_screen.dart';
import 'logic/exercise_list_screen_logic.dart';
import 'data/workout_repository.dart';
import 'logic/workout_list_screen_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(WorkoutDayAdapter());
  Hive.registerAdapter(WorkoutExerciseAdapter());
  Hive.registerAdapter(WorkoutSetAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(ExerciseCategoryAdapter());
  Hive.registerAdapter(MuscleGroupAdapter());
  await Hive.openBox<WorkoutDay>('workouts');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WorkoutScreenLogic(workoutName: ''),
        ),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
        Provider(create: (context) => WorkoutRepository()),
        Provider(
          create:
              (context) => WorkoutListLogic(
                Provider.of<WorkoutRepository>(context, listen: false),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
