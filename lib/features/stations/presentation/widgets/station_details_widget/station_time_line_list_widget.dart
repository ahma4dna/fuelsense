import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/station_history_entity.dart';
import 'package:fuelsense/features/stations/domain/entities/time_line_item_ui_model.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/time_line_step_row.dart';
import 'package:gap/gap.dart';

class StationTimelineListWidget extends StatefulWidget {
  final List<StationHistoryEntity>? historyEntities;
  final List<TimelineItemUiModel>? customItems;
  final void Function(int historyId)? onItemToggled;

  const StationTimelineListWidget({
    super.key,
    this.historyEntities,
    this.customItems,
    this.onItemToggled,
  });

  @override
  State<StationTimelineListWidget> createState() => _StationTimelineListWidgetState();
}

class _StationTimelineListWidgetState extends State<StationTimelineListWidget> {
  final Set<int> _expandedIds = {};
  bool _initialized = false;

  List<TimelineItemUiModel> get _effectiveItems {
    if (widget.customItems != null && widget.customItems!.isNotEmpty) {
      return widget.customItems!;
    }
    if (widget.historyEntities != null) {
      return widget.historyEntities!.map(TimelineItemUiModel.fromEntity).toList();
    }
    return [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFirstExpanded();
  }

  @override
  void didUpdateWidget(covariant StationTimelineListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initFirstExpanded();
  }

  void _initFirstExpanded() {
    if (!_initialized) {
      final items = _effectiveItems;
      if (items.isNotEmpty) {
        _expandedIds.add(items.first.id);
        _initialized = true;
      }
    }
  }

  void _toggleExpand(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
    widget.onItemToggled?.call(id);
  }

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);
    final items = _effectiveItems;

    return widget.historyEntities!.isEmpty
        ? Text(
            appContext.localText.history_this_station_not_avialeble,
            style: AppStyles.getBold(
              context: context,
              fontSize: AppSize.s17,
              color: Color(0xFF3F4E4C),
            ),
          )
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 20,
                        color: Color(0xFF4A5957),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          'الخط الزمني لحالات المحطة السابقة',
                          style: AppStyles.getBold(
                            context: context,
                            fontSize: AppSize.s17,
                            color: Color(0xFF3F4E4C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isExpanded = _expandedIds.contains(item.id);
                        final isLast = index == items.length - 1;

                        return TimelineStepRow(
                          item: item,
                          isExpanded: isExpanded,
                          isLast: isLast,
                          onToggle: () => _toggleExpand(item.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
