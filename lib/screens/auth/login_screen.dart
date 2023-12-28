import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/auth/auth_bloc.dart';
import 'package:weather_app/utils/assets.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/common_codes.dart';
import 'package:weather_app/utils/paints.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/utils/size_config.dart';
import 'package:weather_app/utils/strings.dart';
import 'package:weather_app/utils/text_style.dart';
import 'package:weather_app/utils/validation_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  AnimationController? controller;
  Animation<double>? sizeFactor;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    sizeFactor = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller!, curve: Curves.bounceOut),
    );
    controller!.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoadingState) {
          isLoading = state.isLoading;
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: scaffoldLoader(
            showLoader: isLoading,
            backgroundColor: AppColors.primaryColor,
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.setHeight(),
                    vertical: 50.setHeight(),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Hero(
                          tag: "logo",
                          child: assetImage(
                            AppAssets.logo,
                            height: 85.setHeight(),
                          ),
                        ),
                        sizeBoxHeight(7),
                        label(
                          AppStrings.weatherApp,
                          style: AppTextStyle.normalText(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        sizeBoxHeight(20),
                        label(
                          AppStrings.wlcBackGladToSeeYou,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.normalText(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        sizeBoxHeight(20),
                        ScaleTransition(
                          scale: sizeFactor!,
                          alignment: Alignment.topCenter,
                          child: CustomPaint(
                            painter: MyRoundedRectanglePainter(),
                            child: Container(
                              padding: EdgeInsets.only(
                                top: 40.setHeight(),
                                bottom: 30.setHeight(),
                                left: 20.setWidth(),
                                right: 20.setWidth(),
                              ),
                              child: Column(
                                children: [
                                  ...textFormFieldLabel(
                                    title: AppStrings.email,
                                    isOptional: false,
                                    hintText: AppStrings.emailHint,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixImage: AppAssets.mail,
                                    controller: emailController,
                                    validator: (value) =>
                                        ValidationHelper.validateEmail(value),
                                  ),
                                  sizeBoxHeight(20),
                                  ...textFormFieldLabel(
                                    title: AppStrings.password,
                                    isOptional: false,
                                    hintText: AppStrings.passwordHint,
                                    keyboardType: TextInputType.visiblePassword,
                                    prefixImage: AppAssets.lock,
                                    isPassword: true,
                                    controller: passController,
                                    titleSuffix:
                                        "${AppStrings.forgotPassword}?",
                                    titleSuffixOnTap: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context).pushNamed(
                                          RouteName.forgotPasswordScreen);
                                    },
                                  ),
                                  sizeBoxHeight(30),
                                  gradientMaterialButton(
                                    width: 200,
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      if (formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                              LoginEvent(
                                                  context: context,
                                                  email: emailController.text,
                                                  password:
                                                      passController.text),
                                            );
                                      }
                                    },
                                    title: AppStrings.login,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        sizeBoxHeight(110),
                        label(
                          AppStrings.dontHaveAnAccount,
                          style: AppTextStyle.normalText(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        textButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(RouteName.registerScreen),
                          title: AppStrings.registerForFree,
                          color: AppColors.tertiaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
