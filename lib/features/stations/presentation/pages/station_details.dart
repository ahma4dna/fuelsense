// import 'package:flutter/material.dart';
// import 'package:fuelsense/core/application/resource/app_colors.dart';
// import 'package:fuelsense/core/application/resource/app_context.dart';
// import 'package:fuelsense/core/application/resource/app_padding.dart';
// import 'package:fuelsense/core/application/resource/app_size.dart';
// import 'package:fuelsense/core/application/resource/app_styles.dart';
// import 'package:fuelsense/features/stations/data/models/station_model.dart';
// import 'package:fuelsense/features/stations/presentation/routes/home_path.dart';
// import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/header_station_details.dart';
// import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/report_widget.dart';
// import 'package:fuelsense/features/stations/presentation/widgets/station_details_widget/station_details_widget.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';

// class StationDetails extends StatefulWidget {
//   final StationModel? stationModel;
//   const StationDetails({super.key, this.stationModel});

//   @override
//   State<StationDetails> createState() => _StationDetailsState();
// }

// class _StationDetailsState extends State<StationDetails> {
//   @override
//   Widget build(BuildContext context) {
//     final appContext = AppContext.of(context);
//     return Scaffold(
//       extendBody: true,
//       bottomSheet: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               width: 2,
//               color: AppColors.border,
//             ),
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(
//             top: AppPadding.p10,
//             left: AppPadding.p20,
//             right: AppPadding.p20,
//             bottom: MediaQuery.paddingOf(context).bottom + AppPadding.p20,
//           ),
//           child: SizedBox(
//             height: AppSize.s56,
//             child: Container(
//               height: AppSize.s56,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0xB20F172A),
//                     blurRadius: 24,
//                     offset: Offset(0, 10),
//                     spreadRadius: -10,
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.deepNavy,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                 ),
//                 onPressed: () {
//                   context.pushNamed(reportName);
//                 },
//                 child: Text(
//                   appContext.localText.confirm_station_state,
//                   style: AppStyles.getBold(
//                     context: context,
//                     color: Colors.white,
//                     fontSize: AppSize.s16,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: AppPadding.p20,
//             right: AppPadding.p20,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               HeaderStationDetails(appContext: appContext),
//               const Gap(AppSize.s12),
//               Flexible(
//                 child: StationDetailsWidget(
//                   stationModel: widget.stationModel,
//                   widget: widget,
//                   appContext: appContext,
//                 ),
//               ),
//               const Gap(AppSize.s26),
//               Text(
//                 appContext.localText.currnt_reports,
//                 maxLines: 2,
//                 overflow: TextOverflow.fade,
//                 style: AppStyles.getExtraBold(
//                   context: context,
//                   color: const Color(0xFF0F172A),
//                   fontSize: AppSize.s20,
//                 ),
//               ),

//               Expanded(
//                 child: ListView.builder(
//                   itemCount: 12,
//                   itemBuilder: (context, index) => ReportWidget(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
