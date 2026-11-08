import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';

import '../../../domain/entities/account_profile_entity.dart';
import 'edit_profile_header.dart';
import 'edit_profile_text_field.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final AccountProfileEntity profile;
  final Future<void> Function(String fullName) onSave;

  const EditProfileBottomSheet({
    super.key,
    required this.profile,
    required this.onSave,
  });

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await widget.onSave(_nameController.text.trim());
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final appContext = AppContext.of(context);

    return Directionality(
      textDirection: appContext.isRt ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppPadding.p20,
          AppPadding.p16,
          AppPadding.p20,
          bottomInset + AppPadding.p24,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF6F4EE),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSize.s28),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: AppSize.s44,
                    height: AppSize.s4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0CCC2),
                      borderRadius: BorderRadius.circular(AppSize.s10),
                    ),
                  ),
                ),
                const Gap(AppSize.s18),
                const EditProfileHeader(),
                const Gap(AppSize.s22),
                Text(
                  appContext.localText.full_name,
                  style: AppStyles.getBold(
                    context: context,
                    fontSize: AppSize.s14,
                    color: const Color(0xFF11201F),
                  ),
                ),
                const Gap(AppSize.s8),
                EditProfileTextField(
                  controller: _nameController,
                  hint: appContext.localText.full_name_hint,
                  validator: (val) {
                    if (val == null || val.trim().length < 3) {
                      return appContext.localText.name_validation_error;
                    }
                    return null;
                  },
                ),
                const Gap(AppSize.s16),
                SizedBox(
                  height: AppSize.s52,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F6E67),
                      foregroundColor: Colors.white,
                      elevation: AppSize.s0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s16),
                      ),
                    ),
                    icon: _isSaving
                        ? const SizedBox.shrink()
                        : const Icon(
                            Icons.check_circle_outline_rounded,
                            size: AppSize.s20,
                          ),
                    label: _isSaving
                        ? const SizedBox(
                            width: AppSize.s22,
                            height: AppSize.s22,
                            child: CircularProgressIndicator(
                              strokeWidth: AppSize.s2_5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            appContext.localText.save_changes,
                            style: AppStyles.getBold(
                              context: context,
                              fontSize: AppSize.s15,
                              color: Colors.white,
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
  }
}
