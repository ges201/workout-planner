import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/workout_creation_screen_logic.dart';
import '../models/exercise library/exercise.dart';
import '../models/workout/workout_day.dart';
import '../models/workout/workout_exercise.dart';
import '../models/workout/workout_set.dart';
import 'exercise_list_screen.dart';

class WorkoutCreationScreen extends StatefulWidget {
  final String workoutName;
  final WorkoutDay? existingWorkout;

  const WorkoutCreationScreen({
    super.key,
    required this.workoutName,
    this.existingWorkout,
  });

  @override
  State<WorkoutCreationScreen> createState() => _WorkoutCreationScreenState();
}

class _WorkoutCreationScreenState extends State<WorkoutCreationScreen> {
  late final WorkoutScreenLogic logic;
  late final FocusNode _workoutNameFocusNode;
  late TextEditingController _workoutNameController;

  @override
  void initState() {
    super.initState();
    _workoutNameFocusNode = FocusNode();
    _workoutNameController = TextEditingController(text: widget.workoutName);
    logic = Provider.of<WorkoutScreenLogic>(context, listen: false);
    logic.workoutName = widget.workoutName;
  }

  @override
  void dispose() {
    logic.selectedExercises.clear();
    logic.workoutName = '';
    _workoutNameFocusNode.dispose();
    _workoutNameController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!logic.hasUnsavedChanges) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _buildUnsavedChangesDialog(context),
    );
    return result ?? false;
  }

  Widget _buildUnsavedChangesDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Unsaved Changes'),
      content: const Text(
        'You have unsaved changes. Do you want to save before exiting?',
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Discard'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
          (logic.workoutName.isNotEmpty &&
              logic.selectedExercises.isNotEmpty)
              ? () async {
            try {
              await logic.saveWorkout(context);
              if (context.mounted) Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout saved'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save workout: $e')),
                );
                Navigator.of(context).pop(false);
              }
            }
          }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer<WorkoutScreenLogic>(
        builder:
            (context, logic, _) => Scaffold(
          appBar: AppBar(
            title: Text('Add to ${widget.workoutName}'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (await _onWillPop()) Navigator.of(context).pop();
              },
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildWorkoutHeader(context),
                  const SizedBox(height: 8),
                  Expanded(child: _buildExerciseList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    final hasExercises = logic.selectedExercises.isNotEmpty;
    return ListView.separated(
      itemCount: hasExercises ? logic.selectedExercises.length + 1 : 1,
      separatorBuilder:
          (context, index) =>
      hasExercises && index < logic.selectedExercises.length - 1
          ? const SizedBox(height: 12)
          : const SizedBox.shrink(),
      itemBuilder: (context, index) {
        if (!hasExercises) return _buildEmptyStateWithButton();
        if (index == logic.selectedExercises.length) {
          return _buildAddExerciseButton();
        }
        return _buildExerciseCard(index);
      },
    );
  }

  // Updated _buildAddExerciseButton
  Widget _buildAddExerciseButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 300,
          child: FloatingActionButton.extended(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final selected = await Navigator.push<List<Exercise>>(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ExerciseListScreen(isSelectionMode: true),
                ),
              );
              if (selected != null && selected.isNotEmpty) {
                for (var exercise in selected) {
                  logic.addExercise(exercise);
                }
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Exercise'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateWithButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          'Tap below to add exercises',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        _buildAddExerciseButton(),
      ],
    );
  }

  Widget _buildWorkoutHeader(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _workoutNameController,
                    focusNode: _workoutNameFocusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Workout name, e.g: "Leg day", "Upper"',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: const Icon(Icons.edit, size: 16),
                      errorText:
                      logic.workoutName.isEmpty
                          ? 'Workout name is required'
                          : null,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: logic.updateWorkoutName,
                    onEditingComplete: () => _workoutNameFocusNode.unfocus(),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed:
                  (logic.selectedExercises.isNotEmpty &&
                      logic.workoutName.isNotEmpty)
                      ? () async {
                    try {
                      await logic.saveWorkout(context);
                      if (context.mounted) {
                        // Add this SnackBar:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Workout saved'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to save: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                      : null,
                  tooltip: 'Save Workout',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (logic.selectedExercises.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Select at least one exercise',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            Container(
              alignment: Alignment.center,
              child: Text(
                '${logic.selectedExercises.length} exercises selected',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(int exerciseIndex) {
    final exercise = logic.selectedExercises[exerciseIndex];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExerciseHeader(exercise, exerciseIndex),
              const SizedBox(height: 8),
              _buildSetHeader(),
              ..._buildSetRows(exercise, exerciseIndex),
              _buildAddSetButton(exercise, exerciseIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseHeader(WorkoutExercise exercise, int index) {
    return Row(
      children: [
        Expanded(
          child: Text(
            exercise.exercise.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => logic.removeExercise(index),
        ),
      ],
    );
  }

  Widget _buildSetHeader() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(width: 36),
          Expanded(child: _HeaderLabel('Weight')),
          Expanded(child: _HeaderLabel('Reps')),
          Expanded(child: _HeaderLabel('Rest')),
          SizedBox(width: 36),
        ],
      ),
    );
  }

  List<Widget> _buildSetRows(WorkoutExercise exercise, int exerciseIndex) {
    return List.generate(
      exercise.sets.length,
          (setIndex) => _buildSetRow(
        exerciseIndex: exerciseIndex,
        setIndex: setIndex,
        set: exercise.sets[setIndex],
      ),
    );
  }

  Widget _buildSetRow({
    required int exerciseIndex,
    required int setIndex,
    required WorkoutSet set,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              'Set ${setIndex + 1}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          _buildEditableField(
            context: context,
            value: '${set.weight} kg',
            color: Colors.blue,
            onTap: () => _showWeightPicker(exerciseIndex, setIndex),
          ),
          const SizedBox(width: 8),
          _buildEditableField(
            context: context,
            value: set.formattedReps(),
            color: Colors.green,
            onTap: () => _showRepsPicker(exerciseIndex, setIndex),
          ),
          const SizedBox(width: 8),
          _buildEditableField(
            context: context,
            value: set.formattedRest(),
            color: Colors.orange,
            onTap: () => _showRestPicker(exerciseIndex, setIndex),
          ),
          if (logic.selectedExercises[exerciseIndex].sets.length > 1)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 18),
              onPressed: () => logic.removeSet(exerciseIndex, setIndex),
            ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required BuildContext context,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddSetButton(WorkoutExercise exercise, int exerciseIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: () => logic.addSet(exerciseIndex),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Set'),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  void _showWeightPicker(int exerciseIndex, int setIndex) {
    final set = logic.selectedExercises[exerciseIndex].sets[setIndex];
    final controller = TextEditingController(text: set.weight.toString());
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(
          'Weight for ${logic.selectedExercises[exerciseIndex].exercise.name}',
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            suffix: Text('kg'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final weight = double.tryParse(controller.text) ?? 0;
              logic.updateSetWeight(exerciseIndex, setIndex, weight);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showRestPicker(int exerciseIndex, int setIndex) {
    final set = logic.selectedExercises[exerciseIndex].sets[setIndex];
    final minMinutes = (set.minRestSeconds ~/ 60).toString();
    final minSeconds = (set.minRestSeconds % 60).toString();
    final maxMinutes = (set.maxRestSeconds ~/ 60).toString();
    final maxSeconds = (set.maxRestSeconds % 60).toString();
    final minMinutesController = TextEditingController(text: minMinutes);
    final minSecondsController = TextEditingController(text: minSeconds);
    final maxMinutesController = TextEditingController(text: maxMinutes);
    final maxSecondsController = TextEditingController(text: maxSeconds);
    bool useTimeRange = set.isRestRange;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
        builder:
            (context, setStateDialog) => AlertDialog(
          title: Text(
            'Rest Time for ${logic.selectedExercises[exerciseIndex].exercise.name}',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Use Time Range'),
                  value: useTimeRange,
                  onChanged:
                      (value) =>
                      setStateDialog(() => useTimeRange = value),
                ),
                const SizedBox(height: 16),
                _buildTimeInputs(
                  context: context,
                  label:
                  useTimeRange ? 'Minimum Rest Time' : 'Rest Time',
                  minutesController: minMinutesController,
                  secondsController: minSecondsController,
                ),
                if (useTimeRange) ...[
                  const SizedBox(height: 24),
                  _buildTimeInputs(
                    context: context,
                    label: 'Maximum Rest Time',
                    minutesController: maxMinutesController,
                    secondsController: maxSecondsController,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final minTotal = _calculateTotalSeconds(
                  minMinutesController.text,
                  minSecondsController.text,
                );
                final maxTotal =
                useTimeRange
                    ? _calculateTotalSeconds(
                  maxMinutesController.text,
                  maxSecondsController.text,
                )
                    : minTotal;
                logic.updateSetRest(
                  exerciseIndex,
                  setIndex,
                  minTotal,
                  maxTotal,
                  useTimeRange,
                );
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputs({
    required BuildContext context,
    required String label,
    required TextEditingController minutesController,
    required TextEditingController secondsController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Minutes',
                  counterText: '',
                ),
                maxLength: 2,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Seconds',
                  counterText: '',
                ),
                maxLength: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  int _calculateTotalSeconds(String minutes, String seconds) {
    final mins = int.tryParse(minutes) ?? 0;
    final secs = int.tryParse(seconds) ?? 0;
    return (mins * 60) + secs;
  }

  void _showRepsPicker(int exerciseIndex, int setIndex) {
    final set = logic.selectedExercises[exerciseIndex].sets[setIndex];
    final minController = TextEditingController(text: set.minReps.toString());
    final maxController = TextEditingController(text: set.maxReps.toString());
    bool useRepRange = set.isRepRange;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
        builder:
            (context, setStateDialog) => AlertDialog(
          title: Text(
            'Reps for ${logic.selectedExercises[exerciseIndex].exercise.name}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Use Rep Range'),
                value: useRepRange,
                onChanged:
                    (value) =>
                    setStateDialog(() => useRepRange = value),
              ),
              TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: useRepRange ? 'Minimum Reps' : 'Reps',
                ),
              ),
              if (useRepRange) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: maxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Maximum Reps',
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final min = int.tryParse(minController.text) ?? 1;
                final max =
                useRepRange
                    ? int.tryParse(maxController.text) ?? min
                    : min;
                logic.updateSetReps(
                  exerciseIndex,
                  setIndex,
                  min,
                  max,
                  useRepRange,
                );
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  const _HeaderLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}