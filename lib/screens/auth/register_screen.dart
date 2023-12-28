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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  AnimationController? controller;
  Animation<double>? sizeFactor;

  int currentView = 0;
  bool isLoading = false;

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
        return PopScope(
          canPop: currentView != 0,
          onPopInvoked: (value) async {
            if (!value) currentView = 0;
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: scaffoldLoader(
              showLoader: isLoading,
              backgroundColor: AppColors.primaryColor,
              body: SingleChildScrollView(
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
                          AppStrings.registerNewUserHere,
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
                              child:
                                  currentView == 0 ? firstView() : secondView(),
                            ),
                          ),
                        ),
                        sizeBoxHeight(150),
                        label(
                          AppStrings.alreadyHaveAnAccount,
                          style: AppTextStyle.normalText(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        textButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  RouteName.loginScreen, (route) => false),
                          title: AppStrings.loginHere,
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

  Widget firstView() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          ...textFormFieldLabel(
            title: AppStrings.fullName,
            isOptional: false,
            hintText: AppStrings.nameHint,
            keyboardType: TextInputType.name,
            prefixImage: AppAssets.user,
            controller: nameController,
            validator: (value) => ValidationHelper.validateName(value),
          ),
          sizeBoxHeight(20),
          ...textFormFieldLabel(
            title: AppStrings.email,
            isOptional: false,
            hintText: AppStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            prefixImage: AppAssets.mail,
            controller: emailController,
            validator: (value) => ValidationHelper.validateEmail(value),
          ),
          sizeBoxHeight(30),
          gradientMaterialButton(
            width: 200,
            onTap: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  currentView = 1;
                });
              }
            },
            title: AppStrings.next,
          ),
        ],
      ),
    );
  }

  Widget secondView() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ...textFormFieldLabel(
            title: AppStrings.password,
            isOptional: false,
            hintText: AppStrings.passwordHint,
            keyboardType: TextInputType.visiblePassword,
            prefixImage: AppAssets.lock,
            controller: passwordController,
            isPassword: true,
            validator: (value) => ValidationHelper.validatePassword(value),
          ),
          sizeBoxHeight(20),
          ...textFormFieldLabel(
            title: AppStrings.reEnterPassword,
            isOptional: false,
            hintText: AppStrings.passwordHint,
            keyboardType: TextInputType.visiblePassword,
            prefixImage: AppAssets.lock,
            controller: rePasswordController,
            isPassword: true,
            validator: (value) => ValidationHelper.validateReEnterPassword(
                value, passwordController.text),
          ),
          sizeBoxHeight(30),
          Row(
            children: [
              Flexible(
                child: materialButton(
                  onTap: () => setState(() {
                    currentView = 0;
                  }),
                  height: 48.setHeight(),
                  width: double.infinity,
                  color: AppColors.grey,
                  child: label(
                    AppStrings.back,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              sizeBoxWidth(10),
              gradientMaterialButton(
                width: 200,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                          RegisterEvent(
                            context: context,
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );
                  }
                },
                title: AppStrings.signUp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
