import 'package:flutter/material.dart';
import 'breath_training_page.dart';

class ActivityAgentPage extends StatefulWidget {
  const ActivityAgentPage({super.key});

  @override
  State<ActivityAgentPage> createState() => _ActivityAgentPageState();
}

class _ActivityAgentPageState extends State<ActivityAgentPage> {
  final List<ActivityRecommendation> _recommendations = [];
  String _currentMood = 'neutral';
  String _stressLevel = 'medium';
  
  @override
  void initState() {
    super.initState();
    _generateRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildMoodAssessment(),
            const SizedBox(height: 24),
            _buildRecommendations(),
            const SizedBox(height: 24),
            _buildActivityProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.teal[400]!, Colors.teal[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.support_agent,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity Agent',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personalized wellness activities for you',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodAssessment() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Assessment',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildMoodSelector(),
            const SizedBox(height: 16),
            _buildStressLevelSelector(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _generateRecommendations();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recommendations updated based on your input!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Update Recommendations'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Current Mood:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['happy', 'neutral', 'sad', 'anxious', 'energetic'].map((mood) {
            return FilterChip(
              label: Text(
                mood.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
              selected: _currentMood == mood,
              onSelected: (selected) {
                setState(() {
                  _currentMood = mood;
                });
              },
              selectedColor: Colors.teal[100],
              checkmarkColor: Colors.teal[700],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStressLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stress Level:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['low', 'medium', 'high'].map((level) {
            return FilterChip(
              label: Text(
                level.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
              selected: _stressLevel == level,
              onSelected: (selected) {
                setState(() {
                  _stressLevel = level;
                });
              },
              selectedColor: Colors.orange[100],
              checkmarkColor: Colors.orange[700],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Activities',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                return _buildRecommendationCard(_recommendations[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(ActivityRecommendation recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: recommendation.color.withOpacity(0.2),
                  child: Icon(
                    recommendation.icon,
                    color: recommendation.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recommendation.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.duration,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.local_fire_department, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.intensity,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _startActivity(recommendation),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: recommendation.color,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(60, 36),
                  ),
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityProgress() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressItem('Breathing Exercises', 2, 3, Colors.blue),
            _buildProgressItem('Meditation Sessions', 1, 2, Colors.purple),
            _buildProgressItem('Physical Activity', 0, 1, Colors.green),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[600]!),
            ),
            const SizedBox(height: 8),
            Text(
              'Daily Goal: 60% Complete',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String title, int completed, int target, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title),
          ),
          Text(
            '$completed/$target',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _generateRecommendations() {
    setState(() {
      _recommendations.clear();
      
      // Generate recommendations based on mood and stress level
      if (_stressLevel == 'high' || _currentMood == 'anxious') {
        _recommendations.add(ActivityRecommendation(
          title: 'Deep Breathing Exercise',
          description: 'Calm your mind with guided breathing',
          duration: '5-10 min',
          intensity: 'Low',
          icon: Icons.air,
          color: Colors.blue,
          activityType: 'breathing',
        ));
      }
      
      if (_currentMood == 'sad' || _stressLevel == 'medium') {
        _recommendations.add(ActivityRecommendation(
          title: 'Mindfulness Meditation',
          description: 'Practice present moment awareness',
          duration: '10-15 min',
          intensity: 'Low',
          icon: Icons.self_improvement,
          color: Colors.purple,
          activityType: 'meditation',
        ));
      }
      
      if (_currentMood == 'neutral' || _currentMood == 'happy') {
        _recommendations.add(ActivityRecommendation(
          title: 'Gratitude Journal',
          description: 'Write down three things you\'re grateful for',
          duration: '5 min',
          intensity: 'Low',
          icon: Icons.book,
          color: Colors.orange,
          activityType: 'journal',
        ));
      }
      
      if (_currentMood == 'energetic') {
        _recommendations.add(ActivityRecommendation(
          title: 'Quick Workout',
          description: 'Get your body moving with light exercises',
          duration: '15-20 min',
          intensity: 'Medium',
          icon: Icons.fitness_center,
          color: Colors.green,
          activityType: 'exercise',
        ));
      }
      
      // Always include a general recommendation
      _recommendations.add(ActivityRecommendation(
        title: 'Progressive Muscle Relaxation',
        description: 'Release tension throughout your body',
        duration: '10-12 min',
        intensity: 'Low',
        icon: Icons.spa,
        color: Colors.teal,
        activityType: 'relaxation',
      ));
    });
  }

  void _startActivity(ActivityRecommendation recommendation) {
    switch (recommendation.activityType) {
      case 'breathing':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BreathTrainingPage(),
          ),
        );
        break;
      default:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(recommendation.title),
            content: Text(
              'This activity will be available soon!\n\n'
              '${recommendation.description}\n\n'
              'Duration: ${recommendation.duration}\n'
              'Intensity: ${recommendation.intensity}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
    }
  }
}

class ActivityRecommendation {
  final String title;
  final String description;
  final String duration;
  final String intensity;
  final IconData icon;
  final Color color;
  final String activityType;

  ActivityRecommendation({
    required this.title,
    required this.description,
    required this.duration,
    required this.intensity,
    required this.icon,
    required this.color,
    required this.activityType,
  });
}
