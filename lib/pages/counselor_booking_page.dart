import 'package:flutter/material.dart';
import '../theme/calm_theme.dart';

class CounselorBookingPage extends StatefulWidget {
  const CounselorBookingPage({super.key});

  @override
  State<CounselorBookingPage> createState() => _CounselorBookingPageState();
}

class _CounselorBookingPageState extends State<CounselorBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _concernController = TextEditingController();
  
  String _selectedTimeSlot = '';
  String _selectedDate = '';
  String _preferredCounselor = 'Any Available';
  bool _isBooked = false;
  String _bookingId = '';

  final List<String> _timeSlots = [
    '9:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '2:00 PM - 3:00 PM',
    '3:00 PM - 4:00 PM',
    '4:00 PM - 5:00 PM',
  ];

  final List<String> _counselors = [
    'Any Available',
    'Dr. Sarah Johnson',
    'Dr. Michael Chen',
    'Dr. Emily Davis',
    'Dr. Robert Wilson',
  ];

  @override
  void dispose() {
    _concernController.dispose();
    super.dispose();
  }

  void _bookAppointment() {
    if (_selectedTimeSlot.isNotEmpty && _selectedDate.isNotEmpty) {
      
      // Generate a simple booking ID
      final now = DateTime.now();
      _bookingId = 'CB${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      
      setState(() {
        _isBooked = true;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Appointment booked successfully!',
            style: CalmTheme.bodyLarge.copyWith(color: Colors.white),
          ),
          backgroundColor: CalmTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select date and time slot',
            style: CalmTheme.bodyLarge.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _isBooked = false;
      _selectedTimeSlot = '';
      _selectedDate = '';
      _preferredCounselor = 'Any Available';
      _bookingId = '';
    });
    _concernController.clear();
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
              
              // Page Title
              Text(
                'Book Counselor Appointment',
                style: CalmTheme.headingLarge.copyWith(
                  color: CalmTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: CalmTheme.spacingL),

              if (!_isBooked) ...[
                _buildBookingForm(),
              ] else ...[
                _buildBookingConfirmation(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment Details Section
            Text(
              'Book Your Appointment',
              style: CalmTheme.headingMedium.copyWith(
                color: CalmTheme.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: CalmTheme.spacingM),

            // Preferred Counselor Dropdown
            DropdownButtonFormField<String>(
              value: _preferredCounselor,
              decoration: InputDecoration(
                labelText: 'Preferred Counselor',
                labelStyle: CalmTheme.bodyMedium.copyWith(
                  color: CalmTheme.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: CalmTheme.sage),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: CalmTheme.primaryGreen),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _counselors.map((counselor) {
                return DropdownMenuItem(
                  value: counselor,
                  child: Text(
                    counselor,
                    style: CalmTheme.bodyMedium.copyWith(
                      color: CalmTheme.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _preferredCounselor = value!;
                });
              },
            ),
            SizedBox(height: CalmTheme.spacingM),

            // Date Selection
            _buildDateSelector(),
            SizedBox(height: CalmTheme.spacingM),

            // Time Slot Selection
            _buildTimeSlotSelector(),
            SizedBox(height: CalmTheme.spacingM),

            // Concern/Notes Field
            TextFormField(
              controller: _concernController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Concerns or Notes (Optional)',
                labelStyle: CalmTheme.bodyMedium.copyWith(
                  color: CalmTheme.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: CalmTheme.sage),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: CalmTheme.primaryGreen),
                ),
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: CalmTheme.spacingL),

            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: CalmTheme.primaryButton.copyWith(
                  minimumSize: MaterialStateProperty.all(const Size(0, 50)),
                ),
                child: Text(
                  'Book Appointment',
                  style: CalmTheme.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Date *',
          style: CalmTheme.bodyMedium.copyWith(
            color: CalmTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: CalmTheme.spacingS),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: CalmTheme.primaryGreen,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: CalmTheme.textPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                _selectedDate = '${picked.day}/${picked.month}/${picked.year}';
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(CalmTheme.spacingM),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: CalmTheme.sage),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: CalmTheme.textSecondary,
                  size: 20,
                ),
                SizedBox(width: CalmTheme.spacingS),
                Text(
                  _selectedDate.isEmpty ? 'Select Date' : _selectedDate,
                  style: CalmTheme.bodyMedium.copyWith(
                    color: _selectedDate.isEmpty ? CalmTheme.textSecondary : CalmTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots *',
          style: CalmTheme.bodyMedium.copyWith(
            color: CalmTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: CalmTheme.spacingS),
        Wrap(
          spacing: CalmTheme.spacingS,
          runSpacing: CalmTheme.spacingS,
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeSlot = slot;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: CalmTheme.spacingM,
                  vertical: CalmTheme.spacingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? CalmTheme.primaryGreen : Colors.white,
                  border: Border.all(
                    color: isSelected ? CalmTheme.primaryGreen : CalmTheme.sage,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slot,
                  style: CalmTheme.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : CalmTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBookingConfirmation() {
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
          
          Text(
            'Appointment Booked Successfully!',
            style: CalmTheme.headingMedium.copyWith(
              color: CalmTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: CalmTheme.spacingM),
          
          Text(
            'Your counseling session has been scheduled. Please save your booking details for reference.',
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
                
                _buildDetailRow('Booking ID:', _bookingId),
                _buildDetailRow('Counselor:', _preferredCounselor),
                _buildDetailRow('Date:', _selectedDate),
                _buildDetailRow('Time:', _selectedTimeSlot),
                
                if (_concernController.text.isNotEmpty) ...[
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
                    _concernController.text,
                    style: CalmTheme.bodyMedium.copyWith(
                      color: CalmTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: CalmTheme.spacingL),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: CalmTheme.primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, 45),
                  ),
                  child: Text(
                    'Book Another',
                    style: CalmTheme.bodyMedium.copyWith(
                      color: CalmTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: CalmTheme.spacingM),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: CalmTheme.primaryButton.copyWith(
                    minimumSize: MaterialStateProperty.all(const Size(0, 45)),
                  ),
                  child: Text(
                    'Done',
                    style: CalmTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
}