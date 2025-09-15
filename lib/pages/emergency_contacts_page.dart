import 'package:flutter/material.dart';
import '../theme/calm_theme.dart';
import '../widgets/main_navigation_wrapper.dart';
import '../services/user_service.dart';

class EmergencyContactsPage extends StatefulWidget {
  final Map<String, String> profileData;

  const EmergencyContactsPage({
    super.key,
    required this.profileData,
  });

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Emergency Contact 1
  final _contact1NameController = TextEditingController();
  final _contact1PhoneController = TextEditingController();
  
  // Emergency Contact 2
  final _contact2NameController = TextEditingController();
  final _contact2PhoneController = TextEditingController();
  
  final UserService _userService = UserService();
  bool _isLoading = false;  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.background,
      appBar: AppBar(
        backgroundColor: CalmTheme.primaryGreen,
        title: Text(
          'Emergency Contacts',
          style: CalmTheme.headingMedium.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildInfoSection(),
                const SizedBox(height: 32),
                _buildEmergencyContact1(),
                const SizedBox(height: 24),
                _buildEmergencyContact2(),
                const SizedBox(height: 40),
                _buildCompleteButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
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
                  Icons.emergency,
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
                      'Emergency Contacts',
                      style: CalmTheme.headingMedium.copyWith(
                        color: CalmTheme.primaryGreen,
                      ),
                    ),
                    SizedBox(height: CalmTheme.spacingXS),
                    Text(
                      'Add two trusted contacts for emergency situations',
                      style: CalmTheme.bodyMedium.copyWith(
                        color: CalmTheme.textSecondary,
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

  Widget _buildEmergencyContact1() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: CalmTheme.primaryGreen,
                size: 24,
              ),
              SizedBox(width: CalmTheme.spacingS),
              Text(
                'Emergency Contact 1',
                style: CalmTheme.headingMedium.copyWith(
                  color: CalmTheme.primaryGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: CalmTheme.spacingL),
          _buildContactField(
            controller: _contact1NameController,
            hintText: 'Enter contact name',
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the contact name';
              }
              return null;
            },
          ),
          SizedBox(height: CalmTheme.spacingL),
          _buildContactField(
            controller: _contact1PhoneController,
            hintText: 'Enter phone number',
            labelText: 'Phone Number',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact2() {
    return Container(
      decoration: CalmTheme.cardDecoration,
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: CalmTheme.primaryGreen,
                size: 24,
              ),
              SizedBox(width: CalmTheme.spacingS),
              Text(
                'Emergency Contact 2',
                style: CalmTheme.headingMedium.copyWith(
                  color: CalmTheme.primaryGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: CalmTheme.spacingL),
          _buildContactField(
            controller: _contact2NameController,
            hintText: 'Enter contact name',
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the contact name';
              }
              return null;
            },
          ),
          SizedBox(height: CalmTheme.spacingL),
          _buildContactField(
            controller: _contact2PhoneController,
            hintText: 'Enter phone number',
            labelText: 'Phone Number',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: CalmTheme.bodyMedium.copyWith(
            color: CalmTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: CalmTheme.spacingS),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: CalmTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: CalmTheme.bodyLarge.copyWith(
                color: CalmTheme.textTertiary,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: CalmTheme.sage,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleComplete,
        style: CalmTheme.primaryButton,
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Complete Setup',
                    style: CalmTheme.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: CalmTheme.spacingS),
                  const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }

  void _handleComplete() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        // TODO: Save profile data and emergency contacts to database
        // For now, just simulate a delay
        await Future.delayed(const Duration(seconds: 1));
        
        // Mark profile as completed
        await _userService.markProfileCompleted();
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile setup completed successfully!'),
              backgroundColor: CalmTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          
          // Navigate to main app
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigationWrapper(),
            ),
            (route) => false, // Remove all previous routes
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _contact1NameController.dispose();
    _contact1PhoneController.dispose();
    _contact2NameController.dispose();
    _contact2PhoneController.dispose();
    super.dispose();
  }
}
