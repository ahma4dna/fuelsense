import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/account/presentation/widgets/about/about_app_bottom_sheet.dart';
import 'package:fuelsense/features/account/presentation/widgets/buttons/logout_card_button.dart';
import 'package:fuelsense/features/account/presentation/widgets/cards/settings_tile.dart';
import 'package:fuelsense/features/account/presentation/widgets/common/section_header_title.dart';
import 'package:fuelsense/features/account/presentation/widgets/dialogs/sign_out_dialog.dart';
import 'package:fuelsense/features/account/presentation/widgets/edit_profile/edit_profile_bottom_sheet.dart';
import 'package:fuelsense/features/account/presentation/widgets/header/account_header_section.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/account_profile_entity.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final AccountCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AccountCubit>()..loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openEditProfileSheet(AccountProfileEntity profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileBottomSheet(
        profile: profile,
        onSave: (fullName) => _cubit.updateProfile(fullName: fullName),
      ),
    );
  }

  void _openAboutAppSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AboutAppBottomSheet(),
    );
  }

  void _confirmSignOut() {
    SignOutDialog.show(
      context: context,
      onConfirm: _cubit.signOut,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSize.s20),
      border: Border.all(color: const Color(0xFFE6E2D9), width: AppSize.s1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: AppSize.s0_02),
          blurRadius: AppSize.s10,
          offset: const Offset(AppSize.s0, AppSize.s4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state.actionStatus == AccountActionStatus.profileUpdated && state.message != null) {
            Flushbar(
              message: state.message!,
              backgroundColor: const Color(0xFF0F6E67),
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(AppPadding.p16),
              borderRadius: BorderRadius.circular(AppSize.s14),
            ).show(context);
          } else if (state.actionStatus == AccountActionStatus.error && state.message != null) {
            Flushbar(
              message: state.message!,
              backgroundColor: const Color(0xFFD92D20),
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(AppPadding.p16),
              borderRadius: BorderRadius.circular(AppSize.s14),
            ).show(context);
          } else if (state.actionStatus == AccountActionStatus.loggedOut) {
            context.go(authLogin);
          }
        },
        builder: (context, state) {
          final profile =
              state.profile ??
              AccountProfileEntity(
                id: '',
                fullName: appContext.localText.default_user_name,
              );

          return Directionality(
            textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              body: Column(
                children: [
                  AccountHeaderSection(
                    profile: profile,
                    onEditTap: () => _openEditProfileSheet(profile),
                  ),
                  Expanded(
                    child: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0F6E67),
                            ),
                          )
                        : RefreshIndicator(
                            color: const Color(0xFF0F6E67),
                            onRefresh: _cubit.loadProfile,
                            child: ListView(
                              padding: const EdgeInsets.fromLTRB(
                                AppPadding.p16,
                                AppPadding.p16,
                                AppPadding.p16,
                                AppPadding.p32,
                              ),
                              children: [
                                SectionHeaderTitle(
                                  title: appContext.localText.privacy_and_rules,
                                ),
                                const Gap(AppSize.s10),
                                Container(
                                  decoration: _cardDecoration(),
                                  child: Column(
                                    children: [
                                      SettingsTile(
                                        icon: Icons.description_outlined,
                                        title: appContext.localText.terms_of_use,
                                        subtitle: appContext.localText.terms_subtitle,
                                        onTap: () => context.pushNamed(termsOfUseName),
                                      ),
                                      const Divider(
                                        height: AppSize.s1,
                                        indent: AppSize.s56,
                                        endIndent: AppPadding.p16,
                                        color: Color(0xFFECE9E0),
                                      ),
                                      SettingsTile(
                                        icon: Icons.shield_outlined,
                                        title: appContext.localText.privacy_policy,
                                        subtitle: appContext.localText.privacy_subtitle,
                                        onTap: () => context.pushNamed(privacyPolicyName),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(AppSize.s22),
                                SectionHeaderTitle(
                                  title: appContext.localText.about_system,
                                ),
                                const Gap(AppSize.s10),
                                Container(
                                  decoration: _cardDecoration(),
                                  child: SettingsTile(
                                    icon: Icons.info_outline_rounded,
                                    title: appContext.localText.about_app_title,
                                    subtitle: appContext.localText.about_app_subtitle,
                                    trailingBadge: appContext.localText.app_version_badge,
                                    onTap: _openAboutAppSheet,
                                  ),
                                ),
                                const Gap(AppSize.s26),
                                LogoutCardButton(
                                  isLoggingOut: state.actionStatus == AccountActionStatus.loggingOut,
                                  onTap: _confirmSignOut,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
