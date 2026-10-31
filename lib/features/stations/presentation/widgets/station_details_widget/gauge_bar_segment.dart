import 'package:flutter/material.dart';

class GaugeBarSegment extends StatelessWidget {
  final Color barColor;
  final Color thumbBorderColor;
  final bool isActive;

  const GaugeBarSegment({
    super.key,
    required this.barColor,
    required this.thumbBorderColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          if (isActive)
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: thumbBorderColor,
                  width: 3.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
