import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/entities/field_report_entity.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/hint_today_report_widget.dart';
import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/report_widget.dart';

class ListReportToday extends StatelessWidget {
  const ListReportToday({
    super.key,
    required this.appContext,
    required this.reports,
  });

  final AppContext appContext;
  final List<FieldReportEntity> reports;

  @override
  Widget build(BuildContext context) {
    return reports.isEmpty
        ? Text(
            appContext.localText.history_this_station_not_avialeble,
            style: AppStyles.getBold(
              context: context,
              fontSize: AppSize.s17,
              color: Color(0xFF3F4E4C),
            ),
          )
        : Column(
            children: [
              HintTodayReportWidget(appContext: appContext),
              Expanded(
                child: ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppPadding.p10),
                      child: ReportWidget(
                        appContext: appContext,
                        report: reports[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
