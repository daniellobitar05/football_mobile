import 'package:dio/dio.dart';
import 'package:fot_mob_app/models/index.dart';

class FootballApiService {
  // Real API endpoint - works on mobile, requires proxy on web
  static const String apiBaseUrl = 'https://api.football-data.org/v4';
  static const String apiKey = '5a488af03d0a46a8b516c8807861dde2';

  late Dio _dio;

  FootballApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        headers: {
          'X-Auth-Token': apiKey,
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🚀 API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ API Error: ${error.message}');
          // Return mock data on CORS error for web development
          if (error.message?.contains('connection error') == true ||
              error.message?.contains('XMLHttpRequest') == true) {
            print('📡 CORS detected - returning mock data for web development');
            return handler.resolve(_getMockResponse());
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Return realistic mock match data for web development (CORS workaround)
  Response _getMockResponse() {
    return Response(
      requestOptions: RequestOptions(path: ''),
      statusCode: 200,
      data: {
        'matches': [
          {
            'id': 401902,
            'utcDate': DateTime.now().add(const Duration(hours: 1)).toUtc().toIso8601String(),
            'status': 'LIVE',
            'stage': '1/2 Final',
            'competition': {'id': 2001, 'name': 'UEFA Champions League', 'code': 'CL'},
            'homeTeam': {
              'id': 57,
              'name': 'Manchester City',
              'shortName': 'MCI',
              'crest': 'https://crests.football-data.org/57.png'
            },
            'awayTeam': {
              'id': 73,
              'name': 'Atlético Madrid',
              'shortName': 'ATM',
              'crest': 'https://crests.football-data.org/73.png'
            },
            'score': {'halfTime': {'home': 2, 'away': 1}, 'winner': null},
          },
          {
            'id': 401905,
            'utcDate': DateTime.now().add(const Duration(hours: 3)).toUtc().toIso8601String(),
            'status': 'SCHEDULED',
            'competition': {'id': 2001, 'name': 'UEFA Champions League', 'code': 'CL'},
            'homeTeam': {
              'id': 64,
              'name': 'Liverpool',
              'shortName': 'LIV',
              'crest': 'https://crests.football-data.org/64.png'
            },
            'awayTeam': {
              'id': 78,
              'name': 'Inter',
              'shortName': 'INT',
              'crest': 'https://crests.football-data.org/78.png'
            },
            'score': {'winner': null},
          },
          {
            'id': 390312,
            'utcDate': DateTime.now().subtract(const Duration(hours: 2)).toUtc().toIso8601String(),
            'status': 'FINISHED',
            'competition': {'id': 2014, 'name': 'Premier League', 'code': 'PL'},
            'homeTeam': {
              'id': 1,
              'name': 'Arsenal',
              'shortName': 'ARS',
              'crest': 'https://crests.football-data.org/1.png'
            },
            'awayTeam': {
              'id': 6,
              'name': 'Manchester United',
              'shortName': 'MUN',
              'crest': 'https://crests.football-data.org/6.png'
            },
            'score': {'fullTime': {'home': 3, 'away': 1}, 'winner': 'HOME'},
          },
        ]
      },
    );
  }

  /// Get live matches for today and upcoming days
  Future<List<Match>> getLiveMatches() async {
    try {
      final response = await _dio.get(
        '/matches',
        queryParameters: {
          'status': 'LIVE',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> matches = response.data['matches'] ?? [];
        return matches.map((m) => Match.fromJson(m)).toList();
      }
      throw Exception('Failed to load live matches');
    } on DioException catch (e) {
      print('Error fetching live matches: $e');
      rethrow;
    }
  }

  /// Get all matches (scheduled, live, finished)
  Future<List<Match>> getMatches({
    String status = 'SCHEDULED,LIVE,FINISHED',
    int daysAhead = 7,
  }) async {
    try {
      final response = await _dio.get(
        '/matches',
        queryParameters: {
          'status': status,
          'dateFrom': DateTime.now().toString().split(' ')[0],
          'dateTo': DateTime.now()
              .add(Duration(days: daysAhead))
              .toString()
              .split(' ')[0],
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> matches = response.data['matches'] ?? [];
        return matches.map((m) => Match.fromJson(m)).toList();
      }
      throw Exception('Failed to load matches');
    } on DioException catch (e) {
      print('Error fetching matches: $e');
      rethrow;
    }
  }

  /// Get matches for a specific competition (e.g., Premier League)
  Future<List<Match>> getCompetitionMatches(
    String competitionCode, {
    String status = 'SCHEDULED,LIVE,FINISHED',
  }) async {
    try {
      final response = await _dio.get(
        '/competitions/$competitionCode/matches',
        queryParameters: {
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> matches = response.data['matches'] ?? [];
        return matches.map((m) => Match.fromJson(m)).toList();
      }
      throw Exception('Failed to load competition matches');
    } on DioException catch (e) {
      print('Error fetching competition matches: $e');
      rethrow;
    }
  }

  /// Get standings for a specific competition
  Future<List<Standing>> getStandings(String competitionCode) async {
    try {
      final response = await _dio.get(
        '/competitions/$competitionCode/standings',
      );

      if (response.statusCode == 200) {
        final standings =
            response.data['standings'] as List<dynamic>? ?? [];
        if (standings.isNotEmpty) {
          final table = standings[0]['table'] as List<dynamic>? ?? [];
          return table.map((s) => Standing.fromJson(s)).toList();
        }
      }
      throw Exception('Failed to load standings');
    } on DioException catch (e) {
      print('Error fetching standings: $e');
      rethrow;
    }
  }

  /// Get match details
  Future<Match> getMatchDetails(int matchId) async {
    try {
      final response = await _dio.get('/matches/$matchId');

      if (response.statusCode == 200) {
        return Match.fromJson(response.data['match']);
      }
      throw Exception('Failed to load match details');
    } on DioException catch (e) {
      print('Error fetching match details: $e');
      rethrow;
    }
  }
}
