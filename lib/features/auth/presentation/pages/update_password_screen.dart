import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:fuelsense/features/auth/presentation/widgets/rigester/password_strength_meter.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../domain/enums/auth_enums.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _passwordError;
  String? _confirmError;

  @override
  void initState() {
    super.initState();

    _passwordFocusNode.addListener(() => setState(() {}));
    _confirmFocusNode.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  PasswordStrength _evaluatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;

    final hasMinLength = password.length >= 8;
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final hasSpecialOrUpper = RegExp(r'[A-Z!@#\$&*~_.,]').hasMatch(password) && password.length >= 10;

    if (!hasMinLength || !hasDigit) {
      return PasswordStrength.weak;
    }

    if (hasSpecialOrUpper) {
      return PasswordStrength.strong;
    }

    return PasswordStrength.medium;
  }

  void _submitNewPassword(AppContext appContext) {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    bool hasError = false;

    final strength = _evaluatePasswordStrength(password);

    if (strength == PasswordStrength.empty || strength == PasswordStrength.weak) {
      _passwordError = appContext.localText.password_error;
      hasError = true;
    } else {
      _passwordError = null;
    }

    if (confirmPassword != password) {
      _confirmError = appContext.localText.password_mismatch;
      hasError = true;
    } else {
      _confirmError = null;
    }

    setState(() {});

    if (hasError) return;

    getIt<AuthBloc>().add(UpdatePasswordEvent(password));
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    final strength = _evaluatePasswordStrength(
      _passwordController.text,
    );

    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.passwordUpdated) {
            context.pushReplacementNamed(authLoginName);

            Flushbar(
              message: appContext.localText.password_updated_success,
              backgroundColor: AppColors.primary,
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
            ).show(context);
          } else if (state.status == AuthStatus.error) {
            Flushbar(
              message: appContext.localText.password_update_error,
              backgroundColor: const Color(0xFFD92D20),
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;

          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.s24,
                  AppSize.s28,
                  AppSize.s24,
                  AppSize.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      appContext.localText.new_password_title,
                      style: AppStyles.getExtraBold(
                        context: context,
                        fontSize: AppSize.s28,
                        color: const Color(0xFF11201F),
                      ),
                    ),

                    const Gap(AppSize.s8),

                    Text(
                      appContext.localText.new_password_subtitle,
                      style: AppStyles.getMeduim(
                        context: context,
                        fontSize: AppSize.s14,
                        color: const Color(0xFF5A6866),
                      ),
                    ),

                    const Gap(AppSize.s28),

                    // New Password
                    Text(
                      appContext.localText.new_password,
                      style: AppStyles.getBold(
                        context: context,
                        fontSize: AppSize.s14,
                        color: const Color(0xFF11201F),
                      ),
                    ),

                    const Gap(AppSize.s8),

                    AuthTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      hintText: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outline_rounded,
                      errorText: _passwordError,
                      activeBorderColor: AppColors.primary,
                      onChanged: (_) {
                        if (_passwordError != null) {
                          setState(() => _passwordError = null);
                        }
                      },
                      suffixWidget: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: const Color(0xFF5A6866),
                          size: AppSize.s22,
                        ),
                      ),
                    ),

                    const Gap(AppSize.s16),

                    // Confirm Password
                    Text(
                      appContext.localText.confirm_new_password,
                      style: AppStyles.getBold(
                        context: context,
                        fontSize: AppSize.s14,
                        color: const Color(0xFF11201F),
                      ),
                    ),

                    const Gap(AppSize.s8),

                    AuthTextField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmFocusNode,
                      hintText: '••••••••',
                      obscureText: _obscureConfirm,
                      prefixIcon: Icons.lock_reset_rounded,
                      errorText: _confirmError,
                      activeBorderColor: AppColors.primary,
                      onChanged: (_) {
                        if (_confirmError != null) {
                          setState(() => _confirmError = null);
                        }
                      },
                      suffixWidget: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: const Color(0xFF5A6866),
                          size: AppSize.s22,
                        ),
                      ),
                    ),

                    const Gap(AppSize.s14),

                    // Password Strength
                    _UpdatePasswordStrengthBar(
                      strength: strength,
                    ),

                    const Gap(AppSize.s28),

                    // Save Button
                    SizedBox(
                      height: AppSize.s54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _submitNewPassword(appContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSize.s16,
                            ),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: AppSize.s24,
                                height: AppSize.s24,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppSize.s2_5,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                appContext.localText.save_new_password,
                                style: AppStyles.getBold(
                                  context: context,
                                  fontSize: AppSize.s16,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --------------------------------------------------
// Password Strength Bar
// --------------------------------------------------

class _UpdatePasswordStrengthBar extends StatelessWidget {
  final PasswordStrength strength;

  const _UpdatePasswordStrengthBar({
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);

    final (int activeSegments, Color activeColor, String labelText) = switch (strength) {
      PasswordStrength.empty => (
        0,
        const Color(0xFFE2DFD7),
        appContext.localText.week,
      ),
      PasswordStrength.weak => (
        1,
        const Color(0xFFD92D20),
        appContext.localText.week,
      ),
      PasswordStrength.medium => (
        2,
        const Color(0xFFD97706),
        appContext.localText.medium,
      ),
      PasswordStrength.strong => (
        3,
        const Color(0xFF16A34A),
        appContext.localText.strong,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index < activeSegments;

                  return Expanded(
                    child: Container(
                      height: AppSize.s6,
                      margin: EdgeInsetsDirectional.only(
                        end: index < 2 ? AppSize.s6 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : const Color(0xFFE4E1D8),
                        borderRadius: BorderRadius.circular(
                          AppSize.s10,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Gap(AppSize.s12),

            Text(
              '${appContext.localText.strong_pasword}: $labelText',
              style: AppStyles.getBold(
                context: context,
                fontSize: AppSize.s12,
                color: strength == PasswordStrength.empty ? const Color(0xFF7B8886) : activeColor,
              ),
            ),
          ],
        ),

        const Gap(AppSize.s6),

        Text(
          appContext.localText.warrning_password,
          style: AppStyles.getMeduim(
            context: context,
            fontSize: AppSize.s12,
            color: const Color(0xFF7B8886),
          ),
        ),
      ],
    );
  }
}
