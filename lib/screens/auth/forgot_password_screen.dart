import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/auth/auth_bloc.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/common_codes.dart';
import 'package:weather_app/utils/size_config.dart';
import 'package:weather_app/utils/strings.dart';
import 'package:weather_app/utils/validation_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

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
            appBar: AppBar(
              title: label(AppStrings.forgotPassword),
              surfaceTintColor: AppColors.white,
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.setHeight(),
                  vertical: 20.setHeight(),
                ),
                child: Column(
                  children: [
                    label(AppStrings.forgotPasswordContent),
                    sizeBoxHeight(20),
                    SimpleTextField(
                      controller: emailController,
                      hintText: AppStrings.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          ValidationHelper.validateEmail(value),
                    ),
                    sizeBoxHeight(30),
                    gradientMaterialButton(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(ForgotPasswordEvent(
                              context: context, email: emailController.text));
                        }
                      },
                      width: 200,
                      title: AppStrings.sendLink,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
