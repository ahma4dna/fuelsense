import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';
import 'package:gap/gap.dart';

class AccountSkeleton extends StatelessWidget {
  const AccountSkeleton({super.key});

  Widget _card(int rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E2D9)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows; i++) ...[
            if (i > 0) const SizedBox(height: 18),
            const Row(
              children: [
                SkeletonBlock(width: 40, height: 40, radius: 12),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBlock(width: 130, height: 13),
                      SizedBox(height: 8),
                      SkeletonBlock(width: 200, height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PulseSkeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p16,
          AppPadding.p16,
          AppPadding.p16,
          AppPadding.p32,
        ),
        children: [
          const SkeletonBlock(width: 110, height: 14),
          const Gap(AppSize.s10),
          _card(2),
          const Gap(AppSize.s22),
          const SkeletonBlock(width: 90, height: 14),
          const Gap(AppSize.s10),
          _card(1),
          const Gap(AppSize.s26),
          const SkeletonBlock(width: double.infinity, height: 56, radius: 20),
        ],
      ),
    );
  }
}
