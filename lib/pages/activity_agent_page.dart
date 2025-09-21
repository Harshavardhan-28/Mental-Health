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
      backgroundColor: CalmTheme.lightGreen.withOpacity(0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(CalmTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with hamburger icon
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: CalmTheme.textPrimary,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              _buildMoodAssessment(),
              SizedBox(height: CalmTheme.spacingL),
              _buildRecommendations(),
              SizedBox(height: CalmTheme.spacingL),
              _buildActivityProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodAssessment() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0E8), // Eggshell white
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(CalmTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Check-in',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
            ),
          ),
          SizedBox(height: CalmTheme.spacingM),
          _buildMoodSelector(),
          SizedBox(height: CalmTheme.spacingM),
          _buildStressLevelSelector(),
          SizedBox(height: CalmTheme.spacingM),
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
                    backgroundColor: const Color(0xFF6B8E6B),
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
              backgroundColor: const Color.fromARGB(255, 108, 121, 94).withOpacity(0.2),
              selectedColor: CalmTheme.primaryGreen,
              showCheckmark: false,
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
              showCheckmark: false,
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
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0E8), // Eggshell white
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(CalmTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wellness Activities',
            style: CalmTheme.headingMedium.copyWith(
              color: const Color.fromARGB(255, 107, 142, 107),
            ),
          ),
          SizedBox(height: CalmTheme.spacingM),
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
    return Container(
      margin: EdgeInsets.only(bottom: CalmTheme.spacingS),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 241, 235),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(CalmTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: recommendation.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    recommendation.icon,
                    color: recommendation.color,
                    size: 18,
                  ),
                ),
                SizedBox(width: CalmTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.title,
                        style: CalmTheme.headingMedium.copyWith(
                          color: CalmTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: CalmTheme.spacingXS),
                      Text(
                        recommendation.description,
                        style: CalmTheme.bodyMedium.copyWith(
                          color: CalmTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: CalmTheme.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: CalmTheme.textSecondary,
                          ),
                          SizedBox(width: CalmTheme.spacingXS),
                          Flexible(
                            child: Text(
                              recommendation.duration,
                              style: CalmTheme.caption.copyWith(
                                color: CalmTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: CalmTheme.spacingXS),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: CalmTheme.textSecondary,
                          ),
                          SizedBox(width: CalmTheme.spacingXS),
                          Flexible(
                            child: Text(
                              recommendation.intensity,
                              style: CalmTheme.caption.copyWith(
                                color: CalmTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: CalmTheme.spacingM),
                ElevatedButton(
                  onPressed: () => _startActivity(recommendation),
                  style: CalmTheme.primaryButton.copyWith(
                    backgroundColor: MaterialStateProperty.all(recommendation.color),
                    minimumSize: MaterialStateProperty.all(const Size(80, 36)),
                  ),
                  child: Text(
                    'Start',
                    style: CalmTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0E8), // Eggshell white
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(CalmTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Progress',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
            ),
          ),
          SizedBox(height: CalmTheme.spacingM),
          _buildProgressItem('Breathing Exercises', 2, 3, CalmTheme.primaryGreen),
          _buildProgressItem('Meditation Sessions', 1, 2, CalmTheme.sage),
          _buildProgressItem('Physical Activity', 0, 1, CalmTheme.sage),
          SizedBox(height: CalmTheme.spacingM),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: const Color.fromARGB(255, 156, 175, 136).withOpacity(0.3),
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
      padding: EdgeInsets.only(bottom: CalmTheme.spacingS),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: CalmTheme.spacingS),
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
          color: const Color(0xFF8FBC8F), // Sky blue
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
          color: const Color(0xFF8FBC8F), // Medium purple
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
          color: const Color(0xFF8FBC8F) ,// Plum
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
          color: const Color(0xFF8FBC8F), // Light sea green
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
        color: const Color(0xFF8FBC8F), // Dark sea green
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
