import 'dart:developer' as dev;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/constants.dart';
import '../../../models/user_profile.dart';

/// AuthService implementation using google_sign_in.
/// Manages Google OAuth2 flow and local session persistence.
class AuthServiceImpl {
  AuthServiceImpl() : _googleSignIn = GoogleSignIn(scopes: kGoogleScopes);

  final GoogleSignIn _googleSignIn;

  /// Initiates the Google Sign-In flow.
  /// Returns a UserProfile on success, throws on failure.
  Future<UserProfile> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Sign-in was cancelled by the user.');
      }

      final now = DateTime.now();
      final profile = UserProfile(
        googleId: account.id,
        displayName: account.displayName ?? 'Student',
        email: account.email,
        photoUrl: account.photoUrl,
        createdAt: now,
        updatedAt: now,
      );

      // Persist to SharedPreferences
      await _saveToPrefs(profile);

      dev.log('Sign-in successful: ${profile.email}', name: 'AuthService');
      return profile;
    } catch (e) {
      dev.log('ERROR: Sign-in failed: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Signs out and clears the local session.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kPrefUserGoogleId);
    await prefs.remove(kPrefUserDisplayName);
    await prefs.remove(kPrefUserEmail);
    await prefs.remove(kPrefUserPhotoUrl);
    await prefs.remove(kPrefOnboardingComplete);
    dev.log('Signed out and cleared local session', name: 'AuthService');
  }

  /// Returns the current signed-in user from local storage.
  Future<UserProfile?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final googleId = prefs.getString(kPrefUserGoogleId);
    if (googleId == null) return null;

    return UserProfile(
      googleId: googleId,
      displayName: prefs.getString(kPrefUserDisplayName) ?? 'Student',
      email: prefs.getString(kPrefUserEmail) ?? '',
      photoUrl: prefs.getString(kPrefUserPhotoUrl),
      collegeName: prefs.getString(kPrefCollegeName),
      onboardingComplete: prefs.getBool(kPrefOnboardingComplete) ?? false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Returns a valid OAuth2 access token, refreshing if needed.
  Future<String> getAccessToken() async {
    final account =
        _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    if (account == null) {
      throw Exception('No signed-in user. Please sign in first.');
    }

    final auth = await account.authentication;
    final token = auth.accessToken;
    if (token == null) {
      throw Exception('Failed to obtain access token.');
    }

    return token;
  }

  /// Checks if a user is currently signed in.
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  /// Marks onboarding as complete.
  Future<void> completeOnboarding({String? collegeName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefOnboardingComplete, true);
    if (collegeName != null) {
      await prefs.setString(kPrefCollegeName, collegeName);
    }
    dev.log(
      'Onboarding completed (college: $collegeName)',
      name: 'AuthService',
    );
  }

  Future<void> _saveToPrefs(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefUserGoogleId, profile.googleId);
    await prefs.setString(kPrefUserDisplayName, profile.displayName);
    await prefs.setString(kPrefUserEmail, profile.email);
    if (profile.photoUrl != null) {
      await prefs.setString(kPrefUserPhotoUrl, profile.photoUrl!);
    }
  }
}
