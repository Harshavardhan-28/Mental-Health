import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../widgets/main_navigation_wrapper.dart';
import '../theme/calm_theme.dart';
import 'profile_setup_page.dart';

// Clean auth screen with calming design
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignInView = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalmTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 48),
              _buildHeader(),
              const SizedBox(height: 32),
              _buildGoogleSignInButton(),
              const SizedBox(height: 28),
              _buildDivider(),
              const SizedBox(height: 28),
              _buildForm(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 28),
              _buildBottomNavigation(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Spa icon for wellness
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: CalmTheme.sage.withOpacity(0.2),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: CalmTheme.primaryGreen.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.spa,
            size: 40,
            color: CalmTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 24),
        // Calming app title
        Text(
          'MindEase',
          style: CalmTheme.displayLarge.copyWith(
            color: CalmTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isSignInView ? 'Welcome Back' : 'Join Us',
          style: CalmTheme.headingLarge.copyWith(
            color: CalmTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isSignInView
              ? 'Continue your wellness journey'
              : 'Begin your path to inner peace',
          style: CalmTheme.bodyLarge.copyWith(
            color: CalmTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : _handleGoogleSignIn,
        icon: const Icon(Icons.account_circle, size: 24, color: Colors.black87),
        label: Text(
          isSignInView ? 'Sign in with Google' : 'Sign up with Google',
          style: CalmTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: CalmTheme.surface,
          elevation: 0,
          side: BorderSide(color: CalmTheme.sage.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: CalmTheme.sage.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: CalmTheme.bodyMedium.copyWith(
              color: CalmTheme.textTertiary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Divider(color: CalmTheme.sage.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: _validatePassword,
          ),
          if (!isSignInView) ...[
            const SizedBox(height: 16),
            _buildTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              validator: _validateConfirmPassword,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: CalmTheme.cardDecoration,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
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
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleEmailAuth,
        style: CalmTheme.primaryButton,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Text(
                isSignInView ? 'Sign In' : 'Create Account',
                style: CalmTheme.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isSignInView = !isSignInView;
              _clearForm();
            });
          },
          child: Text(
            isSignInView
                ? 'Need an account? Sign up'
                : 'Already have an account? Sign in',
            style: CalmTheme.bodyLarge.copyWith(
              color: CalmTheme.primaryGreen,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // Validation methods
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Action handlers - FIXED VERSIONS
  Future<void> _handleGoogleSignIn() async {
    setState(() => isLoading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (mounted && user != null) {
        // Check if user needs to complete profile setup
        final needsProfileSetup = _userService.isNewUser() || !await _userService.hasCompletedProfile();
        
        if (needsProfileSetup && !isSignInView) {
          // New user who clicked "Sign up with Google" - go to profile setup
          _navigateToProfileSetup();
        } else if (needsProfileSetup && isSignInView) {
          // Existing user who hasn't completed profile - show message and go to profile
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please complete your profile setup.'),
              backgroundColor: CalmTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
          );
        } else {
          // User has completed profile - go to main app
          _navigateToActivities('Successfully signed in with Google!');
        }
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      if (isSignInView) {
        // Fixed: Using positional parameters
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (mounted) {
          _navigateToActivities('Successfully signed in!');
        }
      } else {
        // Fixed: Using positional parameters with named displayName
        await _authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          displayName: _emailController.text.trim().split('@')[0],
        );
        if (mounted) {
          _navigateToProfileSetup();
        }
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _formKey.currentState?.reset();
  }

  void _navigateToActivities([String? message]) {
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationWrapper()),
    );
  }

  void _navigateToProfileSetup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Account created successfully! Please complete your profile.'),
        backgroundColor: CalmTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.replaceFirst('Exception: ', '')),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}