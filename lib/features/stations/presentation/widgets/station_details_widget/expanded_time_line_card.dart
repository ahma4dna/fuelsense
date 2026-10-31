import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/time_line_item_ui_model.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/delay_percentage_badge.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/three_segment_traffic_gauge.dart';
import 'package:gap/gap.dart';

class ExpandedTimelineCard extends StatelessWidget {
  final TimelineItemUiModel item;

  const ExpandedTimelineCard({super.key, required this.item});

  Color get _statusAccentColor {
    switch (item.status) {
      case OfficialStationStatus.open:
        return const Color(0xFF16A34A);
      case OfficialStationStatus.refilling:
        return const Color(0xFFF08A00);
      case OfficialStationStatus.onTheWay:
        return const Color(0xFF0F6E67);
      case OfficialStationStatus.closed:
      case OfficialStationStatus.outOfFuel:
        return const Color(0xFFD92D20);
      case OfficialStationStatus.unknown:
        return const Color(0xFF7B8886);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBF9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE6E2D9),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: _statusAccentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: const Color(0xFFECEAE2),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.approval_rounded,
                        color: const Color(0xFFC25E00),
                        size: AppSize.s26,
                      ),
                    ),
                    const Gap(AppSize.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الحالة الرسمية وقتها',
                            style: AppStyles.getExtraBold(
                              context: context,
                              fontSize: AppSize.s14,
                              color: const Color(0xFFC25E00),
                            ),
                          ),
                          const Gap(AppSize.s4),
                          Text(
                            item.expandedStatusTitle,
                            style: AppStyles.getExtraBold(
                              context: context,
                              fontSize: AppSize.s13,
                              color: const Color(0xFF11201F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE6E2D9),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.expandedTrafficText,
                  style: AppStyles.getBold(
                    context: context,
                    fontSize: AppSize.s14,
                    color: const Color(0xFF4A5957),
                  ),
                ),
                const Gap(AppSize.s12),
                Row(
                  children: [
                    Expanded(
                      child: ThreeSegmentTrafficGauge(
                        trafficLevel: item.trafficLevel,
                      ),
                    ),
                    const Gap(AppSize.s12),
                    DelayPercentageBadge(
                      delayPercentage: item.delayPercentage,
                      trafficLevel: item.trafficLevel,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(AppSize.s12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: Color(0xFF7B8886),
                ),
              ),
              const Gap(8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppStyles.getBold(
                      context: context,
                      fontSize: AppSize.s13,
                      color: const Color(0xFF4A5957),
                    ),
                    children: [
                      TextSpan(
                        text: 'أرشيف الآراء: ',
                        style: AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF11201F),
                        ),
                      ),
                      TextSpan(
                        text: item.archiveSummaryText,
                        style: AppStyles.getMeduim(
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
