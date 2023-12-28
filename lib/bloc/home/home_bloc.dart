import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/common_codes.dart';
import 'package:weather_app/utils/strings.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  WeatherModel weatherData = WeatherModel();
  HomeBloc() : super(HomeInitial()) {
    on<FetchDataEvent>(fetchDataEvent);
  }

  fetchDataEvent(FetchDataEvent event, emit) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            "https://api.weatherapi.com/v1/forecast.json?key=521546d62ac4451aad252824232712&days=7&q=${event.searchText}"),
      );

      if (response.statusCode == 200) {
        weatherData = WeatherModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      snackBar(AppStrings.somethingWentWrong);
      emit(FetchedDataState(weatherData));
    }

    emit(FetchedDataState(weatherData));
  }
}
