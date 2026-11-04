import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_padding.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';

class TrafficThreeBarsIndicator extends StatelessWidget {
  final int severityLevel;

  const TrafficThreeBarsIndicator({
    super.key,
    required this.severityLevel,
  });

  Color _barColor(int index) {
    if (severityLevel == 1 && index == 0) {
      return const Color(0xFF16A34A);
    }
    if (severityLevel == 2 && index == 1) {
      return const Color(0xFFF59E0B);
    }
    if (severityLevel == 3 && index == 2) {
      return const Color(0xFFDC2626);
    }
    return const Color(0xFFF2D6D3);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: AppSize.s14,
          height: AppSize.s6,
          margin: EdgeInsetsDirectional.only(
            end: index < 2 ? AppPadding.p4 : AppSize.s0,
          ),
          decoration: BoxDecoration(
            color: _barColor(index),
            borderRadius: BorderRadius.circular(AppSize.s6),
          ),
        );
      }),
    );
  }
}
