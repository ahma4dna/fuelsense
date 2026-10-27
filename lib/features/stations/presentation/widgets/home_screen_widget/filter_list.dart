import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_bloc.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_event.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_state.dart';
import 'package:fuelsense/features/stations/presentation/widgets/home_screen_widget/filter_widget.dart';

class FilterList extends StatelessWidget {
  final StationsState state;
  final FocusNode searchFocusNode;
  const new({
    super.key,
    required this.state,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: searchFocusNode.hasFocus ? 0 : 1,
      duration: Duration(milliseconds: 200),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...StationQuickFilter.values.map((filter) {
              final isSelected = state.activeQuickFilter == filter && state.selectedCityFilter == null;

              return FilterWidget(
                onTap: () {
                  context.read<StationsBloc>().add(
                    ChangeQuickFilterEvent(filter),
                  );
                },
                isSelected: isSelected,
                filter: filter,
              );
            }),
          ],
        ),
      ),
    );
  }
}
