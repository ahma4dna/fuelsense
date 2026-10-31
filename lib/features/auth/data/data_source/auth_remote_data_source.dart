import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserProfileModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserProfileModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  });

  Future<UserProfileModel> signInWithGoogle();

  Future<void> resetPassword({required String email});

  Future<UserProfileModel?> getCurrentUserProfile();

  Future<void> signOut();
  Future<void> updatePassword({required String newPassword});
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSourceImpl(this._supabase);

  @override
  Future<UserProfileModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException("");
    }

    final fallbackName = (user.userMetadata?['full_name'] as String?) ?? email.split('@').first;

    return _ensureAndGetProfile(
      userId: user.id,
      email: user.email,
      fallbackFullName: fallbackName,
    );
  }

  @override
  Future<UserProfileModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'full_name': fullName.trim()},
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('');
    }

    return _ensureAndGetProfile(
      userId: user.id,
      email: user.email,
      fallbackFullName: fullName.trim(),
    );
  }

  @override
  Future<UserProfileModel> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId: '25282113440-lu885smuetbran83gb5po1ta5v33gmoj.apps.googleusercontent.com',
    );
    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw const AuthException('');
    }

    final authz = await googleUser.authorizationClient.authorizationForScopes(['email', 'profile']);
    final accessToken = authz?.accessToken;

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('');
    }

    final meta = user.userMetadata;
    final fullName = (meta?['full_name'] as String?) ?? (meta?['name'] as String?) ?? 'مستخدم FuelSense';
    final avatarUrl = (meta?['avatar_url'] as String?) ?? (meta?['picture'] as String?);

    return _ensureAndGetProfile(
      userId: user.id,
      email: user.email,
      fallbackFullName: fullName,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: 'fuelsense://reset-password',
    );
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    await _supabase.auth.signOut();
  }

  @override
  Future<UserProfileModel?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final fallbackName = (user.userMetadata?['full_name'] as String?) ?? '';
    return _ensureAndGetProfile(
      userId: user.id,
      email: user.email,
      fallbackFullName: fallbackName,
    );
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<UserProfileModel> _ensureAndGetProfile({
    required String userId,
    String? email,
    required String fallbackFullName,
    String? avatarUrl,
  }) async {
    final existing = await _supabase.from('profiles').select().eq('id', userId).maybeSingle();

    if (existing != null) {
      return UserProfileModel.fromJson(existing, email: email);
    }

    final inserted = await _supabase
        .from('profiles')
        .upsert({
          'id': userId,
          'full_name': fallbackFullName,
          'avatar_url': ?avatarUrl,
          'role': 'user',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return UserProfileModel.fromJson(inserted, email: email);
  }
}
