import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/auth/auth_bloc.dart';
import 'package:weather_app/bloc/home/home_bloc.dart';
import 'package:weather_app/firebase_options.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/utils/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: Routes.routes,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
          ),
          scaffoldBackgroundColor: AppColors.white,
        ),
        scaffoldMessengerKey: snackbarKey,
        initialRoute: RouteName.splashScreen,
      ),
    );
  }
}

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
