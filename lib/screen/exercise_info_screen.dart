import 'package:flutter/material.dart';
import '../models/exercise library/exercise.dart';
import '../models/exercise library/muscle_groups.dart';
import '../utils/enum_utils.dart';

/// A screen that displays detailed information about an exercise.
/// Contains tabbed sections for Info, Graphs, and History.
class ExerciseInfoScreen extends StatefulWidget {
  /// The exercise to display details for
  final Exercise exercise;

  const ExerciseInfoScreen({super.key, required this.exercise});

  @override
  State<ExerciseInfoScreen> createState() => _ExerciseInfoScreenState();
}

class _ExerciseInfoScreenState extends State<ExerciseInfoScreen>
    with SingleTickerProviderStateMixin {
  /// TabController for managing the tabbed interface
  late TabController _tabController;

  /// List of tab titles
  final List<String> _tabs = ['Info', 'Graphs', 'History'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.blue,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ), // Bold for selected
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ), // Normal for unselected
          tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildInfoTab(), _buildGraphsTab(), _buildHistoryTab()],
      ),
    );
  }

  //===================================
  // Tab Content Builders
  //===================================

  /// Builds the Info tab with exercise details and muscle groups
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExerciseVisual(),
          const SizedBox(height: 20),
          _buildInfoCard(), // Combined card
          const SizedBox(height: 16),
          _buildInstructionsCard(),
          const SizedBox(height: 16),
          _buildTipsCard(),
        ],
      ),
    );
  }

  /// Builds a consolidated information card with exercise details and muscle groups
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Info Section
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: 14,
                  child: Icon(
                    Icons.fitness_center,
                    color: Colors.blue,
                    size: 18, // Added explicit size to match other icons
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exercise.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        enumToString(widget.exercise.category),
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),

            // Muscle Groups Section
            _buildSectionHeader(
              icon: Icons.accessibility_new,
              title: 'Muscle Groups',
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildMuscleGroupDetail(
              'Primary',
              widget.exercise.primaryMuscles,
              Colors.orange[700]!,
            ),
            const SizedBox(height: 8),
            _buildMuscleGroupDetail(
              'Secondary',
              widget.exercise.secondaryMuscles,
              Colors.blue[700]!,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget for muscle group detail rows
  Widget _buildMuscleGroupDetail(
    String label,
    List<MuscleGroup> muscles,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            muscles.map((m) => enumToString(m)).join(', '),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  /// Builds the Graphs tab with visual performance data
  Widget _buildGraphsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.show_chart,
            title: 'Performance Graphs',
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildPlaceholderCard(
            'Weight Progress',
            Icons.trending_up,
            Colors.blue[700]!,
            height: 240,
          ),
          const SizedBox(height: 16),
          _buildPlaceholderCard(
            'Volume Progress',
            Icons.bar_chart,
            Colors.green[700]!,
            height: 240,
          ),
          const SizedBox(height: 16),
          _buildPlaceholderCard(
            'Frequency',
            Icons.calendar_today,
            Colors.orange[700]!,
            height: 240,
          ),
        ],
      ),
    );
  }

  /// Builds the History tab with past workout data
  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.history,
            title: 'Workout History',
            color: Colors.teal,
          ),
          const SizedBox(height: 16),
          // Placeholder text for workout history
          Center(
            child: Text(
              'Workout history will appear here.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //===================================
  // Info Tab Components
  //===================================

  /// Builds a visual representation of the exercise
  Widget _buildExerciseVisual() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey[400]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Exercise GIF/Video Placeholder',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  /// Builds a card with instructions on how to perform the exercise
  Widget _buildInstructionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.list_alt,
              title: 'Instructions',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            const Text(
              'This is where the exercise instructions will go. It will include detailed steps on how to perform the exercise correctly.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a card with tips for the exercise
  Widget _buildTipsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.lightbulb_outline,
              title: 'Tips',
              color: Colors.amber,
            ),
            const SizedBox(height: 12),
            const Text(
              '• Keep your back straight throughout the movement\n'
              '• Focus on controlled movement rather than speed\n'
              '• Breathe out during the exertion phase',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //===================================
  // Shared Components
  //===================================

  /// Builds a placeholder card for graphs or other data visualizations
  Widget _buildPlaceholderCard(
    String title,
    IconData icon,
    Color color, {
    double height = 200,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$title Graph Placeholder',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a section header with icon and title
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
