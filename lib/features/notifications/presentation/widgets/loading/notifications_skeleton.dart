import 'package:flutter/material.dart';
import 'package:fuelsense/core/widget/smooth_animations.dart';
import 'package:gap/gap.dart';

class NotificationsSkeleton extends StatelessWidget {
  const NotificationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PulseSkeleton(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
        itemCount: 5,
        separatorBuilder: (_, _) => const Gap(12),
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBlock(width: 46, height: 46, radius: 14),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBlock(width: 90, height: 14),
                    SizedBox(height: 12),
                    SkeletonBlock(width: double.infinity, height: 12),
                    SizedBox(height: 8),
                    SkeletonBlock(width: 160, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
