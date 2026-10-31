import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/auth/presentation/widgets/rigester/auth_or_divider.dart';
import 'package:fuelsense/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:fuelsense/features/auth/presentation/widgets/google_auth_button.dart';
import 'package:fuelsense/features/auth/presentation/widgets/rigester/password_strength_meter.dart';
import 'package:fuelsense/features/auth/routes/reports_path.dart';
import 'package:fuelsense/features/staionssjs/routes/stations_path.dart';
import 'package:fuelsense/features/stations/presentation/routes/home_path.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../domain/enums/auth_enums.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;

  const RegisterScreen({super.key, this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _acceptedTerms = true;

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  PasswordStrength _evaluatePasswordStrength(
    String password,
  ) {
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

  void _submitRegister(AppContext con) {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool hasError = false;

    if (fullName.length < 3) {
      _nameError = con.localText.name_error;
      hasError = true;
    } else {
      _nameError = null;
    }

    if (!_isValidEmail(email)) {
      _emailError = con.localText.email_error;
      hasError = true;
    } else {
      _emailError = null;
    }

    final strength = _evaluatePasswordStrength(password);
    if (strength == PasswordStrength.empty || strength == PasswordStrength.weak) {
      _passwordError = con.localText.password_error;
      hasError = true;
    } else {
      _passwordError = null;
    }

    setState(() {});
    if (hasError) return;

    if (!_acceptedTerms) {
      Flushbar(
        message: con.localText.accepted_terms,
        backgroundColor: const Color(0xFFD92D20),
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    getIt<AuthBloc>().add(
      SignUpWithEmailEvent(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);
    final passwordStrength = _evaluatePasswordStrength(_passwordController.text);

    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.goNamed(homeName);
          } else if (state.status == AuthStatus.error) {
            Flushbar(
              message: appContext.localText.error_crate_account,
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
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 30,
                            color: Color(0xFF11201F),
                          ),
                        ),
                      ),
                    ),
                    const Gap(AppSize.s8),

                    //
                    Text(
                      appContext.localText.create_new_account,
                      style: AppStyles.getExtraBold(
                        context: context,
                        fontSize: AppSize.s28,
                        color: Color(0xFF11201F),
                      ),
                    ),
                    const Gap(AppSize.s6),
                    Text(
                      appContext.localText.create_new_account_title,
                      style: AppStyles.getMeduim(
                        context: context,
                        fontSize: AppSize.s15,
                        color: Color(0xFF5A6866),
                      ),
                    ),
                    const Gap(AppSize.s22),

                    //
                    GoogleAuthButton(
                      label: appContext.localText.sin_up_google,
                      onTap: isLoading
                          ? null
                          : () {
                              if (!_acceptedTerms) {
                                Flushbar(
                                  message: appContext.localText.accepted_terms,
                                  backgroundColor: const Color(0xFFD92D20),
                                  flushbarPosition: FlushbarPosition.TOP,
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                                return;
                              }
                              getIt<AuthBloc>().add(
                                SignInWithGoogleEvent(),
                              );
                            },
                    ),
                    const Gap(AppSize.s20),

                    //
                    AuthOrDivider(
                      text: appContext.localText.or_sin_up_email,
                    ),
                    const Gap(AppSize.s20),

                    //
                    Text(
                      appContext.localText.full_name,
                      style: AppStyles.getBold(
                        context: context,
                        fontSize: AppSize.s14,
                        color: Color(0xFF11201F),
                      ),
                    ),
                    const Gap(AppSize.s8),
                    AuthTextField(
                      controller: _fullNameController,
                      focusNode: _nameFocusNode,
                      hintText: 'سالم الفيتوري',
                      prefixIcon: Icons.person_outline_rounded,
                      errorText: _nameError,
                      activeBorderColor: const Color(0xFF0F6E67),
                      onChanged: (_) {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),
                    const Gap(AppSize.s16),

                    //
                    Text(
                      appContext.localText.email,
                      style: AppStyles.getBold(
                        context: context,
                        fontSize: AppSize.s14,
                        color: Color(0xFF11201F),
                      ),
                    ),
                    const Gap(AppSize.s8),
                    AuthTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      hintText: 'اكتب بريدك الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
                      errorText: _emailError,
                      activeBorderColor: AppColors.primary,
                      onChanged: (val) {
                        if (_emailError != null && _isValidEmail(val)) {
                          setState(() => _emailError = null);
                        }
                      },
                    ),
                    const Gap(AppSize.s16),

                    // كلمة المرور
                    Text(
                      appContext.localText.password,
                      style: AppStyles.getBold(
                        context: context,
                        fontSize: AppSize.s14,
                        color: Color(0xFF11201F),
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
                      activeBorderColor: const Color(0xFF0F6E67),
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

                    //
                    PasswordStrengthMeter(strength: passwordStrength),
                    const Gap(AppSize.s18),

                    //
                    Row(
                      children: [
                        SizedBox(
                          width: AppSize.s24,
                          height: AppSize.s24,
                          child: Checkbox(
                            value: _acceptedTerms,
                            onChanged: (val) {
                              setState(() {
                                _acceptedTerms = val ?? false;
                              });
                            },
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSize.s6),
                            ),
                          ),
                        ),
                        const Gap(AppSize.s10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _acceptedTerms = !_acceptedTerms;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  "${appContext.localText.accept} ",
                                  style: AppStyles.getMeduim(
                                    context: context,
                                    fontSize: AppSize.s13,
                                    color: Color(0xFF4A5957),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => context.pushNamed(termsOfUseName),
                                  child: Text(
                                    "${appContext.localText.terms} ",
                                    style: TextStyle(
                                      color: Color(0xFF0F6E67),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${appContext.localText.and} ",
                                  style: AppStyles.getMeduim(
                                    context: context,
                                    fontSize: AppSize.s13,
                                    color: Color(0xFF4A5957),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => context.pushNamed(privacyPolicyName),
                                  child: Text(
                                    appContext.localText.privcy,
                                    style: TextStyle(
                                      color: Color(0xFF0F6E67),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSize.s22),

                    // create account btn
                    SizedBox(
                      height: AppSize.s54,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                _submitRegister(appContext);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F6E67),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: AppSize.s24,
                                height: AppSize.s24,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppSize.s2_5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                appContext.localText.create_account,
                                style: AppStyles.getBold(
                                  context: context,
                                  fontSize: AppSize.s16,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                    const Gap(AppSize.s24),

                    //
                    Center(
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: RichText(
                          text: TextSpan(
                            style: AppStyles.getMeduim(
                              context: context,
                              fontSize: AppSize.s14,
                              color: Color(0xFF5A6866),
                            ),
                            children: [
                              TextSpan(text: appContext.localText.you_have_account),
                              TextSpan(
                                text: appContext.localText.sign_in,
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
          );
        },
      ),
    );
  }
}

///
