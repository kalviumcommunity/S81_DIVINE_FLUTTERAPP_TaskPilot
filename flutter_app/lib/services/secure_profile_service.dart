import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Represents a user's profile in Firestore.
/// Each user can only access and modify their own profile document.
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String bio;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.bio,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create from Firestore document
  factory UserProfile.fromMap(Map<String, dynamic> map, String docId) {
    return UserProfile(
      uid: docId,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create a copy with modifications
  UserProfile copyWith({
    String? displayName,
    String? bio,
    String? phoneNumber,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// SecureProfileService manages user profile data with Firestore Security Rules.
/// 
/// This service demonstrates:
/// - Reading only authenticated user's own profile
/// - Writing only to authenticated user's own profile
/// - Security rules enforcing uid-based access control
/// - Proper error handling for unauthorized access
class SecureProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Constants for Firestore structure
  static const String profilesCollection = 'users';

  /// Get current authenticated user's UID
  String? get currentUserUid => _auth.currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get reference to current user's profile document (no fetch)
  DocumentReference<Map<String, dynamic>> getMyProfileRef() {
    final uid = currentUserUid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection(profilesCollection).doc(uid);
  }

  /// Get reference to any user's profile document
  DocumentReference<Map<String, dynamic>> getUserProfileRef(String uid) {
    return _firestore.collection(profilesCollection).doc(uid);
  }

  /// Read current user's profile
  /// 
  /// This operation will succeed because:
  /// 1. User is authenticated
  /// 2. Security rule: request.auth != null && request.auth.uid == uid
  /// 3. The requested document ID matches the user's UID
  Future<UserProfile?> getMyProfile() async {
    try {
      final uid = currentUserUid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Fetching profile for authenticated user: $uid');

      final docSnapshot = await getMyProfileRef().get();

      if (!docSnapshot.exists) {
        debugPrint('Profile does not exist for user: $uid');
        return null;
      }

      final profile = UserProfile.fromMap(docSnapshot.data() ?? {}, uid);
      debugPrint('Successfully retrieved profile for user: $uid');
      return profile;
    } on FirebaseException catch (e) {
      debugPrint('Firebase error reading profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error reading profile: $e');
      rethrow;
    }
  }

  /// Attempt to read another user's profile
  /// 
  /// This operation will FAIL because:
  /// 1. User is authenticated but with different UID
  /// 2. Security rule: request.auth != null && request.auth.uid == uid
  /// 3. The requested document ID does NOT match the user's UID
  /// 4. Firestore will deny the read with permission-denied error
  Future<UserProfile?> getOtherUserProfile(String targetUid) async {
    try {
      final currentUid = currentUserUid;
      if (currentUid == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Attempting to fetch profile for user: $targetUid');
      debugPrint('Current authenticated user: $currentUid');

      if (currentUid == targetUid) {
        debugPrint('Cannot use this method to access own profile. Use getMyProfile() instead.');
        throw Exception('Use getMyProfile() for your own profile');
      }

      debugPrint('Security Rule Check: Does $currentUid == $targetUid? NO - This should fail!');

      final docSnapshot = await getUserProfileRef(targetUid).get();

      // This line should not be reached if security rules are properly configured
      debugPrint('WARNING: Unauthorized read succeeded! Security rules may be misconfigured.');
      
      if (!docSnapshot.exists) {
        return null;
      }

      return UserProfile.fromMap(docSnapshot.data() ?? {}, targetUid);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('✓ Security rule correctly blocked unauthorized read: ${e.message}');
      } else {
        debugPrint('Firebase error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  /// Create or update current user's profile
  /// 
  /// This operation will succeed because:
  /// 1. User is authenticated
  /// 2. Security rule allows write to own document
  Future<void> updateMyProfile({
    required String displayName,
    required String bio,
    required String phoneNumber,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Updating profile for user: $uid');

      final profile = UserProfile(
        uid: uid,
        email: _auth.currentUser?.email ?? '',
        displayName: displayName,
        bio: bio,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await getMyProfileRef().set(profile.toMap(), SetOptions(merge: true));
      debugPrint('Successfully updated profile for user: $uid');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error updating profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  /// Attempt to update another user's profile
  /// 
  /// This operation will FAIL because:
  /// 1. Security rule: allow write: if request.auth != null && request.auth.uid == uid
  /// 2. The document ID does NOT match the authenticated user's UID
  /// 3. Firestore will deny the write with permission-denied error
  Future<void> updateOtherUserProfile({
    required String targetUid,
    required String displayName,
    required String bio,
    required String phoneNumber,
  }) async {
    try {
      final currentUid = currentUserUid;
      if (currentUid == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Attempting to update profile for user: $targetUid');
      debugPrint('Current authenticated user: $currentUid');

      if (currentUid == targetUid) {
        throw Exception('Use updateMyProfile() for your own profile');
      }

      debugPrint('Security Rule Check: Does $currentUid == $targetUid? NO - This should fail!');

      final profile = UserProfile(
        uid: targetUid,
        email: '', // We don't know the target user's email
        displayName: displayName,
        bio: bio,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await getUserProfileRef(targetUid).set(profile.toMap());

      // This line should not be reached if security rules are properly configured
      debugPrint('WARNING: Unauthorized write succeeded! Security rules may be misconfigured.');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('✓ Security rule correctly blocked unauthorized write: ${e.message}');
      } else {
        debugPrint('Firebase error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  /// Delete current user's profile
  Future<void> deleteMyProfile() async {
    try {
      final uid = currentUserUid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Deleting profile for user: $uid');
      await getMyProfileRef().delete();
      debugPrint('Successfully deleted profile for user: $uid');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error deleting profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error deleting profile: $e');
      rethrow;
    }
  }

  /// Stream of current user's profile updates
  Stream<UserProfile?> getMyProfileStream() {
    final uid = currentUserUid;
    if (uid == null) {
      return Stream.error('User not authenticated');
    }

    return getMyProfileRef().snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return UserProfile.fromMap(snapshot.data() ?? {}, uid);
    }).handleError((e) {
      debugPrint('Stream error: $e');
    });
  }

  /// Initialize profile for new user
  /// Called automatically after signup
  Future<void> initializeProfileForNewUser({
    required String email,
  }) async {
    try {
      final uid = currentUserUid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Initializing profile for new user: $uid with email: $email');

      final profile = UserProfile(
        uid: uid,
        email: email,
        displayName: '',
        bio: '',
        phoneNumber: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await getMyProfileRef().set(profile.toMap(), SetOptions(merge: true));
      debugPrint('Profile initialized successfully for user: $uid');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error initializing profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error initializing profile: $e');
      rethrow;
    }
  }
}
