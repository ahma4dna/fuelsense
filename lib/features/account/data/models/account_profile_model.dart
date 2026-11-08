import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/account_profile_entity.dart';

class AccountProfileModel extends AccountProfileEntity {
  const AccountProfileModel({
    required super.id,
    required super.fullName,
    super.createdAt,
  });

  factory AccountProfileModel.fromSupabase({
    required User? authUser,
    Map<String, dynamic>? profileRow,
  }) {
    final meta = authUser?.userMetadata ?? {};

    final resolvedName = (profileRow?['full_name'] as String?)?.trim().isNotEmpty == true
        ? (profileRow!['full_name'] as String).trim()
        : (profileRow?['name'] as String?)?.trim().isNotEmpty == true
        ? (profileRow!['name'] as String).trim()
        : (meta['full_name'] as String?)?.trim().isNotEmpty == true
        ? (meta['full_name'] as String).trim()
        : (meta['name'] as String?)?.trim() ?? 'مستخدم FuelSense';

    return AccountProfileModel(
      id: authUser?.id ?? (profileRow?['id']?.toString() ?? ''),
      fullName: resolvedName,

      createdAt: authUser?.createdAt != null ? DateTime.tryParse(authUser!.createdAt) : null,
    );
  }
}
