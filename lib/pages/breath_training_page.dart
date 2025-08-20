import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'completion_page.dart';

class BreathTrainingPage extends StatefulWidget {
  const BreathTrainingPage({super.key});

  @override
  State<BreathTrainingPage> createState() => _BreathTrainingPageState();
}

class _BreathTrainingPageState extends State<BreathTrainingPage>
    with TickerProviderStateMixin {
  late AnimationController _breathAnimationController;
  late Animation<double> _breathAnimation;
  
  Timer? _timer;
  Timer? _breathTimer;
  int _seconds = 0;
  int _minutes = 5; // Start from 5:00
  bool _isPlaying = false;
  late AudioPlayer _audioPlayer;
  
  // Breathing phases
  String _currentPhase = 'Inhale';
  int _phaseSeconds = 0;
  final int _inhaleSeconds = 4;
  final int _holdSeconds = 4;
  final int _exhaleSeconds = 4;
  
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // Initialize breathing animation
    _breathAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _breathAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathAnimationController,
      curve: Curves.easeInOut,
    ));
    
    // Start timers
    _startTimer();
    _startBreathingCycle();
    _playAudio();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _breathTimer?.cancel();
    _breathAnimationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
  
  void _startBreathingCycle() {
    // Start with inhale animation immediately
    _breathAnimationController.reset();
    _breathAnimationController.forward();
    
    _breathTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _phaseSeconds++;
        
        if (_currentPhase == 'Inhale' && _phaseSeconds >= _inhaleSeconds) {
          _currentPhase = 'Hold';
          _phaseSeconds = 0;
          // Keep animation at max size during hold
        } else if (_currentPhase == 'Hold' && _phaseSeconds >= _holdSeconds) {
          _currentPhase = 'Exhale';
          _phaseSeconds = 0;
          // Start exhale animation (shrink)
          _breathAnimationController.reverse();
        } else if (_currentPhase == 'Exhale' && _phaseSeconds >= _exhaleSeconds) {
          _currentPhase = 'Inhale';
          _phaseSeconds = 0;
          // Start inhale animation (grow)
          _breathAnimationController.forward();
        }
      });
    });
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else if (_minutes > 0) {
          _minutes--;
          _seconds = 59;
        } else {
          _timer?.cancel();
          _completeExercise();
        }
      });
      
      // Update progress (removed as progress bar is not in UI)
      // double totalSeconds = 5 * 60; // 5 minutes
      // double elapsed = (5 * 60 - (_minutes * 60 + _seconds)).toDouble();
      // _progressAnimationController.value = elapsed / totalSeconds;
    });
  }
  
  void _playAudio() async {
    try {
      await _audioPlayer.play(AssetSource('audio/breathing_audio.mp3'));
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
  
  void _pauseResumeAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _timer?.cancel(); // Stop the countdown timer
      _breathTimer?.cancel();
      _breathAnimationController.stop();
    } else {
      await _audioPlayer.resume();
      _startTimer(); // Restart the countdown timer
      _startBreathingCycle();
      
      // Resume animation based on current phase
      if (_currentPhase == 'Inhale') {
        _breathAnimationController.forward();
      } else if (_currentPhase == 'Exhale') {
        _breathAnimationController.reverse();
      }
      // Hold phase keeps animation stopped
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }
  
  void _completeExercise() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CompletionPage()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.black54),
                    onPressed: () {
                      // Toggle sound
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Breath Training title
                  const Text(
                    'Breath Training',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Timer
                  Text(
                    '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Breathing instruction
                  Text(
                    _currentPhase,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Breathing circle (animated)
                  AnimatedBuilder(
                    animation: _breathAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 200 * _breathAnimation.value,
                        height: 200 * _breathAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF60A5FA).withOpacity(0.3),
                              const Color(0xFF3B82F6).withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.air,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 60),
                  
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.skip_previous, color: Color(0xFF3B82F6)),
                          onPressed: () {
                            // Previous track
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      
                      // Play/Pause button
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: _pauseResumeAudio,
                        ),
                      ),
                      const SizedBox(width: 20),
                      
                      // Next button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.skip_next, color: Color(0xFF3B82F6)),
                          onPressed: () {
                            // Next track
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
