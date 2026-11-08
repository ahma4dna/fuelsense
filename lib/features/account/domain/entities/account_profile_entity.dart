import 'package:equatable/equatable.dart';

class AccountProfileEntity extends Equatable {
  final String id;
  final String fullName;

  final DateTime? createdAt;

  const AccountProfileEntity({
    required this.id,
    required this.fullName,

    this.createdAt,
  });

  String get initials {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'م';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return trimmed[0];
  }

  AccountProfileEntity copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? city,
  }) {
    return AccountProfileEntity(
      id: id,
      fullName: fullName ?? this.fullName,

      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, fullName, createdAt];
}
