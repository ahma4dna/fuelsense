import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixWidget;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final Color activeBorderColor;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    required this.activeBorderColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final isFocused = focusNode.hasFocus;

    final Color borderColor = hasError
        ? const Color(0xFFE04F4F)
        : (isFocused ? activeBorderColor : const Color(0xFFE6E2D9));

    final Color iconColor = hasError
        ? const Color(0xFFD92D20)
        : (isFocused ? activeBorderColor : const Color(0xFF7B8886));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: AppSize.s54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: (hasError || isFocused) ? 1.6 : 1.0,
            ),
          ),
          child: Row(
            children: [
              const Gap(AppSize.s14),
              Icon(prefixIcon, color: iconColor, size: AppSize.s22),
              const Gap(AppSize.s10),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: AppStyles.getBold(
                    context: context,
                    fontSize: AppSize.s15,
                    color: Color(0xFF11201F),
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppStyles.getMeduim(
                      context: context,
                      fontSize: AppSize.s14,
                      color: Color(0xFF8C9896),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
                  ),
                ),
              ),
              if (suffixWidget != null) suffixWidget! else const Gap(AppSize.s14),
            ],
          ),
        ),
        if (hasError) ...[
          const Gap(AppSize.s6),
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: AppSize.s16,
                color: Color(0xFFD92D20),
              ),
              const Gap(AppSize.s5),
              Expanded(
                child: Text(
                  errorText!,
                  style: AppStyles.getBold(
                    context: context,
                    fontSize: AppSize.s12,
                    color: Color(0xFFD92D20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
