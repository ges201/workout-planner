import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/exercise_list_screen_logic.dart';
import '../models/exercise library/exercise.dart';
import '../utils/enum_utils.dart';
import '../models/exercise library/exercise_categories.dart';
import '../models/exercise library/muscle_groups.dart';
import 'exercise_info_screen.dart';

/// A screen that displays a list of exercises with search and filtering capabilities.
/// Can be used in selection mode to allow users to pick exercises.
class ExerciseListScreen extends StatefulWidget {
  /// Whether the screen should allow selection of multiple exercises
  final bool isSelectionMode;

  const ExerciseListScreen({super.key, this.isSelectionMode = false});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ExerciseProvider>(context, listen: false);
    provider.clearFilters();
    provider.clearSelectedExercises();
  }

  @override
  void dispose() {
    // Optionally keep this for cleanup when the screen is permanently removed
    final provider = Provider.of<ExerciseProvider>(context, listen: false);
    provider.clearFilters();
    provider.clearSelectedExercises();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(children: [_buildSearchBar(context), _buildExerciseList()]),
    );
  }

  //===================================
  // Main UI Components
  //===================================

  /// Builds the app bar with a title and actions based on selection mode
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        widget.isSelectionMode ? 'Select Exercises' : 'Exercise List',
      ),
      actions:
          widget.isSelectionMode
              ? [
                Consumer<ExerciseProvider>(
                  builder:
                      (context, provider, _) => TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            provider.selectedExercises.toList(),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Done'),
                      ),
                ),
              ]
              : null,
    );
  }

  /// Builds the main exercise list with filtered results
  Widget _buildExerciseList() {
    return Expanded(
      child: Consumer<ExerciseProvider>(
        builder: (context, provider, _) {
          if (provider.filteredExercises.isEmpty) {
            return const Center(
              child: Text(
                'No exercises found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = provider.filteredExercises[index];
              final isSelected =
                  widget.isSelectionMode &&
                  provider.selectedExercises.contains(exercise);

              return _buildExerciseCard(provider, exercise, isSelected);
            },
          );
        },
      ),
    );
  }

  /// Builds an individual exercise card with appropriate actions
  Widget _buildExerciseCard(
    ExerciseProvider provider,
    Exercise exercise,
    bool isSelected,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          exercise.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${enumToString(exercise.category)} | ${exercise.primaryMuscles.map((m) => enumToString(m)).join(', ')}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        trailing:
            widget.isSelectionMode
                ? Checkbox(
                  value: isSelected,
                  onChanged: (_) => provider.toggleExerciseSelection(exercise),
                )
                : const Icon(Icons.info_outline, color: Colors.blue, size: 30),
        onTap:
            widget.isSelectionMode
                ? () => provider.toggleExerciseSelection(exercise)
                : () => _showExerciseInfo(context, exercise),
      ),
    );
  }

  //===================================
  // Search and Filter Components
  //===================================

  /// Builds the search bar with filter button
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          return TextField(
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color:
                      provider.selectedCategories.isNotEmpty ||
                              provider.selectedMuscles.isNotEmpty
                          ? Colors.blue
                          : Colors.grey,
                ),
                onPressed: () => _showFilterDialog(context),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onChanged: provider.setSearchQuery,
          );
        },
      ),
    );
  }

  /// Displays a dialog for filtering exercises by category and muscle group
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeIn,
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: Consumer<ExerciseProvider>(
              builder:
                  (context, provider, _) => AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.filter_alt, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Filters'),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterSection(
                            title: 'Exercise Type',
                            options: ExerciseCategory.values,
                            currentSelection: provider.selectedCategories,
                            onToggled: provider.toggleCategory,
                          ),
                          const Divider(height: 30),
                          _buildFilterSection(
                            title: 'Muscle Group',
                            options: MuscleGroup.values,
                            currentSelection: provider.selectedMuscles,
                            onToggled: provider.toggleMuscle,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: provider.clearFilters,
                        child: const Text('Clear All'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
            ),
          ),
    );
  }

  /// Builds a section of filter options (categories or muscle groups)
  Widget _buildFilterSection<T>({
    required String title,
    required List<T> options,
    required Set<T> currentSelection,
    required Function(T) onToggled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              options.map((option) {
                final isSelected = currentSelection.contains(option);
                return ChoiceChip(
                  label: Text(
                    enumToString(option),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  selected: isSelected,
                  showCheckmark: false,
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (_) => onToggled(option),
                );
              }).toList(),
        ),
      ],
    );
  }

  //===================================
  // Exercise Details Modal
  //===================================

  /// Shows a modal bottom sheet with detailed exercise information
  void _showExerciseInfo(BuildContext context, Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseInfoScreen(exercise: exercise),
      ),
    );
  }
}
