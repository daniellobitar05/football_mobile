# Architecture & Design Document

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ HomeScreen   │  │ Match Details│  │ Standings    │     │
│  │              │  │ Screen       │  │ Screen       │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         └────────────┬─────────────────┬──────┘             │
└────────────────────┼───────────────────┼──────────────────┘
                     │                   │
┌────────────────────┼───────────────────┼──────────────────┐
│   State Management Layer (Provider)    │                  │
│  ┌─────────────────────────────────────┼────────────────┐ │
│  │  MatchesProvider    │  StandingsProvider │            │ │
│  └────────────┬────────┴────────┬─────────────┘            │
└───────────────┼─────────────────┼──────────────────────────┘
                │                 │
┌───────────────┼─────────────────┼──────────────────────────┐
│        Business Logic Layer (Services)                     │
│  ┌──────────────────────┐  ┌──────────────────────────┐  │
│  │ FootballApiService   │  │ FirebaseService          │  │
│  │ - getMatches()       │  │ - saveLiveUpdate()       │  │
│  │ - getLiveMatches()   │  │ - listenToUpdates()      │  │
│  │ - getStandings()     │  │ - addFavorite()          │  │
│  └──────────┬───────────┘  └──────────┬──────────────┘  │
│  ┌──────────────────────────────────────────────────────┐ │
│  │ NotificationService                                  │ │
│  │ - initializeNotifications()                          │ │
│  │ - subscribeToMatch()                                 │ │
│  │ - subscribeToTeam()                                  │ │
│  └──────────────────────────────────────────────────────┘ │
└────────┬──────────────────────────────────────┬────────────┘
         │                                      │
         ▼                                      ▼
┌────────────────────────────────────────────────────────────┐
│              External Services & APIs                      │
│  ┌──────────────────┐              ┌────────────────────┐ │
│  │ football-data.org│              │ Firebase Services  │ │
│  │      API         │              │ - Firestore        │ │
│  │                  │              │ - Cloud Messaging  │ │
│  └──────────────────┘              │ - Storage          │ │
│                                    └────────────────────┘ │
└────────────────────────────────────────────────────────────┘
```

## Design Patterns Used

### 1. **Provider Pattern** (State Management)
- Implements ChangeNotifier for reactive updates
- Decouples UI from business logic
- Allows easy testing of logic without UI

```dart
// Usage in widget
Consumer<MatchesProvider>(
  builder: (context, matchesProvider, _) {
    return ListView.builder(
      itemCount: matchesProvider.matches.length,
      itemBuilder: (context, index) {
        return MatchCard(match: matchesProvider.matches[index]);
      },
    );
  },
);
```

### 2. **Singleton Pattern** (Services)
- Ensures single instance of each service
- Prevents multiple API calls for same resource
- Manages application state globally

```dart
class FootballApiService {
  static final FootballApiService _instance = FootballApiService();
  
  factory FootballApiService() => _instance;
}
```

### 3. **Repository Pattern** (Data Access)
- Services act as repositories
- Abstract data source (API vs Local)
- Single point of data access

### 4. **Observer Pattern** (Firestore)
- Real-time listeners using `snapshots()`
- Automatic UI updates on data change
- Efficient data synchronization

```dart
_firestore.collection('live_matches')
  .doc(matchId.toString())
  .snapshots()
  .listen((snapshot) => updateUI());
```

## Data Flow

### Getting Matches:
```
User Action (Refresh)
    ↓
HomeScreen.initState() / refreshButton.onPressed()
    ↓
MatchesProvider.fetchMatches()
    ↓
FootballApiService.getMatches()
    ↓
HTTP Request to football-data.org
    ↓
Parse JSON → Match models
    ↓
MatchesProvider.notifyListeners()
    ↓
UI Rebuilds with new data
```

### Real-time Updates:
```
Firebase Cloud Function detects match update
    ↓
Publishes message to FCM topic
    ↓
NotificationService.onMessage listener
    ↓
Shows notification + handles custom data
    ↓
FirebaseService.saveLiveMatchUpdate()
    ↓
Stores in Firestore
    ↓
HomeScreen listening to Firestore snapshots
    ↓
UI Updates in real-time
```

## Error Handling Strategy

### API Errors:
```dart
try {
  final matches = await _apiService.getMatches();
} on DioException catch (e) {
  // Handle different error types
  if (e.response?.statusCode == 401) {
    // Invalid API key
  } else if (e.response?.statusCode == 429) {
    // Rate limited
  } else if (e.type == DioExceptionType.connectionTimeout) {
    // Network timeout
  }
  _error = 'Failed to load matches: $e';
} catch (e) {
  // Unexpected error
  _error = 'Unexpected error: $e';
} finally {
  notifyListeners();
}
```

### UI Error Display:
```dart
if (matchesProvider.error != null) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.error_outline, size: 64),
        Text(matchesProvider.error),
        ElevatedButton(
          onPressed: () => matchesProvider.fetchMatches(),
          child: Text('Retry'),
        ),
      ],
    ),
  );
}
```

## Caching Strategy

### Three-Level Cache:
1. **Memory Cache** - In-app MatchesProvider
2. **Local Storage** - SharedPreferences for user preferences
3. **Firestore Cache** - Server-side data caching

```dart
// Memory cache example
Map<String, CachedData<List<Match>>> _matchesCache = {};

Future<List<Match>> getMatches() async {
  final cacheKey = 'matches_${DateTime.now().day}';
  
  if (_matchesCache.containsKey(cacheKey) && 
      !_matchesCache[cacheKey]!.isExpired) {
    return _matchesCache[cacheKey]!.data;
  }
  
  final matches = await _apiService.getMatches();
  _matchesCache[cacheKey] = CachedData(
    data: matches,
    timestamp: DateTime.now(),
  );
  return matches;
}
```

## Performance Considerations

### 1. **Image Caching**
```dart
Image.network(
  teamCrest,
  cacheWidth: 100,
  cacheHeight: 100,
)
```

### 2. **Lazy Loading**
```dart
ListView.builder(
  itemBuilder: (context, index) {
    // Only builds visible items
    return MatchCard(match: matches[index]);
  },
)
```

### 3. **Efficient Rebuilds**
```dart
// Only rebuild when MatchesProvider changes
Consumer<MatchesProvider>(
  builder: (context, provider, _) {
    // rebuild on provider change
  },
)

// Multiple providers with specific selectors
Selector<MatchesProvider, List<Match>>(
  selector: (_, provider) => provider.liveMatches,
  builder: (context, liveMatches, _) {
    // rebuild only when liveMatches changes
  },
)
```

## Security Considerations

### 1. **API Key Management**
```dart
// Never commit API keys
// Use environment variables or secure storage
const String apiKey = String.fromEnvironment(
  'FOOTBALL_API_KEY',
  defaultValue: 'YOUR_API_KEY',
);
```

### 2. **Firestore Security Rules**
```
// Only allow reading public data
match /cached_matches/{document=**} {
  allow read: if true;
  allow write: if false;
}

// User data is private
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}
```

### 3. **Input Validation**
```dart
// Validate user input before API calls
String validateTeamName(String name) {
  if (name.isEmpty) throw ArgumentError('Team name cannot be empty');
  if (name.length > 100) throw ArgumentError('Team name too long');
  return name;
}
```

## Testing Strategy

### Unit Tests
- Test individual functions
- Mock API responses
- Verify error handling

### Widget Tests
- Test UI components
- Verify user interactions
- Check visual output

### Integration Tests
- Test complete user flows
- Verify app initialization
- Test navigation

## Future Scalability

### Planned Enhancements:
1. **User Authentication** - User accounts & preferences
2. **Advanced Filtering** - By team, competition, date range
3. **Player Statistics** - Individual player performance data
4. **Social Features** - Comments, sharing, predictions
5. **Offline Mode** - Cached data availability offline
6. **Multi-language** - i18n support for 10+ languages
7. **Analytics** - Custom analytics dashboard
8. **Admin Panel** - For moderating user content

## Code Organization Principles

1. **Single Responsibility** - Each class has one reason to change
2. **DRY (Don't Repeat Yourself)** - Reusable widgets & functions
3. **SOLID Principles** - Dependency injection, interfaces
4. **Separation of Concerns** - Clear boundaries between layers
5. **Naming Conventions** - Clear, descriptive names

## Configuration Management

```dart
// Centralized configuration
abstract class AppConfig {
  static const String apiBaseUrl = 'https://api.football-data.org/v4';
  static const String apiKey = 'YOUR_API_KEY';
  static const Duration apiTimeout = Duration(seconds: 10);
  static const Map<String, String> competitions = {
    'PL': 'Premier League',
    // ...
  };
}
```

## Monitoring & Logging

```dart
// Structured logging
class Logger {
  static void info(String message) => print('ℹ️  $message');
  static void success(String message) => print('✅ $message');
  static void error(String message) => print('❌ $message');
  static void warning(String message) => print('⚠️  $message');
}

// Usage in services
Logger.info('Fetching matches...');
final matches = await _apiService.getMatches();
Logger.success('Matches fetched: ${matches.length} items');
```
