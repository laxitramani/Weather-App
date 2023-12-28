import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/size_config.dart';

class AppTextStyle {
  static TextStyle normalText({
    double fontSize = 14,
    FontWeight? fontWeight,
    Color? color = AppColors.black,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize.setHeight(),
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }
}
