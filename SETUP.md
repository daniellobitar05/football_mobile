# Football Live - Senior Project

A modern, feature-rich Flutter application for live football match tracking with real-time updates, standings, and team statistics.

## Features

✨ **Live Match Tracking**
- Real-time live match scores and updates
- Live match notifications
- Detailed match statistics

📅 **Match Management**
- View scheduled, live, and finished matches
- Filter matches by competition and status
- Add matches to favorites

🏆 **League Standings**
- Complete league tables for major competitions
- Team performance metrics
- Win/Draw/Loss statistics

🔔 **Real-time Updates**
- Firebase Firestore integration for live data
- Push notifications for match events
- Auto-refresh for live matches

🎨 **Modern UI**
- Beautiful gradient cards
- Smooth animations
- Dark mode support
- Responsive design

## Supported Competitions

- 🇬🇧 Premier League (PL)
- 🇪🇸 La Liga (LA)
- 🇮🇹 Serie A (SA)
- 🇩🇪 Bundesliga (BL1)
- 🇫🇷 Ligue 1 (FR1)
- 🇵🇹 Primeira Liga (PPL)
- 🇳🇱 Eredivisie (DED)
- 🏆 UEFA Champions League (CL)

## Setup Instructions

### 1. Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK 3.10.0 or higher
- Android Studio or Xcode (for mobile development)
- Git

### 2. Clone & Install Dependencies

```bash
git clone <repository-url>
cd fot_mob_app
flutter pub get
```

### 3. API Configuration

#### Football Data API (Required)

1. Visit [football-data.org](https://www.football-data.org/)
2. Register for a free account
3. Get your API key
4. Open `lib/services/football_api_service.dart`
5. Replace `'YOUR_API_KEY_HERE'` with your actual API key:

```dart
static const String apiKey = 'YOUR_ACTUAL_API_KEY';
```

### 4. Firebase Setup (Optional - For Real-time Updates)

#### For Android:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add Android app to the project
4. Download `google-services.json`
5. Place it in `android/app/`

#### For iOS:

1. Add iOS app to your Firebase project
2. Download `GoogleService-Info.plist`
3. Add it to Xcode (Runner project)

#### Enable Services:

- Cloud Firestore
- Cloud Messaging (for notifications)

### 5. Run the App

```bash
flutter clean
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── match.dart           # Match model
│   └── standing.dart        # Standing model
├── services/                # API & Firebase services
│   ├── football_api_service.dart
│   └── firebase_service.dart
├── providers/               # State management
│   ├── matches_provider.dart
│   └── standings_provider.dart
├── screens/                 # UI screens
│   ├── home_screen.dart
│   ├── match_details_screen.dart
│   └── standings_screen.dart
├── widgets/                 # Reusable widgets
│   ├── match_card.dart
│   ├── standing_row.dart
│   └── loading_shimmer.dart
├── utils/                   # Utilities & extensions
│   └── extensions.dart
└── config/                  # Configuration
    ├── app_colors.dart
    └── app_constants.dart
```

## Tech Stack

- **Framework**: Flutter 3.10.0+
- **State Management**: Provider
- **Networking**: Dio, HTTP
- **Database**: Firebase Firestore
- **Notifications**: Firebase Cloud Messaging
- **Code Generation**: json_serializable
- **UI Components**: Flutter Material 3

## Key Dependencies

```yaml
provider: ^6.0.0              # State management
dio: ^5.3.1                   # HTTP client
firebase_core: ^2.24.0        # Firebase
cloud_firestore: ^4.13.0      # Firestore
firebase_messaging: ^14.6.0   # Push notifications
shimmer: ^3.0.0               # Loading animations
intl: ^0.19.0                 # Internationalization
```

## API Usage Example

### Fetching Live Matches

```dart
final apiService = FootballApiService();
final liveMatches = await apiService.getLiveMatches();
```

### Getting League Standings

```dart
final standings = await apiService.getStandings('PL'); // Premier League
```

### Real-time Match Updates

```dart
final firebaseService = FirebaseService();
firebaseService.listenToMatchUpdates(matchId).listen((snapshot) {
  // Update UI with real-time data
});
```

## State Management with Provider

### MatchesProvider

```dart
final matchesProvider = Provider.of<MatchesProvider>(context);
await matchesProvider.fetchMatches();
final liveMatches = matchesProvider.liveMatches;
```

### StandingsProvider

```dart
final standingsProvider = Provider.of<StandingsProvider>(context);
await standingsProvider.fetchStandings('PL');
final standings = standingsProvider.getStandingsByCompetition('PL');
```

## Features to Implement Next

- [ ] User authentication (Sign up/Login)
- [ ] User preferences & favorites persistence
- [ ] Advanced match search & filtering
- [ ] Push notifications for favorite teams
- [ ] Player statistics & profiles
- [ ] Match predictions & analytics
- [ ] Social features (share, comments)
- [ ] Offline mode with cached data
- [ ] Multi-language support

## Troubleshooting

### API Key Issues
- Ensure your API key is valid and has quota remaining
- Check the football-data.org dashboard for usage stats

### Firebase Connection Issues
- Verify Firebase configuration files are correctly placed
- Check internet connection
- Ensure Firestore rules allow read access

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build
flutter run
```

## Performance Optimization

- Data caching to reduce API calls
- Image caching with cached_network_image
- Shimmer loading indicators for better UX
- Efficient state management with Provider
- Pagination for large lists

## Security Notes

- Never commit API keys to version control
- Use environment variables for sensitive data
- Implement proper Firestore security rules
- Validate all API responses

## Contributing

Contributions are welcome! Please follow the project structure and coding standards.

## License

This project is created for educational purposes.

## Author

Created as a senior university project in 2026.

---

**Note**: This is a fully-featured, production-ready sports app built with professional practices. It demonstrates:
- Clean architecture
- State management patterns
- API integration
- Real-time updates
- Modern UI/UX design
- Firebase integration
- Error handling
- Code organization
