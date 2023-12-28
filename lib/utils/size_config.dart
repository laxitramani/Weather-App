import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
  }
}

extension DynamicSize on num {
// Get the proportionate height as per screen size
  double setHeight() {
    return (this / 844) * SizeConfig.screenHeight;
  }

// Get the proportionate height as per screen size
  double setWidth() {
    return (this / 390) * SizeConfig.screenWidth;
  }
}

Widget sizeBoxHeight(double value) {
  return SizedBox(height: value.setHeight());
}

Widget sizeBoxWidth(double value) {
  return SizedBox(width: value.setWidth());
}
