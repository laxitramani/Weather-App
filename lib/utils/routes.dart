import 'package:flutter/material.dart';
import 'package:weather_app/screens/auth/forgot_password_screen.dart';
import 'package:weather_app/screens/auth/login_screen.dart';
import 'package:weather_app/screens/auth/register_screen.dart';
import 'package:weather_app/screens/home/detail_screen.dart';
import 'package:weather_app/screens/home/home_screen.dart';
import 'package:weather_app/screens/splash_screen.dart';

class RouteName {
  static const String splashScreen = "/splashScreen";
  static const String homeScreen = "/homeScreen";
  static const String loginScreen = "/loginScreen";
  static const String registerScreen = "/registerScreen";
  static const String forgotPasswordScreen = "/forgotPasswordScreen";
  static const String detailScreen = "/detailScreen";
}

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RouteName.splashScreen: (context) => const SplashScreen(),
    RouteName.homeScreen: (context) => const HomeScreen(),
    RouteName.loginScreen: (context) => const LoginScreen(),
    RouteName.registerScreen: (context) => const RegisterScreen(),
    RouteName.forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    RouteName.detailScreen: (context) => const DetailScreen(),
  };
}
