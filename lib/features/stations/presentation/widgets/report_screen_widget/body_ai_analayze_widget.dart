// import 'dart:io';

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

// class BodyAiAnalayzeWidget extends StatelessWidget {
//   const new({
//     super.key,
//     required this.capturedImage,
//     required this.aiAnalayzState,
//   });

//   final File? capturedImage;
//   final AiAnalayzState aiAnalayzState;
//   Widget getWidget(AiAnalayzState aiAnalayzState, BuildContext context, AppContext appContext) {
//     switch (aiAnalayzState) {
//       case AiAnalayzState.lading:
//         return Column(
//           key: ValueKey("lading_ai"),
//           children: [
//             Text(
//               appContext.localText.loading_ai,
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

//       case AiAnalayzState.success:
//         return Container(
//           key: ValueKey("success_ai"),
//           padding: const EdgeInsets.all(AppPadding.p16),
//           decoration: ShapeDecoration(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(22),
//             ),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     appContext.localText.qualtiy_analyze_ai,
//                     style: AppStyles.getExtraBold(
//                       context: context,
//                       fontSize: AppSize.s20,
//                       color: const Color(0xFF0F172A),
//                     ),
//                   ),
//                   Spacer(),
//                   Text(
//                     '100/',
//                     style: AppStyles.getBold(
//                       context: context,
//                       color: const Color(0xFF90A1B8),
//                       fontSize: AppSize.s14,
//                     ),
//                   ),
//                   Text(
//                     '89',
//                     style: AppStyles.getExtraBold(
//                       context: context,
//                       color: const Color(0xFF0F172A),
//                       fontSize: AppSize.s24,
//                     ),
//                   ),
//                 ],
//               ),
//               const Gap(AppSize.s12),
//               LinearProgressIndicator(
//                 color: AppColors.primary,
//                 backgroundColor: AppColors.lightBackground,
//                 minHeight: AppSize.s8,
//                 value: 0.89,
//               ),
//               const Gap(AppSize.s12),
//               Row(
//                 children: [
//                   Text(
//                     appContext.localText.detect_car,
//                     style: AppStyles.getExtraBold(
//                       context: context,
//                       color: const Color(0xFF0F172A),
//                       fontSize: AppSize.s18,
//                     ),
//                   ),
//                   const Gap(AppSize.s2),
//                   Text(
//                     "5",
//                     style: AppStyles.getExtraBold(
//                       context: context,
//                       color: const Color(0xFF0F172A),
//                       fontSize: AppSize.s20,
//                     ),
//                   ),
//                   const Gap(AppSize.s2),
//                   Text(
//                     appContext.localText.car,
//                     style: AppStyles.getExtraBold(
//                       context: context,
//                       color: const Color(0xFF0F172A),
//                       fontSize: AppSize.s18,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       case AiAnalayzState.error:
//         return Padding(
//           key: ValueKey("error_ai"),
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
//                   appContext.localText.error_chck_ai_image,
//                   style: AppStyles.getBold(
//                     context: context,
//                     color: const Color(0xFFB00020),
//                     fontSize: AppSize.s16,
//                   ),
//                 ),
//               ),
//               const Gap(AppSize.s20),
//               Text(
//                 appContext.localText.retry_chck_ai_image,
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
//     final AppContext appContext = AppContext.of(context);
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(AppSize.s22),
//             child: Image.file(
//               capturedImage!,
//               fit: BoxFit.cover,
//               width: AppSize.s374,
//               height: AppSize.s374,
//             ),
//           ),
//           const Gap(AppSize.s20),
//           AnimatedSwitcher(
//             duration: Duration(milliseconds: 400),
//             transitionBuilder: (child, animation) {
//               return ScaleTransition(
//                 scale: animation,
//                 child: FadeTransition(opacity: animation, child: child),
//               );
//             },
//             child: getWidget(aiAnalayzState, context, appContext),
//           ),
//           const Gap(AppSize.s20),
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
//                     appContext.localText.note_ai_analayze,
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
//         ],
//       ),
//     );
//   }
// }
