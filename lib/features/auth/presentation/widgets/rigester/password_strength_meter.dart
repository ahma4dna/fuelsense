import 'package:flutter/widgets.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/auth/domain/enums/auth_enums.dart';
import 'package:gap/gap.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthMeter({super.key, required this.strength});

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
            //
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
            const Gap(AppSize.s12),
            Text(
              'قوة كلمة المرور: $labelText',
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
          'ثمانية أحرف على الأقل، وتحتوي رقماً',
          style: AppStyles.getMeduim(
            context: context,
            fontSize: AppSize.s12,
            color: Color(0xFF7B8886),
          ),
        ),
      ],
    );
  }
}
