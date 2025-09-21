import 'package:flutter/material.dart';
import 'start_activity_page.dart';
import '../theme/calm_theme.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 243),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(CalmTheme.spacingL),
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
              // Page title
              Text(
                'Activities',
                style: CalmTheme.displayLarge.copyWith(
                  color: CalmTheme.primaryGreen,
                ),
              ),
              SizedBox(height: CalmTheme.spacingXL),

              // Start activity now button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CalmTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CalmTheme.primaryGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StartActivityPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: CalmTheme.spacingL, 
                        horizontal: CalmTheme.spacingL,
                      ),
                      child: Row(
                        children: [                          
                          Text(
                            'Begin wellness activity',
                            style: CalmTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.all(CalmTheme.spacingS),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: CalmTheme.spacingXXL),

              // Today's summary
              Text(
                "Today's Activities",
                style: CalmTheme.headingMedium.copyWith(
                  color: CalmTheme.primaryGreen,
                ),
              ),
              SizedBox(height: CalmTheme.spacingM),

              // Activity items
              Expanded(
                child: ListView(
                  children: [
                    _buildActivityItem(
                      icon: Icons.nature_people,
                      title: 'Mindful Walking',
                      subtitle: '10 min',
                      color: CalmTheme.primaryGreen,
                      isCompleted: true,
                    ),
                    SizedBox(height: CalmTheme.spacingM),
                    _buildActivityItem(
                      icon: Icons.spa,
                      title: 'Breathing Exercise',
                      subtitle: 'Continue practice',
                      color: CalmTheme.sage,
                      isCompleted: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StartActivityPage()),
                        );
                      },
                    ),
                    SizedBox(height: CalmTheme.spacingM),
                    _buildActivityItem(
                      icon: Icons.self_improvement,
                      title: 'Meditation',
                      subtitle: '5 min',
                      color: const Color(0xFF5D8A66),
                      isCompleted: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isCompleted,
    VoidCallback? onTap,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: isCompleted ? Colors.grey[600] : const Color(0xFF3B82F6),
                          fontWeight: isCompleted ? FontWeight.normal : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
