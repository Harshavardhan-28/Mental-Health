import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/activities_page.dart';
import '../pages/mental_health_chatbot_page.dart';
import '../pages/activity_agent_page.dart';
import '../theme/calm_theme.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const HomePage(),
    const ActivitiesPage(),
    const MentalHealthChatbotPage(),
    const ActivityAgentPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.background,
      appBar: AppBar(
        title: Text(
          'MindEase',
          style: CalmTheme.headingLarge.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: CalmTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildSideNavigation(),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildSideNavigation() {
    return Drawer(
      backgroundColor: CalmTheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: CalmTheme.primaryGreen,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.spa,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  'MindEase',
                  style: CalmTheme.headingLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your wellness companion',
                  style: CalmTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.spa,
            title: 'Home',
            index: 0,
          ),
          _buildDrawerItem(
            icon: Icons.forest,
            title: 'Activities',
            index: 1,
          ),
          _buildDrawerItem(
            icon: Icons.self_improvement,
            title: 'Wellness Chat',
            index: 2,
          ),
          _buildDrawerItem(
            icon: Icons.nature_people,
            title: 'Activity Guide',
            index: 3,
          ),
          Divider(color: CalmTheme.sage.withOpacity(0.3)),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: CalmTheme.sage,
            ),
            title: Text(
              'Settings',
              style: CalmTheme.bodyLarge.copyWith(
                color: CalmTheme.textSecondary,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to settings page
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: CalmTheme.sage,
            ),
            title: Text(
              'About',
              style: CalmTheme.bodyLarge.copyWith(
                color: CalmTheme.textSecondary,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to about page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? CalmTheme.primaryGreen : CalmTheme.sage,
      ),
      title: Text(
        title,
        style: CalmTheme.bodyLarge.copyWith(
          color: isSelected ? CalmTheme.primaryGreen : CalmTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      selectedTileColor: CalmTheme.lightGreen.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}
