import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/time_line_item_ui_model.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:gap/gap.dart';

class CollapsedTimelineView extends StatelessWidget {
  final TimelineItemUiModel item;
  final VoidCallback onShowReportsTap;

  const CollapsedTimelineView({
    super.key,
    required this.item,
    required this.onShowReportsTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = _getStatusPillStyle(item.status);
    final trafficStyle = _getTrafficPillStyle(item.trafficLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusStyle.backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: statusStyle.dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    item.collapsedStatusText,
                    style: AppStyles.getBold(
                      context: context,
                      fontSize: AppSize.s13,
                      color: statusStyle.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: trafficStyle.backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.route_outlined,
                    size: 16,
                    color: trafficStyle.iconColor,
                  ),
                  const Gap(5),
                  Text(
                    item.collapsedTrafficText,
                    style: AppStyles.getBold(
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
        const Gap(20),
      ],
    );
  }

  ({Color backgroundColor, Color dotColor, Color textColor}) _getStatusPillStyle(
    OfficialStationStatus status,
  ) {
    switch (status) {
      case OfficialStationStatus.closed:
      case OfficialStationStatus.outOfFuel:
        return (
          backgroundColor: const Color(0xFFFDECEC),
          dotColor: const Color(0xFFE04F4F),
          textColor: const Color(0xFFB42318),
        );
      case OfficialStationStatus.refilling:
        return (
          backgroundColor: const Color(0xFFFFF4E5),
          dotColor: const Color(0xFFF08A00),
          textColor: const Color(0xFFB54708),
        );
      case OfficialStationStatus.open:
        return (
          backgroundColor: const Color(0xFFE6F6EF),
          dotColor: const Color(0xFF16A34A),
          textColor: const Color(0xFF15803D),
        );
      case OfficialStationStatus.onTheWay:
        return (
          backgroundColor: const Color(0xFFEEF9F7),
          dotColor: const Color(0xFF0F6E67),
          textColor: const Color(0xFF0F6E67),
        );
      case OfficialStationStatus.unknown:
        return (
          backgroundColor: const Color(0xFFF2F4F7),
          dotColor: const Color(0xFF667085),
          textColor: const Color(0xFF344054),
        );
    }
  }

  ({Color backgroundColor, Color iconColor}) _getTrafficPillStyle(
    TrafficLevel level,
  ) {
    switch (level) {
      case TrafficLevel.normal:
        return (
          backgroundColor: const Color(0xFFE6F6EF),
          iconColor: const Color(0xFF16A34A),
        );
      case TrafficLevel.busy:
        return (
          backgroundColor: const Color(0xFFFDF5DF),
          iconColor: const Color(0xFFD97706),
        );
      case TrafficLevel.heavy:
        return (
          backgroundColor: const Color(0xFFFDECEC),
          iconColor: const Color(0xFFD92D20),
        );
    }
  }
}
