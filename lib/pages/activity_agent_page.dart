import 'package:flutter/material.dart';
import 'breath_training_page.dart';
import '../theme/calm_theme.dart';

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
      backgroundColor: CalmTheme.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(CalmTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: CalmTheme.spacingXL),
            _buildMoodAssessment(),
            SizedBox(height: CalmTheme.spacingXL),
            _buildRecommendations(),
            SizedBox(height: CalmTheme.spacingXL),
            _buildActivityProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: CalmTheme.sage.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.nature_people,
                  color: CalmTheme.primaryGreen,
                  size: 30,
                ),
              ),
              SizedBox(width: CalmTheme.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Guide',
                      style: CalmTheme.headingLarge.copyWith(
                        color: CalmTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodAssessment() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Check-in',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
            ),
          ),
          SizedBox(height: CalmTheme.spacingL),
          _buildMoodSelector(),
          SizedBox(height: CalmTheme.spacingL),
          _buildStressLevelSelector(),
          SizedBox(height: CalmTheme.spacingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _generateRecommendations();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Recommendations updated!',
                      style: CalmTheme.bodyLarge.copyWith(color: Colors.white),
                    ),
                    backgroundColor: CalmTheme.primaryGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: CalmTheme.primaryButton,
              child: Text(
                'Update Activities',
                style: CalmTheme.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: CalmTheme.bodyLarge.copyWith(
            color: CalmTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: CalmTheme.spacingS),
        Wrap(
          spacing: CalmTheme.spacingS,
          runSpacing: CalmTheme.spacingS,
          children: ['happy', 'neutral', 'sad', 'anxious', 'energetic'].map((mood) {
            return FilterChip(
              label: Text(
                mood.toUpperCase(),
                style: CalmTheme.caption.copyWith(
                  color: _currentMood == mood 
                    ? Colors.white 
                    : CalmTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: _currentMood == mood,
              onSelected: (selected) {
                setState(() {
                  _currentMood = mood;
                });
              },
              backgroundColor: CalmTheme.sage.withOpacity(0.2),
              selectedColor: CalmTheme.primaryGreen,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: _currentMood == mood 
                  ? CalmTheme.primaryGreen 
                  : CalmTheme.sage.withOpacity(0.3),
              ),
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
        Text(
          'Energy level:',
          style: CalmTheme.bodyLarge.copyWith(
            color: CalmTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: CalmTheme.spacingS),
        Wrap(
          spacing: CalmTheme.spacingS,
          runSpacing: CalmTheme.spacingS,
          children: ['low', 'medium', 'high'].map((level) {
            return FilterChip(
              label: Text(
                level.toUpperCase(),
                style: CalmTheme.caption.copyWith(
                  color: _stressLevel == level 
                    ? Colors.white 
                    : CalmTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: _stressLevel == level,
              onSelected: (selected) {
                setState(() {
                  _stressLevel = level;
                });
              },
              backgroundColor: CalmTheme.sage.withOpacity(0.2),
              selectedColor: CalmTheme.primaryGreen,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: _stressLevel == level 
                  ? CalmTheme.primaryGreen 
                  : CalmTheme.sage.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wellness Activities',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
            ),
          ),
          SizedBox(height: CalmTheme.spacingL),
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
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Progress',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
            ),
          ),
          SizedBox(height: CalmTheme.spacingL),
          _buildProgressItem('Breathing Exercises', 2, 3, CalmTheme.primaryGreen),
          _buildProgressItem('Meditation Sessions', 1, 2, CalmTheme.sage),
          _buildProgressItem('Physical Activity', 0, 1, CalmTheme.sage),
          SizedBox(height: CalmTheme.spacingL),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: CalmTheme.sage.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(CalmTheme.primaryGreen),
          ),
          SizedBox(height: CalmTheme.spacingS),
          Text(
            'Daily Goal: 60% Complete',
            style: CalmTheme.bodyMedium.copyWith(
              color: CalmTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, int completed, int target, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: CalmTheme.spacingM),
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
          SizedBox(width: CalmTheme.spacingM),
          Expanded(
            child: Text(
              title,
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.textPrimary,
              ),
            ),
          ),
          Text(
            '$completed/$target',
            style: CalmTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: CalmTheme.textSecondary,
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
