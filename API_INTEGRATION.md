# API Integration Guide - Football Data

## Getting Started

### 1. Sign Up for API Key

1. Visit [football-data.org](https://www.football-data.org/)
2. Click "Register"
3. Create your account
4. Go to your profile
5. Copy your API key (it will be in the Pricing section after free tier selection)

### 2. Update Configuration

In `lib/services/football_api_service.dart`:

```dart
static const String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your key
```

## API Endpoints & Usage

### Getting Matches

#### All Matches with Filters:
```dart
final apiService = FootballApiService();
final matches = await apiService.getMatches(
  status: 'SCHEDULED,LIVE,FINISHED',
  daysAhead: 7,
);
```

#### Live Matches Only:
```dart
final liveMatches = await apiService.getLiveMatches();
```

#### Specific Competition:
```dart
final plMatches = await apiService.getCompetitionMatches('PL');
```

### Getting League Tables

```dart
final standings = await apiService.getStandings('PL'); // Premier League
```

## Available Competitions

| Code | Competition | Country |
|------|-------------|---------|
| PL | Premier League | 🇬🇧 England |
| LA | La Liga | 🇪🇸 Spain |
| SA | Serie A | 🇮🇹 Italy |
| BL1 | Bundesliga | 🇩🇪 Germany |
| FR1 | Ligue 1 | 🇫🇷 France |
| PPL | Primeira Liga | 🇵🇹 Portugal |
| DED | Eredivisie | 🇳🇱 Netherlands |
| CL | UEFA Champions League | 🏆 Europe |

## Match Status Values

- `SCHEDULED` or `TIMED` - Match not started
- `LIVE` or `IN_PLAY` - Match in progress
- `PAUSED` - Match halftime
- `FINISHED` - Match completed
- `POSTPONED` - Match postponed
- `CANCELLED` - Match cancelled
- `SUSPENDED` - Match suspended

## Response Models

### Match Object:
```dart
Match(
  id: 123456,
  utcDate: '2024-04-20T15:00:00Z',
  status: 'LIVE',
  homeTeam: Team(...),
  awayTeam: Team(...),
  score: Score(
    winner: 'HOME',
    fullTimeScore: ScoreDetails(home: 2, away: 1),
  ),
  competition: Competition(...),
)
```

### Standing Object:
```dart
Standing(
  position: 1,
  team: Team(...),
  playedGames: 30,
  won: 20,
  draw: 5,
  lost: 5,
  points: 65,
  goalsFor: 65,
  goalsAgainst: 25,
  goalDifference: 40,
)
```

## Error Handling

The API service includes error handling:

```dart
try {
  final matches = await apiService.getMatches();
} on DioException catch (e) {
  print('Error: ${e.message}');
  // Handle specific error types
  if (e.response?.statusCode == 401) {
    print('Invalid API key');
  } else if (e.response?.statusCode == 429) {
    print('Rate limit exceeded');
  }
}
```

## Rate Limiting

Free tier limits:
- 10 requests per minute
- 100 requests per day

Paid tier:
- Up to 100 requests per minute
- No daily limit

### Implementing Rate Limit Handling:

```dart
Duration _lastRequestTime = Duration.zero;
const int _rateLimitMs = 100; // 10 requests per second

Future<List<Match>> getMatches() async {
  final elapsed = DateTime.now().difference(DateTime.now().subtract(_lastRequestTime));
  if (elapsed.inMilliseconds < _rateLimitMs) {
    await Future.delayed(
      Duration(milliseconds: _rateLimitMs - elapsed.inMilliseconds),
    );
  }
  _lastRequestTime = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch);
  return _apiService.getMatches();
}
```

## Caching Strategy

Implement local caching to reduce API calls:

```dart
// Cache matches for 5 minutes
final _matchesCache = <String, CachedData<List<Match>>>{};
const Duration _cacheDuration = Duration(minutes: 5);

Future<List<Match>> getMatches() async {
  final cacheKey = 'all_matches';
  final cached = _matchesCache[cacheKey];
  
  if (cached != null && !cached.isExpired) {
    return cached.data;
  }
  
  final matches = await _apiService.getMatches();
  _matchesCache[cacheKey] = CachedData(
    data: matches,
    timestamp: DateTime.now(),
  );
  return matches;
}
```

## Testing the API

### Manual Testing in Dart:

```dart
void main() async {
  final apiService = FootballApiService();
  
  // Test live matches
  print('Fetching live matches...');
  final liveMatches = await apiService.getLiveMatches();
  print('Found ${liveMatches.length} live matches');
  
  // Test standings
  print('Fetching Premier League standings...');
  final standings = await apiService.getStandings('PL');
  print('Premier League table:');
  for (var standing in standings) {
    print('${standing.position}. ${standing.team.name}: ${standing.points}pts');
  }
}
```

## Advanced Usage

### Implement Auto-Refresh for Live Matches:

```dart
class LiveMatchService {
  late Timer _refreshTimer;
  final Duration _refreshInterval = Duration(minutes: 1);

  void startLiveMatching() {
    _refreshTimer = Timer.periodic(_refreshInterval, (_) async {
      final matches = await _apiService.getLiveMatches();
      // Update UI with new data
    });
  }

  void stop() {
    _refreshTimer.cancel();
  }
}
```

### Batch Request Multiple Competitions:

```dart
Future<Map<String, List<Match>>> getMultipleCompetitions(
  List<String> competitionCodes,
) async {
  final results = <String, List<Match>>{};
  
  for (final code in competitionCodes) {
    final matches = await _apiService.getCompetitionMatches(code);
    results[code] = matches;
  }
  
  return results;
}
```

## Troubleshooting

### "Unauthorized" Error (401):
- Check your API key is correct
- Verify API key hasn't expired
- Sign in on football-data.org to confirm account status

### "Not Found" Error (404):
- Verify competition code is correct
- Check match/team ID exists
- Ensure date format is correct (YYYY-MM-DD)

### "Too Many Requests" Error (429):
- Implement request queuing
- Reduce request frequency
- Cache responses longer

### "Bad Request" Error (400):
- Check date format
- Verify status values are valid
- Ensure required parameters are provided

## API Documentation

Full API documentation: https://www.football-data.org/documentation

Key endpoints:
- `/matches` - Get all matches
- `/matches/{id}` - Get specific match
- `/competitions/{code}/matches` - Competition matches
- `/competitions/{code}/standings` - League table
- `/teams/{id}` - Team details

## Best Practices

1. **Cache aggressively** - Store data locally
2. **Batch requests** - Fetch multiple resources together
3. **Handle errors gracefully** - Show user-friendly messages
4. **Rate limit** - Respect API limits
5. **Validate data** - Check responses before using
6. **Log requests** - Help with debugging
7. **Use compression** - Reduce data transfer
8. **Implement retry logic** - Handle transient failures
