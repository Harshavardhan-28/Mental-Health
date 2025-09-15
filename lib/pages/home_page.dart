import 'package:flutter/material.dart';
import 'dart:math';
import 'breath_training_page.dart';
import '../theme/calm_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  
  final List<String> _affirmations = [
    "You are stronger than you think",
    "Take it one breath at a time",
    "Your mental health matters",
    "You are worthy of peace and happiness",
    "Every small step counts",
    "You have overcome challenges before",
    "Be kind to yourself today",
    "Your feelings are valid",
  ];
  
  final List<MoodEntry> _moodEntries = [
    MoodEntry(DateTime.now().subtract(const Duration(days: 6)), 3),
    MoodEntry(DateTime.now().subtract(const Duration(days: 5)), 4),
    MoodEntry(DateTime.now().subtract(const Duration(days: 4)), 2),
    MoodEntry(DateTime.now().subtract(const Duration(days: 3)), 5),
    MoodEntry(DateTime.now().subtract(const Duration(days: 2)), 3),
    MoodEntry(DateTime.now().subtract(const Duration(days: 1)), 4),
    MoodEntry(DateTime.now(), 4),
  ];

  late String _currentAffirmation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _breathingController.repeat(reverse: true);
    
    _currentAffirmation = _affirmations[Random().nextInt(_affirmations.length)];
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(CalmTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(),
              SizedBox(height: CalmTheme.spacingXL),
              _buildAffirmationSection(),
              SizedBox(height: CalmTheme.spacingXL),
              _buildMoodTimelineSection(),
              SizedBox(height: CalmTheme.spacingL),
              _buildQuickActionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: CalmTheme.sage.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.spa,
              color: CalmTheme.primaryGreen,
              size: 30,
            ),
          ),
          SizedBox(width: CalmTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: CalmTheme.headingLarge.copyWith(
                    color: CalmTheme.primaryGreen,
                  ),
                ),
                SizedBox(height: CalmTheme.spacingXS),
                Text(
                  "How are you feeling today?",
                  style: CalmTheme.bodyLarge.copyWith(
                    color: CalmTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationSection() {
    return Container(
      decoration: CalmTheme.cardDecoration.copyWith(
        color: CalmTheme.lightGreen.withOpacity(0.3),
      ),
      padding: EdgeInsets.all(CalmTheme.spacingXL),
      child: Column(
        children: [
          // Breathing animation with spa icon
          AnimatedBuilder(
            animation: _breathingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _breathingAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: CalmTheme.sage.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: CalmTheme.primaryGreen.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.spa,
                    color: CalmTheme.primaryGreen,
                    size: 40,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: CalmTheme.spacingL),
          Text(
            _currentAffirmation,
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: CalmTheme.spacingM),
          Text(
            "Breathe with the gentle rhythm above",
            style: CalmTheme.bodyMedium.copyWith(
              color: CalmTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTimelineSection() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Mood Journey",
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
            ),
          ),
          SizedBox(height: CalmTheme.spacingM),
          Text(
            "Track how you're feeling over time",
            style: CalmTheme.bodyMedium.copyWith(
              color: CalmTheme.textSecondary,
            ),
          ),
          SizedBox(height: CalmTheme.spacingL),
          // Simple mood visualization with calming design
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _moodEntries.length,
              itemBuilder: (context, index) {
                final entry = _moodEntries[index];
                return _buildMoodTimelineItem(entry, index == _moodEntries.length - 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTimelineItem(MoodEntry entry, bool isLatest) {
    return Container(
      margin: EdgeInsets.only(right: CalmTheme.spacingM),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getMoodColor(entry.mood),
              border: isLatest 
                ? Border.all(color: CalmTheme.primaryGreen, width: 3) 
                : null,
              boxShadow: [
                BoxShadow(
                  color: CalmTheme.sage.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getMoodIcon(entry.mood),
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: CalmTheme.spacingXS),
          Text(
            '${entry.date.day}/${entry.date.month}',
            style: CalmTheme.caption.copyWith(
              color: CalmTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wellness Actions',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
            ),
          ),
          SizedBox(height: CalmTheme.spacingM),
          Text(
            'Quick access to your favorite activities',
            style: CalmTheme.bodyMedium.copyWith(
              color: CalmTheme.textSecondary,
            ),
          ),
          SizedBox(height: CalmTheme.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.spa,
                  label: 'Breathing',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BreathTrainingPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: CalmTheme.spacingM),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.self_improvement,
                  label: 'Chat',
                  onTap: () {
                    // Navigate to chatbot via drawer selection
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Fixed height for consistent sizing
        padding: EdgeInsets.all(CalmTheme.spacingL),
        decoration: BoxDecoration(
          color: CalmTheme.sage.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CalmTheme.sage.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: CalmTheme.sage.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: CalmTheme.primaryGreen,
              size: 32,
            ),
            SizedBox(height: CalmTheme.spacingS),
            Text(
              label,
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int mood) {
    switch (mood) {
      case 1: return const Color(0xFFD4A574); // Warm brown for sad
      case 2: return const Color(0xFFE5A85C); // Soft orange for okay
      case 3: return CalmTheme.sage; // Sage for neutral
      case 4: return CalmTheme.primaryGreen; // Primary green for good
      case 5: return const Color(0xFF5D8A66); // Deep green for great
      default: return CalmTheme.mutedGray;
    }
  }

  IconData _getMoodIcon(int mood) {
    switch (mood) {
      case 1: return Icons.sentiment_very_dissatisfied;
      case 2: return Icons.sentiment_dissatisfied;
      case 3: return Icons.sentiment_neutral;
      case 4: return Icons.sentiment_satisfied;
      case 5: return Icons.sentiment_very_satisfied;
      default: return Icons.help;
    }
  }
}

class MoodEntry {
  final DateTime date;
  final int mood;

  MoodEntry(this.date, this.mood);
}
