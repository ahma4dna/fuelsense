import 'package:flutter/material.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/gauge_bar_segment.dart';
import 'package:gap/gap.dart';

class ThreeSegmentTrafficGauge extends StatelessWidget {
  final TrafficLevel trafficLevel;

  const ThreeSegmentTrafficGauge({super.key, required this.trafficLevel});

  @override
  Widget build(BuildContext context) {
    final bool isNormal = trafficLevel == TrafficLevel.normal;
    final bool isBusy = trafficLevel == TrafficLevel.busy;
    final bool isHeavy = trafficLevel == TrafficLevel.heavy;

    return Row(
      children: [
        Expanded(
          child: GaugeBarSegment(
            barColor: isNormal ? const Color(0xFF22C55E) : const Color(0xFFD9F3E4),
            thumbBorderColor: const Color(0xFF16A34A),
            isActive: isNormal,
          ),
        ),
        const Gap(6),
        Expanded(
          child: GaugeBarSegment(
            barColor: isBusy ? const Color(0xFFF59E0B) : const Color(0xFFF7EECF),
            thumbBorderColor: const Color(0xFFD97706),
            isActive: isBusy,
          ),
        ),
        const Gap(6),
        Expanded(
          child: GaugeBarSegment(
            barColor: isHeavy ? const Color(0xFFE05252) : const Color(0xFFFADCDC),
            thumbBorderColor: const Color(0xFFD92D20),
            isActive: isHeavy,
          ),
        ),
      ],
    );
  }
}
