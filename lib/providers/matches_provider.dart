import 'package:flutter/material.dart';
import 'package:fot_mob_app/models/index.dart';
import 'package:fot_mob_app/services/index.dart';

class MatchesProvider extends ChangeNotifier {
  final FootballApiService _apiService = FootballApiService();

  List<Match> _matches = [];
  List<Match> _liveMatches = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Match> get matches => _matches;
  List<Match> get liveMatches => _liveMatches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch all matches (scheduled, live, finished)
  Future<void> fetchMatches({int daysAhead = 7}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _matches = await _apiService.getMatches(daysAhead: daysAhead);
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch matches: $e';
      print('❌ Error in MatchesProvider.fetchMatches: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch only live matches
  Future<void> fetchLiveMatches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _liveMatches = await _apiService.getLiveMatches();
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch live matches: $e';
      print('❌ Error in MatchesProvider.fetchLiveMatches: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh matches periodically (useful for live updates)
  Future<void> refreshMatches() async {
    await fetchLiveMatches();
    await fetchMatches();
  }

  /// Filter matches by status
  List<Match> getMatchesByStatus(String status) {
    return _matches.where((match) {
      if (status == 'LIVE') return match.isLive;
      if (status == 'FINISHED') return match.isFinished;
      if (status == 'SCHEDULED') return match.isScheduled;
      return false;
    }).toList();
  }

  /// Get matches for today
  List<Match> getTodayMatches() {
    final today = DateTime.now();
    return _matches.where((match) {
      final matchDate = DateTime.parse(match.utcDate);
      return matchDate.year == today.year &&
          matchDate.month == today.month &&
          matchDate.day == today.day;
    }).toList();
  }

  /// Get upcoming matches
  List<Match> getUpcomingMatches() {
    return _matches.where((match) => match.isScheduled).toList();
  }
}
