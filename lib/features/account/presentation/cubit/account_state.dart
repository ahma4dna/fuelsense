import 'package:equatable/equatable.dart';

import '../../domain/entities/account_profile_entity.dart';

enum AccountActionStatus {
  idle,
  updatingProfile,
  profileUpdated,
  loggingOut,
  loggedOut,
  error,
}

class AccountState extends Equatable {
  final bool isLoading;
  final AccountProfileEntity? profile;
  final AccountActionStatus actionStatus;
  final String? message;

  const AccountState({
    this.isLoading = true,
    this.profile,
    this.actionStatus = AccountActionStatus.idle,
    this.message,
  });

  AccountState copyWith({
    bool? isLoading,
    AccountProfileEntity? profile,
    AccountActionStatus? actionStatus,
    String? message,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      actionStatus: actionStatus ?? this.actionStatus,
      message: message,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, actionStatus, message];
}
