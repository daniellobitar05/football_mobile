import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
      rethrow;
    }
  }

  /// Save live match update to Firestore
  Future<void> saveLiveMatchUpdate(int matchId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('live_matches')
          .doc(matchId.toString())
          .set({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('✅ Match update saved to Firestore');
    } catch (e) {
      print('❌ Error saving match update: $e');
    }
  }

  /// Listen to live match updates in real-time
  Stream<DocumentSnapshot> listenToMatchUpdates(int matchId) {
    return _firestore
        .collection('live_matches')
        .doc(matchId.toString())
        .snapshots();
  }

  /// Get user's favorite matches
  Future<List<String>> getFavoriteMatches(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return List<String>.from(doc.data()?['favorites'] ?? []);
      }
      return [];
    } catch (e) {
      print('❌ Error fetching favorites: $e');
      return [];
    }
  }

  /// Add match to favorites
  Future<void> addFavoriteMatch(String userId, String matchId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([matchId]),
      });
    } catch (e) {
      print('❌ Error adding favorite: $e');
    }
  }

  /// Remove match from favorites
  Future<void> removeFavoriteMatch(String userId, String matchId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([matchId]),
      });
    } catch (e) {
      print('❌ Error removing favorite: $e');
    }
  }

  /// Cache matches locally in Firestore
  Future<void> cacheMatches(List<Map<String, dynamic>> matches) async {
    try {
      final batch = _firestore.batch();
      for (var match in matches) {
        final docRef = _firestore.collection('cached_matches').doc();
        batch.set(docRef, {
          ...match,
          'cachedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      print('✅ Matches cached successfully');
    } catch (e) {
      print('❌ Error caching matches: $e');
    }
  }
}
