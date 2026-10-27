import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/presentation/widgets/home_screen_widget/search_staion_widget.dart';

class SearchStationsList extends StatelessWidget {
  final List<StationEntity> stations;
  final String query;
  final ValueChanged<StationEntity> onStationSelected;

  const SearchStationsList({
    super.key,
    required this.stations,
    required this.onStationSelected,
    this.query = '',
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.4;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x290F172A),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Material(
        color: AppColors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s18),
          side: BorderSide(color: AppColors.border, width: AppSize.s1),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: AppSize.s5),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: stations.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            indent: 72,
            endIndent: AppPadding.p16,
            color: AppColors.border,
          ),
          itemBuilder: (context, index) {
            final station = stations[index];
            return SearchStaionWidget(
              stationModel: station,
              query: query,
              onTap: () => onStationSelected(station),
            );
          },
        ),
      ),
    );
  }
}
