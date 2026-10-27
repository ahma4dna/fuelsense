// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fuelsense/core/application/resource/app_assets.dart';
// import 'package:fuelsense/core/application/resource/app_colors.dart';
// import 'package:fuelsense/core/application/resource/app_context.dart';
// import 'package:fuelsense/core/application/resource/app_padding.dart';
// import 'package:fuelsense/core/application/resource/app_size.dart';
// import 'package:fuelsense/core/application/resource/app_styles.dart';
// import 'package:fuelsense/features/stations/presentation/bloc/report/report_state.dart';
// import 'package:gap/gap.dart';

// class CheckLocationBody extends StatelessWidget {
//   final AppContext appContext;
//   final CheckLocationState checkLocationState;
//   const CheckLocationBody({
//     super.key,
//     required this.appContext,
//     required this.checkLocationState,
//   });
//   Widget getWidget(CheckLocationState checkLocationState, BuildContext context) {
//     switch (checkLocationState) {
//       case CheckLocationState.lading:
//         return Column(
//           key: ValueKey("loction_loading"),
//           children: [
//             Text(
//               appContext.localText.loading_loction,
//               style: AppStyles.getExtraBold(
//                 context: context,
//                 color: AppColors.deepNavy,
//                 fontSize: AppSize.s18,
//               ),
//             ),
//             const Gap(AppSize.s20),
//             SizedBox(
//               width: AppSize.s40,
//               height: AppSize.s40,
//               child: CircularProgressIndicator(
//                 color: AppColors.deepNavy,
//                 strokeWidth: AppSize.s8,
//               ),
//             ),
//           ],
//         );

//       case CheckLocationState.success:
//         return Padding(
//           key: ValueKey("loction_success"),
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppPadding.p20,
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppPadding.p16,
//                   vertical: AppPadding.p6,
//                 ),
//                 decoration: ShapeDecoration(
//                   color: const Color(0x1E10B881),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16777200),
//                   ),
//                 ),
//                 child: Text(
//                   appContext.localText.succecss_checkh_location,
//                   style: AppStyles.getBold(
//                     context: context,
//                     color: const Color(0xFF007955),
//                     fontSize: AppSize.s16,
//                   ),
//                 ),
//               ),
//               const Gap(AppSize.s20),
//               Text(
//                 appContext.localText.you_inside_range_station,
//                 style: AppStyles.getExtraBold(
//                   context: context,
//                   color: const Color(0xFF0F172A),
//                   fontSize: AppSize.s24,
//                 ),
//               ),
//               const Gap(AppSize.s20),
//               Text(
//                 appContext.localText.success_cheeck_location_subtitle,
//                 textAlign: TextAlign.center,

//                 style: AppStyles.getRgular(
//                   context: context,
//                   color: const Color(0xFF61738D),
//                   fontSize: AppSize.s16,
//                 ),
//               ),
//             ],
//           ),
//         );

//       case CheckLocationState.error:
//         return Padding(
//           key: ValueKey("loction_error"),
//           padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppPadding.p16,
//                   vertical: AppPadding.p6,
//                 ),
//                 decoration: ShapeDecoration(
//                   color: const Color(0x1EFF0000),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16777200),
//                   ),
//                 ),
//                 child: Text(
//                   appContext.localText.error_checkh_location,
//                   style: AppStyles.getBold(
//                     context: context,
//                     color: const Color(0xFFB00020),
//                     fontSize: AppSize.s16,
//                   ),
//                 ),
//               ),
//               const Gap(AppSize.s20),
//               Text(
//                 appContext.localText.plese_check_enable_location_and_nebrey_station,
//                 textAlign: TextAlign.center,
//                 style: AppStyles.getExtraBold(
//                   context: context,
//                   color: AppColors.deepNavy,
//                   fontSize: AppSize.s16,
//                 ),
//               ),

//               const Gap(AppSize.s20),
//               TextButton(
//                 style: TextButton.styleFrom(
//                   overlayColor: const Color(0x1EFF0000),
//                 ),
//                 onPressed: () {},
//                 child: Text(
//                   appContext.localText.retry,
//                   style: AppStyles.getExtraBold(
//                     context: context,
//                     color: Colors.red,
//                     fontSize: AppSize.s18,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SvgPicture.asset(
//             checkLocationState != CheckLocationState.error ? AppAssets.locationInsdeArea : AppAssets.locationOutArea,
//             width: AppSize.s280,
//             height: AppSize.s280,
//             fit: BoxFit.scaleDown,
//           ),
//           const Gap(AppSize.s20),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 400),
//             child: getWidget(checkLocationState, context),
//           ),
//         ],
//       ),
//     );
//   }
// }
