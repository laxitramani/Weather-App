import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/utils/assets.dart';
import 'package:weather_app/utils/common_codes.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.of(context).pushReplacementNamed(
          FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified
              ? RouteName.homeScreen
              : RouteName.loginScreen),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: assetImage(
          AppAssets.logo,
          height: 160.setHeight(),
          width: 160.setHeight(),
        ),
      ),
    );
  }
}
