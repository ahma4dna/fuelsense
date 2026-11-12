import 'package:flutter/widgets.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/features/stations_directory/presentation/widgets/loading/skeleton_card.dart';
import 'package:gap/gap.dart';

class SkeletonList extends StatefulWidget {
  const SkeletonList({super.key});

  @override
  State<SkeletonList> createState() => SkeletonListState();
}

class SkeletonListState extends State<SkeletonList> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p16,
          AppPadding.p4,
          AppPadding.p16,
          AppPadding.p24,
        ),
        itemCount: 5,
        separatorBuilder: (_, _) => const Gap(AppSize.s14),
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) {
              final t = Curves.easeInOut.transform(_pulse.value);
              return Opacity(
                opacity: 0.45 + 0.55 * t,
                child: const SkeletonCard(),
              );
            },
          );
        },
      ),
    );
  }
}
