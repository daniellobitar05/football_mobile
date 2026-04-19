/// App constants and configuration
class AppConstants {
  // API Configuration
  static const String footballDataApiKey = 'YOUR_API_KEY_HERE';
  static const String footballDataBaseUrl = 'https://api.football-data.org/v4';

  // Firebase Configuration
  static const String firebaseProjectId = 'your-project-id';
  static const String firebaseAppId = 'your-app-id';

  // Competitions
  static const Map<String, String> competitions = {
    'PL': 'Premier League',
    'LA': 'La Liga',
    'SA': 'Serie A',
    'BL1': 'Bundesliga',
    'FR1': 'Ligue 1',
    'PPL': 'Primeira Liga',
    'DED': 'Eredivisie',
    'CL': 'UEFA Champions League',
  };

  // Refresh intervals
  static const Duration liveMatchRefreshInterval = Duration(minutes: 1);
  static const Duration matchesRefreshInterval = Duration(minutes: 5);
  static const Duration standingsRefreshInterval = Duration(minutes: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 1);

  // API Timeout
  static const Duration apiTimeout = Duration(seconds: 10);

  // Days ahead to fetch matches
  static const int daysAheadToFetch = 7;
}
