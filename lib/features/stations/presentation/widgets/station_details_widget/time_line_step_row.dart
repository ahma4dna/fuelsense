import 'package:flutter/material.dart';
import 'package:fuelsense/features/stations/domain/entities/time_line_item_ui_model.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/collapsed_timeline_view.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/expanded_time_line_card.dart';
import 'package:gap/gap.dart';

class TimelineStepRow extends StatelessWidget {
  final TimelineItemUiModel item;
  final bool isExpanded;
  final bool isLast;
  final VoidCallback onToggle;

  const TimelineStepRow({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.isLast,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 36, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 19,
                        color: Color(0xFF7B8886),
                      ),
                      const Gap(6),
                      Text(
                        item.relativeTimeText,
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF11201F),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        size: 24,
                        color: const Color(0xFF5A6866),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(10),

              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  alignment: AlignmentDirectional.topStart,
                  child: SizedBox(
                    width: double.infinity,
                    child: isExpanded
                        ? ExpandedTimelineCard(item: item)
                        : CollapsedTimelineView(
                            item: item,
                            onShowReportsTap: onToggle,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),

        PositionedDirectional(
          top: 0,
          bottom: 0,
          start: 0,
          width: 26,
          child: Column(
            children: [
              const Gap(2),
              _buildTimelineNode(isExpanded),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: const Color(0xFFE2DFD7),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineNode(bool active) {
    if (active) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFFD2ECE8),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 11,
            height: 11,
            decoration: const BoxDecoration(
              color: Color(0xFF0F6E67),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7F2),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF7B8886),
          width: 2.3,
        ),
      ),
    );
  }
}
