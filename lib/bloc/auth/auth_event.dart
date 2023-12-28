part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  BuildContext context;
  String email;
  String password;

  LoginEvent({
    required this.context,
    required this.email,
    required this.password,
  });
}

class ForgotPasswordEvent extends AuthEvent {
  BuildContext context;
  String email;

  ForgotPasswordEvent({
    required this.context,
    required this.email,
  });
}

class RegisterEvent extends AuthEvent {
  BuildContext context;
  String name;
  String email;
  String password;

  RegisterEvent({
    required this.context,
    required this.name,
    required this.email,
    required this.password,
  });
}
