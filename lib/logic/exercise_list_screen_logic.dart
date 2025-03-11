import 'package:flutter/material.dart';
import '../models/exercise library/exercise.dart';
import '../models/exercise library/muscle_groups.dart';
import '../models/exercise library/exercise_categories.dart';
import '../data/exercise_seed.dart';

class ExerciseProvider extends ChangeNotifier {
  //Core exercise data
  final List<Exercise> _exerciseList = kDefaultExercises;
  List<Exercise> get exerciseList => List.unmodifiable(_exerciseList);

  // Filter parameters
  final Set<ExerciseCategory> _selectedCategories = {};
  final Set<MuscleGroup> _selectedMuscles = {};
  String _searchQuery = '';

  // Selection state
  final Set<Exercise> _selectedExercises = {};

  // Getters for external access
  Set<ExerciseCategory> get selectedCategories => _selectedCategories;
  Set<MuscleGroup> get selectedMuscles => _selectedMuscles;
  Set<Exercise> get selectedExercises => Set.unmodifiable(_selectedExercises);

  //=====================
  // Selection Management
  //=====================
  void toggleExerciseSelection(Exercise exercise) {
    _selectedExercises.contains(exercise)
        ? _selectedExercises.remove(exercise)
        : _selectedExercises.add(exercise);
    notifyListeners();
  }

  void clearSelectedExercises() {
    _selectedExercises.clear();
    notifyListeners();
  }

  //=================
  // Filter Management
  //=================
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleCategory(ExerciseCategory category) {
    _selectedCategories.contains(category)
        ? _selectedCategories.remove(category)
        : _selectedCategories.add(category);
    notifyListeners();
  }

  void toggleMuscle(MuscleGroup muscle) {
    _selectedMuscles.contains(muscle)
        ? _selectedMuscles.remove(muscle)
        : _selectedMuscles.add(muscle);
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategories.clear();
    _selectedMuscles.clear();
    notifyListeners();
  }

  //=====================
  // Filtered Exercise List
  //=====================
  List<Exercise> get filteredExercises {
    return _exerciseList.where((exercise) {
      final nameMatch = exercise.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final categoryMatch =
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(exercise.category);

      final muscleMatch =
          _selectedMuscles.isEmpty ||
          exercise.primaryMuscles.any((m) => _selectedMuscles.contains(m));

      return nameMatch && categoryMatch && muscleMatch;
    }).toList();
  }
}
