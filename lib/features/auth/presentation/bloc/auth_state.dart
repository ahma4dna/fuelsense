import 'package:equatable/equatable.dart';

import '../../../../core/domain/models/failure.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/enums/auth_enums.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfileEntity? userProfile;
  final Failure? failure;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userProfile,
    this.failure,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated && userProfile != null;

  AuthState copyWith({
    AuthStatus? status,
    UserProfileEntity? userProfile,
    bool clearUser = false,
    Failure? failure,
  }) {
    return AuthState(
      status: status ?? this.status,
      userProfile: clearUser ? null : (userProfile ?? this.userProfile),
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, userProfile, failure];
}
