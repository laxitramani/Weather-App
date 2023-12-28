part of 'home_bloc.dart';

sealed class HomeEvent {}

class FetchDataEvent extends HomeEvent {
  String searchText;

  FetchDataEvent(this.searchText);
}
