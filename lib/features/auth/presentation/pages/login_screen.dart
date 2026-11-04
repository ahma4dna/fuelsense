import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:fuelsense/features/auth/presentation/widgets/google_auth_button.dart';
import 'package:fuelsense/features/auth/presentation/widgets/login/login_radar_header.dart';
import 'package:fuelsense/features/auth/presentation/widgets/rigester/auth_or_divider.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:fuelsense/features/main/routes/main_pathe.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../domain/enums/auth_enums.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  const LoginScreen({super.key, this.onLoginSuccess});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  String? _emailError;
  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  void _submitLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = AppContext.of(context).localText.email_error;
      });
      return;
    }
    setState(() => _emailError = null);
    getIt<AuthBloc>().add(
      SignInWithEmailEvent(
        email: email,
        password: password,
      ),
    );
  }

  void _onForgotPassword(BuildContext con) {
    con.pushNamed(forGotPaswordName);
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.passwordRecoveryMode) {
            context.pushReplacementNamed(changePaswordName);
          }
          if (state.status == AuthStatus.authenticated) {
            context.goNamed(mainPathName);
          } else if (state.status == AuthStatus.passwordResetSent) {
            Flushbar(
              message: appContext.localText.password_reset_sent,
              backgroundColor: AppColors.primary,
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
            ).show(context);
          } else if (state.status == AuthStatus.error) {
            Flushbar(
              message: appContext.localText.login_error,
              backgroundColor: const Color(0xFFD92D20),
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;
          return Scaffold(
            backgroundColor: const Color(0xFF0A3832),
            body: Column(
              children: [
                // Header
                const LoginRadarHeader(),
                // Login Form
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSize.s32),
                        topRight: Radius.circular(AppSize.s32),
                      ),
                    ),
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
                          // Email
                          Text(
                            appContext.localText.email,
                            style: AppStyles.getBold(
                              context: context,
                              fontSize: AppSize.s14,
                              color: _emailError != null
                                  ? const Color(0xFFD92D20)
                                  : (_emailFocusNode.hasFocus ? AppColors.primary : const Color(0xFF11201F)),
                            ),
                          ),
                          const Gap(AppSize.s8),
                          AuthTextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            hintText: appContext.localText.email_hint,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.mail_outline_rounded,
                            errorText: _emailError,
                            activeBorderColor: AppColors.primary,
                            onChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                          ),
                          const Gap(AppSize.s18),
                          // Password
                          Text(
                            appContext.localText.password,
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
                            activeBorderColor: AppColors.primary,
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
                          const Gap(AppSize.s12),
                          // Forgot Password
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: InkWell(
                              onTap: () => _onForgotPassword(context),
                              borderRadius: BorderRadius.circular(AppSize.s6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.s4,
                                ),
                                child: Text(
                                  appContext.localText.forgot_password,
                                  style: AppStyles.getBold(
                                    context: context,
                                    fontSize: AppSize.s13_5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Gap(AppSize.s20),
                          // Login Button
                          SizedBox(
                            height: AppSize.s54,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submitLogin,
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
                                      appContext.localText.login,
                                      style: AppStyles.getBold(
                                        context: context,
                                        fontSize: AppSize.s16,
                                        color: AppColors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const Gap(AppSize.s22),
                          // Divider
                          AuthOrDivider(
                            text: appContext.localText.or,
                          ),
                          const Gap(AppSize.s20),
                          // Google Login
                          GoogleAuthButton(
                            label: appContext.localText.continue_with_google,
                            onTap: isLoading
                                ? null
                                : () => getIt<AuthBloc>().add(
                                    SignInWithGoogleEvent(),
                                  ),
                          ),
                          const Gap(AppSize.s32),
                          // Register
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                context.pushNamed(authRegiterNmae);
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: AppStyles.getMeduim(
                                    context: context,
                                    fontSize: AppSize.s14,
                                    color: const Color(0xFF5A6866),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: appContext.localText.no_account,
                                    ),
                                    TextSpan(
                                      text: appContext.localText.create_new_account,
                                      style: AppStyles.getBold(
                                        context: context,
                                        fontSize: AppSize.s14,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
