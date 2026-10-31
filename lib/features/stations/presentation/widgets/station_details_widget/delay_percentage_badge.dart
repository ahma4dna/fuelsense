import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:gap/gap.dart';

class DelayPercentageBadge extends StatelessWidget {
  final int delayPercentage;
  final TrafficLevel trafficLevel;

  const DelayPercentageBadge({
    super.key,
    required this.delayPercentage,
    required this.trafficLevel,
  });

  Color get _bgColor {
    switch (trafficLevel) {
      case TrafficLevel.heavy:
        return const Color(0xFFFBE7E7);
      case TrafficLevel.busy:
        return const Color(0xFFFCF4DC);
      case TrafficLevel.normal:
        return const Color(0xFFE6F6EF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '+$delayPercentage%',
            textDirection: TextDirection.ltr,
            style: AppStyles.getExtraBold(
              context: context,
              fontSize: AppSize.s16,
              color: const Color(0xFF11201F),
            ),
          ),
          const Gap(2),
          Text(
            'تأخير',
            style: AppStyles.getBold(
              context: context,
              fontSize: AppSize.s12,
              color: const Color(0xFF4A5957),
            ),
          ),
        ],
      ),
    );
  }
}
