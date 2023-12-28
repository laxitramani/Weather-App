part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

class FetchedDataState extends HomeState {
  WeatherModel weatherData;

  FetchedDataState(this.weatherData);
}
