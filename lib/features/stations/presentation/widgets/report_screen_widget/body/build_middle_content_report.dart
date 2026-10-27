// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fuelsense/core/application/resource/app_assets.dart';
// import 'package:fuelsense/core/application/resource/app_colors.dart';
// import 'package:fuelsense/core/application/resource/app_context.dart';
// import 'package:fuelsense/core/application/resource/app_padding.dart';
// import 'package:fuelsense/core/application/resource/app_size.dart';
// import 'package:fuelsense/core/application/resource/app_styles.dart';
// import 'package:fuelsense/features/stations/domain/enums/report_time_line.dart';
// import 'package:fuelsense/features/stations/domain/enums/station_statet.dart';
// import 'package:fuelsense/features/stations/presentation/bloc/report/report_state.dart';
// import 'package:fuelsense/features/stations/presentation/widgets/report_screen_widget/body_ai_analayze_widget.dart';
// import 'package:fuelsense/features/stations/presentation/widgets/report_screen_widget/check_location_body.dart';
// import 'package:fuelsense/features/stations/presentation/widgets/report_screen_widget/station_state_widget.dart';
// import 'package:gap/gap.dart';

// class BuildMiddleContentReport extends StatelessWidget {
//   const BuildMiddleContentReport({
//     super.key,
//     required this.isFullScreen,
//     required this.reportTimeLine,
//     this.controller,
//     this.capturedImage,
//     required this.appContext,
//     required this.isCameraOpen,
//     this.onTapSelectOpen,
//     this.onTapSelectUploading,
//     this.onTapSelectClose,
//     required this.selectedStateStation,
//   });
//   final bool isFullScreen;
//   final ReportTimeLine reportTimeLine;
//   final CameraController? controller;
//   final File? capturedImage;
//   final AppContext appContext;
//   final bool isCameraOpen;
//   final void Function()? onTapSelectOpen;
//   final void Function()? onTapSelectUploading;
//   final void Function()? onTapSelectClose;
//   final StationStateEnum selectedStateStation;

//   @override
//   Widget build(BuildContext context) {
//     if (isFullScreen &&
//         controller != null &&
//         controller!.value.isInitialized &&
//         reportTimeLine == ReportTimeLine.camera) {
//       return SizedBox(
//         key: const ValueKey('camera_preview_full'),
//         width: double.infinity,
//         height: double.infinity,
//         child: CameraPreview(controller!),
//       );
//     } else if (capturedImage != null && reportTimeLine == ReportTimeLine.camera) {
//       return ClipRRect(
//         key: const ValueKey('captured_image_card'),
//         borderRadius: BorderRadius.circular(AppSize.s22),
//         child: Image.file(
//           capturedImage!,
//           fit: BoxFit.cover,
//           width: double.infinity,
//           height: double.infinity,
//         ),
//       );
//     } else if (reportTimeLine == ReportTimeLine.location) {
//       return CheckLocationBody(
//         key: const ValueKey("CheckLocationBody"),
//         appContext: appContext,
//         checkLocationState: CheckLocationState.success,
//       );
//     } else if (reportTimeLine == ReportTimeLine.ai && capturedImage != null) {
//       return BodyAiAnalayzeWidget(
//         aiAnalayzState: AiAnalayzState.success,
//         key: const ValueKey('ai_analysis'),
//         capturedImage: capturedImage,
//       );
//     } else if (reportTimeLine == ReportTimeLine.camera && isCameraOpen) {
//       return const Center(
//         key: ValueKey('camera_loading'),
//         child: CircularProgressIndicator(color: AppColors.primary),
//       );
//     } else if (reportTimeLine == ReportTimeLine.sendReport) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Gap(AppSize.s20),

//           Text(
//             appContext.localText.please_selcte_state_station,
//             style: AppStyles.getExtraBold(
//               context: context,
//               color: AppColors.black,
//               fontSize: AppSize.s18,
//             ),
//           ),
//           const Gap(AppSize.s10),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: onTapSelectOpen,
//                   child: StationStateWidget(
//                     index: 0,
//                     context: context,
//                     isSelected: selectedStateStation == StationStateEnum.open,
//                     stateEnum: StationStateEnum.open,
//                     appContext: appContext,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: AppSize.s10),

//               Expanded(
//                 child: GestureDetector(
//                   onTap: onTapSelectClose,
//                   child: StationStateWidget(
//                     index: 1,
//                     context: context,
//                     isSelected: selectedStateStation == StationStateEnum.close,
//                     stateEnum: StationStateEnum.close,
//                     appContext: appContext,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: AppSize.s10),

//               Expanded(
//                 child: GestureDetector(
//                   onTap: onTapSelectUploading,
//                   child: StationStateWidget(
//                     index: 2,
//                     context: context,
//                     isSelected: selectedStateStation == StationStateEnum.unloading,
//                     stateEnum: StationStateEnum.unloading,
//                     appContext: appContext,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),

//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppPadding.p12,
//               vertical: AppPadding.p16,
//             ),
//             decoration: ShapeDecoration(
//               color: const Color(0x99CCFBF1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(18),
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SvgPicture.asset(
//                   AppAssets.note,
//                   height: AppSize.s20,
//                   width: AppSize.s20,
//                 ),
//                 const Gap(AppSize.s12),
//                 Expanded(
//                   child: Text(
//                     appContext.localText.send_report_note,
//                     maxLines: 2,

//                     style: AppStyles.getRgular(
//                       context: context,
//                       color: const Color(0xFF0F766E),
//                       fontSize: AppSize.s14,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Gap(AppSize.s30),
//         ],
//       );
//     } else {
//       return Column(
//         children: [
//           const Gap(AppSize.s60),
//           SvgPicture.asset(
//             AppAssets.successSendReport,
//             width: AppSize.s120,
//             height: AppSize.s120,
//             fit: BoxFit.scaleDown,
//           ),
//           const Gap(AppSize.s24),
//           Text(
//             appContext.localText.done_send_report,
//             style: AppStyles.getExtraBold(
//               context: context,
//               color: const Color(0xFF0F172A),
//               fontSize: AppSize.s24,
//             ),
//           ),
//           const Gap(AppSize.s12),
//           Text(
//             appContext.localText.thank_you,
//             style: AppStyles.getExtraBold(
//               context: context,
//               color: const Color(0xFF0F172A),
//               fontSize: AppSize.s24,
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }
