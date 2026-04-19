import 'package:flutter/material.dart';
import 'package:fot_mob_app/models/index.dart';
import 'package:fot_mob_app/services/index.dart';

class StandingsProvider extends ChangeNotifier {
  final FootballApiService _apiService = FootballApiService();

  Map<String, List<Standing>> _standings = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, List<Standing>> get standings => _standings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch standings for a specific competition
  Future<void> fetchStandings(String competitionCode) async {
    if (_standings.containsKey(competitionCode)) {
      return; // Already fetched
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getStandings(competitionCode);
      _standings[competitionCode] = data;
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch standings: $e';
      print('❌ Error in StandingsProvider.fetchStandings: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get standings for a specific competition
  List<Standing> getStandingsByCompetition(String competitionCode) {
    return _standings[competitionCode] ?? [];
  }

  /// Clear standings cache for a competition
  void clearStandings(String competitionCode) {
    _standings.remove(competitionCode);
    notifyListeners();
  }

  /// Clear all standings cache
  void clearAllStandings() {
    _standings.clear();
    notifyListeners();
  }
}
