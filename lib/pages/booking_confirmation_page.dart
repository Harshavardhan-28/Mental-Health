import 'package:flutter/material.dart';
import '../theme/calm_theme.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String bookingId;
  final String counselor;
  final String date;
  final String timeSlot;
  final String? notes;

  const BookingConfirmationPage({
    super.key,
    required this.bookingId,
    required this.counselor,
    required this.date,
    required this.timeSlot,
    this.notes,
  });

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
              // Header with back button
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
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
              
              SizedBox(height: CalmTheme.spacingL),
              
              _buildConfirmationCard(context),
              
              SizedBox(height: CalmTheme.spacingL),
              
              _buildNextStepsCard(),
              
              SizedBox(height: CalmTheme.spacingL),
              
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationCard(BuildContext context) {
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
      padding: EdgeInsets.all(CalmTheme.spacingL),
      child: Column(
        children: [
          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: CalmTheme.primaryGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: CalmTheme.primaryGreen,
              size: 50,
            ),
          ),
          SizedBox(height: CalmTheme.spacingL),
          
          // Success Message
          Text(
            'Appointment Confirmed!',
            style: CalmTheme.headingLarge.copyWith(
              color: CalmTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: CalmTheme.spacingM),
          
          Text(
            'Your counseling session has been successfully scheduled. Please save your booking details for reference.',
            style: CalmTheme.bodyMedium.copyWith(
              color: CalmTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: CalmTheme.spacingL),

          // Booking Details Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(CalmTheme.spacingM),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: CalmTheme.sage.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Details',
                  style: CalmTheme.bodyLarge.copyWith(
                    color: CalmTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: CalmTheme.spacingM),
                
                _buildDetailRow('Booking ID:', bookingId),
                _buildDetailRow('Counselor:', counselor),
                _buildDetailRow('Date:', date),
                _buildDetailRow('Time:', timeSlot),
                
                if (notes != null && notes!.isNotEmpty) ...[
                  SizedBox(height: CalmTheme.spacingS),
                  Text(
                    'Notes:',
                    style: CalmTheme.bodyMedium.copyWith(
                      color: CalmTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: CalmTheme.spacingXS),
                  Text(
                    notes!,
                    style: CalmTheme.bodyMedium.copyWith(
                      color: CalmTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
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
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: CalmTheme.primaryGreen,
                size: 24,
              ),
              SizedBox(width: CalmTheme.spacingS),
              Text(
                'What Happens Next?',
                style: CalmTheme.headingMedium.copyWith(
                  color: CalmTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: CalmTheme.spacingM),
          
          _buildNextStepItem(
            Icons.schedule,
            'Reminder',
            'You will receive a reminder 24 hours before your appointment.',
          ),
          
          _buildNextStepItem(
            Icons.location_on,
            'Session Details',
            'Session location and joining instructions will be provided via your preferred communication method.',
          ),
          
          _buildNextStepItem(
            Icons.phone,
            'Contact',
            'If you need to reschedule or cancel, please contact us at least 24 hours in advance.',
          ),
          
          _buildNextStepItem(
            Icons.psychology,
            'Preparation',
            'Take some time to think about what you\'d like to discuss during your session.',
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: CalmTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: CalmTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: CalmTheme.primaryGreen,
              size: 18,
            ),
          ),
          SizedBox(width: CalmTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CalmTheme.bodyMedium.copyWith(
                    color: CalmTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: CalmTheme.spacingXS),
                Text(
                  description,
                  style: CalmTheme.bodyMedium.copyWith(
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

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigate back to booking page for another appointment
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.add,
                  color: CalmTheme.primaryGreen,
                  size: 20,
                ),
                label: Text(
                  'Book Another',
                  style: CalmTheme.bodyMedium.copyWith(
                    color: CalmTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: CalmTheme.primaryGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(0, 45),
                ),
              ),
            ),
            SizedBox(width: CalmTheme.spacingM),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to home or main dashboard
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Go Home',
                  style: CalmTheme.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: CalmTheme.primaryButton.copyWith(
                  minimumSize: MaterialStateProperty.all(const Size(0, 45)),
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: CalmTheme.spacingM),
        
        // Secondary Actions
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  _shareBookingDetails(context);
                },
                icon: Icon(
                  Icons.share,
                  color: CalmTheme.sage,
                  size: 18,
                ),
                label: Text(
                  'Share Details',
                  style: CalmTheme.bodyMedium.copyWith(
                    color: CalmTheme.sage,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  _saveToCalendar(context);
                },
                icon: Icon(
                  Icons.calendar_today,
                  color: CalmTheme.sage,
                  size: 18,
                ),
                label: Text(
                  'Add to Calendar',
                  style: CalmTheme.bodyMedium.copyWith(
                    color: CalmTheme.sage,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: CalmTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareBookingDetails(BuildContext context) {
    // Show a dialog with sharing options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Share Booking Details',
          style: CalmTheme.headingMedium.copyWith(
            color: CalmTheme.textPrimary,
          ),
        ),
        content: Text(
          'Booking details:\nID: $bookingId\nCounselor: $counselor\nDate: $date\nTime: $timeSlot',
          style: CalmTheme.bodyMedium.copyWith(
            color: CalmTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveToCalendar(BuildContext context) {
    // Show a dialog for calendar integration
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add to Calendar',
          style: CalmTheme.headingMedium.copyWith(
            color: CalmTheme.textPrimary,
          ),
        ),
        content: Text(
          'Would you like to add this appointment to your calendar?',
          style: CalmTheme.bodyMedium.copyWith(
            color: CalmTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Calendar event created successfully!',
                    style: CalmTheme.bodyMedium.copyWith(color: Colors.white),
                  ),
                  backgroundColor: CalmTheme.primaryGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: Text(
              'Add Event',
              style: CalmTheme.bodyMedium.copyWith(
                color: CalmTheme.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}