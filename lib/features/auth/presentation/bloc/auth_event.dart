import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class CheckAuthSessionEvent extends AuthEvent {}

final class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

final class SignUpWithEmailEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  const SignUpWithEmailEvent({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

final class SignInWithGoogleEvent extends AuthEvent {}

final class ResetPasswordEvent extends AuthEvent {
  final String email;
  const ResetPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}

final class PasswordRecoveryLinkDetectedEvent extends AuthEvent {}

final class UpdatePasswordEvent extends AuthEvent {
  final String newPassword;
  const UpdatePasswordEvent(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

final class SignOutEvent extends AuthEvent {}
