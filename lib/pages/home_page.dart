import 'package:flutter/material.dart';
import 'breath_training_page.dart';
import '../theme/calm_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedMood; // Store selected mood (1-5)
  
  // Weekly mood data (0 = no data, 1-5 = mood levels)
  final List<int> weeklyMoods = [2, 3, 1, 3, 2, 4, 1]; // Mon-Sun
  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.lightGreen.withOpacity(0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with hamburger icon
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
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
              _buildHeader(),
              const SizedBox(height: 24),
              _buildWeeklyMoodTracker(),
              const SizedBox(height: 24),
              _buildBreathingCard(),
              const SizedBox(height: 24),
              _buildDailyMoodSelector(),
              const SizedBox(height: 24),
              _buildRediscoverSection(),
              const SizedBox(height: 24),
              _buildMindfulnessSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good Morning,";
    } else if (hour < 17) {
      greeting = "Good Afternoon,";
    } else {
      greeting = "Good Evening,";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: CalmTheme.bodyLarge.copyWith(
                color: CalmTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'User name',
              style: CalmTheme.headingLarge.copyWith(
                color: CalmTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyMoodTracker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          return _buildWeeklyMoodItem(weekDays[index], weeklyMoods[index]);
        }),
      ),
    );
  }

  Widget _buildWeeklyMoodItem(String day, int mood) {
    Color moodColor = _getWeeklyMoodColor(mood);
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: mood > 0 ? moodColor.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: mood > 0 ? Icon(
            _getWeeklyMoodIcon(mood),
            color: moodColor,
            size: 20,
          ) : const Icon(
            Icons.help_outline,
            color: Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: CalmTheme.bodyMedium.copyWith(
            color: CalmTheme.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Color _getWeeklyMoodColor(int mood) {
    switch (mood) {
      case 1: return const Color.fromARGB(255, 239, 39, 25); // Angry - Red
      case 2: return const Color.fromARGB(255, 243, 135, 33); // Sad - Orange
      case 3: return const Color.fromARGB(255, 227, 241, 33); // Happy - Yellow
      case 4: return const Color.fromARGB(255, 163, 249, 41); // Good - Light Green
      case 5: return const Color.fromARGB(255, 3, 107, 43); // Joy - Dark Green
      default: return Colors.grey.withOpacity(0.3);
    }
  }

  IconData _getWeeklyMoodIcon(int mood) {
    switch (mood) {
      case 1: return Icons.sentiment_very_dissatisfied;
      case 2: return Icons.sentiment_dissatisfied;
      case 3: return Icons.sentiment_neutral;
      case 4: return Icons.sentiment_satisfied;
      case 5: return Icons.sentiment_very_satisfied;
      default: return Icons.help_outline;
    }
  }

  Widget _buildBreathingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a Moment to Breathe',
                  style: CalmTheme.headingMedium.copyWith(
                    color: CalmTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Calm your mind and restore balance',
                  style: CalmTheme.bodyMedium.copyWith(
                    color: CalmTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BreathTrainingPage(),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: CalmTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMoodSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How Your Day Today?',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodOption(1, 'Angry', const Color.fromARGB(255, 239, 39, 25)),
              _buildMoodOption(2, 'Sad', const Color.fromARGB(255, 243, 135, 33)),
              _buildMoodOption(3, 'Happy', const Color.fromARGB(255, 227, 241, 33)),
              _buildMoodOption(4, 'Good', const Color.fromARGB(255, 163, 249, 41)),
              _buildMoodOption(5, 'Joy', const Color.fromARGB(255, 3, 107, 43)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(int mood, String label, Color color) {
    bool isSelected = selectedMood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.3),
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 3) : null,
            ),
            child: Icon(
              _getWeeklyMoodIcon(mood),
              color: isSelected ? Colors.white : color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: CalmTheme.bodyMedium.copyWith(
              color: isSelected ? color : CalmTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRediscoverSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rediscover Yourself Today',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rediscover yourself from now on',
            style: CalmTheme.bodyMedium.copyWith(
              color: CalmTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRediscoverOption(Icons.mood, 'Mood Journey', CalmTheme.sage),
              _buildRediscoverOption(Icons.local_florist, 'Mood Garden', const Color.fromARGB(255, 72, 101, 72)),
              _buildRediscoverOption(Icons.book, 'Daily Journal', const Color.fromARGB(255, 55, 81, 55)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRediscoverOption(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Add navigation logic here
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMindfulnessSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: CalmTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Only 10 mins per day',
                style: CalmTheme.bodyMedium.copyWith(
                  color: CalmTheme.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Train Your Mindfulness',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: CalmTheme.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Start Training',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class MoodEntry {
  final DateTime date;
  final int mood;

  MoodEntry(this.date, this.mood);
}
