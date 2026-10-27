import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_bloc.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_event.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_state.dart';
import 'package:fuelsense/features/stations/presentation/widgets/home_screen_widget/search_stations_list.dart';
import 'package:gap/gap.dart';

class SearchAndNotificationHeaderWidget extends StatelessWidget {
  final AppContext appContext;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(StationEntity) onStationSelected;
  final StationsState state;
  const new({
    super.key,
    required this.appContext,
    required this.searchController,
    required this.searchFocusNode,
    required this.onStationSelected,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppSize.s52,
                child: TextField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  keyboardType: TextInputType.webSearch,
                  decoration: InputDecoration(
                    hint: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.search,
                          height: AppSize.s22,
                          width: AppSize.s22,
                        ),
                        const Gap(AppSize.s5),
                        Text(
                          appContext.localText.search_lable,
                          style: AppStyles.getRgular(
                            context: context,
                            color: const Color(0xFF90A1B8),
                            fontSize: AppSize.s16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    context.read<StationsBloc>().add(SearchStationsEvent(value));
                  },
                ),
              ),
            ),
            const Gap(AppSize.s5),
            Container(
              height: AppSize.s52,
              width: AppSize.s52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s18),
                color: AppColors.white,
                border: Border.all(
                  width: AppSize.s1,
                  color: AppColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F0F172A),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                    spreadRadius: -10,
                  ),
                  BoxShadow(
                    color: Color(0xB2E1E8F0),
                    blurRadius: 0,
                    offset: Offset(0, 0),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.notification,
                  width: AppSize.s22,
                  height: AppSize.s22,
                ),
              ),
            ),
          ],
        ),
        if (searchController.text.isNotEmpty && state.filteredStations.isNotEmpty)
          SearchStationsList(
            stations: state.filteredStations,
            query: searchController.text,
            onStationSelected: onStationSelected,
          ),
      ],
    );
  }
}
