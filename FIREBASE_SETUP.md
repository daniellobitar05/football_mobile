# Firebase Configuration Guide

## Setup Steps

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter your project name (e.g., "football-live-app")
4. Enable Google Analytics (optional)
5. Create the project

### 2. Register Your App

#### For Android:
1. In Firebase console, click "Android" icon
2. Enter package name: `com.example.fot_mob_app`
3. Download `google-services.json`
4. Place in `android/app/` directory

#### For iOS:
1. In Firebase console, click "iOS" icon
2. Enter bundle ID: `com.example.fotMobApp`
3. Download `GoogleService-Info.plist`
4. Add to Xcode (Runner target)

### 3. Enable Required Services

#### Cloud Firestore:
1. Go to "Build" → "Firestore Database"
2. Click "Create Database"
3. Choose "Start in test mode" (for development)
4. Choose region (e.g., us-central1)
5. Click "Enable"

#### Cloud Messaging (for notifications):
1. Go to "Build" → "Cloud Messaging"
2. Enable Cloud Messaging API
3. Configure notification settings

#### Authentication (Optional - for user login):
1. Go to "Build" → "Authentication"
2. Click "Get started"
3. Enable "Anonymous" sign-in (quick start)

### 4. Apply Firestore Security Rules

1. In Firestore, go to "Rules" tab
2. Replace default rules with content from `firestore.rules`
3. Click "Publish"

### 5. Enable API Keys

1. Go to "Project settings" → "APIs & Services"
2. Enable these APIs:
   - Firestore API
   - Cloud Messaging API
   - Cloud Storage API

## Configuration in Flutter

### Initialize Firebase in main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Generate firebase_options.dart

Run in terminal:
```bash
flutterfire configure
```

This will:
- Detect your Firebase project
- Generate firebase_options.dart
- Configure Android and iOS automatically

## Environment Configuration

Create `.env` file in project root:

```env
FOOTBALL_API_KEY=your_football_data_api_key
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_STORAGE_BUCKET=your-firebase-storage-bucket
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
```

## Testing Firestore Locally

### Using Firebase Emulator Suite

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Start emulator
firebase emulators:start
```

### Configure app to use emulator:

```dart
if (kDebugMode) {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

## Common Firestore Operations

### Save data:
```dart
await FirebaseFirestore.instance
    .collection('live_matches')
    .doc(matchId.toString())
    .set({
      'matchId': matchId,
      'homeTeam': match.homeTeam.name,
      'awayTeam': match.awayTeam.name,
      'score': '${match.score.homeGoals}-${match.score.awayGoals}',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
```

### Listen to real-time updates:
```dart
FirebaseFirestore.instance
    .collection('live_matches')
    .doc(matchId.toString())
    .snapshots()
    .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        // Update UI
      }
    });
```

### Query with filters:
```dart
await FirebaseFirestore.instance
    .collection('live_matches')
    .where('status', isEqualTo: 'LIVE')
    .orderBy('updatedAt', descending: true)
    .limit(10)
    .get();
```

## Push Notifications Setup

### Android:

1. Open `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
    classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
}
```

2. Open `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.firebase:firebase-messaging'
}
```

### iOS:

1. Enable Push Notifications in Xcode:
   - Select Runner → Signing & Capabilities
   - Click "+ Capability"
   - Add "Push Notifications"

2. Configure APNs certificate in Firebase console

## Monitoring & Analytics

1. Go to Firebase console
2. Check "Analytics" dashboard for user activity
3. Monitor Firestore usage in "Firestore Database"
4. Review Cloud Messaging statistics

## Troubleshooting

### Can't connect to Firebase:
```bash
# Check internet connection
# Clear Flutter cache
flutter clean
flutter pub get
```

### Firestore permissions denied:
- Check Firestore Rules
- Ensure user is authenticated if rules require it
- Use Firebase emulator for testing

### APK size increase due to Firebase:
- Use ProGuard/R8 for minification
- Enable code shrinking in release builds

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
