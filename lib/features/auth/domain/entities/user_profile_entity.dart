import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String? email;
  final String fullName;
  final String? avatarUrl;
  final int totalReports;
  final bool isBanned;
  final DateTime? bannedUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String role;
  final String? fcmToken;
  final bool notifyOnOfficialRefill;
  final bool notifyOnCameraVerify;
  final DateTime lastNotificationsSeenAt;

  const UserProfileEntity({
    required this.id,
    this.email,
    required this.fullName,
    this.avatarUrl,
    this.totalReports = 0,
    this.isBanned = false,
    this.bannedUntil,
    required this.createdAt,
    required this.updatedAt,
    this.role = 'user',
    this.fcmToken,
    this.notifyOnOfficialRefill = true,
    this.notifyOnCameraVerify = true,
    required this.lastNotificationsSeenAt,
  });

  bool get isCurrentlyBanned {
    if (!isBanned) return false;
    if (bannedUntil == null) return true;
    return bannedUntil!.isAfter(DateTime.now());
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    avatarUrl,
    totalReports,
    isBanned,
    bannedUntil,
    createdAt,
    updatedAt,
    role,
    fcmToken,
    notifyOnOfficialRefill,
    notifyOnCameraVerify,
    lastNotificationsSeenAt,
  ];
}
