import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/account/presentation/widgets/about/about_app_bottom_sheet.dart';
import 'package:fuelsense/features/account/presentation/widgets/account_skeleton.dart';
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

  static final AnimationStyle _sheetAnimation = AnimationStyle(
    duration: const Duration(milliseconds: 420),
    curve: Curves.easeOutCubic,
    reverseDuration: const Duration(milliseconds: 260),
    reverseCurve: Curves.easeInCubic,
  );

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
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: _sheetAnimation,
      builder: (_) => EditProfileBottomSheet(
        profile: profile,
        onSave: (fullName) async => await _cubit.updateProfile(fullName: fullName),
      ),
    );
  }

  void _openAboutAppSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: _sheetAnimation,
      builder: (_) => const AboutAppBottomSheet(),
    );
  }

  void _confirmSignOut() {
    HapticFeedback.mediumImpact();
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

  Widget _stagger(int index, Widget child) {
    return FadeSlide(
      delay: Duration(milliseconds: 100 + index * 80),
      dy: 28,
      scaleFrom: 0.98,
      duration: const Duration(milliseconds: 600),
      child: child,
    );
  }

  Flushbar<void> _buildFlushbar(String message, Color color) {
    return Flushbar<void>(
      message: message,
      backgroundColor: color,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(AppPadding.p16),
      borderRadius: BorderRadius.circular(AppSize.s14),
      animationDuration: const Duration(milliseconds: 450),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
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
            HapticFeedback.lightImpact();
            _buildFlushbar(state.message!, const Color(0xFF0F6E67)).show(context);
          } else if (state.actionStatus == AccountActionStatus.error && state.message != null) {
            HapticFeedback.heavyImpact();
            _buildFlushbar(state.message!, const Color(0xFFD92D20)).show(context);
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

          final showSkeleton = state.isLoading && state.profile == null;

          return Directionality(
            textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              body: Column(
                children: [
                  FadeSlide(
                    dy: -24,
                    duration: const Duration(milliseconds: 650),
                    child: AccountHeaderSection(
                      profile: profile,
                      onEditTap: () => _openEditProfileSheet(profile),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: showSkeleton
                          ? const AccountSkeleton(key: ValueKey('skeleton'))
                          : KeyedSubtree(
                              key: const ValueKey('content'),
                              child: _buildContent(context, state, appContext),
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

  Widget _buildContent(
    BuildContext context,
    AccountState state,
    AppContext appContext,
  ) {
    return RefreshIndicator(
      color: const Color(0xFF0F6E67),
      backgroundColor: AppColors.white,

      onRefresh: () async {
        HapticFeedback.lightImpact();
        await _cubit.loadProfile();
      },
      child: ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p16,
          AppPadding.p16,
          AppPadding.p16,
          AppPadding.p32,
        ),
        children: [
          _stagger(
            0,
            SectionHeaderTitle(
              title: appContext.localText.privacy_and_rules,
            ),
          ),
          const Gap(AppSize.s10),
          _stagger(
            1,
            PressScale(
              scale: 0.985,
              child: Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.description_outlined,
                      title: appContext.localText.terms_of_use,
                      subtitle: appContext.localText.terms_subtitle,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        context.pushNamed(termsOfUseName);
                      },
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
                      onTap: () {
                        HapticFeedback.selectionClick();
                        context.pushNamed(privacyPolicyName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(AppSize.s22),
          _stagger(
            2,
            SectionHeaderTitle(
              title: appContext.localText.about_system,
            ),
          ),
          const Gap(AppSize.s10),
          _stagger(
            3,
            PressScale(
              scale: 0.985,
              child: Container(
                decoration: _cardDecoration(),
                child: SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: appContext.localText.about_app_title,
                  subtitle: appContext.localText.about_app_subtitle,
                  trailingBadge: appContext.localText.app_version_badge,
                  onTap: _openAboutAppSheet,
                ),
              ),
            ),
          ),
          const Gap(AppSize.s26),
          _stagger(
            4,
            PressScale(
              scale: 0.97,
              child: LogoutCardButton(
                isLoggingOut: state.actionStatus == AccountActionStatus.loggingOut,
                onTap: _confirmSignOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
