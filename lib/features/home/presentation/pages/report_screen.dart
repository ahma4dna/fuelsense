import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/features/home/domain/enums/report_time_line.dart';
import 'package:fuelsense/features/home/domain/enums/station_statet.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_bloc.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_event.dart';
import 'package:fuelsense/features/home/presentation/bloc/report/report_state.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fuelsense/features/home/presentation/widgets/report_screen_widget/body/build_bottom_actions_report.dart';
import 'package:fuelsense/features/home/presentation/widgets/report_screen_widget/body/build_middle_content_report.dart';
import 'package:fuelsense/features/home/presentation/widgets/report_screen_widget/hedar_report_widget.dart';
import 'package:fuelsense/features/home/presentation/widgets/report_screen_widget/time_line_widget.dart';

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
                      child: BuildMiddleContentReport(
                        controller: _controller,
                        isFullScreen: isFullScreenCamera,
                        reportTimeLine: state.reportTimeLine,
                        appContext: appContext,
                        isCameraOpen: isCameraOpen,
                        selectedStateStation: selectedState,
                        capturedImage: capturedImage,
                        onTapSelectOpen: () {
                          setState(() {
                            selectedState = StationStateEnum.open;
                          });
                        },
                        onTapSelectClose: () {
                          setState(() {
                            selectedState = StationStateEnum.close;
                          });
                        },
                        onTapSelectUploading: () {
                          setState(() {
                            selectedState = StationStateEnum.unloading;
                          });
                        },
                      ),
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
                    child: BuildBottomActionsReport(
                      reportTimeLine: state.reportTimeLine,
                      isCameraOpen: isCameraOpen,
                      retakePhoto: retakePhoto,
                      takePhoto: takePhoto,
                      capturedImage: capturedImage,
                      contionToAi: () {
                        blocContext.read<ReportBloc>().add(
                          UpdateTimeLine(reportTimeLine: ReportTimeLine.ai),
                        );
                        _controller?.dispose();
                        _controller = null;
                      },
                      contionToCamera: () async {
                        blocContext.read<ReportBloc>().add(
                          UpdateTimeLine(reportTimeLine: ReportTimeLine.camera),
                        );
                        await openCamera();
                      },
                      contionToSendReport: () {
                        blocContext.read<ReportBloc>().add(
                          UpdateTimeLine(reportTimeLine: ReportTimeLine.sendReport),
                        );
                      },
                      contionToSuccess: () {
                        blocContext.read<ReportBloc>().add(
                          UpdateTimeLine(reportTimeLine: ReportTimeLine.success),
                        );
                      },
                      appContext: appContext,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
