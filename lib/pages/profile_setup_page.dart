import 'package:flutter/material.dart';
import '../theme/calm_theme.dart';
import 'emergency_contacts_page.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.background,
      appBar: AppBar(
        backgroundColor: CalmTheme.primaryGreen,
        title: Text(
          'Complete Your Profile',
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
                _buildWelcomeSection(),
                const SizedBox(height: 32),
                _buildFormFields(),
                const SizedBox(height: 40),
                _buildNextButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
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
                  Icons.person_add,
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
                      'Tell us about yourself',
                      style: CalmTheme.headingMedium.copyWith(
                        color: CalmTheme.primaryGreen,
                      ),
                    ),
                    SizedBox(height: CalmTheme.spacingXS),
                    Text(
                      'Help us personalize your experience',
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

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: CalmTheme.bodyLarge.copyWith(
            color: CalmTheme.primaryGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: CalmTheme.spacingL),
        _buildInputField(
          controller: _ageController,
          hintText: 'Enter your age',
          labelText: 'Age',
          prefixIcon: Icons.cake,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your age';
            }
            final age = int.tryParse(value);
            if (age == null || age < 13 || age > 120) {
              return 'Please enter a valid age between 13 and 120';
            }
            return null;
          },
        ),
        SizedBox(height: CalmTheme.spacingL),
        _buildInputField(
          controller: _courseController,
          hintText: 'e.g., Computer Science, Psychology',
          labelText: 'Course/Major',
          prefixIcon: Icons.school,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your course or major';
            }
            return null;
          },
        ),
        SizedBox(height: CalmTheme.spacingL),
        _buildInputField(
          controller: _yearController,
          hintText: 'e.g., 1st Year, 2nd Year, Graduate',
          labelText: 'Academic Year',
          prefixIcon: Icons.calendar_today,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your academic year';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInputField({
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

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleNext,
        style: CalmTheme.primaryButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next',
              style: CalmTheme.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: CalmTheme.spacingS),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // Store the profile data and navigate to emergency contacts
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmergencyContactsPage(
            profileData: {
              'age': _ageController.text.trim(),
              'course': _courseController.text.trim(),
              'year': _yearController.text.trim(),
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _courseController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
