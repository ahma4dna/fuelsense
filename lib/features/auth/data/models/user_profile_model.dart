import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    super.email,
    required super.fullName,
    super.avatarUrl,
    super.totalReports,
    super.isBanned,
    super.bannedUntil,
    required super.createdAt,
    required super.updatedAt,
    super.role,
    super.fcmToken,
    super.notifyOnOfficialRefill,
    super.notifyOnCameraVerify,
    required super.lastNotificationsSeenAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json, {String? email}) {
    return UserProfileModel(
      id: json['id'] as String,
      email: email,
      fullName: (json['full_name'] as String?) ?? '',
      avatarUrl: json['avatar_url'] as String?,
      totalReports: (json['total_reports'] as num?)?.toInt() ?? 0,
      isBanned: (json['is_banned'] as bool?) ?? false,
      bannedUntil: json['banned_until'] != null ? DateTime.tryParse(json['banned_until'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : DateTime.now(),
      role: (json['role'] as String?) ?? 'user',
      fcmToken: json['fcm_token'] as String?,
      notifyOnOfficialRefill: (json['notify_on_official_refill'] as bool?) ?? true,
      notifyOnCameraVerify: (json['notify_on_camera_verify'] as bool?) ?? true,
      lastNotificationsSeenAt: json['last_notifications_seen_at'] != null
          ? DateTime.parse(json['last_notifications_seen_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toUpsertJson() {
    return {
      'id': id,
      'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'role': role,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
