import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/auth/presentation/widgets/auth_text_field.dart';
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

  void _submitResetRequest(AppContext appContext) {
    final email = _emailController.text.trim();

    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = appContext.localText.invalid_email_format;
      });
      return;
    }

    setState(() => _emailError = null);
    getIt<AuthBloc>().add(ResetPasswordEvent(email));
  }

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);
    final localText = appContext.localText;

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
              message: localText.reset_link_send_error,
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
                padding: EdgeInsets.fromLTRB(
                  AppSize.s24,
                  AppSize.s12,
                  AppSize.s24,
                  AppSize.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(AppSize.s20),
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.s6),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: AppSize.s28,
                            color: const Color(0xFF11201F),
                          ),
                        ),
                      ),
                    ),
                    Gap(AppSize.s16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isEmailSent
                          ? _buildStaticCheckEmailView(
                              isLoading,
                              appContext,
                            )
                          : _buildEmailInputForm(
                              isLoading,
                              appContext,
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

  Widget _buildEmailInputForm(
    bool isLoading,
    AppContext appContext,
  ) {
    final localText = appContext.localText;

    return Column(
      key: const ValueKey('input_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localText.forgot_password_title,
          style: AppStyles.getExtraBold(
            context: context,
            fontSize: AppSize.s28,
            color: const Color(0xFF11201F),
          ),
        ),
        Gap(AppSize.s8),
        Text(
          localText.forgot_password_subtitle,
          style: AppStyles.getMeduim(
            context: context,
            fontSize: AppSize.s14,
            color: const Color(0xFF5A6866),
          ).copyWith(height: 1.5),
        ),
        Gap(AppSize.s28),
        Text(
          localText.email,
          style: AppStyles.getBold(
            context: context,
            fontSize: AppSize.s14,
            color: const Color(0xFF11201F),
          ),
        ),
        Gap(AppSize.s8),
        AuthTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          hintText: localText.email_hint,
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
        Gap(AppSize.s28),
        SizedBox(
          height: AppSize.s54,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _submitResetRequest(appContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F6E67),
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: AppSize.s24,
                    height: AppSize.s24,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSize.s2_5,
                      color: AppColors.white,
                    ),
                  )
                : Text(
                    localText.send_reset_link,
                    style: AppStyles.getBold(
                      context: context,
                      fontSize: AppSize.s16,
                      color: AppColors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaticCheckEmailView(
    bool isLoading,
    AppContext appContext,
  ) {
    final localText = appContext.localText;

    return Container(
      key: const ValueKey('static_check_email_view'),
      padding: EdgeInsets.all(AppSize.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s24),
        border: Border.all(
          color: const Color(0xFFE6E2D9),
          width: AppSize.s1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppSize.s54 + AppSize.s18,
            height: AppSize.s54 + AppSize.s18,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF9F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_unread_outlined,
              size: AppSize.s36,
              color: const Color(0xFF0F6E67),
            ),
          ),
          Gap(AppSize.s20),
          Text(
            localText.check_your_email,
            textAlign: TextAlign.center,
            style: AppStyles.getExtraBold(
              context: context,
              fontSize: AppSize.s22,
              color: const Color(0xFF11201F),
            ),
          ),
          Gap(AppSize.s10),
          Text(
            '${localText.reset_link_sent_to}\n${_emailController.text.trim()}',
            textAlign: TextAlign.center,
            style: AppStyles.getBold(
              context: context,
              fontSize: AppSize.s14,
              color: const Color(0xFF4A5957),
            ).copyWith(height: 1.6),
          ),
          Gap(AppSize.s14),
          Container(
            padding: EdgeInsets.all(AppSize.s14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF9F7),
              borderRadius: BorderRadius.circular(AppSize.s14),
            ),
            child: Text(
              localText.reset_link_instructions,
              textAlign: TextAlign.center,
              style: AppStyles.getBold(
                context: context,
                fontSize: AppSize.s14,
                color: const Color(0xFF083A38),
              ).copyWith(height: 1.5),
            ),
          ),
          Gap(AppSize.s24),
          SizedBox(
            width: double.infinity,
            height: AppSize.s54,
            child: OutlinedButton(
              onPressed: isLoading ? null : () => _submitResetRequest(appContext),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xFF0F6E67),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s14),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: AppSize.s20,
                      height: AppSize.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSize.s2,
                        color: const Color(0xFF0F6E67),
                      ),
                    )
                  : Text(
                      localText.resend_reset_link,
                      style: AppStyles.getBold(
                        context: context,
                        fontSize: AppSize.s14,
                        color: const Color(0xFF0F6E67),
                      ),
                    ),
            ),
          ),
          Gap(AppSize.s12),
          TextButton(
            onPressed: () {
              setState(() {
                _isEmailSent = false;
              });
            },
            child: Text(
              localText.edit_email,
              style: AppStyles.getBold(
                context: context,
                fontSize: AppSize.s14,
                color: const Color(0xFF5A6866),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
