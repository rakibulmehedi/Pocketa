# Pocketa Deployment Guide

## Overview

This document provides comprehensive instructions for deploying the Pocketa personal finance management app to various platforms and environments.

## Prerequisites

### Development Environment
- Flutter 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code
- Git
- Node.js (for build tools)

### Platform-Specific Requirements

#### Android
- Android SDK 34
- Java 11 or higher
- Android Studio
- Google Play Console account

#### iOS
- macOS with Xcode 14+
- iOS 12.0+ deployment target
- Apple Developer account
- App Store Connect access

## Build Configuration

### 1. Environment Setup

#### Environment Variables
Create `.env` file in project root:
```env
# Supabase Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Firebase Configuration
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_API_KEY=your_firebase_api_key

# Analytics
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true

# Debug Mode
DEBUG=false
```

#### Build Configuration
```yaml
# pubspec.yaml
version: 1.0.0+1
name: pocketa
description: Personal Finance Management App

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.0.0"
```

### 2. Android Configuration

#### App-Level Build Configuration
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.pocketa.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

#### ProGuard Rules
```proguard
# android/app/proguard-rules.pro
-keep class com.pocketa.** { *; }
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }

# Hive
-keep class com.pocketa.data.models.** { *; }

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
```

#### App Signing
```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Create key.properties
echo "storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=../upload-keystore.jks" > android/key.properties
```

### 3. iOS Configuration

#### Info.plist Configuration
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>Pocketa</string>
<key>CFBundleIdentifier</key>
<string>com.pocketa.app</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<!-- Permissions -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan receipts</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to save receipts</string>
```

#### Xcode Project Settings
```swift
// ios/Runner.xcodeproj/project.pbxproj
IPHONEOS_DEPLOYMENT_TARGET = 12.0;
SWIFT_VERSION = 5.0;
```

## Build Process

### 1. Pre-Build Steps

#### Code Generation
```bash
# Generate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Clean build
flutter clean
flutter pub get
```

#### Environment Setup
```bash
# Copy environment file
cp .env.example .env

# Update environment variables
# Edit .env with production values
```

### 2. Android Build

#### Debug Build
```bash
# Debug APK
flutter build apk --debug

# Debug App Bundle
flutter build appbundle --debug
```

#### Release Build
```bash
# Release APK
flutter build apk --release

# Release App Bundle
flutter build appbundle --release

# Split APKs by ABI
flutter build apk --split-per-abi --release
```

#### Build Verification
```bash
# Verify APK
flutter build apk --analyze-size

# Verify App Bundle
flutter build appbundle --analyze-size
```

### 3. iOS Build

#### Debug Build
```bash
# Debug build
flutter build ios --debug

# Debug build with simulator
flutter build ios --debug --simulator
```

#### Release Build
```bash
# Release build
flutter build ios --release

# Archive for App Store
flutter build ipa --release
```

#### Build Verification
```bash
# Verify iOS build
flutter build ios --analyze-size
```

## Deployment

### 1. Android Deployment

#### Google Play Console

##### App Bundle Upload
```bash
# Build release bundle
flutter build appbundle --release

# Upload to Play Console
# Use Google Play Console web interface or gcloud CLI
gcloud auth login
gcloud config set project your-project-id
gcloud app deploy android/app-release.aab
```

##### Play Console Configuration
1. **App Information**
   - App name: Pocketa
   - Short description: Personal Finance Management
   - Full description: Comprehensive personal finance management app
   - Category: Finance
   - Content rating: Everyone

2. **Store Listing**
   - Screenshots (phone, tablet, 7-inch tablet, 10-inch tablet)
   - Feature graphic
   - App icon
   - Promotional video (optional)

3. **Release Management**
   - Production track
   - Staged rollout (10% → 50% → 100%)
   - Release notes

##### App Signing
```bash
# Generate upload key
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configure Play App Signing
# Upload key to Play Console
# Download deployment certificate
```

#### Internal Testing
```bash
# Build internal testing APK
flutter build apk --release

# Upload to Play Console Internal Testing
# Add testers via email
# Test on various devices
```

#### Beta Testing
```bash
# Build beta bundle
flutter build appbundle --release

# Upload to Play Console Beta Testing
# Configure beta testing track
# Add beta testers
```

### 2. iOS Deployment

#### App Store Connect

##### Archive Upload
```bash
# Build for App Store
flutter build ipa --release

# Upload to App Store Connect
# Use Xcode Organizer or Transporter
```

##### App Store Connect Configuration
1. **App Information**
   - App name: Pocketa
   - Subtitle: Personal Finance Management
   - Category: Finance
   - Content rights: Yes

2. **App Store Listing**
   - Screenshots (iPhone, iPad)
   - App preview videos
   - App icon
   - Description and keywords

3. **App Review Information**
   - Contact information
   - Demo account
   - Review notes
   - App review attachments

#### TestFlight
```bash
# Build for TestFlight
flutter build ipa --release

# Upload to TestFlight
# Use Xcode Organizer
# Add internal/external testers
```

#### Internal Testing
```bash
# Build for internal testing
flutter build ios --release

# Install on test devices
# Use Xcode or TestFlight
```

## Continuous Integration

### 1. GitHub Actions

#### Android CI/CD
```yaml
# .github/workflows/android.yml
name: Android CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Run tests
      run: flutter test --coverage
      
    - name: Upload coverage
      uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Generate code
      run: flutter packages pub run build_runner build --delete-conflicting-outputs
      
    - name: Build APK
      run: flutter build apk --release
      
    - name: Build App Bundle
      run: flutter build appbundle --release
      
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: android-builds
        path: build/app/outputs/
```

#### iOS CI/CD
```yaml
# .github/workflows/ios.yml
name: iOS CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Run tests
      run: flutter test --coverage
      
    - name: Upload coverage
      uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Generate code
      run: flutter packages pub run build_runner build --delete-conflicting-outputs
      
    - name: Build iOS
      run: flutter build ios --release --no-codesign
      
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: ios-builds
        path: build/ios/
```

### 2. Fastlane Integration

#### Android Fastlane
```ruby
# android/fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Build and upload to Play Console"
  lane :deploy do
    gradle(
      task: "bundle",
      build_type: "Release"
    )
    
    upload_to_play_store(
      track: "internal",
      aab: "app/build/outputs/bundle/release/app-release.aab"
    )
  end
end
```

#### iOS Fastlane
```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Build and upload to App Store"
  lane :deploy do
    build_app(
      scheme: "Runner",
      export_method: "app-store"
    )
    
    upload_to_app_store(
      ipa: "Runner.ipa"
    )
  end
end
```

## Monitoring and Analytics

### 1. Crash Reporting

#### Firebase Crashlytics
```dart
// lib/main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  runApp(MyApp());
}
```

#### Error Handling
```dart
// lib/core/error_handling/error_handler.dart
class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log to console in debug mode
    if (kDebugMode) {
      print('Error: $error');
      print('Stack trace: $stackTrace');
    }
    
    // Report to Crashlytics in release mode
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
```

### 2. Performance Monitoring

#### Firebase Performance
```dart
// lib/core/performance/performance_monitor.dart
class PerformanceMonitor {
  static void trackPageLoad(String pageName, Duration loadTime) {
    FirebasePerformance.instance.newTrace('page_load').then((trace) {
      trace.putAttribute('page_name', pageName);
      trace.putMetric('load_time_ms', loadTime.inMilliseconds);
      trace.stop();
    });
  }
  
  static void trackUserAction(String action, Map<String, dynamic> parameters) {
    FirebaseAnalytics.instance.logEvent(
      name: 'user_action',
      parameters: {
        'action': action,
        ...parameters,
      },
    );
  }
}
```

### 3. Analytics

#### Firebase Analytics
```dart
// lib/core/analytics/analytics_service.dart
class AnalyticsService {
  static Future<void> trackEvent(String eventName, Map<String, dynamic> parameters) async {
    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }
  
  static Future<void> setUserProperty(String key, String value) async {
    await FirebaseAnalytics.instance.setUserProperty(
      name: key,
      value: value,
    );
  }
}
```

## Security

### 1. Code Obfuscation

#### Android Obfuscation
```gradle
// android/app/build.gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### iOS Obfuscation
```bash
# Use Flutter's built-in obfuscation
flutter build ios --release --obfuscate --split-debug-info=build/debug-info
```

### 2. API Security

#### Environment Variables
```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: false);
}
```

#### Secure Storage
```dart
// lib/core/storage/secure_storage.dart
class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> store(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }
}
```

## Rollback Strategy

### 1. App Store Rollback

#### Google Play Console
1. Go to Play Console → Release management
2. Select the problematic release
3. Click "Halt rollout" or "Rollback"
4. Monitor crash reports and user feedback

#### App Store Connect
1. Go to App Store Connect → App Store
2. Select the problematic version
3. Click "Remove from sale"
4. Submit a new version with fixes

### 2. Feature Flags

#### Feature Toggle
```dart
// lib/core/features/feature_flags.dart
class FeatureFlags {
  static const bool enableNewFeature = bool.fromEnvironment('ENABLE_NEW_FEATURE', defaultValue: false);
  static const bool enableBetaFeatures = bool.fromEnvironment('ENABLE_BETA_FEATURES', defaultValue: false);
}
```

#### Remote Configuration
```dart
// lib/core/features/remote_config.dart
class RemoteConfig {
  static Future<void> initialize() async {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
  }
  
  static bool getFeatureFlag(String key) {
    return FirebaseRemoteConfig.instance.getBool(key);
  }
}
```

## Post-Deployment

### 1. Monitoring

#### Key Metrics
- Crash rate
- ANR (Application Not Responding) rate
- App launch time
- Memory usage
- Battery usage
- User engagement

#### Monitoring Tools
- Firebase Crashlytics
- Firebase Performance
- Firebase Analytics
- Google Play Console
- App Store Connect

### 2. User Feedback

#### Feedback Collection
```dart
// lib/core/feedback/feedback_service.dart
class FeedbackService {
  static Future<void> submitFeedback(String feedback) async {
    // Send to backend
    await ApiService.post('/feedback', {'message': feedback});
    
    // Track analytics
    await AnalyticsService.trackEvent('feedback_submitted', {
      'feedback_length': feedback.length,
    });
  }
}
```

#### In-App Rating
```dart
// lib/core/rating/in_app_rating.dart
class InAppRating {
  static Future<void> requestRating() async {
    await InAppReview.requestReview();
  }
}
```

### 3. Updates

#### Over-the-Air Updates
```dart
// lib/core/updates/update_service.dart
class UpdateService {
  static Future<void> checkForUpdates() async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.performImmediateUpdate();
    }
  }
}
```

## Troubleshooting

### 1. Common Issues

#### Build Failures
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

#### Signing Issues
```bash
# Verify keystore
keytool -list -v -keystore upload-keystore.jks

# Check signing configuration
flutter build apk --release --verbose
```

#### iOS Build Issues
```bash
# Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter build ios --release
```

### 2. Debug Information

#### Log Collection
```dart
// lib/core/debug/debug_logger.dart
class DebugLogger {
  static void log(String message) {
    if (kDebugMode) {
      print('[$message] ${DateTime.now()}');
    }
  }
}
```

#### Crash Analysis
```dart
// lib/core/debug/crash_analyzer.dart
class CrashAnalyzer {
  static void analyzeCrash(Object error, StackTrace stackTrace) {
    // Analyze crash patterns
    // Send to analytics
    // Generate reports
  }
}
```

## Best Practices

### 1. Release Management
- Use semantic versioning
- Maintain release notes
- Test on multiple devices
- Monitor crash reports
- Plan rollback strategy

### 2. Security
- Obfuscate sensitive code
- Use secure storage
- Validate all inputs
- Implement proper authentication
- Regular security audits

### 3. Performance
- Monitor app performance
- Optimize for different devices
- Use efficient algorithms
- Minimize memory usage
- Test on low-end devices

### 4. User Experience
- Collect user feedback
- Monitor user behavior
- A/B test features
- Improve based on data
- Maintain backward compatibility
