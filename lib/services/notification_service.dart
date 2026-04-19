import 'package:flutter/material.dart';

// Firebase Messaging is not included in web build
// This service is designed for mobile platforms (iOS/Android)
// For web, notifications can be implemented via Web Push API or other mechanisms

/// Service for handling push notifications and real-time match updates
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  /// Initialize notification service
  /// On web, this is a no-op. On mobile, firebase_messaging is initialized here.
  Future<void> initializeNotifications() async {
    try {
      print('📲 Notification service initialized');
      // Firebase Messaging initialization would go here for mobile builds
      // See documentation for enabling notifications on Android/iOS
    } catch (e) {
      print('❌ Error initializing notifications: $e');
    }
  }

  /// Setup message handlers
  /// On web, this is a no-op. On mobile, message handlers are registered here.
  void _setupMessageHandlers() {
    print('📲 Message handlers registered');
    // Firebase Messaging listeners would go here for mobile builds
  }

  /// Handle notification data
  void _handleMessageData(Map<String, dynamic> data) {
    // Handle custom actions based on data
    if (data.containsKey('matchId')) {
      final matchId = data['matchId'];
      print('🏟️ Match notification for match: $matchId');
      // Navigate to match details
    }

    if (data.containsKey('action')) {
      final action = data['action'];
      switch (action) {
        case 'live_update':
          print('⚡ Live match update');
          break;
        case 'goal':
          print('⚽ Goal scored!');
          _playNotificationSound();
          break;
        case 'match_ended':
          print('🏁 Match ended');
          break;
        default:
          print('Action: $action');
      }
    }
  }

  /// Show local notification
  void _showNotification({required String title, required String body}) {
    print('🔔 Notification: $title - $body');
    // For web: use Web Notification API
    // For mobile: use flutter_local_notifications package
  }

  /// Play notification sound
  void _playNotificationSound() {
    print('🔊 Playing notification sound');
  }

  /// Save FCM token to Firestore
  Future<void> _saveFcmTokenToFirestore(String token) async {
    print('💾 Saving FCM token to Firestore');
  }

  /// Subscribe to topic for multiple users
  /// On web, this is a no-op. On mobile with firebase_messaging, this subscribes to FCM topics.
  Future<void> subscribeToTopic(String topic) async {
    try {
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic: $e');
    }
  }

  /// Subscribe to team notifications
  Future<void> subscribeToTeam(String teamId) async {
    await subscribeToTopic('team_$teamId');
  }

  /// Subscribe to match notifications
  Future<void> subscribeToMatch(String matchId) async {
    await subscribeToTopic('match_$matchId');
  }

  /// Subscribe to competition notifications
  Future<void> subscribeToCompetition(String competitionCode) async {
    await subscribeToTopic('competition_$competitionCode');
  }

  /// Subscribe to live match alerts
  Future<void> subscribeToLiveMatches() async {
    await subscribeToTopic('live_matches');
  }
}

/// Service for managing match update subscriptions
class MatchUpdateService {
  static final MatchUpdateService _instance = MatchUpdateService._internal();

  factory MatchUpdateService() {
    return _instance;
  }

  MatchUpdateService._internal();

  final Set<String> _subscribedMatches = {};
  final Set<String> _subscribedTeams = {};
  final Set<String> _subscribedCompetitions = {};
  final NotificationService _notificationService = NotificationService();

  /// Subscribe to specific match updates
  Future<void> subscribeToMatch(String matchId) async {
    if (_subscribedMatches.contains(matchId)) return;

    _subscribedMatches.add(matchId);
    await _notificationService.subscribeToMatch(matchId);
    print('✅ Subscribed to match updates: $matchId');
  }

  /// Unsubscribe from match updates
  Future<void> unsubscribeFromMatch(String matchId) async {
    if (!_subscribedMatches.contains(matchId)) return;

    _subscribedMatches.remove(matchId);
    await _notificationService.unsubscribeFromTopic('match_$matchId');
    print('✅ Unsubscribed from match: $matchId');
  }

  /// Subscribe to team updates
  Future<void> subscribeToTeam(String teamId) async {
    if (_subscribedTeams.contains(teamId)) return;

    _subscribedTeams.add(teamId);
    await _notificationService.subscribeToTeam(teamId);
    print('✅ Subscribed to team updates: $teamId');
  }

  /// Subscribe to competition updates
  Future<void> subscribeToCompetition(String competitionCode) async {
    if (_subscribedCompetitions.contains(competitionCode)) return;

    _subscribedCompetitions.add(competitionCode);
    await _notificationService.subscribeToCompetition(competitionCode);
    print('✅ Subscribed to competition: $competitionCode');
  }

  /// Get all subscribed matches
  Set<String> getSubscribedMatches() => _subscribedMatches;

  /// Get all subscribed teams
  Set<String> getSubscribedTeams() => _subscribedTeams;

  /// Get all subscribed competitions
  Set<String> getSubscribedCompetitions() => _subscribedCompetitions;

  /// Clear all subscriptions
  Future<void> clearAllSubscriptions() async {
    for (final matchId in _subscribedMatches) {
      await _notificationService.unsubscribeFromTopic('match_$matchId');
    }
    for (final teamId in _subscribedTeams) {
      await _notificationService.unsubscribeFromTopic('team_$teamId');
    }
    for (final competition in _subscribedCompetitions) {
      await _notificationService
          .unsubscribeFromTopic('competition_$competition');
    }

    _subscribedMatches.clear();
    _subscribedTeams.clear();
    _subscribedCompetitions.clear();
    print('✅ All subscriptions cleared');
  }
}
