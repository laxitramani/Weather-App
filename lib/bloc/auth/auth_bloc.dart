import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/utils/common_codes.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/utils/strings.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(loginEvent);
    on<RegisterEvent>(registerEvent);
    on<ForgotPasswordEvent>(forgotPasswordEvent);
  }

  loginEvent(LoginEvent event, emit) async {
    emit(LoadingState(true));
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    )
        .then((value) async {
      value.user!.emailVerified
          ? Navigator.of(event.context)
              .pushNamedAndRemoveUntil(RouteName.homeScreen, (route) => false)
          : await value.user
              ?.sendEmailVerification()
              .then(
                (value) => snackBar(AppStrings.verifyEmailBeforeLogin),
              )
              .catchError((e) {
              emit(LoadingState(false));
              return snackBar(e.message.toString());
            });
    });
    emit(LoadingState(false));
  }

  registerEvent(RegisterEvent event, emit) async {
    emit(LoadingState(true));
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: event.email,
      password: event.password,
    )
        .then((value) async {
      await Future.wait([
        value.user?.sendEmailVerification().then(
          (value) {
            Navigator.pop(event.context);
            snackBar(AppStrings.registerSuccess);
          },
        ).catchError((e) {
          emit(LoadingState(false));
          snackBar(e.message.toString());
        }) as Future,
        value.user?.updateDisplayName(event.name) as Future,
      ]);
    }).catchError((e) {
      emit(LoadingState(false));
      snackBar(e.message.toString());
    });
    emit(LoadingState(false));
  }

  forgotPasswordEvent(ForgotPasswordEvent event, emit) async {
    emit(LoadingState(true));
    await firebaseAuth.sendPasswordResetEmail(email: event.email).then((value) {
      Navigator.pop(event.context);
      snackBar(AppStrings.emailSentSuccessfullys);
    }).catchError((e) {
      emit(LoadingState(false));
      snackBar(e.message.toString());
    });
    emit(LoadingState(false));
  }
}
