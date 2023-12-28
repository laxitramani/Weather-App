part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadingState extends AuthState {
  bool isLoading;
  LoadingState(this.isLoading);
}
