import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/domain/enums/station_statet.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_bloc.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_event.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_state.dart';
import 'package:fuelsense/features/home/presentation/bloc/station/station_state.dart';
import 'package:fuelsense/features/home/presentation/routes/home_path.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class StationDetails extends StatefulWidget {
  final StationModel? stationModel;
  const StationDetails({super.key, this.stationModel});

  @override
  State<StationDetails> createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {
  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);
    return Scaffold(
      extendBody: true,
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 2,
              color: AppColors.border,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: AppPadding.p10,
            left: AppPadding.p20,
            right: AppPadding.p20,
            bottom: MediaQuery.paddingOf(context).bottom + AppPadding.p20,
          ),
          child: SizedBox(
            height: AppSize.s56,
            child: Container(
              height: AppSize.s56,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xB20F172A),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepNavy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  context.pushNamed(reportName);
                },
                child: Text(
                  appContext.localText.confirm_station_state,
                  style: AppStyles.getBold(
                    context: context,
                    color: Colors.white,
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppPadding.p20,
            right: AppPadding.p20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderStationDetails(appContext: appContext),
              const Gap(AppSize.s12),
              Flexible(
                child: StationDetailsWidget(
                  stationModel: widget.stationModel,
                  widget: widget,
                  appContext: appContext,
                ),
              ),
              const Gap(AppSize.s26),
              Text(
                appContext.localText.currnt_reports,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: AppStyles.getExtraBold(
                  context: context,
                  color: const Color(0xFF0F172A),
                  fontSize: AppSize.s20,
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) => ReportWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportWidget extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p10,
      ),
      margin: EdgeInsets.only(
        bottom: AppPadding.p10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xB2E1E8F0),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(AppSize.s22),
        border: Border.all(
          width: 1,
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.deepNavy,
          ),
          const Gap(AppSize.s10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    "احمد الناجي",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: const Color(0xFF0F172A),
                      fontSize: AppSize.s20,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    "يوجد وقود",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: AppColors.primary,
                      fontSize: AppSize.s18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    height: AppSize.s45,
                    width: AppSize.s45,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      border: Border.all(width: 2, color: AppColors.border),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xB20F172A),
                          blurRadius: AppSize.s24,
                          offset: Offset(AppSize.s0, AppSize.s10),
                          spreadRadius: -AppSize.s10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.thumb_up,
                      size: AppSize.s26,
                    ),
                  ),
                ),

                Flexible(
                  child: Container(
                    height: AppSize.s45,
                    width: AppSize.s45,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      border: Border.all(width: 2, color: AppColors.border),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xB20F172A),
                          blurRadius: AppSize.s24,
                          offset: Offset(AppSize.s0, AppSize.s10),
                          spreadRadius: -AppSize.s10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.thumb_down,
                      size: AppSize.s26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StationDetailsWidget extends StatelessWidget {
  const StationDetailsWidget({
    super.key,
    required this.widget,
    required this.appContext,
    this.stationModel,
  });

  final StationDetails widget;
  final AppContext appContext;
  final StationModel? stationModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.s20),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xB2E1E8F0),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(AppSize.s22),
        border: Border.all(
          width: 1,
          color: AppColors.border,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.stationModel?.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: AppStyles.getExtraBold(
                    context: context,
                    color: const Color(0xFF0F172A),
                    fontSize: AppSize.s20,
                  ),
                ),
              ),
              const Gap(AppSize.s10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: ShapeDecoration(
                  color: widget.stationModel?.statusLabelColor.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: AppSize.s10,
                      height: AppSize.s10,
                      decoration: ShapeDecoration(
                        color: widget.stationModel?.statusLabelColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s100),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.stationModel?.statusLabel ?? "",
                      style: AppStyles.getBold(
                        color: widget.stationModel?.statusLabelColor,
                        fontSize: AppSize.s14,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(AppSize.s20),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      SizedBox(
                        width: AppSize.s132,
                        height: AppSize.s132,
                        child: CircularProgressIndicator(
                          strokeWidth: 14,
                          value: widget.stationModel?.currentProbability ?? 0,
                          color: widget.stationModel?.statusLabelColor,
                          backgroundColor: const Color(0XFFE2E7F1),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      SizedBox(
                        width: AppSize.s132,
                        height: AppSize.s132,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '100/',
                                      overflow: TextOverflow.fade,
                                      style: AppStyles.getBold(
                                        context: context,
                                        color: const Color(0xFF90A1B8),
                                        fontSize: AppSize.s18,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      ((widget.stationModel?.currentProbability ?? 0) * 100).toStringAsFixed(
                                        0,
                                      ),
                                      overflow: TextOverflow.fade,
                                      style: AppStyles.getExtraBold(
                                        context: context,
                                        color: const Color(0xFF0F172A),
                                        fontSize: AppSize.s38,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Flexible(
                              child: Text(
                                appContext.localText.confdance_prob,
                                overflow: TextOverflow.fade,
                                style: AppStyles.getMeduim(
                                  context: context,
                                  color: const Color(0xFF61738D),
                                  fontSize: AppSize.s12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSize.s20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Flexible(
                        child: Text(
                          widget.stationModel?.confidance ?? "",
                          style: AppStyles.getBold(
                            context: context,
                            color: const Color(0xFF0F172A),
                            fontSize: AppSize.s16,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'مبني على 12 بلاغاً موثقاً خلال آخر ساعتين.',

                          style: AppStyles.getRgular(
                            context: context,
                            color: const Color(0xFF61738D),
                            fontSize: AppSize.s13,
                          ),
                        ),
                      ),
                      const Gap(AppSize.s20),
                      Container(
                        height: AppSize.s48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFF0F172A),

                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xB20F172A),
                              blurRadius: AppSize.s24,
                              offset: Offset(AppSize.s0, AppSize.s10),
                              spreadRadius: -AppSize.s10,
                            ),
                          ],
                        ),
                        child: Material(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () async {
                              await LocationService.openMap(
                                latitude: stationModel?.latitude ?? 0,
                                longitude: stationModel?.longitude ?? 0,
                              );
                            },
                            splashColor: AppColors.white.withValues(alpha: 0.3),
                            highlightColor: AppColors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appContext.localText.location_trak,
                                    style: AppStyles.getBold(
                                      context: context,
                                      fontSize: AppSize.s16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const Gap(AppSize.s8),
                                  SvgPicture.asset(
                                    AppAssets.trackLocation,
                                    height: AppSize.s24,
                                    width: AppSize.s24,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderStationDetails extends StatelessWidget {
  const new({
    super.key,
    required this.appContext,
  });

  final AppContext appContext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s44,
          height: AppSize.s44,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: AppColors.border,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Center(
              child: SvgPicture.asset(
                AppAssets.back,
                width: AppSize.s22,
                height: AppSize.s22,
              ),
            ),
          ),
        ),
        const Gap(AppSize.s12),
        Text(
          appContext.localText.station_details,
          style: AppStyles.getBold(
            color: const Color(0xFF0F172A),
            fontSize: AppSize.s18,
            context: context,
          ),
        ),
      ],
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;

  bool isCameraOpen = false;
  File? capturedImage;
  StationStateEnum selectedState = StationStateEnum.open;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
  }

  Future<void> openCamera() async {
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          isCameraOpen = true;
        });
      }
    }
  }

  Future<void> takePhoto() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final XFile file = await _controller!.takePicture();
      setState(() {
        capturedImage = File(file.path);
        isCameraOpen = false;
      });
    }
  }

  void retakePhoto() {
    setState(() {
      capturedImage = null;
      isCameraOpen = true;
    });
  }

  void closeCamera() {
    setState(() {
      isCameraOpen = false;
      capturedImage = null;
    });
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);

    final bool isFullScreenCamera = isCameraOpen && capturedImage == null;

    return BlocProvider(
      create: (context) => getIt<ReportBloc>(),
      child: BlocBuilder<ReportBloc, ReportState>(
        builder: (blocContext, state) {
          return Scaffold(
            backgroundColor: isFullScreenCamera ? Colors.black : AppColors.lightBackground,
            body: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  top: isFullScreenCamera ? 0 : AppSize.s140,
                  bottom: isFullScreenCamera ? 0 : AppSize.s100,
                  left: isFullScreenCamera ? 0 : AppPadding.p20,
                  right: isFullScreenCamera ? 0 : AppPadding.p20,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                      return Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: <Widget>[
                          ...previousChildren,
                          ?currentChild,
                        ],
                      );
                    },
                    child: SizedBox.expand(
                      key: ValueKey(state.reportTimeLine.name),
                      child: _buildMiddleContent(appContext, isFullScreenCamera, state.reportTimeLine),
                    ),
                  ),
                ),
                if (!isFullScreenCamera && state.reportTimeLine != ReportTimeLine.success)
                  Positioned(
                    right: AppSize.s20,
                    left: AppSize.s20,
                    top: AppSize.s5,
                    child: SafeArea(
                      child: HedarReportWidget(
                        isOpenCamera: false,
                        appContext: appContext,
                        reportTimeLine: state.reportTimeLine,
                      ),
                    ),
                  ),
                if (state.reportTimeLine != ReportTimeLine.success)
                  Positioned(
                    right: AppSize.s20,
                    left: AppSize.s20,
                    top: AppSize.s40,
                    child: SafeArea(
                      child: TimeLineWidget(
                        reportTimeLine: state.reportTimeLine,
                        index: 2,
                      ),
                    ),
                  ),

                Positioned(
                  left: AppPadding.p20,
                  right: AppPadding.p20,
                  bottom: MediaQuery.paddingOf(context).bottom + AppPadding.p16,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: _buildBottomActions(appContext, state.reportTimeLine, blocContext),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiddleContent(AppContext appContext, bool isFullScreen, ReportTimeLine reportTimeLine) {
    if (isFullScreen &&
        _controller != null &&
        _controller!.value.isInitialized &&
        reportTimeLine == ReportTimeLine.camera) {
      return SizedBox(
        key: const ValueKey('camera_preview_full'),
        width: double.infinity,
        height: double.infinity,
        child: CameraPreview(_controller!),
      );
    } else if (capturedImage != null && reportTimeLine == ReportTimeLine.camera) {
      return ClipRRect(
        key: const ValueKey('captured_image_card'),
        borderRadius: BorderRadius.circular(AppSize.s22),
        child: Image.file(
          capturedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (reportTimeLine == ReportTimeLine.location) {
      return CheckLocationBody(
        key: const ValueKey("CheckLocationBody"),
        appContext: appContext,
        checkLocationState: CheckLocationState.success,
      );
    } else if (reportTimeLine == ReportTimeLine.ai && capturedImage != null) {
      return BodyAiAnalayzeWidget(
        aiAnalayzState: AiAnalayzState.success,
        key: const ValueKey('ai_analysis'),
        capturedImage: capturedImage,
      );
    } else if (reportTimeLine == ReportTimeLine.camera && isCameraOpen) {
      return const Center(
        key: ValueKey('camera_loading'),
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (reportTimeLine == ReportTimeLine.sendReport) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(AppSize.s20),

          Text(
            appContext.localText.please_selcte_state_station,
            style: AppStyles.getExtraBold(
              context: context,
              color: AppColors.black,
              fontSize: AppSize.s18,
            ),
          ),
          const Gap(AppSize.s10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedState = StationStateEnum.open;
                    });
                  },
                  child: StationStateWidget(
                    index: 0,
                    context: context,
                    isSelected: selectedState == StationStateEnum.open,
                    stateEnum: StationStateEnum.open,
                    appContext: appContext,
                  ),
                ),
              ),

              const SizedBox(width: AppSize.s10),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedState = StationStateEnum.close;
                    });
                  },
                  child: StationStateWidget(
                    index: 1,
                    context: context,
                    isSelected: selectedState == StationStateEnum.close,
                    stateEnum: StationStateEnum.close,
                    appContext: appContext,
                  ),
                ),
              ),

              const SizedBox(width: AppSize.s10),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedState = StationStateEnum.unloading;
                    });
                  },
                  child: StationStateWidget(
                    index: 2,
                    context: context,
                    isSelected: selectedState == StationStateEnum.unloading,
                    stateEnum: StationStateEnum.unloading,
                    appContext: appContext,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
              vertical: AppPadding.p16,
            ),
            decoration: ShapeDecoration(
              color: const Color(0x99CCFBF1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppAssets.note,
                  height: AppSize.s20,
                  width: AppSize.s20,
                ),
                const Gap(AppSize.s12),
                Expanded(
                  child: Text(
                    appContext.localText.send_report_note,
                    maxLines: 2,

                    style: AppStyles.getRgular(
                      context: context,
                      color: const Color(0xFF0F766E),
                      fontSize: AppSize.s14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s30),
        ],
      );
    } else {
      return Column(
        children: [
          const Gap(AppSize.s60),
          SvgPicture.asset(
            AppAssets.successSendReport,
            width: AppSize.s120,
            height: AppSize.s120,
            fit: BoxFit.scaleDown,
          ),
          const Gap(AppSize.s24),
          Text(
            appContext.localText.done_send_report,
            style: AppStyles.getExtraBold(
              context: context,
              color: const Color(0xFF0F172A),
              fontSize: AppSize.s24,
            ),
          ),
          const Gap(AppSize.s12),
          Text(
            appContext.localText.thank_you,
            style: AppStyles.getExtraBold(
              context: context,
              color: const Color(0xFF0F172A),
              fontSize: AppSize.s24,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildBottomActions(AppContext appContext, ReportTimeLine reportTimeLine, BuildContext blocContext) {
    if (capturedImage != null && reportTimeLine == ReportTimeLine.camera) {
      return Row(
        key: const ValueKey('action_buttons'),
        children: [
          Expanded(
            child: Container(
              height: AppSize.s56,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Color(0xB20F172A), blurRadius: 24, offset: Offset(0, 10), spreadRadius: -10),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: retakePhoto,
                child: Text(
                  "إعادة الالتقاط",
                  style: AppStyles.getBold(
                    context: context,
                    color: AppColors.deepNavy,
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
            ),
          ),
          const Gap(AppSize.s16),
          Expanded(
            child: Container(
              height: AppSize.s56,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xB20F172A),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepNavy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  blocContext.read<ReportBloc>().add(
                    UpdateTimeLine(reportTimeLine: ReportTimeLine.ai),
                  );
                  _controller?.dispose();
                  _controller = null;
                },
                child: Text(
                  "متابعة",
                  style: AppStyles.getBold(
                    context: context,
                    color: Colors.white,
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (isCameraOpen && reportTimeLine == ReportTimeLine.camera) {
      return Center(
        key: const ValueKey('capture_button'),
        child: GestureDetector(
          onTap: takePhoto,
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (reportTimeLine == ReportTimeLine.location) {
      return ContianCheckBotton(
        key: const ValueKey('start_camera_button'),
        title: appContext.localText.contion_check,
        onPressed: () async {
          blocContext.read<ReportBloc>().add(
            UpdateTimeLine(reportTimeLine: ReportTimeLine.camera),
          );
          await openCamera();
        },
      );
    } else if (reportTimeLine == ReportTimeLine.ai) {
      return ContianCheckBotton(
        key: const ValueKey('start_camera_button_ai'),
        title: appContext.localText.contion,
        onPressed: () {
          blocContext.read<ReportBloc>().add(
            UpdateTimeLine(reportTimeLine: ReportTimeLine.sendReport),
          );
        },
      );
    } else if (reportTimeLine == ReportTimeLine.sendReport) {
      return SendReportBotton(
        key: ValueKey("SendReportBotton"),
        onPressed: () {
          blocContext.read<ReportBloc>().add(
            UpdateTimeLine(reportTimeLine: ReportTimeLine.success),
          );
        },
        appContext: appContext,
      );
    } else {
      return ContianCheckBotton(
        key: const ValueKey('start_camera_button_success'),
        title: appContext.localText.contion,
        onPressed: () {
          context.pop();
        },
      );
    }
  }
}

class StationStateWidget extends StatefulWidget {
  const StationStateWidget({
    super.key,
    required this.context,
    required this.isSelected,
    required this.stateEnum,
    required this.appContext,
    required this.index,
  });

  final BuildContext context;
  final AppContext appContext;
  final StationStateEnum stateEnum;
  final bool isSelected;
  final int index;

  @override
  State<StationStateWidget> createState() => _StationStateWidgetState();
}

class _StationStateWidgetState extends State<StationStateWidget> {
  final List<Color> colors = [
    const Color(0xFF10B981),
    const Color(0xFFEF4444),
    const Color(0xFFF97316),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      widget.appContext.localText.open,
      widget.appContext.localText.close,
      widget.appContext.localText.unloading,
    ];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          width: double.infinity,
          height: AppSize.s100,
          duration: Duration(milliseconds: 400),

          decoration: ShapeDecoration(
            color: widget.isSelected ? const Color(0xFFE8FAF7) : Colors.white,
            shape: RoundedRectangleBorder(
              side: widget.isSelected
                  ? BorderSide(
                      width: 2,
                      color: const Color(0xFF00BFA6),
                    )
                  : BorderSide(
                      width: 2,
                      color: const Color(0xFFE1E8F0),
                    ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: AppSize.s16,
                height: AppSize.s16,
                decoration: ShapeDecoration(
                  color: colors[widget.index],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
              ),
              const Gap(AppSize.s10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 400),
                  maxLines: 1,
                  style: widget.isSelected
                      ? AppStyles.getBold(
                          context: context,
                          color: const Color(0xFF0F172A),
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getBold(
                          context: context,
                          color: const Color(0xFF61738D),
                          fontSize: AppSize.s14,
                        ),
                  child: Text(
                    titles[widget.index],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.isSelected)
          Positioned(
            top: -AppSize.s8,
            left: AppSize.s10,
            child: SvgPicture.asset(
              AppAssets.selected,
              height: AppSize.s24,
              width: AppSize.s24,
            ),
          ),
      ],
    );
  }
}

class BodyAiAnalayzeWidget extends StatelessWidget {
  const new({
    super.key,
    required this.capturedImage,
    required this.aiAnalayzState,
  });

  final File? capturedImage;
  final AiAnalayzState aiAnalayzState;
  Widget getWidget(AiAnalayzState aiAnalayzState, BuildContext context, AppContext appContext) {
    switch (aiAnalayzState) {
      case AiAnalayzState.lading:
        return Column(
          key: ValueKey("lading_ai"),
          children: [
            Text(
              appContext.localText.loading_ai,
              style: AppStyles.getExtraBold(
                context: context,
                color: AppColors.deepNavy,
                fontSize: AppSize.s18,
              ),
            ),
            const Gap(AppSize.s20),
            SizedBox(
              width: AppSize.s40,
              height: AppSize.s40,
              child: CircularProgressIndicator(
                color: AppColors.deepNavy,
                strokeWidth: AppSize.s8,
              ),
            ),
          ],
        );

      case AiAnalayzState.success:
        return Container(
          key: ValueKey("success_ai"),
          padding: const EdgeInsets.all(AppPadding.p16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    appContext.localText.qualtiy_analyze_ai,
                    style: AppStyles.getExtraBold(
                      context: context,
                      fontSize: AppSize.s20,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '100/',
                    style: AppStyles.getBold(
                      context: context,
                      color: const Color(0xFF90A1B8),
                      fontSize: AppSize.s14,
                    ),
                  ),
                  Text(
                    '89',
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: const Color(0xFF0F172A),
                      fontSize: AppSize.s24,
                    ),
                  ),
                ],
              ),
              const Gap(AppSize.s12),
              LinearProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.lightBackground,
                minHeight: AppSize.s8,
                value: 0.89,
              ),
              const Gap(AppSize.s12),
              Row(
                children: [
                  Text(
                    appContext.localText.detect_car,
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: const Color(0xFF0F172A),
                      fontSize: AppSize.s18,
                    ),
                  ),
                  const Gap(AppSize.s2),
                  Text(
                    "5",
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: const Color(0xFF0F172A),
                      fontSize: AppSize.s20,
                    ),
                  ),
                  const Gap(AppSize.s2),
                  Text(
                    appContext.localText.car,
                    style: AppStyles.getExtraBold(
                      context: context,
                      color: const Color(0xFF0F172A),
                      fontSize: AppSize.s18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case AiAnalayzState.error:
        return Padding(
          key: ValueKey("error_ai"),
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16,
                  vertical: AppPadding.p6,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0x1EFF0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                child: Text(
                  appContext.localText.error_chck_ai_image,
                  style: AppStyles.getBold(
                    context: context,
                    color: const Color(0xFFB00020),
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
              const Gap(AppSize.s20),
              Text(
                appContext.localText.retry_chck_ai_image,
                textAlign: TextAlign.center,
                style: AppStyles.getExtraBold(
                  context: context,
                  color: AppColors.deepNavy,
                  fontSize: AppSize.s16,
                ),
              ),

              const Gap(AppSize.s20),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: const Color(0x1EFF0000),
                ),
                onPressed: () {},
                child: Text(
                  appContext.localText.retry,
                  style: AppStyles.getExtraBold(
                    context: context,
                    color: Colors.red,
                    fontSize: AppSize.s18,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s22),
            child: Image.file(
              capturedImage!,
              fit: BoxFit.cover,
              width: AppSize.s374,
              height: AppSize.s374,
            ),
          ),
          const Gap(AppSize.s20),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: getWidget(aiAnalayzState, context, appContext),
          ),
          const Gap(AppSize.s20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
              vertical: AppPadding.p16,
            ),
            decoration: ShapeDecoration(
              color: const Color(0x99CCFBF1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppAssets.note,
                  height: AppSize.s20,
                  width: AppSize.s20,
                ),
                const Gap(AppSize.s12),
                Expanded(
                  child: Text(
                    appContext.localText.note_ai_analayze,
                    maxLines: 2,

                    style: AppStyles.getRgular(
                      context: context,
                      color: const Color(0xFF0F766E),
                      fontSize: AppSize.s14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SendReportBotton extends StatelessWidget {
  const new({
    super.key,
    required this.onPressed,
    required this.appContext,
  });

  final void Function() onPressed;
  final AppContext appContext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s56,
      child: Container(
        height: AppSize.s56,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xCC00BFA6),
              blurRadius: 24,
              offset: Offset(0, 10),
              spreadRadius: -10,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BFA6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            appContext.localText.send_report,
            style: AppStyles.getBold(
              context: context,
              color: const Color(0xFF0F172A),
              fontSize: AppSize.s16,
            ),
          ),
        ),
      ),
    );
  }
}

class ContianCheckBotton extends StatelessWidget {
  const ContianCheckBotton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s56,
      child: Container(
        height: AppSize.s56,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xB20F172A),
              blurRadius: 24,
              offset: Offset(0, 10),
              spreadRadius: -10,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepNavy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: AppStyles.getBold(
              context: context,
              color: Colors.white,
              fontSize: AppSize.s16,
            ),
          ),
        ),
      ),
    );
  }
}

class CheckLocationBody extends StatelessWidget {
  final AppContext appContext;
  final CheckLocationState checkLocationState;
  const CheckLocationBody({
    super.key,
    required this.appContext,
    required this.checkLocationState,
  });
  Widget getWidget(CheckLocationState checkLocationState, BuildContext context) {
    switch (checkLocationState) {
      case CheckLocationState.lading:
        return Column(
          key: ValueKey("loction_loading"),
          children: [
            Text(
              appContext.localText.loading_loction,
              style: AppStyles.getExtraBold(
                context: context,
                color: AppColors.deepNavy,
                fontSize: AppSize.s18,
              ),
            ),
            const Gap(AppSize.s20),
            SizedBox(
              width: AppSize.s40,
              height: AppSize.s40,
              child: CircularProgressIndicator(
                color: AppColors.deepNavy,
                strokeWidth: AppSize.s8,
              ),
            ),
          ],
        );

      case CheckLocationState.success:
        return Padding(
          key: ValueKey("loction_success"),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16,
                  vertical: AppPadding.p6,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0x1E10B881),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                child: Text(
                  appContext.localText.succecss_checkh_location,
                  style: AppStyles.getBold(
                    context: context,
                    color: const Color(0xFF007955),
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
              const Gap(AppSize.s20),
              Text(
                appContext.localText.you_inside_range_station,
                style: AppStyles.getExtraBold(
                  context: context,
                  color: const Color(0xFF0F172A),
                  fontSize: AppSize.s24,
                ),
              ),
              const Gap(AppSize.s20),
              Text(
                appContext.localText.success_cheeck_location_subtitle,
                textAlign: TextAlign.center,

                style: AppStyles.getRgular(
                  context: context,
                  color: const Color(0xFF61738D),
                  fontSize: AppSize.s16,
                ),
              ),
            ],
          ),
        );

      case CheckLocationState.error:
        return Padding(
          key: ValueKey("loction_error"),
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16,
                  vertical: AppPadding.p6,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0x1EFF0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                child: Text(
                  appContext.localText.error_checkh_location,
                  style: AppStyles.getBold(
                    context: context,
                    color: const Color(0xFFB00020),
                    fontSize: AppSize.s16,
                  ),
                ),
              ),
              const Gap(AppSize.s20),
              Text(
                appContext.localText.plese_check_enable_location_and_nebrey_station,
                textAlign: TextAlign.center,
                style: AppStyles.getExtraBold(
                  context: context,
                  color: AppColors.deepNavy,
                  fontSize: AppSize.s16,
                ),
              ),

              const Gap(AppSize.s20),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: const Color(0x1EFF0000),
                ),
                onPressed: () {},
                child: Text(
                  appContext.localText.retry,
                  style: AppStyles.getExtraBold(
                    context: context,
                    color: Colors.red,
                    fontSize: AppSize.s18,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SvgPicture.asset(
            checkLocationState != CheckLocationState.error ? AppAssets.locationInsdeArea : AppAssets.locationOutArea,
            width: AppSize.s280,
            height: AppSize.s280,
            fit: BoxFit.scaleDown,
          ),
          const Gap(AppSize.s20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: getWidget(checkLocationState, context),
          ),
        ],
      ),
    );
  }
}

class HedarReportWidget extends StatelessWidget {
  const HedarReportWidget({
    super.key,
    required this.appContext,
    required this.reportTimeLine,
    required this.isOpenCamera,
  });

  final AppContext appContext;
  final ReportTimeLine reportTimeLine;
  final bool isOpenCamera;

  String getTitle(ReportTimeLine reportTimeLine, AppContext appContex) {
    switch (reportTimeLine) {
      case ReportTimeLine.location:
        return appContex.localText.check_location;
      case ReportTimeLine.camera:
        return appContex.localText.camera_shot;
      case ReportTimeLine.ai:
        return appContex.localText.shot_ai;
      case ReportTimeLine.sendReport:
        return appContex.localText.send_report;
      case ReportTimeLine.success:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s44,
          height: AppSize.s44,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: AppColors.border,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Center(
              child: SvgPicture.asset(
                AppAssets.back,
                width: AppSize.s22,
                height: AppSize.s22,
              ),
            ),
          ),
        ),
        const Gap(AppSize.s12),
        AnimatedDefaultTextStyle(
          style: AppStyles.getBold(
            color: isOpenCamera ? AppColors.white : const Color(0xFF0F172A),
            fontSize: AppSize.s18,
            context: context,
          ),
          duration: Duration(milliseconds: 300),
          child: Text(
            getTitle(reportTimeLine, appContext),
          ),
        ),
      ],
    );
  }
}

class TimeLineWidget extends StatelessWidget {
  final ReportTimeLine reportTimeLine;
  final int index;

  const TimeLineWidget({
    super.key,
    required this.reportTimeLine,
    required this.index,
  });

  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA6),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.location
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text("الموقع"),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s6),
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: reportTimeLine.index >= ReportTimeLine.camera.index
                        ? const Color(0xFF00BFA6)
                        : const Color(0xFFE1E8F0),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.camera
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text("الكاميرا"),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s6),
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: reportTimeLine.index >= ReportTimeLine.ai.index
                        ? const Color(0xFF00BFA6)
                        : const Color(0xFFE1E8F0),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.ai
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text('تحليل AI'),
                ),
              ],
            ),
          ),
          const Gap(AppSize.s6),
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                    color: reportTimeLine.index >= ReportTimeLine.sendReport.index
                        ? const Color(0xFF00BFA6)
                        : const Color(0xFFE1E8F0),
                    borderRadius: BorderRadius.circular(16777200),
                  ),
                ),
                const Gap(AppSize.s6),
                AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: reportTimeLine == ReportTimeLine.sendReport
                      ? AppStyles.getBold(
                          context: context,
                          color: AppColors.black,
                          fontSize: AppSize.s14,
                        )
                      : AppStyles.getMeduim(
                          context: context,
                          color: const Color(0xFF90A1B8),
                          fontSize: AppSize.s14,
                        ),
                  child: const Text('البلاغ'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ReportTimeLine {
  location,
  camera,
  ai,
  sendReport,
  success,
}
