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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  final _emailFocusNode = FocusNode();

  String? _emailError;
  bool _isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  void _submitResetRequest() {
    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = 'صيغة البريد الإلكتروني غير صحيحة';
      });
      return;
    }

    setState(() => _emailError = null);
    getIt<AuthBloc>().add(ResetPasswordEvent(email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.passwordResetSent) {
            setState(() {
              _isEmailSent = true;
            });
          } else if (state.status == AuthStatus.error) {
            Flushbar(
              message: 'تعذر إرسال رابط الاستعادة',
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
                      const Gap(16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isEmailSent ? _buildStaticCheckEmailView(isLoading) : _buildEmailInputForm(isLoading),
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

  Widget _buildEmailInputForm(bool isLoading) {
    return Column(
      key: const ValueKey('input_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'استعادة كلمة المرور',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF11201F),
          ),
        ),
        const Gap(8),
        const Text(
          'أدخل بريدك الإلكتروني المسجل وسنرسل لك رابطاً آمناً لإعادة تعيين كلمة المرور الخاصة بك.',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5A6866),
            height: 1.5,
          ),
        ),
        const Gap(28),
        const Text(
          'البريد الإلكتروني',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF11201F),
          ),
        ),
        const Gap(8),
        AuthTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          hintText: 'اكتب بريدك الإلكتروني',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline_rounded,
          errorText: _emailError,
          activeBorderColor: const Color(0xFF0F6E67),
          onChanged: (val) {
            if (_emailError != null && _isValidEmail(val)) {
              setState(() => _emailError = null);
            }
          },
        ),
        const Gap(28),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitResetRequest,
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
                    'إرسال رابط الاستعادة',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaticCheckEmailView(bool isLoading) {
    return Container(
      key: const ValueKey('static_check_email_view'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE6E2D9),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF9F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_unread_outlined,
              size: 36,
              color: Color(0xFF0F6E67),
            ),
          ),
          const Gap(20),
          const Text(
            'تحقق من بريدك الإلكتروني',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF11201F),
            ),
          ),
          const Gap(10),
          Text(
            'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى البريد الإلكتروني:\n${_emailController.text.trim()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5957),
              height: 1.6,
            ),
          ),
          const Gap(14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF9F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'يرجى فتح بريدك الإلكتروني والضغط على الرابط المرسل، وسيقوم الرابط بإعادتك تلقائياً إلى التطبيق لتعيين كلمة المرور الجديدة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF083A38),
                height: 1.5,
              ),
            ),
          ),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: isLoading ? null : _submitResetRequest,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0F6E67)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0F6E67),
                      ),
                    )
                  : const Text(
                      'إعادة إرسال الرابط',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F6E67),
                      ),
                    ),
            ),
          ),
          const Gap(12),
          TextButton(
            onPressed: () {
              setState(() {
                _isEmailSent = false;
              });
            },
            child: const Text(
              'تعديل البريد الإلكتروني',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A6866),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
