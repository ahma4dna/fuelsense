import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/account_profile_model.dart';

abstract class AccountRemoteDataSource {
  Future<AccountProfileModel> getAccountProfile();
  Future<AccountProfileModel> updateAccountProfile({
    required String fullName,
  });
  Future<void> signOut();
}

@LazySingleton(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final SupabaseClient _supabase;

  AccountRemoteDataSourceImpl(this._supabase);

  @override
  Future<AccountProfileModel> getAccountProfile() async {
    final user = _supabase.auth.currentUser;
    Map<String, dynamic>? profileRow;

    if (user != null) {
      try {
        profileRow = await _supabase.from('profiles').select().eq('id', user.id).maybeSingle();
      } catch (_) {}
    }

    return AccountProfileModel.fromSupabase(
      authUser: user,
      profileRow: profileRow,
    );
  }

  @override
  Future<AccountProfileModel> updateAccountProfile({
    required String fullName,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('يرجى تسجيل الدخول أولاً لتحديث بياناتك.');
    }

    // 1. تحديث user_metadata في Supabase Auth
    final updatedAuth = await _supabase.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': fullName.trim(),
        },
      ),
    );

    Map<String, dynamic>? updatedProfileRow;
    try {
      updatedProfileRow = await _supabase
          .from('profiles')
          .update({
            'full_name': fullName.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq("id", user.id)
          .select()
          .maybeSingle();
    } catch (_) {}

    return AccountProfileModel.fromSupabase(
      authUser: updatedAuth.user ?? _supabase.auth.currentUser,
      profileRow:
          updatedProfileRow ??
          {
            'id': user.id,
            'full_name': fullName.trim(),
          },
    );
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
