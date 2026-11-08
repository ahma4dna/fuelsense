import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/preferences/preferences_provider.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/usecases.dart';
import 'account_state.dart';

@injectable
class AccountCubit extends Cubit<AccountState> {
  final GetAccountProfileUseCase _getAccountProfileUseCase;
  final UpdateAccountProfileUseCase _updateAccountProfileUseCase;
  final SignOutAccountUseCase _signOutAccountUseCase;
  final PreferencesProvider _preferencesProvider;

  AccountCubit(
    this._getAccountProfileUseCase,
    this._updateAccountProfileUseCase,
    this._signOutAccountUseCase,
    this._preferencesProvider,
  ) : super(const AccountState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, actionStatus: AccountActionStatus.idle));

    final result = await _getAccountProfileUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          actionStatus: AccountActionStatus.error,
          message: "",
        ),
      ),
      (profile) => emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
          actionStatus: AccountActionStatus.idle,
        ),
      ),
    );
  }

  Future<void> updateProfile({
    required String fullName,
  }) async {
    emit(
      state.copyWith(
        actionStatus: AccountActionStatus.updatingProfile,
        message: null,
      ),
    );

    final result = await _updateAccountProfileUseCase(
      fullName: fullName,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: AccountActionStatus.error,
          message: "",
        ),
      ),
      (updatedProfile) => emit(
        state.copyWith(
          profile: updatedProfile,
          actionStatus: AccountActionStatus.profileUpdated,
          message: 'تم تحديث معلوماتك الشخصية بنجاح',
        ),
      ),
    );
  }

  Future<void> signOut() async {
    emit(state.copyWith(actionStatus: AccountActionStatus.loggingOut));

    final result = await _signOutAccountUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: AccountActionStatus.error,
          message: "",
        ),
      ),
      (_) {
        _preferencesProvider.sinOutAuthMethode();
        emit(
          state.copyWith(
            actionStatus: AccountActionStatus.loggedOut,
          ),
        );
      },
    );
  }
}
