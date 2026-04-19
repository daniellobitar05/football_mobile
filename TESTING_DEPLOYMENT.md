# Testing & Deployment Guide

## Unit Testing

### Running Tests

```bash
flutter test
```

### Example Unit Tests

#### Test API Service:
```dart
// test/services/football_api_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fot_mob_app/services/football_api_service.dart';

void main() {
  group('FootballApiService', () {
    late FootballApiService apiService;

    setUp(() {
      apiService = FootballApiService();
    });

    test('getLiveMatches returns non-empty list', () async {
      final matches = await apiService.getLiveMatches();
      expect(matches, isNotEmpty);
    });

    test('getMatches with valid parameters returns matches', () async {
      final matches = await apiService.getMatches(daysAhead: 7);
      expect(matches, isList);
    });

    test('getStandings returns valid standings', () async {
      final standings = await apiService.getStandings('PL');
      expect(standings, isNotEmpty);
      expect(standings.first.position, greaterThan(0));
    });
  });
}
```

#### Test Providers:
```dart
// test/providers/matches_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fot_mob_app/providers/matches_provider.dart';

void main() {
  group('MatchesProvider', () {
    test('initial state is correct', () {
      final provider = MatchesProvider();
      expect(provider.matches, isEmpty);
      expect(provider.isLoading, isFalse);
    });

    test('fetchMatches updates state correctly', () async {
      final provider = MatchesProvider();
      await provider.fetchMatches();
      
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });
  });
}
```

## Widget Testing

```dart
// test/widgets/match_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fot_mob_app/widgets/match_card.dart';
import 'package:fot_mob_app/models/match.dart';

void main() {
  group('MatchCard Widget', () {
    testWidgets('displays match information correctly', (WidgetTester tester) async {
      // Mock match object
      final mockMatch = Match(
        id: 1,
        utcDate: '2024-04-20T15:00:00Z',
        status: 'LIVE',
        homeTeam: Team(id: 1, name: 'Home', shortName: 'HOM'),
        awayTeam: Team(id: 2, name: 'Away', shortName: 'AWA'),
        score: Score(winner: 'HOME', fullTimeScore: ScoreDetails(home: 2, away: 1)),
        competition: Competition(id: 1, name: 'League', code: 'LG'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MatchCard(
              match: mockMatch,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify match info is displayed
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Away'), findsOneWidget);
      expect(find.text('2 - 1'), findsOneWidget);
    });

    testWidgets('tap triggers callback', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MatchCard(
              match: mockMatch,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MatchCard));
      expect(tapped, isTrue);
    });
  });
}
```

## Integration Testing

```dart
// test_driver/app.dart
import 'package:flutter/material.dart';
import 'package:fot_mob_app/main.dart' as app;

void main() {
  app.main();
}

// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fot_mob_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Full app flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify home screen is displayed
      expect(find.text('Football Live'), findsOneWidget);

      // Verify tabs are present
      expect(find.byType(TabBar), findsOneWidget);

      // Tap standings tab
      await tester.tap(find.text('🏆 STANDINGS'));
      await tester.pumpAndSettle();

      // Verify standings screen loaded
      expect(find.text('League Standings'), findsOneWidget);
    });
  });
}
```

## Building for Release

### Android Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release

# Output location: build/app/outputs/
```

### iOS Build

```bash
# Build IPA
flutter build ios --release

# Archive for App Store
# Use Xcode: Product → Archive
```

### Web Build

```bash
flutter build web --release
# Output: build/web/
```

## Performance Testing

```dart
// test/performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fot_mob_app/providers/matches_provider.dart';

void main() {
  test('Matches provider performance', () async {
    final provider = MatchesProvider();
    
    final stopwatch = Stopwatch()..start();
    await provider.fetchMatches();
    stopwatch.stop();
    
    print('Fetch time: ${stopwatch.elapsedMilliseconds}ms');
    expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Should be < 5 seconds
  });
}
```

## Firebase Testing

### Test Firestore Rules Locally:

```bash
# Start emulator suite
firebase emulators:start --only firestore

# Run tests against emulator
flutter test --dart-define=FIRESTORE_EMULATOR_HOST=localhost:8080
```

## App Size Optimization

```bash
# Analyze app size
flutter build apk --analyze-size

# Build with code shrinking
flutter build apk --release --shrink
```

## Pre-Deployment Checklist

- [ ] All tests passing
- [ ] No lint warnings
- [ ] Update version in pubspec.yaml
- [ ] Update build number
- [ ] Test on physical devices
- [ ] Test all features
- [ ] Verify API keys are set correctly
- [ ] Firebase configured for production
- [ ] Privacy policy ready
- [ ] App icon and splash screen finalized
- [ ] Screenshots for app store
- [ ] Description and changelog written
- [ ] Privacy policy reviewed
- [ ] Terms of service prepared

## Deployment to App Stores

### Google Play Store:

1. Create signing key:
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

2. Configure signing in `android/app/build.gradle`

3. Build release bundle:
```bash
flutter build appbundle --release
```

4. Upload to Google Play Console

### Apple App Store:

1. Create App ID in Apple Developer
2. Configure signing in Xcode
3. Build in Xcode: Product → Archive
4. Upload to App Store Connect

### Web Deployment:

```bash
# Build web app
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting

# Or deploy to other hosts (Vercel, Netlify, etc.)
```

## Monitoring & Analytics

### Firebase Analytics:

- User engagement
- Event tracking
- Crash reporting
- Performance monitoring

### Custom Analytics:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;

// Log custom event
await analytics.logEvent(
  name: 'match_viewed',
  parameters: {
    'match_id': matchId,
    'competition': competitionCode,
  },
);

// Log screen view
await analytics.logScreenView(
  screenName: 'MatchDetailsScreen',
);
```

## Troubleshooting

### Build Issues:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

### CocoaPods Issues (iOS):
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Gradle Issues (Android):
```bash
cd android
./gradlew clean
cd ..
flutter pub get
```

## Continuous Integration

### GitHub Actions Example:

```yaml
name: Flutter CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v1
        with:
          flutter-version: '3.10.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk
```
