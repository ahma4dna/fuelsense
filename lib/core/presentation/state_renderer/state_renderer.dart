import 'package:flutter/material.dart';
import 'package:fuelsense/core/presentation/state_renderer/state_renderer_type.dart';

import '../../application/resource/app_size.dart';
import '../../application/resource/app_styles.dart';

class StateRenderer extends StatelessWidget {
  const StateRenderer({
    super.key,
    required this.stateRendererType,
    required this.widgetLoading,
    required this.titleError,
    required this.onPressedRetry,
    this.titleEmpty,
  });

  final StateRendererType stateRendererType;
  final Widget widgetLoading;
  final String titleError;
  final String? titleEmpty;
  final void Function()? onPressedRetry;

  @override
  Widget build(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.loadingState:
        return widgetLoading;
      case StateRendererType.errorState:
        return defaultErrorWidget(
          title: titleError,
          context: context,
          onPressed: onPressedRetry,
        );
      case StateRendererType.emptyState:
        return defaultEmptyWidget(context: context);
      case StateRendererType.contentState:
        return SizedBox.shrink();
    }
  }

  Widget defaultErrorWidget({
    required String title,
    required BuildContext context,
    required void Function()? onPressed,
  }) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset(
          //   AppAssets.error,
          //   fit: BoxFit.cover,
          //   width: AppSize.s80,
          //   height: AppSize.s80,
          //   frameRate: FrameRate.max,
          // ),
          SizedBox(height: AppSize.s26),
          Text(
            title,
            style: AppStyles.getRgular(
              context: context,
              fontSize: AppSize.s28,
            ),
          ),
          SizedBox(height: AppSize.s30),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: Size(double.infinity, AppSize.s45),
          //     ),
          //     onPressed: onPressed,
          //     child: Text(
          //       AppContext.of(context).localText.retry,
          //       style: AppStyles.getRegularStyle(
          //         context: context,
          //         fontSize: AppSize.s20,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget defaultEmptyWidget({
    required BuildContext context,
  }) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset(
          //   AppContext.of(context).isDark ? AppAssets.emptyDark : AppAssets.emptyLight,
          //   fit: BoxFit.cover,
          //   width: AppSize.s150,
          //   height: AppSize.s150,
          //   frameRate: FrameRate.max,
          // ),
          SizedBox(height: AppSize.s26),
          // FittedBox(
          //   fit: BoxFit.cover,
          //   child: Text(
          //     titleEmpty??AppContext.of(context).localText.empty_list,
          //     style: AppStyles.getRegularStyle(
          //       context: context,
          //       fontSize: AppSize.s28,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
    );
  }
}
