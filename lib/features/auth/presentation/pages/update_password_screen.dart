import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/auth/presentation/widgets/auth_text_field.dart';
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

  void _submitNewPassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    bool hasError = false;
    final strength = _evaluatePasswordStrength(password);

    if (strength == PasswordStrength.empty || strength == PasswordStrength.weak) {
      _passwordError = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي رقماً';
      hasError = true;
    } else {
      _passwordError = null;
    }

    if (confirmPassword != password) {
      _confirmError = 'كلمتا المرور غير متطابقتين';
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
    final strength = _evaluatePasswordStrength(_passwordController.text);

    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.passwordUpdated) {
            context.pushReplacementNamed(authLoginName);
            Flushbar(
              message: 'تم تغيير كلمة المرور بنجاح، يمكنك الآن تسجيل الدخول',
              backgroundColor: const Color(0xFF0F6E67),
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
            ).show(context);
          } else if (state.status == AuthStatus.error) {
            Flushbar(
              message: 'تعذر تحديث كلمة المرور',
              backgroundColor: const Color(0xFFD92D20),
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'تعيين كلمة مرور جديدة',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF11201F),
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        'أدخل كلمة المرور الجديدة لحسابك، ثم سجل دخولك للمتابعة.',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5A6866),
                        ),
                      ),
                      const Gap(28),

                      // كلمة المرور الجديدة
                      const Text(
                        'كلمة المرور الجديدة',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF11201F),
                        ),
                      ),
                      const Gap(8),
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
                            size: 22,
                          ),
                        ),
                      ),
                      const Gap(16),

                      // تأكيد كلمة المرور الجديدة
                      const Text(
                        'تأكيد كلمة المرور الجديدة',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF11201F),
                        ),
                      ),
                      const Gap(8),
                      AuthTextField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmFocusNode,
                        hintText: '••••••••',
                        obscureText: _obscureConfirm,
                        prefixIcon: Icons.lock_reset_rounded,
                        errorText: _confirmError,
                        activeBorderColor: const Color(0xFF0F6E67),
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
                            size: 22,
                          ),
                        ),
                      ),
                      const Gap(14),

                      // مؤشر قوة كلمة المرور
                      _UpdatePasswordStrengthBar(strength: strength),
                      const Gap(28),

                      // زر الحفظ
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitNewPassword,
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
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'حفظ كلمة المرور الجديدة',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UpdatePasswordStrengthBar extends StatelessWidget {
  final PasswordStrength strength;
  const _UpdatePasswordStrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    final (int activeSegments, Color activeColor, String labelText) = switch (strength) {
      PasswordStrength.empty => (0, const Color(0xFFE2DFD7), 'ضعيفة'),
      PasswordStrength.weak => (1, const Color(0xFFD92D20), 'ضعيفة'),
      PasswordStrength.medium => (2, const Color(0xFFD97706), 'متوسطة'),
      PasswordStrength.strong => (3, const Color(0xFF16A34A), 'قوية'),
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
                      height: 5.5,
                      margin: EdgeInsetsDirectional.only(
                        end: index < 2 ? 6 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : const Color(0xFFE4E1D8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Gap(12),
            Text(
              'قوة كلمة المرور: $labelText',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: strength == PasswordStrength.empty ? const Color(0xFF7B8886) : activeColor,
              ),
            ),
          ],
        ),
        const Gap(6),
        const Text(
          'ثمانية أحرف على الأقل، وتحتوي رقماً',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7B8886),
          ),
        ),
      ],
    );
  }
}
