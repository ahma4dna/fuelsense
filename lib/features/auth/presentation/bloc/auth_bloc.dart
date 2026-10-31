import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/preferences/preferences_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../domain/enums/auth_enums.dart';
import '../../domain/use_case/auth_use_cases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<dynamic>? _supabaseAuthSub;

  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final GetCurrentUserProfileUseCase _getCurrentUserProfileUseCase;
  final SignOutUseCase _signOutUseCase;
  final PreferencesProvider _preferencesProvider;

  AuthBloc({
    required this._signInWithEmailUseCase,
    required this._signUpWithEmailUseCase,
    required this._signInWithGoogleUseCase,
    required this._resetPasswordUseCase,
    required this._updatePasswordUseCase,
    required this._getCurrentUserProfileUseCase,
    required this._signOutUseCase,
    required this._preferencesProvider,
  }) : super(const AuthState()) {
    on<CheckAuthSessionEvent>(_onCheckAuthSession);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<ResetPasswordEvent>(_onResetPassword);
    on<PasswordRecoveryLinkDetectedEvent>(_onPasswordRecoveryDetected);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<SignOutEvent>(_onSignOut);

    _supabaseAuthSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        add(PasswordRecoveryLinkDetectedEvent());
      }
    });
  }

  Future<void> _onCheckAuthSession(
    CheckAuthSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.passwordRecoveryMode) return;

    final result = await _getCurrentUserProfileUseCase();
    result.fold(
      (_) => emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true)),
      (profile) {
        if (profile != null) {
          emit(state.copyWith(status: AuthStatus.authenticated, userProfile: profile));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
        }
      },
    );
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signInWithEmailUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold((failure) => emit(state.copyWith(status: AuthStatus.error, failure: failure)), (profile) {
      emit(
        state.copyWith(status: AuthStatus.authenticated, userProfile: profile),
      );
      _preferencesProvider.setAuthMethode("email");
    });
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signUpWithEmailUseCase(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
    );
    result.fold((failure) => emit(state.copyWith(status: AuthStatus.error, failure: failure)), (profile) {
      emit(
        state.copyWith(status: AuthStatus.authenticated, userProfile: profile),
      );
      _preferencesProvider.setAuthMethode("email");
    });
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _signInWithGoogleUseCase();
    result.fold((failure) => emit(state.copyWith(status: AuthStatus.error, failure: failure)), (profile) {
      emit(
        state.copyWith(status: AuthStatus.authenticated, userProfile: profile),
      );
      _preferencesProvider.setAuthMethode("google");
    });
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _resetPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.error, failure: failure)),
      (_) => emit(state.copyWith(status: AuthStatus.passwordResetSent)),
    );
  }

  void _onPasswordRecoveryDetected(
    PasswordRecoveryLinkDetectedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(status: AuthStatus.passwordRecoveryMode));
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _updatePasswordUseCase(event.newPassword);
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.error, failure: failure)),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.passwordUpdated,
          clearUser: true,
        ),
      ),
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _signOutUseCase();
    emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _supabaseAuthSub?.cancel();
    return super.close();
  }
}
