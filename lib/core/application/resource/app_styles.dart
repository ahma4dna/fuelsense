import 'package:flutter/material.dart';

import 'app_size.dart';

abstract class AppStyles {
  static TextStyle getLight({
    required BuildContext context,
    double? fontSize,
    Color? color,
  }) => TextStyle(
    color: color ?? Color(0xFF121820),
    fontSize: fontSize ?? AppSize.s14,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.w300,
  );
  static TextStyle getRgular({
    required BuildContext context,
    double? fontSize,
    Color? color,
  }) => TextStyle(
    color: color ?? Color(0xFF121820),
    fontSize: fontSize ?? AppSize.s14,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.w400,
  );
  static TextStyle getMeduim({
    required BuildContext context,
    double? fontSize,
    Color? color,
  }) => TextStyle(
    color: color ?? Color(0xFF121820),
    fontSize: fontSize ?? 14,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.w500,
  );

  static TextStyle getBold({
    required BuildContext context,
    double? fontSize,
    Color? color,
  }) => TextStyle(
    color: color ?? Color(0xFF121820),
    fontSize: fontSize ?? 36,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.w700,
  );
  static TextStyle getExtraBold({
    required BuildContext context,
    double? fontSize,
    Color? color,
  }) => TextStyle(
    color: color ?? Color(0xFF121820),
    fontSize: fontSize ?? 36,
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.w800,
  );
}

double getResponsiveSize({
  required BuildContext context,
  required double fontSize,
}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = scaleFactor * fontSize;
  double lowerLimit = fontSize * AppSize.s0_8;
  double upperLimit = fontSize * AppSize.s1;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  if (width < AppSizeConfig.tablet) {
    return width / AppSize.s550;
  } else if (width < AppSizeConfig.deskTop) {
    return width / AppSize.s1000;
  } else {
    return width / AppSize.s1920;
  }
}

class AppSizeConfig {
  static const double deskTop = AppSize.s1200;
  static const double tablet = AppSize.s800;

  //not use if project content web or desk top or change withe or height reel time
  static late double withe, height;

  static void init(BuildContext context) {
    withe = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
  }
}
