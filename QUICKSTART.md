# Quick Start Guide

## 5-Minute Setup

### 1. Get Your API Key (2 minutes)
```
1. Visit: https://www.football-data.org/
2. Register for free account
3. Copy your API key from dashboard
```

### 2. Add API Key (1 minute)
Open `lib/services/football_api_service.dart` and replace:
```dart
static const String apiKey = 'YOUR_API_KEY_HERE';
```
with your actual API key.

### 3. Install Dependencies (1 minute)
```bash
flutter pub get
```

### 4. Run the App (1 minute)
```bash
flutter run
```

## What You Get

✅ **Live Match Tracking** - Real-time match scores
✅ **League Standings** - Complete league tables
✅ **Beautiful UI** - Modern gradient cards and animations
✅ **Multiple Tabs** - Live, Scheduled, and Finished matches
✅ **Dark Mode** - Automatic dark theme support
✅ **Error Handling** - Graceful error messages
✅ **Loading States** - Shimmer loading animations

## Default Features

### Home Screen Tabs:
- 🔴 LIVE - Currently playing matches
- 📅 SCHEDULED - Upcoming matches
- ✅ FINISHED - Completed matches

### Standings Screen:
- 5 major European leagues
- Complete league tables with:
  - Team position
  - Win/Draw/Loss record
  - Points and goal difference

## Project Structure at a Glance

```
fot_mob_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   ├── services/                 # API & Firebase
│   ├── providers/                # State management
│   ├── screens/                  # Pages
│   ├── widgets/                  # UI components
│   ├── config/                   # Constants
│   └── utils/                    # Helpers
├── pubspec.yaml                  # Dependencies
├── SETUP.md                       # Full setup guide
├── API_INTEGRATION.md             # API documentation
├── FIREBASE_SETUP.md              # Firebase guide
├── ARCHITECTURE.md                # System design
└── TESTING_DEPLOYMENT.md          # Testing & deployment
```

## Common Tasks

### Add a New Feature

1. Create model in `lib/models/`
2. Add API method in `FootballApiService`
3. Create provider in `lib/providers/`
4. Build UI in `lib/screens/` or `lib/widgets/`
5. Add to navigation in `main.dart`

### Add Firebase (Optional)

1. Create Firebase project
2. Run: `flutterfire configure`
3. Uncomment Firebase initialization in `main.dart`
4. Use `FirebaseService` in your code

### Style Customization

Colors are in `lib/config/app_colors.dart`:
```dart
class AppColors {
  static const primaryBlue = Color(0xFF1976D2);
  // Change these to customize colors
}
```

## Next Steps

1. **Test the app** - Run it and explore all features
2. **Customize colors** - Update AppColors class
3. **Add Firebase** - Follow FIREBASE_SETUP.md for real-time updates
4. **Deploy** - See TESTING_DEPLOYMENT.md for release builds
5. **Enhance** - Add user authentication, favorites, notifications

## Troubleshooting

**App won't run:**
```bash
flutter clean
flutter pub get
flutter run
```

**API not working:**
- Check API key is correct
- Verify internet connection
- Check football-data.org website is accessible

**Firebase errors:**
- Run `flutterfire configure`
- Check Firebase project configuration
- Verify google-services.json (Android) or GoogleService-Info.plist (iOS)

## Resources

- 📚 [Flutter Docs](https://flutter.dev/docs)
- 🏟️ [Football Data API](https://www.football-data.org/documentation)
- 🔥 [Firebase Docs](https://firebase.google.com/docs)
- 📖 [Provider Package](https://pub.dev/packages/provider)

## Need Help?

Check these documentation files:
- `SETUP.md` - Installation & configuration
- `API_INTEGRATION.md` - API usage & examples
- `FIREBASE_SETUP.md` - Firebase integration
- `ARCHITECTURE.md` - System design & patterns
- `TESTING_DEPLOYMENT.md` - Testing & release

---

**You now have a professional sports app! 🚀**

All features are implemented and ready to use. Just add your API key and start exploring!
