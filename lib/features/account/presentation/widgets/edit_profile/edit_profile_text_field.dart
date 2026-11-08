import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final FormFieldValidator<String>? validator;

  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: AppStyles.getRgular(
        context: context,
        fontSize: AppSize.s14_5,
        color: const Color(0xFF11201F),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.getRgular(
          context: context,
          fontSize: AppSize.s14,
          color: const Color(0xFF8C9896),
        ),
        prefixIcon: const Icon(
          Icons.person_outline_rounded,
          color: Color(0xFF0F6E67),
          size: AppSize.s20,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
          borderSide: const BorderSide(
            color: Color(0xFFE6E2D9),
            width: AppSize.s1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
          borderSide: const BorderSide(
            color: Color(0xFFE6E2D9),
            width: AppSize.s1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
          borderSide: const BorderSide(
            color: Color(0xFF0F6E67),
            width: AppSize.s1_5,
          ),
        ),
      ),
    );
  }
}
