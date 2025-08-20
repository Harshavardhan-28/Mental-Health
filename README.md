# MedicHealth Flutter App

A Flutter app for health and wellness activities with a focus on breathing exercises and meditation.

## Features

- **Activities Page**: Main dashboard showing daily activity summary
- **Start Activity**: Activity selection screen with various wellness options
- **Breath Training**: Interactive breathing exercise with timer and audio playback
- **Completion**: Activity completion summary with statistics

## Pages Overview

1. **Activities Page**: Home screen showing today's activities with completion status
2. **Start Activity Page**: Grid of available activities (Running, Walking, Fitness, Yoga, Breathing, etc.)
3. **Breath Training Page**: 
   - 5-minute breathing exercise timer
   - Animated breathing circle
   - Audio playbook controls (play/pause)
   - Progress bar showing exercise completion
4. **Completion Page**: Shows exercise completion with before/after statistics

## Audio Integration

The app includes audio playback functionality for breathing exercises:
- Uses `audioplayers` package for audio control
- Placeholder audio file: `assets/audio/breathing_audio.mp3`
- Replace the placeholder file with your actual breathing audio

## Setup Instructions

1. **Install Flutter**: Make sure Flutter SDK is installed on your system
2. **Install Dependencies**: 
   ```bash
   flutter pub get
   ```
3. **Add Audio File**: Replace `assets/audio/breathing_audio.mp3` with your actual breathing audio file
4. **Run the App**:
   ```bash
   flutter run
   ```

## Assets Needed

### Audio
- `assets/audio/breathing_audio.mp3` - Breathing exercise audio file (replace placeholder)

### Images (Optional)
- Background images can be added to `assets/images/` folder
- Update the UI code to reference actual image assets if needed

## Technology Stack

- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language
- **audioplayers**: Audio playbook functionality
- **Material Design**: UI components and animations

## Navigation Flow

```
Activities Page → Start Activity Page → Breath Training Page → Completion Page
     ↑                                                              ↓
     ←←←←←←←←←←←←←←←← Back to Daily Activities ←←←←←←←←←←←←←←←←←←
```

## Running the App

1. Connect a device or start an emulator
2. Run `flutter run` in the project directory
3. The app will launch with the Activities page as the home screen

## Notes

- Audio file is currently a placeholder - replace with actual audio
- Background images are using gradient colors - can be replaced with actual images
- All UI elements are responsive and follow Material Design guidelines
- The breathing animation provides visual guidance during exercises
