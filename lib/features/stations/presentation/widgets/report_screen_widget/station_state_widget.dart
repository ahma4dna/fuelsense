import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/features/stations/domain/enums/station_statet.dart';
import 'package:gap/gap.dart';

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
