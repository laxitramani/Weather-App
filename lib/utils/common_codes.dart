import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/utils/assets.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/size_config.dart';
import 'package:weather_app/utils/text_style.dart';

Widget label(
  String label, {
  TextStyle? style,
  TextAlign? textAlign,
}) {
  return Text(
    label,
    textAlign: textAlign,
    style: style,
  );
}

Widget assetImage(
  String img, {
  double? height,
  double? width,
}) {
  return Image.asset(
    img,
    height: height,
    width: width,
  );
}

Widget icon(IconData icon, {Color? color, double? size}) {
  return Icon(
    icon,
    size: size,
    color: color ?? AppColors.white,
  );
}

class SimpleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? hintText;
  final String? prefixImage;
  final Widget? prefixIcon;
  final bool? isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool? readOnly;
  final void Function()? onCompleted;
  final void Function(String)? onChanged;
  final Color? fillColor;

  const SimpleTextField({
    this.controller,
    this.fillColor,
    this.focusNode,
    this.hintText,
    this.inputFormatters,
    this.keyboardType,
    this.isPassword,
    this.onChanged,
    this.onCompleted,
    this.prefixIcon,
    this.prefixImage,
    this.readOnly,
    this.suffixIcon,
    this.validator,
    super.key,
  });

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  bool obsecureText = false;

  @override
  void initState() {
    obsecureText = widget.isPassword ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      onEditingComplete: widget.onCompleted,
      readOnly: widget.readOnly ?? false,
      obscureText: obsecureText,
      onChanged: widget.onChanged,
      style: AppTextStyle.normalText(fontSize: 16),
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.setHeight(),
          horizontal: 20.setWidth(),
        ),
        prefixIcon: widget.prefixImage != null
            ? IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sizeBoxWidth(20),
                    assetImage(
                      widget.prefixImage!,
                      height: 20.setHeight(),
                      width: 20.setHeight(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.setHeight(),
                        vertical: 10.setHeight(),
                      ),
                      child: const VerticalDivider(),
                    ),
                  ],
                ),
              )
            : widget.prefixIcon,
        suffixIcon: widget.isPassword == true
            ? InkWell(
                onTap: () => setState(() {
                  obsecureText = !obsecureText;
                }),
                child: SizedBox(
                  height: 20.setHeight(),
                  width: 20.setHeight(),
                  child: Center(
                    child: assetImage(
                      obsecureText ? AppAssets.eyeOpen : AppAssets.eyeClose,
                      height: 20.setHeight(),
                      width: 20.setHeight(),
                    ),
                  ),
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}

LinearGradient linearGradient() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryColor, AppColors.tertiaryColor],
  );
}

Widget gradientMaterialButton({
  String? title,
  String? suffixImg,
  String? prefixImg,
  double height = 48,
  double prefixImgHeight = 15,
  bool useSpacer = false,
  double? width,
  FontWeight fontWeight = FontWeight.bold,
  EdgeInsetsGeometry? padding,
  void Function()? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: height.setHeight(),
      width: width != null
          ? width == height
              ? width.setHeight()
              : width.setWidth()
          : double.infinity,
      decoration: BoxDecoration(
        gradient: linearGradient(),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixImg != null) ...[
            assetImage(
              prefixImg,
              height: prefixImgHeight.setHeight(),
            ),
            if (title != null) sizeBoxWidth(10)
          ],
          if (title != null)
            label(
              title,
              style: AppTextStyle.normalText(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: fontWeight,
              ),
            ),
          if (suffixImg != null) ...[
            useSpacer ? const Spacer() : sizeBoxWidth(10),
            assetImage(
              suffixImg,
              height: 15.setHeight(),
            ),
          ],
        ],
      ),
    ),
  );
}

List<Widget> textFormFieldLabel({
  required String title,
  double titleFontSize = 14,
  String? titleSuffix,
  bool isOptional = true,
  TextEditingController? controller,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  Widget? suffixIcon,
  Widget? child,
  List<Widget>? children,
  String? hintText,
  String? prefixImage,
  Widget? prefixIcon,
  bool isPassword = false,
  Color? fillColor,
  List<TextInputFormatter>? inputFormatters,
  bool readOnly = false,
  void Function(String)? onChanged,
  void Function()? titleSuffixOnTap,
}) {
  return [
    Row(
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: AppTextStyle.normalText(fontSize: titleFontSize),
            children: [
              if (!isOptional)
                TextSpan(
                  text: "*",
                  style: AppTextStyle.normalText(color: AppColors.red),
                ),
            ],
          ),
        ),
        if (titleSuffix != null) ...[
          const Spacer(),
          textButton(
            onPressed: titleSuffixOnTap,
            title: titleSuffix,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ]
      ],
    ),
    sizeBoxHeight(10),
    if (children != null)
      ...children
    else
      child ??
          SimpleTextField(
            controller: controller,
            hintText: hintText,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            isPassword: isPassword,
            onChanged: onChanged,
            prefixIcon: prefixIcon,
            prefixImage: prefixImage,
            readOnly: readOnly,
            suffixIcon: suffixIcon,
            validator: validator,
            fillColor: fillColor,
          ),
  ];
}

Widget textButton({
  required void Function()? onPressed,
  required String title,
  String? icon,
  double height = 15,
  double fontSize = 16,
  ButtonStyle? style,
  FontWeight? fontWeight,
  Color? color,
  Color? iconColor,
}) {
  return TextButton(
    onPressed: onPressed,
    style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    child: label(
      title,
      style: AppTextStyle.normalText(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    ),
  );
}

Widget materialButton({
  double size = 35,
  double? height,
  Function()? onTap,
  Color? color,
  Color? borderColor,
  double? width,
  double radius = 7,
  BorderRadiusGeometry? borderRadius,
  Widget? child,
}) {
  return MaterialButton(
    onPressed: onTap ?? () {},
    color: color,
    padding: EdgeInsets.zero,
    elevation: 0,
    height: height ?? size.setHeight(),
    minWidth: width ?? size.setHeight(),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      side: borderColor != null
          ? BorderSide(color: borderColor)
          : BorderSide.none,
    ),
    child: child,
  );
}

snackBar(
  String message, {
  int durationSec = 3,
}) {
  return snackbarKey.currentState!.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: 16.setHeight(),
        vertical: 20.setWidth(),
      ),
      padding: EdgeInsets.zero,
      duration: Duration(seconds: durationSec),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      content: Padding(
        padding: EdgeInsets.all(10.setHeight()),
        child: label(message),
      ),
    ),
  );
}

Widget scaffoldLoader({
  required Widget body,
  bool? showLoader,
  Widget? drawer,
  PreferredSizeWidget? appBar,
  Color? backgroundColor,
  Key? key,
}) {
  return PopScope(
    canPop: showLoader != null ? !showLoader : true,
    child: Stack(
      children: [
        Scaffold(
          key: key,
          appBar: appBar,
          drawer: drawer,
          backgroundColor: backgroundColor,
          body: body,
        ),
        if (showLoader != null) showLoader ? process() : const SizedBox(),
      ],
    ),
  );
}

Widget process({double size = 50}) {
  return ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: AppColors.white20,
        alignment: Alignment.center,
        child: const Center(child: CircularProgressIndicator()),
      ),
    ),
  );
}

weatherItem({
  required String imgUrl,
  required String unit,
  dynamic value,
}) {
  return Column(
    children: [
      assetImage(
        imgUrl,
        height: 40.setHeight(),
        width: 40.setHeight(),
      ),
      sizeBoxHeight(10),
      Text(
        "${value ?? 0}$unit",
        style: AppTextStyle.normalText(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );
}

forecastItem(
    {String? date,
    int? minTemp,
    int? maxTemp,
    String? weatherName,
    String? weatherIcon,
    int? chanceOfRain,
    Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 3.0,
      margin: EdgeInsets.only(bottom: 20.setHeight()),
      child: Padding(
        padding: EdgeInsets.all(8.setHeight()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                label(
                  date ?? "",
                  style: const TextStyle(
                    color: Color(0xff6696f5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        label(
                          minTemp.toString(),
                          style: AppTextStyle.normalText(
                            color: AppColors.grey,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        label(
                          '°',
                          style: AppTextStyle.normalText(
                            color: AppColors.grey,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        label(
                          maxTemp.toString(),
                          style: AppTextStyle.normalText(
                            color: AppColors.blackBlueShade,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        label(
                          '°',
                          style: AppTextStyle.normalText(
                            color: AppColors.blackBlueShade,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            sizeBoxHeight(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    assetImage(
                      "${AppAssets.baseIMG}/${(weatherName ?? "overcast").replaceAll(' ', '').toLowerCase()}.png",
                      height: 30.setHeight(),
                    ),
                    sizeBoxWidth(5),
                    label(
                      weatherName ?? "",
                      style: AppTextStyle.normalText(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    label(
                      "$chanceOfRain%",
                      style: AppTextStyle.normalText(
                        fontSize: 18,
                        color: AppColors.tertiaryColor,
                      ),
                    ),
                    sizeBoxWidth(5),
                    assetImage(AppAssets.lightrain, height: 30.setHeight()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

fulldateFormate(String? date) {
  DateTime dateTime = date != null ? DateTime.parse(date) : DateTime.now();

  return DateFormat('MMMMEEEEd').format(dateTime);
}
