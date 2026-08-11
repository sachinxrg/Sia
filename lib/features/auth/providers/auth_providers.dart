import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../data/auth_service_impl.dart';
import '../../../models/user_profile.dart';

/// Provider for the AuthService.
final authServiceProvider = Provider<AuthServiceImpl>((ref) {
  return AuthServiceImpl();
});

/// Async provider for the current user.
final currentUserProvider = FutureProvider<UserProfile?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});

/// Provider tracking whether the user is authenticated.
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user != null;
});

/// Provider tracking whether onboarding is complete.
final isOnboardedProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.onboardingComplete ?? false;
});
